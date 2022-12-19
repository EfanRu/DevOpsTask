### Домашнее задание 6-4

# Задание 1
    Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
    Подключитесь к БД PostgreSQL используя psql.
    Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.
    Найдите и приведите управляющие команды для:
    
        вывода списка БД
        подключения к БД
        вывода списка таблиц
        вывода описания содержимого таблиц
        выхода из psql


# Решение 1
    Создаем docker-compose файл с postgresql
[docker-compose.yml](docker-compose.yml)

    Подключаемся к контейнеру и заходим в psql с пользователем, которого указали в docker-compose файле.
```commandline
psql -U slava
```

        вывода списка БД
```commandline
slava=# \l+
                                                               List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges |  Size   | Tablespace |                Description                 
-----------+-------+----------+------------+------------+-------------------+---------+------------+--------------------------------------------
 postgres  | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | default administrative connection database
 slava     | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | 
 template0 | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | unmodifiable empty database
           |       |          |            |            | slava=CTc/slava   |         |            | 
 template1 | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | default template for new databases
           |       |          |            |            | slava=CTc/slava   |         |            | 
(4 rows)
```

        подключения к БД
```commandline
slava=# \c slava
You are now connected to database "slava" as user "slava".
slava=# \c postgres
You are now connected to database "postgres" as user "slava".
```

        вывода списка таблиц
```commandline
postgres=# \dtS+
                                       List of relations
   Schema   |          Name           | Type  | Owner | Persistence |    Size    | Description 
------------+-------------------------+-------+-------+-------------+------------+-------------
 pg_catalog | pg_aggregate            | table | slava | permanent   | 56 kB      | 
...
 pg_catalog | pg_user_mapping         | table | slava | permanent   | 8192 bytes | 
(62 rows)

```
        вывода описания содержимого таблиц
```commandline
postgres=# \dS+ pg_index
                                      Table "pg_catalog.pg_index"
     Column     |     Type     | Collation | Nullable | Default | Storage  | Stats target | Description 
----------------+--------------+-----------+----------+---------+----------+--------------+-------------
 indexrelid     | oid          |           | not null |         | plain    |              | 
...
 indexprs       | pg_node_tree | C         |          |         | extended |              | 
 indpred        | pg_node_tree | C         |          |         | extended |              | 
Indexes:

...skipping 1 line
    "pg_index_indrelid_index" btree (indrelid)
Access method: heap
```
        выхода из psql
```commandline
С ноги отрубить питание компа или \q
```

# Задание 2
    Используя psql создайте БД test_database.
    Изучите бэкап БД.
    Восстановите бэкап БД в test_database.
    Перейдите в управляющую консоль psql внутри контейнера.
    Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
    Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
    Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.

# Решение 2
    Создаем docker-compose файл с postgresql
[docker-compose.yml](docker-compose.yml)

    Подключаемся к контейнеру и заходим в psql с пользователем, которого указали в docker-compose файле.
```commandline
psql -U slava
```

    Проверяем, что в созданных БД нет test_database

```commandline
slava=# \l+
                                                               List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges |  Size   | Tablespace |                Description                 
-----------+-------+----------+------------+------------+-------------------+---------+------------+--------------------------------------------
 postgres  | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | default administrative connection database
 slava     | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | 
 template0 | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | unmodifiable empty database
           |       |          |            |            | slava=CTc/slava   |         |            | 
 template1 | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | default template for new databases
           |       |          |            |            | slava=CTc/slava   |         |            | 
(4 rows)

```

    Создаем новую БД test_database и проверяем, что она содалась

```commandline
slava=# create database test_database;
CREATE DATABASE
slava=# \l+
                                                                 List of databases
     Name      | Owner | Encoding |  Collate   |   Ctype    | Access privileges |  Size   | Tablespace |                Description                 
---------------+-------+----------+------------+------------+-------------------+---------+------------+--------------------------------------------
 postgres      | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | default administrative connection database
 slava         | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | 
 template0     | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | unmodifiable empty database
               |       |          |            |            | slava=CTc/slava   |         |            | 
 template1     | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | default template for new databases
               |       |          |            |            | slava=CTc/slava   |         |            | 
 test_database | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7753 kB | pg_default | 
(5 rows)

```

    Восстанавливаем БД из дампа
```commandline
root@2ffaf3d6cfac:/# psql -U slava -d test_database < /my_vol/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
root@2ffaf3d6cfac:/# 
```

    Проверяем, что БД увеличилась в размере и появились данные.
```commandline
slava=# \l+
                                                                 List of databases
     Name      | Owner | Encoding |  Collate   |   Ctype    | Access privileges |  Size   | Tablespace |                Description                 
---------------+-------+----------+------------+------------+-------------------+---------+------------+--------------------------------------------
 postgres      | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | default administrative connection database
 slava         | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | 
 template0     | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | unmodifiable empty database
               |       |          |            |            | slava=CTc/slava   |         |            | 
 template1     | slava | UTF8     | en_US.utf8 | en_US.utf8 | =c/slava         +| 7753 kB | pg_default | default template for new databases
               |       |          |            |            | slava=CTc/slava   |         |            | 
 test_database | slava | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7973 kB | pg_default | 
(5 rows)

```

    Подключаемся к БД, чекаем таблицу и проводим по ней анализ;

```commandline
slava=# \c test_database;
You are now connected to database "test_database" as user "slava".
test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# ANALYZE orders;
ANALYZE
```

    Ищем в таблице pg_stats столбец с наибольшим средним размером элемента в байтах
```commandline
test_database=# select attname, avg_width from pg_stats where tablename = 'orders';
 attname | avg_width 
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```

    Как и логично это столбец title.

# Задание 3
    Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
    Предложите SQL-транзакцию для проведения данной операции.
    Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

# Решение 3

    Начинаем транзакцию по делению таблицы, создаем 2 новые таблицы и удаляем прошлую:

```commandline
test_database=# begin transaction;
BEGIN
test_database=*# create table orders_1 as select * from orders where price > 499;
SELECT 3
test_database=*# create table orders_2 as select * from orders where price <= 499;
SELECT 5
test_database=*# drop table orders;
DROP TABLE
test_database=*# commit;
COMMIT
```

    Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Можно используя ограничения CHECK при создании таблиц.

# Задание 4
    Используя утилиту pg_dump создайте бекап БД test_database.
    Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

# Решение 4
    Создаем бэкап
```commandline
root@2ffaf3d6cfac:/# pg_dump -U slava test_database > /my_vol/test_database_my_bcp.sql
```

    Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
Можно добавить ограничение UNIQUE в строки создания таблиц в столбец title.