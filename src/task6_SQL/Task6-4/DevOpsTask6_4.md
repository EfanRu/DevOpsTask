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
    