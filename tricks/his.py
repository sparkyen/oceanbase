import pandas as pd
import numpy as np

def kronecker_product(arrays):
    """计算多个数组的 Kronecker 积"""
    result = np.array([1.0])  # 初始值为 1
    for array in arrays:
        result = np.kron(result, array)
    return result

def main(N, arrays, ndvs):
    # 1. 计算 Kronecker product
    kron_product = kronecker_product(arrays)

    # 2. 计算 (1 - 元素) 的 N 次方，并求和
    modified_elements = (1 - kron_product) ** N
    sum_of_modified_elements = np.sum(modified_elements)
    
    # 3. 计算每个数组的大小 D_i，并求其乘积
    size_product = np.prod([e for e in ndvs])
    
    # 4. 计算最终结果
    result = size_product - sum_of_modified_elements
    
    print(f"Kronecker Product: {kron_product}")
    print(f"Sum of (1 - element)^N: {sum_of_modified_elements}")
    print(f"Product of sizes D_i: {size_product}")
    print(f"Final Result: {result}")

# 1. 读取CSV数据
df = pd.read_csv('BJAQ.csv')

# 初始化一个空列表用于存储每列的频率信息
frequency_info = []

# 遍历每一列数据
arrs = []
ndvs = []
BINS = 10
N = len(df)
for column in df.columns:
    if df[column].dtype in [np.int64, np.float64]:  # 确保列数据类型是数值型
        # 计算直方图频率信息
        data = df[column]
        ndv = len(data.unique())
        ndvs.append(ndv)
        hist, bin_edges = np.histogram(data, bins=BINS)  # bins设置直方图的箱数
        
        # 将频率信息存储为元组并添加到列表中
        arrs.append(np.array(hist/N))
        print(bin_edges)
        column_info = {
            'column_name': column,
            'histogram': (hist/N).tolist(),
            'bin_edges': bin_edges.tolist()
        }
        frequency_info.append(column_info)

print(ndvs)

# 打印每列的频率信息数组
for info in frequency_info:
    print(f"-"*20)
    print(f"| {info['column_name']} |")
    print(f"-"*20)
    for i in range(len(info['histogram'])):
        if i < len(info['bin_edges']) - 1:
            range_str = f"{info['bin_edges'][i]:5.1f} ~ {info['bin_edges'][i+1]:5.1f}"
            print(f"| {info['histogram'][i]:7.7f} | {range_str} |")
    print(f"-"*20)
    print()

main(N,arrs, ndvs)

print(f"总行数: {N}")
unique_rows_count = df.drop_duplicates().shape[0]
print(f"不同行的个数：{unique_rows_count}")