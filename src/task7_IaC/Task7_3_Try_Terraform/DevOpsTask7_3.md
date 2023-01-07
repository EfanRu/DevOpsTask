### Домашнее задание 7-3

# Задание 1
	Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием терраформа и aws.

	Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя, а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано здесь.
	Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.
 
# Решение 1
	Заходим и создаем своё первый бакет по ссылке
[link](https://cloud.yandex.ru/docs/storage/operations/buckets/create)

	Получаем созданный публичный бакет my-first-bucket-by-slava
[link](https://console.cloud.yandex.ru/folders/b1gk7s99783hucvo6t4s/storage/buckets/my-first-bucket-by-slava)

	Создаем для одного из созданных в прошлых ДЗ сервисного аккаунта access-key для доступа в бакет
```commandline
slava@slava-MS-7677:~/Documents/Terraform_backet$ yc iam access-key create --service-account-name service-acc
access_key:
  id: ajeruus4m5s3vhqoueqp
  service_account_id: ajehs0ccf9cqjlljtp8i
  created_at: "2023-01-06T20:39:35.587664737Z"
  key_id: xxx
secret: xxx
```

	Делаем ссылку на наш backend в terraform:
```json
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "<имя бакета>"
    region     = "ru-central1"
    key        = "<путь к файлу состояния в бакете>/<имя файла состояния>.tfstate"
    access_key = "<идентификатор статического ключа>"
    secret_key = "<секретный ключ>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  ```
  
  	Выполняем инициализацию terraform и видим, что backend создался успешно:
 ```commandline
 slava@slava-MS-7677:~/$ terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
```

# Задание 2
	
    Выполните terraform init:
        если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице dynamodb.
        иначе будет создан локальный файл со стейтами.
    Создайте два воркспейса stage и prod.
    В уже созданный aws_instance добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах использовались разные instance_type.
    Добавим count. Для stage должен создаться один экземпляр ec2, а для prod два.
    Создайте рядом еще один aws_instance, но теперь определите их количество при помощи for_each, а не count.
    Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр жизненного цикла create_before_destroy = true в один из рессурсов aws_instance.
    При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:

    Вывод команды terraform workspace list.
    Вывод команды terraform plan для воркспейса prod.

# Решение 2
	Бэкенд создан был в Задании 1.
	Создаем воркспейсы stage и prod:
```commandline
slava@slava-MS-7677:~/$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
slava@slava-MS-7677:~/$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
```

	Делаем выбор в зависимости от workspace выбор дистрибутива:
```json
locals {
  image_id = {
    stage = yandex_compute_image.ubuntu_2004.id,
    prod  = yandex_compute_image.ubuntu-20-04-lts.id
  }
}```

```json
resource "yandex_compute_instance" "vm1-ubuntu" {
  boot_disk {
    initialize_params {
      image_id = local.image_id[terraform.workspace]
    }
  }
}```

	

