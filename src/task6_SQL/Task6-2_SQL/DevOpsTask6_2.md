### Домашнее задание 6-2

# Задание 1
    Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
    Приведите получившуюся команду или docker-compose манифест.

# Решение 1

    Создаем контейнер с postgresDB через docker-compose
[docker-compose.yml](docker-compose.yml)

    Указываем 2 volume для сохранения данных БД после отключения контейнера и бекапов:
      - .:/var/lib/postgresql/test_db
      - .:/var/lib/postgresql/test_db_backup



# Задание 2
    В БД из задачи 1:

    создайте пользователя test-admin-user и БД test_db
    в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
    предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
    создайте пользователя test-simple-user
    предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

    Таблица orders:
    
        id (serial primary key)
        наименование (string)
        цена (integer)
    
    Таблица clients:
    
        id (serial primary key)
        фамилия (string)
        страна проживания (string, index)
        заказ (foreign key orders)
    
    Приведите:
    
        итоговый список БД после выполнения пунктов выше,
        описание таблиц (describe)
        SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
        список пользователей с правами над таблицами test_db


# Решение 2
    Создайте пользователя test-admin-user и БД test_db сделано через docker-compose файл.
[docker-compose.yml](docker-compose.yml)

    В БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```sql
    create table orders (
        id serial primary key,
        наименование VARCHAR(50) not NULL,
        цена INTEGER not null);

    create table clients (
        id serial primary key,
        фамилия VARCHAR(25) not null,
        "страна проживания" VARCHAR(35),
        заказ serial references orders (id));
```    

    И индексация:

```sql
    create index country_index on clients ("страна проживания");

    select * from pg_indexes where tablename not like 'pg%';
```

    Предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
    Все сделано через docker-compose файл
[docker-compose.yml](docker-compose.yml)

    Создайте пользователя test-simple-user
    Предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

```sql
    create user "test-simple-user" with encrypted password '****';
    
    grant select, insert, delete, update 
        on clients, orders
        to "test-simple-user";
```

    Итоговый список БД после выполнения пунктов выше.
    Список БД?? Пунктов выше?? Ничего не понял. Вот список БД.


        test_db=# \l
                                                     List of databases
           Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            
        -----------+-----------------+----------+------------+------------+-----------------------------------------
         postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
         template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
                   |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
         template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
                   |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
         test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | 
        (4 rows)

    Описание таблиц (describe)
        test_db=# \d orders
                                              Table "public.orders"
            Column    |         Type          | Collation | Nullable |              Default               
        --------------+-----------------------+-----------+----------+------------------------------------
         id           | integer               |           | not null | nextval('orders_id_seq'::regclass)
         наименование | character varying(50) |           | not null | 
         цена         | integer               |           | not null | 
        Indexes:
            "orders_pkey" PRIMARY KEY, btree (id)
        Referenced by:
            TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
        
        test_db=# \d clients
                                                   Table "public.clients"
              Column       |         Type          | Collation | Nullable |                 Default                  
        -------------------+-----------------------+-----------+----------+------------------------------------------
         id                | integer               |           | not null | nextval('clients_id_seq'::regclass)
         фамилия           | character varying(25) |           | not null | 
         страна проживания | character varying(35) |           |          | 
         заказ             | integer               |           | not null | nextval('"clients_заказ_seq"'::regclass)
        Indexes:
            "clients_pkey" PRIMARY KEY, btree (id)
            "country_index" btree ("страна проживания")
        Foreign-key constraints:
            "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)



    SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```sql
    SELECT username FROM pg_catalog.pg_user;
```

    Список пользователей с правами над таблицами test_db
    
        test_db=# \du+
                                                      List of roles
            Role name     |                         Attributes                         | Member of | Description 
        ------------------+------------------------------------------------------------+-----------+-------------
         test-admin-user  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}        | 
         test-simple-user |                                                            | {}        | 


# Задание 3
    Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

        Таблица orders
        Наименование 	цена
        Шоколад 	10
        Принтер 	3000
        Книга 	500
        Монитор 	7000
        Гитара 	4000
        
        Таблица clients
        ФИО 	Страна проживания
        Иванов Иван Иванович 	USA
        Петров Петр Петрович 	Canada
        Иоганн Себастьян Бах 	Japan
        Ронни Джеймс Дио 	Russia
        Ritchie Blackmore 	Russia
        
        Используя SQL синтаксис:
        
            вычислите количество записей для каждой таблицы
            приведите в ответе:
                запросы
                результаты их выполнения.


# Решение 3
    Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
```sql
    insert into orders VALUES(1, 'Шоколад', 10);
    
    insert into orders VALUES(2, 'Принтер', 3000),
        (3, 'Книга', 500),
        (4, 'Монитор', 7000),
        (5, 'Гитара', 4000);
        
    insert into clients VALUES(1, 'Иванов Иван Иванович', 'USA', 2),
        (2, 'Петров Петр Петрович', 'Canada', 3),
        (3, 'Иоганн Себастьян Бах', 'Japan', 4),
        (4, 'Ронни Джеймс Дио', 'Russia', 5),
        (5, 'Ritchie Blackmore', 'Russia', 1);
```

    вычислите количество записей для каждой таблицы
    приведите в ответе:
    
        запросы
        результаты их выполнения.

```sql
    select count(id) from orders;
    5
    
    select count(id) from clients;
    5
```

# Задание 4
    Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
    
    Используя foreign keys свяжите записи из таблиц, согласно таблице:
    ФИО 	Заказ
    Иванов Иван Иванович 	Книга
    Петров Петр Петрович 	Монитор
    Иоганн Себастьян Бах 	Гитара
    
    Приведите SQL-запросы для выполнения данных операций.
    
    Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
    

# Решение 4
    Приведите SQL-запросы для выполнения данных операций.
    Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sql
    alter table clients alter column заказ TYPE integer;
    alter table clients alter column заказ drop not null;
    
    update clients set заказ = 5 where фамилия = 'Иоганн Себастьян Бах';
    update clients set заказ = 4 where фамилия = 'Петров Петр Петрович';
    update clients set заказ = 3 where фамилия = 'Иванов Иван Иванович';
    
    select * from clients where заказ is NOT NULL;
```


# Задание 5 
    Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
    Приведите получившийся результат и объясните что значат полученные значения.

# Решение 5
```sql
explain select * from clients where заказ is NOT NULL;
```
    
    Seq Scan on clients  (cost=0.00..14.20 rows=418 width=164)
      Filter: ("заказ" IS NOT NULL)

    Seq Scan говорит нам, что используется последовательное чтение данных из таблицы clients.
    cost говорит нам за сколько мы получили первую строку..последнюю строку. Получается запрос был выполнен за 14.20 мс.
    rows - приблизительное количество строк при выполнении операции.
    width - средний размер одной строки в байтах.
    Filter - фильтр, который использовался.

# Задание 6
    Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
    Остановите контейнер с PostgreSQL (но не удаляйте volumes).
    Поднимите новый пустой контейнер с PostgreSQL.
    Восстановите БД test_db в новом контейнере.
    Приведите список операций, который вы применяли для бэкапа данных и восстановления.

# Решение 6
    Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
        root@e28ab823edd1:~# pg_dump -U test-admin-user -d test_db -h localhost >> /var/lib/postgresql/test_db/test_db.sql

        Скопировали дамб БД через volume на наш хост.

    Остановите контейнер с PostgreSQL (но не удаляйте volumes).
        docker stop {container id}
        docker rm {container id} - иначе он будет пересоздаваться со всеми данными
    Поднимите новый пустой контейнер с PostgreSQL.
        sudo docker-compose up
        sudo docker exec -it {new clear container id} bash
    Проверяем, что он действительно без нащих данных
        root@25902dd6fcd6:/# psql -U test-admin-user -d test_db
        test_db=# select * from orders;
        ERROR:  relation "orders" does not exist
        LINE 1: select * from orders;
    Восстанавливаем из дампа данные
        root@25902dd6fcd6:/# psql -U test-admin-user -d test_db -h localhost < /var/lib/postgresql/test_db/test_db.sql
    Проверяем данные
        test_db=# select * from orders;
         id | наименование | цена 
        ----+--------------+------
          1 | Шоколад      |   10
          2 | Принтер      | 3000
          3 | Книга        |  500
          4 | Монитор      | 7000
          5 | Гитара       | 4000
        (5 rows)


