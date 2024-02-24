# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Решение создание облачной инфраструктуры](#решение-создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Версия [Terraform](https://www.terraform.io/) не старше 1.5.x .

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя.
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---

### Решение создание облачной инфраструктуры

        Версия terraform не старше 1.5.x .
```commandline
slava@slava-FLAPTOP-r:~$ terraform --version
Terraform v1.3.9
on linux_amd64
```

        Сервисный аккаунт будет создаваться тоже через terraform через resource "yandex_iam_service_account".
        Чтобы не хранить чувствительные данные в коде засетим их в переменные окружения:

```commandline
slava@slava-FLAPTOP-r:~$ export TF_VAR_YC_TOKEN=$(yc iam create-token)
slava@slava-FLAPTOP-r:~$ export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
slava@slava-FLAPTOP-r:~$ export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
```

<details><summary>Terraform apply in YC:</summary>

```commandline
slava@slava-FLAPTOP-r:~/Documents/DevOpsTask/src/graduate_work$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_iam_service_account.sa will be created
  + resource "yandex_iam_service_account" "sa" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + name       = "svc-acc-grd"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1gk7s99783hucvo6t4s"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.test will be created
  + resource "yandex_storage_bucket" "test" {
      + access_key            = (known after apply)
      + bucket                = "efanov-bucket-graduate"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + config_read = (known after apply)
          + list        = (known after apply)
          + read        = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

  # yandex_vpc_network.vpc will be created
  + resource "yandex_vpc_network" "vpc" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "graduate-vpc"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_security_group.nat-instance-sg will be created
  + resource "yandex_vpc_security_group" "nat-instance-sg" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "nat-instance-sg"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description    = "any"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "ANY"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }

      + ingress {
          + description    = "ext-http"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 80
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "ext-https"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 443
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "ssh"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 22
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
    }

  # yandex_vpc_subnet.public-a will be created
  + resource "yandex_vpc_subnet" "public-a" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.public-b will be created
  + resource "yandex_vpc_subnet" "public-b" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.11.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.public-c will be created
  + resource "yandex_vpc_subnet" "public-c" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-c"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.12.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

Plan: 9 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_iam_service_account.sa: Creating...
yandex_vpc_network.vpc: Creating...
yandex_vpc_network.vpc: Creation complete after 3s [id=enpjr01oj7un38r6k9uo]
yandex_vpc_subnet.public-a: Creating...
yandex_vpc_subnet.public-c: Creating...
yandex_vpc_subnet.public-b: Creating...
yandex_vpc_security_group.nat-instance-sg: Creating...
yandex_iam_service_account.sa: Creation complete after 3s [id=aje5p4r3n4ole175h9r0]
yandex_iam_service_account_static_access_key.sa-static-key: Creating...
yandex_resourcemanager_folder_iam_member.sa-editor: Creating...
yandex_vpc_subnet.public-a: Creation complete after 0s [id=e9bcsijrj7gfadd2ir6s]
yandex_vpc_subnet.public-c: Creation complete after 1s [id=b0chv9r0jc2bgjlc0osc]
yandex_vpc_subnet.public-b: Creation complete after 1s [id=e2llt1c5cu33dip3jcek]
yandex_iam_service_account_static_access_key.sa-static-key: Creation complete after 2s [id=aje4seqjgifn8010q3hu]
yandex_storage_bucket.test: Creating...
yandex_vpc_security_group.nat-instance-sg: Creation complete after 2s [id=enpj41q4dacvikd78mke]
yandex_resourcemanager_folder_iam_member.sa-editor: Creation complete after 3s [id=b1gk7s99783hucvo6t4s/storage.editor/serviceAccount:aje5p4r3n4ole175h9r0]
yandex_storage_bucket.test: Still creating... [10s elapsed]
yandex_storage_bucket.test: Still creating... [20s elapsed]
yandex_storage_bucket.test: Still creating... [30s elapsed]
yandex_storage_bucket.test: Still creating... [40s elapsed]
yandex_storage_bucket.test: Still creating... [50s elapsed]
yandex_storage_bucket.test: Still creating... [1m0s elapsed]
yandex_storage_bucket.test: Still creating... [1m10s elapsed]
yandex_storage_bucket.test: Still creating... [1m20s elapsed]
yandex_storage_bucket.test: Still creating... [1m30s elapsed]
yandex_storage_bucket.test: Still creating... [1m40s elapsed]
yandex_storage_bucket.test: Still creating... [1m50s elapsed]
yandex_storage_bucket.test: Still creating... [2m0s elapsed]
yandex_storage_bucket.test: Creation complete after 2m2s [id=efanov-bucket-graduate]

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.
```

</details>

<details><summary>Terraform destroy in YC:</summary>

```commandline
slava@slava-FLAPTOP-r:~/Documents/DevOpsTask/src/graduate_work$ terraform destroy
yandex_iam_service_account.sa: Refreshing state... [id=aje5p4r3n4ole175h9r0]
yandex_vpc_network.vpc: Refreshing state... [id=enpjr01oj7un38r6k9uo]
yandex_resourcemanager_folder_iam_member.sa-editor: Refreshing state... [id=b1gk7s99783hucvo6t4s/storage.editor/serviceAccount:aje5p4r3n4ole175h9r0]
yandex_iam_service_account_static_access_key.sa-static-key: Refreshing state... [id=aje4seqjgifn8010q3hu]
yandex_storage_bucket.test: Refreshing state... [id=efanov-bucket-graduate]
yandex_vpc_subnet.public-b: Refreshing state... [id=e2llt1c5cu33dip3jcek]
yandex_vpc_subnet.public-a: Refreshing state... [id=e9bcsijrj7gfadd2ir6s]
yandex_vpc_subnet.public-c: Refreshing state... [id=b0chv9r0jc2bgjlc0osc]
yandex_vpc_security_group.nat-instance-sg: Refreshing state... [id=enpj41q4dacvikd78mke]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # yandex_iam_service_account.sa will be destroyed
  - resource "yandex_iam_service_account" "sa" {
      - created_at = "2024-02-22T19:38:05Z" -> null
      - folder_id  = "b1gk7s99783hucvo6t4s" -> null
      - id         = "aje5p4r3n4ole175h9r0" -> null
      - name       = "svc-acc-grd" -> null
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be destroyed
  - resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      - access_key         = "YCAJEF1BCbK2WXqatDWCElfTI" -> null
      - created_at         = "2024-02-22T19:38:07Z" -> null
      - description        = "static access key for object storage" -> null
      - id                 = "aje4seqjgifn8010q3hu" -> null
      - secret_key         = (sensitive value)
      - service_account_id = "aje5p4r3n4ole175h9r0" -> null
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be destroyed
  - resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      - folder_id = "b1gk7s99783hucvo6t4s" -> null
      - id        = "b1gk7s99783hucvo6t4s/storage.editor/serviceAccount:aje5p4r3n4ole175h9r0" -> null
      - member    = "serviceAccount:aje5p4r3n4ole175h9r0" -> null
      - role      = "storage.editor" -> null
    }

  # yandex_storage_bucket.test will be destroyed
  - resource "yandex_storage_bucket" "test" {
      - access_key            = "YCAJEF1BCbK2WXqatDWCElfTI" -> null
      - bucket                = "efanov-bucket-graduate" -> null
      - bucket_domain_name    = "efanov-bucket-graduate.storage.yandexcloud.net" -> null
      - default_storage_class = "STANDARD" -> null
      - folder_id             = "b1gk7s99783hucvo6t4s" -> null
      - force_destroy         = false -> null
      - id                    = "efanov-bucket-graduate" -> null
      - max_size              = 0 -> null
      - policy                = "" -> null
      - secret_key            = (sensitive value)
      - tags                  = {} -> null

      - anonymous_access_flags {
          - config_read = false -> null
          - list        = false -> null
          - read        = false -> null
        }

      - versioning {
          - enabled = false -> null
        }
    }

  # yandex_vpc_network.vpc will be destroyed
  - resource "yandex_vpc_network" "vpc" {
      - created_at                = "2024-02-22T19:38:05Z" -> null
      - default_security_group_id = "enpas4opjtm5c2r907do" -> null
      - folder_id                 = "b1gk7s99783hucvo6t4s" -> null
      - id                        = "enpjr01oj7un38r6k9uo" -> null
      - labels                    = {} -> null
      - name                      = "graduate-vpc" -> null
      - subnet_ids                = [
          - "b0chv9r0jc2bgjlc0osc",
          - "e2llt1c5cu33dip3jcek",
          - "e9bcsijrj7gfadd2ir6s",
        ] -> null
    }

  # yandex_vpc_security_group.nat-instance-sg will be destroyed
  - resource "yandex_vpc_security_group" "nat-instance-sg" {
      - created_at = "2024-02-22T19:38:08Z" -> null
      - folder_id  = "b1gk7s99783hucvo6t4s" -> null
      - id         = "enpj41q4dacvikd78mke" -> null
      - labels     = {} -> null
      - name       = "nat-instance-sg" -> null
      - network_id = "enpjr01oj7un38r6k9uo" -> null
      - status     = "ACTIVE" -> null

      - egress {
          - description    = "any" -> null
          - from_port      = -1 -> null
          - id             = "enpojlsaa3spj4agldcc" -> null
          - labels         = {} -> null
          - port           = -1 -> null
          - protocol       = "ANY" -> null
          - to_port        = -1 -> null
          - v4_cidr_blocks = [
              - "0.0.0.0/0",
            ] -> null
          - v6_cidr_blocks = [] -> null
        }

      - ingress {
          - description    = "ext-http" -> null
          - from_port      = -1 -> null
          - id             = "enp6llr94vccop381ip2" -> null
          - labels         = {} -> null
          - port           = 80 -> null
          - protocol       = "TCP" -> null
          - to_port        = -1 -> null
          - v4_cidr_blocks = [
              - "0.0.0.0/0",
            ] -> null
          - v6_cidr_blocks = [] -> null
        }
      - ingress {
          - description    = "ext-https" -> null
          - from_port      = -1 -> null
          - id             = "enp5m6kb6539qtl5uo2q" -> null
          - labels         = {} -> null
          - port           = 443 -> null
          - protocol       = "TCP" -> null
          - to_port        = -1 -> null
          - v4_cidr_blocks = [
              - "0.0.0.0/0",
            ] -> null
          - v6_cidr_blocks = [] -> null
        }
      - ingress {
          - description    = "ssh" -> null
          - from_port      = -1 -> null
          - id             = "enphuvhgb91r0cnsdsmr" -> null
          - labels         = {} -> null
          - port           = 22 -> null
          - protocol       = "TCP" -> null
          - to_port        = -1 -> null
          - v4_cidr_blocks = [
              - "0.0.0.0/0",
            ] -> null
          - v6_cidr_blocks = [] -> null
        }
    }

  # yandex_vpc_subnet.public-a will be destroyed
  - resource "yandex_vpc_subnet" "public-a" {
      - created_at     = "2024-02-22T19:38:06Z" -> null
      - folder_id      = "b1gk7s99783hucvo6t4s" -> null
      - id             = "e9bcsijrj7gfadd2ir6s" -> null
      - labels         = {} -> null
      - name           = "public-a" -> null
      - network_id     = "enpjr01oj7un38r6k9uo" -> null
      - v4_cidr_blocks = [
          - "192.168.10.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
    }

  # yandex_vpc_subnet.public-b will be destroyed
  - resource "yandex_vpc_subnet" "public-b" {
      - created_at     = "2024-02-22T19:38:07Z" -> null
      - folder_id      = "b1gk7s99783hucvo6t4s" -> null
      - id             = "e2llt1c5cu33dip3jcek" -> null
      - labels         = {} -> null
      - name           = "public-b" -> null
      - network_id     = "enpjr01oj7un38r6k9uo" -> null
      - v4_cidr_blocks = [
          - "192.168.11.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-b" -> null
    }

  # yandex_vpc_subnet.public-c will be destroyed
  - resource "yandex_vpc_subnet" "public-c" {
      - created_at     = "2024-02-22T19:38:07Z" -> null
      - folder_id      = "b1gk7s99783hucvo6t4s" -> null
      - id             = "b0chv9r0jc2bgjlc0osc" -> null
      - labels         = {} -> null
      - name           = "public-c" -> null
      - network_id     = "enpjr01oj7un38r6k9uo" -> null
      - v4_cidr_blocks = [
          - "192.168.12.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-c" -> null
    }

Plan: 0 to add, 0 to change, 9 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

yandex_vpc_subnet.public-b: Destroying... [id=e2llt1c5cu33dip3jcek]
yandex_resourcemanager_folder_iam_member.sa-editor: Destroying... [id=b1gk7s99783hucvo6t4s/storage.editor/serviceAccount:aje5p4r3n4ole175h9r0]
yandex_vpc_subnet.public-a: Destroying... [id=e9bcsijrj7gfadd2ir6s]
yandex_vpc_subnet.public-c: Destroying... [id=b0chv9r0jc2bgjlc0osc]
yandex_storage_bucket.test: Destroying... [id=efanov-bucket-graduate]
yandex_vpc_security_group.nat-instance-sg: Destroying... [id=enpj41q4dacvikd78mke]
yandex_vpc_subnet.public-a: Destruction complete after 0s
yandex_vpc_security_group.nat-instance-sg: Destruction complete after 0s
yandex_vpc_subnet.public-c: Destruction complete after 1s
yandex_vpc_subnet.public-b: Destruction complete after 1s
yandex_vpc_network.vpc: Destroying... [id=enpjr01oj7un38r6k9uo]
yandex_vpc_network.vpc: Destruction complete after 1s
yandex_resourcemanager_folder_iam_member.sa-editor: Destruction complete after 3s
yandex_storage_bucket.test: Still destroying... [id=efanov-bucket-graduate, 10s elapsed]
yandex_storage_bucket.test: Destruction complete after 11s
yandex_iam_service_account_static_access_key.sa-static-key: Destroying... [id=aje4seqjgifn8010q3hu]
yandex_iam_service_account_static_access_key.sa-static-key: Destruction complete after 1s
yandex_iam_service_account.sa: Destroying... [id=aje5p4r3n4ole175h9r0]
yandex_iam_service_account.sa: Destruction complete after 3s

Destroy complete! Resources: 9 destroyed.

```

</details>


---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

