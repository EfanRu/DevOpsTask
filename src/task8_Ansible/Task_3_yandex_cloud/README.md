# Ansible playbooks с установкой clickhouse, vector и lighthouse

## About
    Playbook с созданием 3 ВМ в Yandex Cloud и установкой коллектора логов vector, БД clickhouse для него и системой 
    аудита lighthouse.
    Выполненно в качестве обучающего проекта.

## Quick start
    - Для удобства в коде уже зашиты системные переменные, чтобы не хранить чувствительные данные в коде. Они требуют 
    инициализации следующими командами, которые должны быть выполнены в каталоге Terraform, как и остальные команды terraform:
```commandline
export TF_VAR_YC_TOKEN=$(yc iam create-token)
export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
terraform apply
```
    - Запуск и создание ВМ через команду terraform apply;
    - После успешного завершения в консоль будут выведены IP адреса серверов external_ip_address. Их нужно будет добавить
    в файл 
[prod.yml](playbook%2Finventory%2Fprod.yml)

    - Запустить через ansible playbook. Для clickhouse playbook называется site.yml (сохранено 
    для синхронизации с заданием). Для vector и lighthouse playbook называются соответственно. 
    Запуск осуществляется командой:
    ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/<имя файла playbook>

---
