use test;
drop table IF EXISTS bjaq;
drop table IF EXISTS power;
CREATE TABLE bjaq (c0 int,c1 int,c2 int,c3 int,c4 float);
CREATE TABLE power (c0 float,c1 float,c2 float,c3 float,c4 float,c5 float);
LOAD DATA /*+ direct(true,0) parallel(4) */ LOCAL INFILE 'BJAQ.csv' INTO TABLE bjaq FIELDS TERMINATED BY ',';
LOAD DATA /*+ direct(true,0) parallel(4) */ LOCAL INFILE 'power.csv' INTO TABLE power FIELDS TERMINATED BY ',';
select * from bjaq limit 10;
select 
min(c0), max(c0), min(c1), max(c1), min(c2), max(c2), 
min(c3), max(c3), min(c4), max(c4)
from bjaq; 
-- +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
-- | min(c0) | max(c0) | min(c1) | max(c1) | min(c2) | max(c2) | min(c3) | max(c3) | min(c4) | max(c4) |
-- +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
-- |       2 |     844 |       2 |     999 |       2 |     290 |       0 |    1071 |   -19.9 |    41.6 |
-- +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+


explain extended select count(*) from bjaq where c0>400;
-- (844-400)*382168/842
-- 201523

explain extended select /*+hint:no_rewrite*/ count(*) from bjaq where c0>=400 and c0<500;
-- (500-400)*382168/842
-- 45388

explain extended select count(*) from bjaq where c0>=400 and c0<500 and c0>=2 and c0<844 and c0>=450 and c0 BETWEEN 470 AND 490;
-- ((490-470)+1/nvd)*382168/842
-- 9077+534=9611

explain extended select /*+hint:no_rewrite*/ count(*) from bjaq where c0=1 and c0 > 0;

select * from power limit 10;
select 
min(c0), max(c0), min(c1), max(c1), min(c2), max(c2), 
min(c3), max(c3), min(c4), max(c4)
from bjaq; 