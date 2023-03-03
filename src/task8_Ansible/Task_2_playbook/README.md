# Ansible playbooks с установкой clickhouse и vector

## About
    Playbook с установкой коллектора логов vector и БД clickhouse для него.
    Выполненно в качестве обучающего проекта.

## Quick start
    - Нужно создать сервер на Centos или аналоге с поддержкой yum, например в Yandex cloud;
    - Добавить IP адрес сервера в iunventory/prod.yml: ansible_host;
    - Запустить через ansible playpook. Для clickhouse playbook называется site.yml (сохранено 
    для синхронизации с заданием). Для vector playbook называется vector.yml. Запуск осуществляется командой:
    ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/<имя файла playbook>

---
