### Домашнее задание 7-2

# Задание 1
	 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).
	 
    Подробная инструкция на русском языке содержится здесь.
    Обратите внимание на период бесплатного использования после регистрации аккаунта.
    Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки базового терраформ конфига.
    Воспользуйтесь инструкцией на сайте терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

# Решение 1
	Делаем все по инструкицям:
		Подключаем yc: https://cloud.yandex.ru/docs/cli/quickstart#install
		Настраиваем service account и создаем файл конфигурации Terraform: https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#before-you-begin
		
        Создание Enviroment переменных, чтобы не хардкодить токен.
```commandline
slava@slava-MS-7677:~$ export TF_VAR_YC_TOKEN=$(yc iam create-token)
slava@slava-MS-7677:~$ export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
slava@slava-MS-7677:~$ export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
slava@slava-MS-7677:~$ terraform apply
```
        
        Остальное можно посмотреть в файлах .tf

        Запускаем успешно terraform plan:
```commandline
slava@slava-MS-7677:~/Documents/netology/my_homework/DevOpsTask/src/task7_IaC/Task7_2_Hello_Terraform$ terraform plan
data.yandex_compute_image.centos: Reading...
data.yandex_compute_image.centos: Read complete after 1s [id=fd8jvcoeij6u9se84dt5]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm1-ubuntu will be created
  + resource "yandex_compute_instance" "vm1-ubuntu" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "user-data" = <<-EOT
                #cloud-config
                users:
                  - name: slava
                    groups: sudo
                    shell: /bin/bash
                    sudo: ['ALL=(ALL) NOPASSWD:ALL']
                    ssh_authorized_keys:
                      - ssh-rsa ...XXX...
        }
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8bfmkt64o90eu4pksv"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = "e9bibsvqqoqfrf7ef0vo"
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
slava@slava-MS-7677:~/Documents/netology/my_homework/DevOpsTask/src/task7_IaC/Task7_2_Hello_Terraform$ 

```


	Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
		AMI - это поддерживаемый образ для Amazon. У нас немного все Yandex cloud, а в нем подобного определения я не нашел есть только образы и Yandex Cloud Marketplace.
		Сделать это можно с помощью Packer.
