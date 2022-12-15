# BigData. Практична робота №6.

## Завдання
Виконати tutorial по [Hive](https://hshirodkar.medium.com/apache-hive-on-docker-4d7280ac6f8e).
Завантажити якісь свої дані та зробити запити.
Оформити у вигляді звіту.

## Виконання tutorial.
1. Запускаємо сервіси
```bash
(venv) ➜  Hive docker-compose up
Starting namenode ... done
Starting datanode ... done
Starting hive-metastore-postgresql ... done
Starting hive-metastore            ... done
Starting hive-server               ... done
Attaching to namenode, datanode, hive-metastore-postgresql, hive-metastore, hive-server
datanode                     | Configuring core
hive-metastore               | Configuring core
hive-metastore               |  - Setting hadoop.proxyuser.hue.hosts=*
datanode                     |  - Setting hadoop.proxyuser.hue.hosts=*
hive-server                  | Configuring core
datanode                     |  - Setting fs.defaultFS=hdfs://namenode:8020
hive-server                  |  - Setting hadoop.proxyuser.hue.hosts=*
datanode                     |  - Setting hadoop.proxyuser.hue.groups=*
hive-server                  |  - Setting fs.defaultFS=hdfs://namenode:8020
namenode                     | Configuring core
...
```
2. Підключаємося до контейнерів
```bash
(venv) ➜  Hive docker exec -it hive-server /bin/bash
root@427c5c5263b9:/opt# ls
hadoop-2.7.4  hive
```
3. Створюємо табличку `employee` та заповнюємо її
```bash
root@427c5c5263b9:/opt# cd ..
root@427c5c5263b9:/# ls
bin  boot  dev  employee  entrypoint.sh  etc  hadoop-data  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@427c5c5263b9:/# cd employee/
root@427c5c5263b9:/employee# ls
employee.csv  employee_table.hql
root@427c5c5263b9:/employee# hive -f employee_table.hql
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop-2.7.4/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in file:/opt/hive/conf/hive-log4j2.properties Async: true
OK
Time taken: 1.296 seconds
OK
Time taken: 0.023 seconds
OK
Time taken: 0.223 seconds
root@427c5c5263b9:/employee# hadoop fs -put employee.csv hdfs://namenode:8020/user/hive/warehouse/testdb.db/employee
```
4. Читаємо данні з таблиці `employee`.
```bash
root@427c5c5263b9:/employee# hive
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop-2.7.4/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in file:/opt/hive/conf/hive-log4j2.properties Async: true
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
hive> show databases;
OK
default
testdb
Time taken: 0.742 seconds, Fetched: 2 row(s)
hive> use testdb;
OK
Time taken: 0.017 seconds
hive> select * from employee;
OK
1       Rudolf Bardin   30      cashier 100     New York        40000   5
2       Rob Trask       22      driver  100     New York        50000   4
3       Madie Nakamura  20      janitor 100     New York        30000   4
4       Alesha Huntley  40      cashier 101     Los Angeles     40000   10
5       Iva Moose       50      cashier 102     Phoenix 50000   20
Time taken: 0.959 seconds, Fetched: 5 row(s)
```

## Завантажити якісь свої дані та зробити запити.
1. Створюємо теку `dataset` та додаємо [данні](./dataset/dataset.csv) та `HQL` [скріпт](./dataset/dataset_table.hql) 
   для створення таблиці dataset.
2. Додаємо цю паку у `volumes` сервісу `hive-server` файлу [docker-compose.yml](./docker-compose.yml), щоб ця тека стала
нам доступна, коли ми підключаємося до контейнерів.
3. Підключаємося до контейнерів та створюємо таблицю `dataset`.
```bash
(venv) ➜  Hive docker exec -it hive-server /bin/bash
root@62fc3a2dd458:/opt# cd ../dataset/
root@62fc3a2dd458:/dataset# ls
dataset.csv  dataset_table.hql
root@62fc3a2dd458:/dataset# hive -f dataset_table.hql
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop-2.7.4/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in file:/opt/hive/conf/hive-log4j2.properties Async: true
OK
Time taken: 1.139 seconds
OK
Time taken: 0.013 seconds
OK
Time taken: 0.319 seconds
root@62fc3a2dd458:/dataset# hadoop fs -put dataset.csv hdfs://namenode:8020/user/hive/warehouse/testdb.db/dataset
```
3. Виконуємо запит для підрахунку кількості стрічок `dataset` для кожної статі.
```bash
hive> select sex, count(*) from dataset group by sex;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = root_20221215181717_ac18ebcd-0482-4745-ad74-33eae8882b46
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2022-12-15 18:17:19,179 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local710964381_0001
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 576640 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
F       985
I       991
M       1160
Time taken: 2.103 seconds, Fetched: 3 row(s)
```
4. Визначаємо значення всі можливі значення `target` у `dataset`.
```bash
hive> select distinct target from dataset order by target;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = root_20221215184542_1258165e-5133-40af-9711-88c35c140082
Total jobs = 2
Launching Job 1 out of 2
Number of reduce tasks not specified. Estimated from input data size: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2022-12-15 18:45:44,761 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local1267381742_0001
Launching Job 2 out of 2
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2022-12-15 18:45:45,970 Stage-2 map = 100%,  reduce = 100%
Ended Job = job_local1621058994_0002
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 288320 HDFS Write: 0 SUCCESS
Stage-Stage-2:  HDFS Read: 288320 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
29
Time taken: 3.949 seconds, Fetched: 28 row(s)
```
3. Знаходимо середнє значення усіх `weight` колонок.
```bash
hive> select avg(weight_1), avg(weight_2), avg(weight_3), avg(weight_4) from dataset;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
Query ID = root_20221215184908_0171a0bf-3967-49c5-87b2-da0268f3b610
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Job running in-process (local Hadoop)
2022-12-15 18:49:10,404 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_local2022274799_0003
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 576640 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
0.8292999043367336      0.3591299426020408      0.18073788265306154     0.23925143494897852
Time taken: 1.571 seconds, Fetched: 1 row(s)
```

## Висновки
Під час цієї практичної роботи я познайомився з технологією `Hive`, 
виконав `tutorial` по локальному розгортанню `Hive` через `docker` 
та виконав агрегаційні запити на власному `dataset`. 
Не зіштовхнувся зі складностями та проблемами у цій практичній роботі.