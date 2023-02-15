
## Основная часть
# Задание 1
    Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

# Решение 1
    Значение 'some_fact' = 12
```commandline
sudo ansible-playbook -i ./playbook/inventory/test.yml ./playbook/site.yml
TASK [Print fact] ****************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}
```
# Задание 2
    Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

# Решение 2
    Поменял файл  examp.yml

# Задание 3
    Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

# Решение 3
    Сделано.
```commandline
$ docker --version
Docker version 20.10.12, build 20.10.12-0ubuntu4
```

# Задание 4
    Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

# Решение 4
    Для работы окружения prod необходимо запустить контейнеры с соответствующими названиями:
```commandline
docker run -d --name ubuntu ubuntu tail -f /dev/null+
docker run -d --name centos centos tail -f /dev/null
```
    Так как первоначально на Ubuntu не установлен Python, то нужно будет его добавить.

    Запустить playbook:
```commandline
ansible-playbook -i ./playbook/inventory/test.yml ./playbook/site.yml

...
TASK [Print fact] ****************************************************************************************************************************
ok: [centos] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
...
```

# Задание 5
    Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

# Решение 5
    Меняем файлы .yml в соответствующих папках group_vars и выполняем playbook
```commanline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml
TASK [Print fact] ****************************************************************************************************************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
``` 

# Задание 6
    Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

# Решение 6
```commanline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml
TASK [Print fact] ****************************************************************************************************************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
``` 

# Задание 7
    При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

# Решение 7
    Зашифровываем переменные через команду
```commandline
ansible-vault encrypt_string
```

# Задание 8
    Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

# Решение 8
    запускаем playbook, но с ключом --ask-vault-pass
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass

TASK [Print fact] ****************************************************************************************************************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```

# Задание 9
    Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

# Решение 9

    Смотрим плагины become через команду:
```commandline
ansible-doc -t become -l 

ansible.netcommon.enable     Switch to elevated permissions on a network device                                                          
community.general.doas       Do As user                                                                                                  
community.general.dzdo       Centrify's Direct Authorize                                                                                 
community.general.ksu        Kerberos substitute user                                                                                    
community.general.machinectl Systemd's machinectl privilege escalation                                                                   
community.general.pbrun      PowerBroker run                                                                                             
community.general.pfexec     profile based execution                                                                                     
community.general.pmrun      Privilege Manager run                                                                                       
community.general.sesu       CA Privileged Access Manager                                                                                
runas                        Run As user                                                                                                 
su                           Substitute User                                                                                             
sudo                         Substitute User DO 
```

    Выберем например плагин sudo. Хотя не понимаю зачем он нам сейчас.

# Задание 10
    В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

# Решение 10
    Добавляем запись в prod.yml:
'''yml
  my_local:
    hosts:
      my_local:
        ansible_connection: local
'''

# Задание  11
    Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

# Решение 11
    Запускаем playbook:
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass

TASK [Print fact] ****************************************************************************************************************************
ok: [my_local] => {
    "msg": "all default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos] => {
    "msg": "el default fact"
}
```

    Видим, что el и deb расшифровались, а в my_local находится значение из папки all

# Задание 12
    Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

# Решение 12
    Сделано


## Необязательная часть

# Задание 1
    При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

# Решение 1
    Так как у нас зашированы не файлы а переменные, то расшифровка их будет следующей:
```commandline
echo '$ANSIBLE_VAULT;1.1;AES256
63636433353266363839303434643738396134393763323536366235323136373438366631353530
3731633330376465323866346236393130653237353338620a316339333236363366653963633165
37353062623966613131316564616138653762313866663830643566353163623537636362636337
3134343039636635340a623135306435353330396339656162343132636537303565633366303839
3762' | ansible-vault decrypt --ask-vault-pass && echo
Vault password: 
Decryption successful
el default fact
```
    или без самого ключа, чтобы проще было прочитать:
```commandline
echo '<encrypt text>' | ansible-vault decrypt --ask-vault-pass && echo
```

# Задание 2
    Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

# Решение 2
    Щтфруем значение и сетим его в group_vars/all/exmp.yml

```commandline
ansible-vault encrypt_string
New Vault password: 
Confirm New Vault password: 
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          38383063353231653432333064343764393164333034663538393535336237323234656239393531
          3932343264346565396637336161626633656130356536340a396566353562626466373865363838
          35383035313635373037646462336431636561623531613132623637333837313135323266356232
          6561316330373266650a613365316362303161306638323338336537396330616532643762643165
          3637
Encryption successful
```

# Задание 3
    Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

# Решение 3
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass
TASK [Print fact] ****************************************************************************************************************************
ok: [my_local] => {
    "msg": "PaSSw0rd"
}
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```

# Задание 4
    Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

# Решение 4
    Дополняем inventory/prod.yml:
```yml
  fed:
    hosts:
      fedora:
        ansible_connection: docker
```
    Скачиваем через Docker образ и запускаем его:
```commandline
docker pull fedora
docker run -d --name fedora fedora tail -f /dev/null
```

    Запускаем playbook:
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass
TASK [Print fact] ****************************************************************************************************************************
ok: [my_local] => {
    "msg": "PaSSw0rd"
}
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "PaSSw0rd"
}
```

# Задание 5
    Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

# Решение 5
    Поднятие контейнеров и установка на Ubuntu python:
[run_containers](playbook%2Fbash_scripts%2Frun_containers)

    Запуск playbook:
[run_playbook_prod](playbook%2Fbash_scripts%2Frun_playbook_prod)

    Остановка и удаление контейнеров
[stop_and_rm_all_containers](playbook%2Fbash_scripts%2Fstop_and_rm_all_containers)

# Задание 6
    Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

# Решение 6