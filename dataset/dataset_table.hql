create database if not exists testdb;
use testdb;
create external table if not exists dataset (
  sex string,
  length double,
  diameter double,
  height double,
  weight_1 double,
  weight_2 double,
  weight_3 double,
  weight_4 double,
  target int
)
row format delimited
fields terminated by ','
lines terminated by '\n'
stored as textfile location 'hdfs://namenode:8020/user/hive/warehouse/testdb.db/dataset';