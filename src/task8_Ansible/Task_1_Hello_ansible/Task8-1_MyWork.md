
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