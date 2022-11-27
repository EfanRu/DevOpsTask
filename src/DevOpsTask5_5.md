### Домашнее задание 5-5

# Задание 1
    
    Дайте письменые ответы на следующие вопросы:

    В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
    Какой алгоритм выбора лидера используется в Docker Swarm кластере?
    Что такое Overlay Network?

# Решение 1
    
    В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
    global - сервис запускается по 1 экзампляру на каждой ноде.
    replicated - сервис будет запущен указанное количество раз на доступных нодах.

    Какой алгоритм выбора лидера используется в Docker Swarm кластере?
    В Docker Swarm кластере используется Raft алгоритм выбора leader управляющей ноды.

    Что такое Overlay Network?
    verlay Network - это сеть, которая накладывается на существующие сети и используется для общения между контейнеров Docker Swarm.


# Задание 2

    Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
    Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
        docker node ls

# Решение 2

![Скриншот Docker swarm node ls](images/task5-5-img.png?raw=true)


# Задание 3

    Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
    Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
        docker service ls


# Решение 3

![Скриншот Docker swarm services](images/task5-5-img2.png?raw=true)


# Задание 4

    Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, 
    что она делает и зачем она нужна:

    # см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
    docker swarm update --autolock=true

# Решение 4

    Docker swarm autolock необходим для автоматического шифрования ключей от управления нодами swarm, которые передаются 
    им автоматически после перезагрузки. Таким образом после перезагрузки docker swar нужно будет ввести ключ 
    от автоматического шифрования.


    slava@manager-01:~$ sudo docker swarm update --autolock=true
    Swarm updated.
    To unlock a swarm manager after it restarts, run the `docker swarm unlock`
    command and provide the following key:
    
        SWMKEY-1-...
    
    Please remember to store this key in a password manager, since without it you
    will not be able to restart the manager.
