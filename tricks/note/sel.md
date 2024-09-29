可以观察到以下场景会出现选择率估计较大偏差的问题：

```sql
// EqualSelEstimator
explain select /*+hint:no_rewrite*/ count(*) from bjaq where (c2,c2)=(4,4);
explain select /*+hint:no_rewrite*/ count(*) from bjaq where c2=4 and/or c2=4;
explain select /*+hint:no_rewrite*/ count(*) from bjaq where (c2,c3)=(2,3) and/or (c2,c3)=(2,3);
// InSelEstimator
explain select /*+hint:no_rewrite*/ count(*) from bjaq where 4 in (c2,c2);
explain select /*+hint:no_rewrite*/ count(*) from bjaq where (2,2) in ((c2,c2));
explain select /*+hint:no_rewrite*/ count(*) from bjaq where 4 in (c2) and/or 4 in (c2);
// EqualSelEstimator & InSelEstimator
explain select /*+hint:no_rewrite*/ count(*) from bjaq where c2=4 and c2 in (4);
// EqualSelEstimator & RangeSelEstimator
explain select /*+hint:no_rewrite*/ count(*) from bjaq where c2>0 and c2<200 and c2=1;
```

根据上述的测试可以发现，在以下前提条件下：

- 查询改写关闭
- 部分表达式之间有独立性假设

谓词条件表达式冗余造成的重复计算，会引起表达式选择率结果的错误估计（`AND`造成偏低，`OR`造成偏高），这本质上是因为同表同谓词的表达式之间是完全相关联的，优化器需要对其进行去重。目前在基数估计这个阶段，除了`join` 谓词外,能够支持冗余表达式消除和合并的话的只有 `RangeSelEstimator` , 对应的原理是碰到同类型的 `Estimator` 就将其的 `range` 放在一起，最后在估计选择率的时候先用 `query range` 来提取最终的 `range` ，从而达到准确估计选择率的目的。而和 `T_OP_BTW` 相关的谓词在 `Resolver` 阶段就已经转化成 `≥ ... AND ≤ ...` 形式的Range 谓词了，本质上也是`RangeSelEstimator` 。

由于`AND` 的优先级高于 `OR` ， `where` 语句中的 `condition` 会被拆解为不同的节点并以一棵树的形式组织起来。

本文中提及的等值谓词包括 `ObEqualSelEstimator`、`ObInSelEstimator`，因为它们最终都等价于计算等值谓词的选择率，并且以下讨论的针对都是同一张表上的同一谓词。

以下采取的策略分三步，对于前两步**本质上是利用离散数学中的幂等率（** `p∨p=p∧p=p`**）**，来消除等值谓词冗余的情况；而对于第三步，则是消除不同谓词间计算范围的冗余：

1. 消除同一表达式节点内的冗余的`=`谓词，比如`(c2,c2)=(4,4)` 、`4 in (c2,c2)`、`(2,2) in ((c2,c2))`
2. 消除不同表达式节点间的冗余`=`谓词，比如 `c2=4 AND c2=4` 、`c2=4 OR c2=4`、`c2=4 and c2 in (4)`
3. 消除不同表达式节点间的冗余`range`谓词，比如 `c2>0 and c2<200 and c2=1`

首先大致说明问题的解决思路，具体描述如下：

1. 对于第一点，优化器直接在对应的 `Estimator` 中进行处理就可以了
2. 对于第二点，首先来看看**谓词提取**的概念：将当前表达式节点中的谓词提取出来用于和其他表达式节点的合并，比如 :
    - `(c2,c2)=(4,4)` 中能够提取出 `c2=4`
    - `(c1,c2)=(4,5)` 中能够提取出 `c1=4`, `c2=5` ,`(c1,c2)=(4,5)`
    
    其次再来看下**表达式合并**的概念：将当前表达式节点提取出来的谓词和其他节点进行合并，这里分为 `AND` 节点的合并与 `OR` 节点的合并两大类：
    
    1. AND 节点的合并
        - A 节点与 B 节点重复，则保留其中一个
            
            e.g. `(c1,c2)=(4,5) AND (c2,c3)=(5,9)` 根据提取出的谓词`c1=4 AND c2=5 AND c2=5 AND c3=9` 最终能够合并成 `c1=4 AND c2=5 AND c3=9`
            
        - A 节点与 B 节点冲突，同样只保留其中一个
            
            e.g. `c1=4 AND c1=5 AND c1=6 …` 始终保留第一个节点的值，即 `c1=4`，原理同 3.b
            
    2. OR 节点的合并
        - A 节点所在的集合被某 B 节点所包含，那么可以直接忽略 B 对最终选择率的贡献
            
            能够这样做的原因在于， 1 与任何表达式相或都是 1 ，当然这需要优化器进行参数窥探；而在其他场景下，重复的谓词并不会造成选择率计算的错误，如`(c1=2 AND c3=6) OR (c1=2 AND c4=5)` 尽管有 `c1=2` 这个公共的表达式，但是不合并不会对结果造成影响。
            
            e.g.1 `(c1=2 AND c3=6) OR c3=6` 可以被合并成 `c3=6` 
            
            e.g.2`(c1=2 AND c3=6 AND c4=6 AND c5=11 AND c0>=1) OR (c3=6 AND c5=11)` 可以被合并为 `(c3=6 AND c5=11 )`
            
    
    对于`OR` 节点的合并其实不仅仅适用于本文提到的等值谓词的情况，但是实现起来并不容易，所以暂时在具体实现中暂不考虑。
    
3. 对于第三点，由于 `c2>2 and c2<290 and c2=1` 这种形式的存在，让本来实际结果为 0 被错估为 1395。可以考虑以下两个方案，在具体实现中使用第二种，注意此时等值谓词和范围谓词各自均已完成合并：
    1. 将等值谓词变为范围谓词，交由 `query range` 模块合并出最终的 `range` 进行选择率的计算。
    2. 直接将等值谓词包含的值（记作集合 `S`）和范围谓词包含的值（记作集合 `R`）进行合并。
        1. AND 节点的合并
            
            假设 `S ⊆ R`，则该范围谓词不会对最终的选择率有贡献；反之，若 `S ⊄ R`，从理论上来说应该将整个表达式的选择率置为 0 ，但是由于用户的 SQL 执行会优先走 `Plan Cache`,  选择率为 0 会造成一些极端的执行的计划，这是优化器不愿意看到的，这里采取的措施是同样只保留等值谓词对最终选择率的贡献。
            
            e.g. `c0=1 AND (c0≥0)` 和 `c0=1 AND (c0≥6)` 都会被合并成 `c0=1`。
            
        2. OR 节点的合并
            
            假设 `S ⊆ R`，则该等值谓词不会对最终的选择率有贡献；反之，不需要进行合并。
            
            e.g. `c0=1 OR (c0≥0)` 会被合并成 `c0≥0`，`c0=1 OR (c0≥6)` 不需要做出任何行动。
            

## 具体实现

在总体设计上，本文可以抽象出更加通用的逻辑，即表达式的抽取与合并。目前的估行系统针对各自能够优化的部分，已经进行了尽可能的优化，但是目前只能合并同一个子类的的节点。因此，本节的具体做法分为以下两步：

1. 

新建合并规则的矩阵

|  | ObEqualSelEstimator | ObInSelEstimator | ObRangeSelEstimator |
| --- | --- | --- | --- |
| ObEqualSelEstimator | 1.1 | 1.2 | 1.3 |
| ObInSelEstimator | 2.1 | 2.2 | 2.3 |
| ObRangeSelEstimator | 3.1 | 3.2 | Y |

假设 $S= A1∩A2∩…∩An$, $T = B1∪B2∪…∪Bm$, `R = Z1∩Z2+…∩Zk`

Ai, Bi: ci=val

Zi:  ci [l1,r1]

1.1 S1 AND S2 , S1 OR S2

(c1,c2)=(2,3) OR (c2,c3)=(3,4) 对结果无影响，不合并；(c1,c2)=(2,3) OR (c1,c2,c3)=(2,3,4) 合并成 (c1,c2)=(2,3)

AND 连接符一律进行合并，消除左右两个节点的冗余部分，如(c1,c2)=(2,3) AND (c1,c3)=(4,5) 合并成 (c1,c2,c3)=(2,3,5)

2.2 T1 AND T2, T1 OR T2

c0 in (1,2,3) OR c0 in (2,3,4) 合并成 c0=1 OR c0=2 OR c0=3 OR c0=4；1 in (c0, c1, c2) OR c1 in (3,4) 是同样的方式

c0 in (1,2,3) AND c0 in (2,3,4) 对结果无影响，不合并； c0 in (1,2,3) AND c0 in (2,3) 合并成 c0 in (2,3)

1.2/2.1 S1 AND T1, S1 OR T1

(c0=1 AND c1=2 AND …) OR ( c0=1 OR c1=3 OR ….) 只要左右节点有相同的谓词，就合并成 ( c0=1 OR c1=3 OR ….) 

(c0=1 AND c1=2 AND …) AND ( c0=1 OR c1=3 OR ….) 只要左右节点有相同的谓词，就合并成 (c0=1 AND c1=2 AND …)

1.3/3.1 S1 AND R1, S1 OR R1

(c0=1 AND c1=2) OR (0≤c0≤100) 合并成 0≤c0≤100

(c0=1 AND c1=2) AND (0≤c0≤100)  合并成 c0=1 AND c1=2

2.3/3.2 T1 AND R1, T1 OR R1

(c0=1 OR c0=200 OR c1=2) OR (0≤c0≤100)  合并成 (c0=200 OR c1=2) OR (0≤c0≤100)

(c0=1 OR c0=200 OR c1=2) AND (0≤c0≤100)  合并成 (0≤c0≤100)

`ObInSelEstimator` 作为整体有特殊的结构不能被拆开，如`c0=1 AND (c0=1 OR c0=2 OR c0=3 )` ，所以需要直接处理

抽象出三种节点针对于内部树结构的通用的数据结构`

1. 
2. 

c0=1 AND (c0=1 OR c0=2 OR c0=3 ) AND c0=5

**解决方案，hash ，借鉴 的做法**

`ObEqualSelEstimator::get_equal_sel` 除了对自己的递归调用外，会被好几个函数直接或者间接调用并用于选择率计算，如：

- `ObEqualSelEstimator`
    - `get_sel`
- `ObInSelEstimator`
    - `get_in_sel`
- `ObSimpleJoinSelEstimator`（`T_OP_NSEQ`）
    - `get_sel`
    - `get_multi_equal_sel`