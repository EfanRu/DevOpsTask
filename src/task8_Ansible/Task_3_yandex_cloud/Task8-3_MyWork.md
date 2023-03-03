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
export TF_VAR_YC_TOKEN=$(yc iam create-token)
export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
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

  Правда пока не автоматизировал полученные IP адреса вставлять в inventory((

## Основная часть

# Задание 1
  Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.

# Решение 1
  [lighthouse.yml](playbook%2Flighthouse.yml)

  Честно playbook отрабатывает, но по факту переходя по IP сервера:порт я получаю 403. Перепробовал кучу вариантов: проверял 
разных пользователей, правильность установленных разрешений на папках и каталогах, выключал SElinux - ничего не помогло.
  Playbook нашел рабочий видимо коллеги (https://github.com/alexei-emelin/Vector_Clickhouse_Lighthouse/blob/main/playbook/site.yml) 
тоже не помог с отображением работы lighthouse. Немного решение у него подсмотрел, но переработал по своему. Ну хоть честно))
 Так как в задании ничего нет про проверку спустя несколько часов решил оставить проблему правильного отображения lighthouse 
я и без этого отстаю от всех((

# Задание 2
  При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.

# Решение 2
  Сделано.

# Задание 3
  Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.

# Решение 3
  Сделано.
[lighthouse.yml](playbook%2Flighthouse.yml)

# Задание 4
  Приготовьте свой собственный inventory файл `prod.yml`.

# Решение 4
  Сделано.
[prod.yml](playbook%2Finventory%2Fprod.yml)

# Задание 5
    Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

# Решение 5
    Так как я не стал делать все в одном файле playbook и файлы site(clickhouse) и vector в прошлых заданиях проверялись, 
    то тут проверю только lighhouse.
```commandline
ansible-lint ./playbook/lighthouse.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: ./playbook/lighthouse.yml
WARNING  Listing 1 violation(s) that are fatal
yaml: no new line character at the end of file (new-line-at-end-of-file)
playbook/lighthouse.yml:55

You can skip specific rules or tags by adding them to your configuration file:
# .ansible-lint
warn_list:  # or 'skip_list' to silence them completely
  - yaml  # Violations reported by yamllint

Finished with 1 failure(s), 0 warning(s) on 1 files.
```

    И после исправления:
```commandline
ansible-lint ./playbook/lighthouse.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: ./playbook/lighthouse.yml
```

# Задание 6
    Попробуйте запустить playbook на этом окружении с флагом `--check`.

# Решение 6
    Запускать будем так же только lighting.yml
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/lighthouse.yml --check

PLAY [Install nginx] ************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
The authenticity of host '51.250.76.248 (51.250.76.248)' can't be established.
ED25519 key fingerprint is SHA256:4MQuyAg+BMmGDnopWeup3589pw80xiSyQxnKmb/JBjM.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [lighthouse-01]

TASK [Install epel-release] *****************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Install nginx] ************************************************************************************************************************************************************
fatal: [lighthouse-01]: FAILED! => {"changed": false, "msg": "No package matching 'nginx' found available, installed or updated", "rc": 126, "results": ["No package matching 'nginx' found available, installed or updated"]}

PLAY RECAP **********************************************************************************************************************************************************************
lighthouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   


```

    Данная ошибка связана с тем, что мы запускаем playbook в флагом --check и epel-release не устанавливается, а без него 
    не будет установлен и nginx. Проверим это в следующем задании.

# Задание 7
    Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

# Задание 7
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/lighthouse.yml --diff

PLAY [Install nginx] ************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install epel-release] *****************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Install nginx] ************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Create nginx config] ******************************************************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /home/slava/.ansible/tmp/ansible-local-4363246jok9qn/tmp8f60enjn/nginx.conf.j2
@@ -1,84 +1,28 @@
-# For more information on configuration, see:
-#   * Official English Documentation: http://nginx.org/en/docs/
-#   * Official Russian Documentation: http://nginx.org/ru/docs/
+user root;
+worker_processes 1;
 
-user nginx;
-worker_processes auto;
-error_log /var/log/nginx/error.log;
-pid /run/nginx.pid;
-
-# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
-include /usr/share/nginx/modules/*.conf;
+error_log /var/log/nginx/error.log warn;
+pid /var/run/nginx.pid;
 
 events {
-    worker_connections 1024;
+  worker_connections 1024;
 }
 
 http {
-    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
-                      '$status $body_bytes_sent "$http_referer" '
-                      '"$http_user_agent" "$http_x_forwarded_for"';
+  include   /etc/nginx/mime.types;
+  default_type  application/octet-stream;
 
-    access_log  /var/log/nginx/access.log  main;
+  log_format main '$remote_addr - $remote_user [$time_local] "$request" '
+                  '$status $body_bytes_sent "$http_refer" '
+                  '"$http_user_agent" "http_x_forwarded_for"';
+  access_log  /var/log/nginx/access.log main;
 
-    sendfile            on;
-    tcp_nopush          on;
-    tcp_nodelay         on;
-    keepalive_timeout   65;
-    types_hash_max_size 4096;
+  sendfile  on;
+  #tcp_nopush on;
 
-    include             /etc/nginx/mime.types;
-    default_type        application/octet-stream;
+  keepalive_timeout 65;
 
-    # Load modular configuration files from the /etc/nginx/conf.d directory.
-    # See http://nginx.org/en/docs/ngx_core_module.html#include
-    # for more information.
-    include /etc/nginx/conf.d/*.conf;
+  gzip  on;
 
-    server {
-        listen       80;
-        listen       [::]:80;
-        server_name  _;
-        root         /usr/share/nginx/html;
-
-        # Load configuration files for the default server block.
-        include /etc/nginx/default.d/*.conf;
-
-        error_page 404 /404.html;
-        location = /404.html {
-        }
-
-        error_page 500 502 503 504 /50x.html;
-        location = /50x.html {
-        }
-    }
-
-# Settings for a TLS enabled server.
-#
-#    server {
-#        listen       443 ssl http2;
-#        listen       [::]:443 ssl http2;
-#        server_name  _;
-#        root         /usr/share/nginx/html;
-#
-#        ssl_certificate "/etc/pki/nginx/server.crt";
-#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
-#        ssl_session_cache shared:SSL:1m;
-#        ssl_session_timeout  10m;
-#        ssl_ciphers HIGH:!aNULL:!MD5;
-#        ssl_prefer_server_ciphers on;
-#
-#        # Load configuration files for the default server block.
-#        include /etc/nginx/default.d/*.conf;
-#
-#        error_page 404 /404.html;
-#            location = /40x.html {
-#        }
-#
-#        error_page 500 502 503 504 /50x.html;
-#            location = /50x.html {
-#        }
-#    }
-
-}
-
+  include /etc/nginx/conf.d/*.conf;
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [start nginx] ***************************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [reload nginx] **************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY [Install Lighthouse] *******************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install git] **************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse Install from git] **********************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Create lighthouse config] *************************************************************************************************************************************************
--- before
+++ after: /home/slava/.ansible/tmp/ansible-local-4363246jok9qn/tmpdghqbnox/lighthouse.conf.j2
@@ -0,0 +1,10 @@
+server {
+    listen 8123;
+    listen [::]:8123;
+    server_name localhost;
+
+    location / {
+        root    /home/slava/lighthouse;
+        index  index.html;
+    }
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [reload nginx] **************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
lighthouse-01              : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


```
    Ошибки в установки nginx нет, о чем шла речь в прошлом задании.

# Задание 8
    Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

# Решение 8
```commandline
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/lighthouse.yml --diff

PLAY [Install nginx] ************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install epel-release] *****************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] ************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Create nginx config] ******************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY [Install Lighthouse] *******************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install git] **************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse Install from git] **********************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Create lighthouse config] *************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP **********************************************************************************************************************************************************************
lighthouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

    changed=0 говорит нам о том, что playbook идемпотентен.

# Задание 9
    Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

# Решение 9
    Сделано.
[README.md](README.md)

# Задание 10
    Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

# Решение 10
    Добавлю после исправления задания 9.
---