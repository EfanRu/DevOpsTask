### Домашнее задание 6-3

# Задание 1
    Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
    Изучите бэкап БД и восстановитесь из него.
    Перейдите в управляющую консоль mysql внутри контейнера.
    Используя команду \h получите список управляющих команд.
    Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
    Подключитесь к восстановленной БД и получите список таблиц из этой БД.
    Приведите в ответе количество записей с price > 300.
    В следующих заданиях мы будем продолжать работу с данным контейнером.

# Решение 1
    Подключаемся к docker контейнеру созданному через docker-compose файл:
[docker-compose.yml](docker-compose.yml)

    Подключаемся к mysql командой
```commandline
bash-4.4# mysql -h localhost -P 3306 -u root -p
```

    Получаем информацию о mysql БД через команду
```commandline
mysql> \s
--------------
mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          15
Current database:       
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.31 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 7 min 18 sec

Threads: 2  Questions: 5  Slow queries: 0  Opens: 119  Flush tables: 3  Open tables: 38  Queries per second avg: 0.011
--------------
```
    Создаем новую базу данных и выбираем её. Иначе некуда загружать backup.
    Разворачиваем её из дампа.
```commandline
mysql> create datase test_db;
mysql> use test_db;
mysql> source /backup/test_dump.sql
Query OK, 0 rows affected (0.00 sec)
...
Query OK, 0 rows affected (0.00 sec)
```

    Проверяем селектом:
```commandline
mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.01 sec)
```

    Приведите в ответе количество записей с price > 300.
```commandline
mysql> select count(id) from orders where price > 300;
+-----------+
| count(id) |
+-----------+
|         1 |
+-----------+
1 row in set (0.00 sec)
```
    
# Задание 2
    Создайте пользователя test в БД c паролем test-pass, используя:
    
        плагин авторизации mysql_native_password
        срок истечения пароля - 180 дней
        количество попыток авторизации - 3
        максимальное количество запросов в час - 100
        аттрибуты пользователя:
            Фамилия "Pretty"
            Имя "James"
    
    Предоставьте привелегии пользователю test на операции SELECT базы test_db.
    
    Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.

# Решение 2

    Создаем пользователя и задаем ему права
```sql
create user 'test'@'localhost' 
     identified with mysql_native_password by 'test-pass'
     WITH MAX_CONNECTIONS_PER_HOUR 100 
     PASSWORD EXPIRE INTERVAL 180 DAY 
     FAILED_LOGIN_ATTEMPTS 3 
     ATTRIBUTE '{
        "Second name": "Pretty",
        "First name": "James"
     }';
Query OK, 0 rows affected (0.12 sec)
     
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.08 sec)

```

    Проверяем созданного пользователя
```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+--------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                        |
+------+-----------+--------------------------------------------------+
| test | localhost | {"First name": "James", "Second name": "Pretty"} |
+------+-----------+--------------------------------------------------+
1 row in set (0.00 sec)
```


# Задача 3
    Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
    Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
    Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
    
        на MyISAM
        на InnoDB


# Решение 3
    Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)
```

    Хмм.. ничего не показывает, а если в транзакции?
    То показывает время выполнения запросов)
```
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiling;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'profiling' at line 1
mysql> show profiles;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00013175 | start transaction |
|        2 | 0.00024225 | set profiling=1   |
|        3 | 0.00006200 | show profiling    |
+----------+------------+-------------------+
3 rows in set, 1 warning (0.00 sec)
```

    Проверяем какой engine установлен на таблице
```
mysql> show table status where name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-12-07 20:08:54 | 2022-12-07 20:08:56 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.06 sec)
```

    Проверяем время для InnoDB
```
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> show profiling;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'profiling' at line 1
mysql> show profiles;
+----------+------------+-----------------------------------------+
| Query_ID | Duration   | Query                                   |
+----------+------------+-----------------------------------------+
|        1 | 0.00037900 | select * from orders                    |
+----------+------------+-----------------------------------------+
11 rows in set, 1 warning (0.00 sec)
```

    Меняем engine

```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.75 sec)
Records: 5  Duplicates: 0  Warnings: 0
```

    Проверяем время для MyISAM
```
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> show profiles;
+----------+------------+-----------------------------------------+
| Query_ID | Duration   | Query                                   |
+----------+------------+-----------------------------------------+
|        1 | 0.00037675 | select * from orders                    |
+----------+------------+-----------------------------------------+
13 rows in set, 1 warning (0.00 sec)

```

    InnoDB 0.00037900 > 0.00037675 MyISAM


# Задание 4
    Изучите файл my.cnf в директории /etc/mysql.
    
    Измените его согласно ТЗ (движок InnoDB):
    
        Скорость IO важнее сохранности данных
        Нужна компрессия таблиц для экономии места на диске
        Размер буффера с незакомиченными транзакциями 1 Мб
        Буффер кеширования 30% от ОЗУ
        Размер файла логов операций 100 Мб
    
    Приведите в ответе измененный файл my.cnf.

# Решение 4
    Файл my.cnf находится не по пути /etc/mysql, а в /etc.
    Изменения в нем согласно задания приведены в соответствующем файле
[my.cnf](my.cnf)
    
    Далее копируем из volume наш измененный файл, останавливаем контейнер, коммитим его изменения,
    перезапускаем и проверяем сохранение изменений и что БД запустилась.
```
bash-4.4# cp /backup/my.cnf /etc/my.cnf
root@slava-MS-7677:Task6-3# docker stop 88c272933895
root@slava-MS-7677:Task6-3# docker commit 88c272933895
root@slava-MS-7677:Task6-3# docker-compose up

bash-4.4# cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
 innodb_buffer_pool_size = 900M
 innodb_log_file_size = 100M
 innodb_log_buffer_size = 1M
 innodb_file_per_table = 1
 innodb_flush_method = O_DSYNC
 innodb_flush_log_at_trx_commit = 2
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

```