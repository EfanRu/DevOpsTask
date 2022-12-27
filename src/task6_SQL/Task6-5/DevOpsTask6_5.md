### Домашнее задание 6-4

# Задание 1
    В этом задании вы потренируетесь в:
        установке elasticsearch
        первоначальном конфигурировании elastcisearch
        запуске elasticsearch в docker
    
    Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:
        составьте Dockerfile-манифест для elasticsearch
        соберите docker-образ и сделайте push в ваш docker.io репозиторий
        запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины
    
    Требования к elasticsearch.yml:
        данные path должны сохраняться в /var/lib
        имя ноды должно быть netology_test
    
    В ответе приведите:
        текст Dockerfile манифеста
        ссылку на образ в репозитории dockerhub
        ответ elasticsearch на запрос пути / в json виде
    
    Подсказки:
        возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
        при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
        при некоторых проблемах вам поможет docker директива ulimit
        elasticsearch в логах обычно описывает проблему и пути ее решения
    
    Далее мы будем работать с данным экземпляром elasticsearch.


# Решение 1
    Создаем образ Centos 7 из Dockerfile:
[Dockerfile](Dockerfile)
```commandline
Sending build context to Docker daemon   5.12kB
Step 1/5 : FROM centos:7
Get "https://registry-1.docker.io/v2/": dial tcp: lookup registry-1.docker.io: Temporary failure in name resolution
```

    Ну ладно, пойдет и Centos 8 (Забыл переименовать контейнер, исправлю позже)
```commandline
slava@slava-MS-7677:~/Documents/netology/my_homework/DevOpsTask/src/task6_SQL/Task6-5$ sudo docker build --rm -t local/c7-systemd .
Sending build context to Docker daemon   5.12kB
Step 1/5 : FROM centos:8
8: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:8
 ---> 5d0da3dc9764
Step 2/5 : ENV container docker
 ---> Running in dd9c8dd66c1f
Removing intermediate container dd9c8dd66c1f
 ---> 059050b88ab4
Step 3/5 : RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); rm -f /lib/systemd/system/multi-user.target.wants/*;rm -f /etc/systemd/system/*.wants/*;rm -f /lib/systemd/system/local-fs.target.wants/*; rm -f /lib/systemd/system/sockets.target.wants/*udev*; rm -f /lib/systemd/system/sockets.target.wants/*initctl*; rm -f /lib/systemd/system/basic.target.wants/*;rm -f /lib/systemd/system/anaconda.target.wants/*;
 ---> Running in 8dd6eae8d531
Removing intermediate container 8dd6eae8d531
 ---> ad4ebfc861d9
Step 4/5 : VOLUME [ "/sys/fs/cgroup" ]
 ---> Running in 606dfa38e89d
Removing intermediate container 606dfa38e89d
 ---> aeaeb3d82b77
Step 5/5 : CMD ["/usr/sbin/init"]
 ---> Running in 0c250316ac24
Removing intermediate container 0c250316ac24
 ---> cbaaace47c08
Successfully built cbaaace47c08
Successfully tagged local/c7-systemd:latest
```

    Проверяем созданный контейнер и запускаем его для установки ElasticSearch
```commandline
slava@slava-MS-7677:~/Documents/netology/my_homework/DevOpsTask/src/task6_SQL/Task6-5$ sudo docker images
REPOSITORY         TAG       IMAGE ID       CREATED              SIZE
local/c7-systemd   latest    cbaaace47c08   About a minute ago   231MB
```

    Понимаем, что не хотим это делать руками и находим готовый docker-compose сброку. Например, https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
    Оказывается, что там кластер. Ну ладно попробуем его поднять. Делаем docker-compose файл с данными нетологии, незабывая сделать файо конфигурации env
[docker-compose.yml](docker-compose.yml)
[.env](.env)

!!!Работает только с VPN, а куда же без него:((

    Но оперативки на компе всего 8 Гб и на кибану места не хватило
```commandline
ERROR: for kibana  Container "5af72a862ecf" is unhealthy.
ERROR: Encountered errors while bringing up the project.
```
    Удаляем всё лишнее и оставляем один эластик. Запускаем и выполняем команду elasticsearch /
```commandline
root@54ff1946a343:~# elasticsearch /
Starts Elasticsearch

Option                Description                                               
------                -----------                                               
-E <KeyValuePair>     Configure a setting                                       
-V, --version         Prints Elasticsearch version information and exits        
-d, --daemonize       Starts Elasticsearch in the background                    
--enrollment-token    An existing enrollment token for securely joining a       
                        cluster                                                 
-h, --help            Show help                                                 
-p, --pidfile <Path>  Creates a pid file in the specified path on start         
-q, --quiet           Turns off standard output/error streams logging in console
-s, --silent          Show minimal output                                       
-v, --verbose         Show verbose output                                       

ERROR: Positional arguments not allowed, found [/]
```
    
    Получаем ошибку max virtual memory areas vm.max_map_count и сразу правим её увеличив лимит на хост машине
```commandline
netology_test01_1  | bootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

slava@slava-MS-7677:~$ sudo sysctl -w vm.max_map_count=262144
```

    Запускаем контейнер и проверяем доступность по адресу https://localhost:9200/
```json
{
  "name" : "netology_test01",
  "cluster_name" : "netology_test_cluster",
  "cluster_uuid" : "_rqrWF2TRaaZ0gv3tvMQQg",
  "version" : {
    "number" : "8.5.3",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "4ed5ee9afac63de92ec98f404ccbed7d3ba9584e",
    "build_date" : "2022-12-05T18:22:22.226119656Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```
	Или через curl
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/"
{
  "name" : "netology_test01",
  "cluster_name" : "netology_test_cluster",
  "cluster_uuid" : "_rqrWF2TRaaZ0gv3tvMQQg",
  "version" : {
    "number" : "8.5.3",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "4ed5ee9afac63de92ec98f404ccbed7d3ba9584e",
    "build_date" : "2022-12-05T18:22:22.226119656Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

    Загружаем докер образ
```commandline
root@slava# docker commit de11626c0446 ledok/netology:elastic
root@slava# docker push ledok/netology:elastic
```

    Ссылка на Docker Hub: 
[Docker hub link elasticsearch](https://hub.docker.com/layers/ledok/netology/elastic/images/sha256-58d0f786e92700f7dca9da793a9cdbd96f93b46896646928948e9feaefe69e0f?context=repo)

# Задание 2
    В этом задании вы научитесь:
      - создавать и удалять индексы
      - изучать состояние кластера
      - обосновывать причину деградации доступности данных
    
    Ознакомтесь с 
[документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
    и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:
    
    | Имя | Количество реплик | Количество шард |
    |-----|-------------------|-----------------|
    | ind-1| 0 | 1 |
    | ind-2 | 1 | 2 |
    | ind-3 | 2 | 4 |
    
    Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
    
    Получите состояние кластера `elasticsearch`, используя API.
    
    Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
    
    Удалите все индексы.
    
    **Важно**
    
    При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
    иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

# Решение 2

    Добавляем и проверяем 1 индекс
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}

slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cat/indices?v"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 m3KmW8RxS7CxgjuOZ6IjGg   1   0          0            0       225b           225b

```

	Итого получаем:
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cat/indices?v"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 m3KmW8RxS7CxgjuOZ6IjGg   1   0          0            0       225b           225b
yellow open   ind-3 sZnSmsiYSy663VgFItleag   4   2          0            0       413b           413b
yellow open   ind-2 ED_52QW8QY2LcU1D3KMovg   2   1          0            0       450b           450b
```

	Проверяем статус кластера
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "netology_test_cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}

```

	Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
		Кластер находится в желтом статусе, потому что у нас 1 нода.
		Индексы находятся в желтом статусе, потому что количество реплик должно быть >= node
		
	Удаляем индексы
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X DELETE "https://localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}
```

# Задание 3
	В данном задании вы научитесь:

	    создавать бэкапы данных
	    восстанавливать индексы из бэкапов

	Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.

	Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.

	Приведите в ответе запрос API и результат вызова API для создания репозитория.

	Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

	Создайте snapshot состояния кластера elasticsearch.

	Приведите в ответе список файлов в директории со snapshotами.

	Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.

	Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.

	Приведите в ответе запрос к API восстановления и итоговый список индексов.

	Подсказки:

	    возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch


# Решение 3

	Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.
		Пошли и сделали директорию /usr/share/elasticsearch/snapshots
		
```commandline
slava@slava-MS-7677:~$ sudo docker exec -it de11626c0446 bash
elasticsearch@de11626c0446:~$ mkdir /usr/share/elasticsearch/snapshots
```

	Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots"
  }
}
'
{
  "error" : {
    "root_cause" : [
      {
        "type" : "repository_exception",
        "reason" : "[netology_backup] location [/usr/share/elasticsearch/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
      }
    ],
    "type" : "repository_exception",
    "reason" : "[netology_backup] failed to create repository",
    "caused_by" : {
      "type" : "repository_exception",
      "reason" : "[netology_backup] location [/usr/share/elasticsearch/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
    }
  },
  "status" : 500
}
```

	Забыл сделать в yml файле настройку path.repo: ["/var/lib"]
	Исправляем в файле контейнера и добавляем переменную в compose файл:
```commandline
elasticsearch@de11626c0446:~/config$ echo 'path.repo: ["/var/lib"]' >> elasticsearch.yml
elasticsearch@de11626c0446:~/config$ cat elasticsearch.yml
cluster.name: "docker-cluster"
network.host: 0.0.0.0
path.repo: ["/var/lib"]
```

	Пробуем заново:
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elastic_back_up"
  }
}
'
{
  "error" : {
    "root_cause" : [
      {
        "type" : "repository_exception",
        "reason" : "[netology_backup] cannot create blob store"
      }
    ],
    "type" : "repository_verification_exception",
    "reason" : "[netology_backup] path  is not accessible on master node",
    "caused_by" : {
      "type" : "repository_exception",
      "reason" : "[netology_backup] cannot create blob store",
      "caused_by" : {
        "type" : "access_denied_exception",
        "reason" : "/var/lib/elastic_back_up"
      }
    }
  },
  "status" : 500
}
```

	Оказывается не хватает прав. Заходим в контейнер и добавляем их
```commandline
root@de11626c0446:/usr/share/elasticsearch# mkdir /var/lib/elastic_back_up
root@de11626c0446:/usr/share/elasticsearch# chown -R elasticsearch:elasticsearch /var/lib/elastic_back_up
```

	Пробуем ещё раз:
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elastic_back_up"
  }
}
'
{
  "acknowledged" : true
}
```

	Все получилось!
	
	Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
	
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cat/indices?v"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  WZgRJ2xDSkShQzcudLkJyQ   1   0          0            0       225b           225b
```

	Создайте snapshot состояния кластера elasticsearch.
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/_snapshot/netology_backup/my_snapshot_1?pretty"
{
  "accepted" : true
}

```

	Приведите в ответе список файлов в директории со snapshotами.
```commandline
root@de11626c0446:/usr/share/elasticsearch# ll /var/lib/elastic_back_up/
total 44
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Dec 27 22:13 ./
drwxr-xr-x 1 root          root           4096 Dec 27 21:42 ../
-rw-rw-r-- 1 elasticsearch root           1098 Dec 27 22:13 index-0
-rw-rw-r-- 1 elasticsearch root              8 Dec 27 22:13 index.latest
drwxrwxr-x 5 elasticsearch root           4096 Dec 27 22:13 indices/
-rw-rw-r-- 1 elasticsearch root          18476 Dec 27 22:13 meta-migimGMxQJK3x-g-BQK5sg.dat
-rw-rw-r-- 1 elasticsearch root            383 Dec 27 22:13 snap-migimGMxQJK3x-g-BQK5sg.dat
```

	Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cat/indices?v"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  WZgRJ2xDSkShQzcudLkJyQ   1   0          0            0       225b           225b
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X DELETE "https://localhost:9200/test?pretty"
{
  "acknowledged" : true
}
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X PUT "https://localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cat/indices?v"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 4ollIWFiQwKWIe4BVJVJ4A   1   0          0            0       225b           225b
```

	Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
```commandline
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X POST "https://localhost:9200/_snapshot/netology_backup/my_snapshot_1/_restore?pretty"
{
  "accepted" : true
}
slava@slava-MS-7677:~$ curl -k -u elastic:pwwd -X GET "https://localhost:9200/_cat/indices?v"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 4ollIWFiQwKWIe4BVJVJ4A   1   0          0            0       225b           225b
green  open   test   pK0CGVOGTu2f5w0lKgoOJg   1   0          0            0       225b           225b
```
	
	
