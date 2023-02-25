# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

# Задание 1
  Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
  Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

# Решение 1
  Подготовил файлы terraform для создания, управления и удаления 3 ВМ: clockhouse, vector и lighthouse:
[main.tf](Terraform%2Fmain.tf)
[data.tf](Terraform%2Fdata.tf)
[resource.tf](Terraform%2Fresource.tf)
[variables.tf](Terraform%2Fvariables.tf)
[versions.tf](Terraform%2Fversions.tf)

```commandline
terraform apply
yandex_compute_image.centos-7: Refreshing state... [id=fd8flliej0s2rv89gka4]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.clickhouse-01 will be created
  + resource "yandex_compute_instance" "clickhouse-01" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                slava:ssh-...
            EOT
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
              + image_id    = "fd8flliej0s2rv89gka4"
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
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.lighthouse-01 will be created
  + resource "yandex_compute_instance" "lighthouse-01" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                slava:ssh-...
            EOT
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
              + image_id    = "fd8flliej0s2rv89gka4"
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

  # yandex_compute_instance.vector-01 will be created
  + resource "yandex_compute_instance" "vector-01" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                slava:ssh-...
            EOT
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
              + image_id    = "fd8flliej0s2rv89gka4"
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

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_clickhouse-01 = (known after apply)
  + external_ip_address_lighthouse-01 = (known after apply)
  + external_ip_address_vector-01     = (known after apply)
  + internal_ip_address_clickhouse-01 = (known after apply)
  + internal_ip_address_lighthouse-01 = (known after apply)
  + internal_ip_address_vector-01     = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_compute_instance.clickhouse-01: Creating...
yandex_compute_instance.lighthouse-01: Creating...
yandex_compute_instance.vector-01: Creating...
yandex_compute_instance.lighthouse-01: Still creating... [10s elapsed]
yandex_compute_instance.vector-01: Still creating... [10s elapsed]
yandex_compute_instance.clickhouse-01: Still creating... [10s elapsed]
yandex_compute_instance.lighthouse-01: Still creating... [20s elapsed]
yandex_compute_instance.vector-01: Still creating... [20s elapsed]
yandex_compute_instance.clickhouse-01: Still creating... [20s elapsed]
yandex_compute_instance.clickhouse-01: Still creating... [30s elapsed]
yandex_compute_instance.vector-01: Still creating... [30s elapsed]
yandex_compute_instance.lighthouse-01: Still creating... [30s elapsed]
yandex_compute_instance.lighthouse-01: Still creating... [40s elapsed]
yandex_compute_instance.clickhouse-01: Still creating... [40s elapsed]
yandex_compute_instance.vector-01: Still creating... [40s elapsed]
yandex_compute_instance.vector-01: Creation complete after 50s [id=fhm40in81glfr6piblq6]
yandex_compute_instance.clickhouse-01: Still creating... [50s elapsed]
yandex_compute_instance.lighthouse-01: Still creating... [50s elapsed]
yandex_compute_instance.clickhouse-01: Creation complete after 52s [id=fhmjqul4n8b2se1uh7da]
yandex_compute_instance.lighthouse-01: Creation complete after 55s [id=fhmcs6oeo5onpjn6eqgi]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_clickhouse-01 = "51.250.93.117"
external_ip_address_lighthouse-01 = "51.250.87.47"
external_ip_address_vector-01 = "51.250.85.101"
internal_ip_address_clickhouse-01 = "10.1.2.22"
internal_ip_address_lighthouse-01 = "10.1.2.6"
internal_ip_address_vector-01 = "10.1.2.26"
```

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---