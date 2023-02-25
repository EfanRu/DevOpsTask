# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

# Задание 1
  (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)

# Решение 1
  Изучил

# Задание 2
  Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.

# Решение 2
  Использую старый

# Задание 3 
  Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

# Решение 3
  Сделано

# Задание 5
  Подготовьте хосты в соответствии с группами из предподготовленного playbook.

# Решение 5
  Подготовил на Yandex cloud сервер на Centos с именем clickhouse-01.
  Если создать ВМ на Ubuntu, то почему-то менеджер пакетов ansible.package ansible.apt не устанавливают из rpm. К сожалению, потратил кучу времени и так и не решил эту проблему.
Конечно можно было преобразовать файл rpm в deb, но это не очень красиво и как-то костыльно - должно же быть уже готовое решение. Подскажите, пожалуйста, как можно через ansible 
установить пакет rpm?
  Добавил в /etc/ansible/ansible.cfg файл строку с расположением private ssh key.

```commandline
PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0  
```

## Основная часть

# Задание 1
  Приготовьте свой собственный inventory файл `prod.yml`.

# Решение 1
  Он уже готов был.
  Play выдает 1 ошибку и 1 спасение из-за того первоначально пробует скачать noarch, которой нет, и потом качает x86_64 в модуле rescue.
```commandline
$ ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml

PLAY [Install Clickhouse] *******************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "slava", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "slava", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] **********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   

```

# Задание 2
  Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

# Решение 3
  Файл с play по установке Vector можно посмотреть тут: [vector.yml](playbook%2Fvector.yml)
  Вывод play Vector:
```commandline
$ ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/vector.yml

PLAY [Install Vector] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Download Vector] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install Vector] ***********************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


```

# Задание 3 и 4
  3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
  4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

# Решение 3 и 4
  3. Из четырёх перечисленных модулей обошелся 1 модулем 'get_url' - скачать rpm файл и после его сразу установить модулем yum.
Остальные нет необходимости использовать, если качаем сразу rpm.
  4. К сожалению, распаковку применить не получилось, так как скачан rpm файл. Но скачивание в определененнёю директорию и 
дальнейшую установку они проводят.
  Подробнее, в файле: [vector.yml](playbook%2Fvector.yml)

# Задание 5
  Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

# Решение 5
  1 запуск ansible-lint:
```commandline
$ ansible-lint ./playbook/site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: ./playbook/site.yml
$ ansible-lint ./playbook/vector.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: ./playbook/vector.yml
```

  Ошибок нет только предупреждение.

# Задание 6
  Попробуйте запустить playbook на этом окружении с флагом `--check`.

# Решение 6
  Запускаем оба play:
```commandline
$ ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "slava", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "slava", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] **********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   



$ ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/vector.yml --check

PLAY [Install Vector] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Download Vector] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install Vector] ***********************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

  Запустил и проверка без выполнения на сервере прошла успешно.

# Задание 7
  Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

# Решение 7
  Меняем название создаваемой базы данных в файле [site.yml](playbook%2Fsite.yml):
```yml
      ansible.builtin.command: "clickhouse client -q 'create database logs1;'"
```
  Запускаем и проверяем:
```commandline
$ ansible-playbook --diff -i ./playbook/inventory/prod.yml ./playbook/site.yml

PLAY [Install Clickhouse] *******************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get Clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "slava", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "slava", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get Clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install Clickhouse packages] **********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   

```

  Изменение было замечено ansible: changed=1

# Задание 8
  Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

# Решение 8
  Без изменений запускаем 2ой раз:
```commandline
$ ansible-playbook --diff -i ./playbook/inventory/prod.yml ./playbook/site.yml

PLAY [Install Clickhouse] *******************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get Clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "slava", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "slava", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_tmp_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get Clickhouse distrib] ***************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install Clickhouse packages] **********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
```

  Изменений не появилось, следовательно наш playbook идемпотентен

# Задание 9
  Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

# Решение 9
  Файл [README.md](README.md)

# Ззадание 10
  Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

# Решение 10
  Сделано: https://github.com/EfanRu/DevOpsTask/tree/08-ansible-02-playbook/src/task8_Ansible/Task_2_playbook

---