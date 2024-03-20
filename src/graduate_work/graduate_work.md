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

    Конфигурационный файл терраформа:

[main.tf](main.tf)

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

### Решение создание Kubernetes кластера

        Для развертывания Kubernetes на нодах будем использовать https://github.com/kubernetes-sigs/kubespray .
        После создания ресурсов необходимо сохранить созданные IP адреса в hosts.yaml. Указывать при этом в ansible_host 
        публичный IP адрес, а ip и access_ip нужно указать внутренний, иначе Kubespray не отработает корректно.
        Так как у меня закончился промокод на яндекс клауд, то я оставил создание 2 ВМ, так как тратятся уже мои личные деньги.
        Но в коде я закомментил вариант для создания ВМ в 3х разных зонах с 3 мастер нодами и 2 воркер нодами.

```commandline
# Change enviroments for kubespray pip and install etcd
virtualenv ansible_pip
source ansible_pip/bin/activate
pip install -r requirements.txt
apt install etcd

# Update Ansible inventory file with inventory builder
declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
```

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
### Решение создание тестового приложения

1. Git репозиторий с тестовым приложением и Dockerfile: 
    - https://github.com/EfanRu/JM_my_web4_spring_boot
    - [Dockerfile](docker%2FDockerfile)
    - [docker-compose.yml](docker%2Fdocker-compose.yml)
2. Регистри с собранным docker image: https://hub.docker.com/repository/docker/ledok/jm_my_web4_spring_boot/general
3. Манифест запуска приложения + postgres на kubernetes: [manifest_app_deploy.yaml](inventory%2Fmanifest_app_deploy.yaml)

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.
---
### Подготовка cистемы мониторинга и деплой приложения
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
### Решение подготовка cистемы мониторинга и деплой приложения

    Для развертывания использовал Kube-prometheus. А для доступа не получилось настроить Ingress-controller (потратил кучу 
    сил и времени), так что реализовал через NodePort http доступ.

```commandline
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install my-prometheus-stack prometheus-community/kube-prometheus-stack
```

    Создание NodePort:

[manifest_app_deploy.yaml](inventory%2Fmanifest_app_deploy.yaml)

1. Git репозиторий с конфигурационными файлами для настройки Kubernetes: https://github.com/prometheus-operator/kube-prometheus
2. Http доступ к web интерфейсу grafana: http://51.250.8.232:30036
3. Дашборды в grafana отображающие состояние Kubernetes кластера. http://51.250.8.232:30036/d/efa86fd1d0c121a26444b636a3f509a8/kubernetes-compute-resources-cluster?orgId=1&refresh=10s

![grafana_dashboard.png](screenshots%2Fgrafana_dashboard.png)

4. Http доступ к тестовому приложению. http://51.250.8.232:30037

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
### Решение установка и настройка CI/CD

    Для текущего состояния кластера достаточно одного мастера Jenkins. Работу с агентами не стал удалять, а закомментил.
[jenkins.yml](infrastructure%2Fjenkins.yml)

```commandline
ansible-playbook -i infrastructure/inventory/cicd/hosts.yml --become --become-user=root --key-file /root/.ssh/id_rsa infrastructure/jenkins.yml
```

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http: http://51.250.8.232:8080
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.

```commandline
slava@slava-FLAPTOP-r:~/Documents/JM_my_web4_spring_boot$ git push origin
Enumerating objects: 11, done.
Counting objects: 100% (11/11), done.
Delta compression using up to 12 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 550 bytes | 550.00 KiB/s, done.
Total 6 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:EfanRu/JM_my_web4_spring_boot.git
   ad0eb58..401395f  master -> master
```

![git_push.png](screenshots%2Fgit_push.png)

![git_push_docker_hub.png](screenshots%2Fgit_push_docker_hub.png)

![git_push_jenkins.png.png](screenshots%2Fgit_push_jenkins.png.png)

3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

```commandline
slava@slava-FLAPTOP-r:~/Documents/JM_my_web4_spring_boot$ git push origin
Enumerating objects: 11, done.
Counting objects: 100% (11/11), done.
Delta compression using up to 12 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 550 bytes | 550.00 KiB/s, done.
Total 6 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:EfanRu/JM_my_web4_spring_boot.git
   ad0eb58..401395f  master -> master
```

![git_push_tag.png](screenshots%2Fgit_push_tag.png)

![git_pusg_tag_docker_hub.png](screenshots%2Fgit_pusg_tag_docker_hub.png)

![git_push_tag_jenkins.png](screenshots%2Fgit_push_tag_jenkins.png)

![git_push_tag_jenkins_k8s.png](screenshots%2Fgit_push_tag_jenkins_k8s.png)

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
    https://github.com/EfanRu/DevOpsTask/tree/main/src/graduate_work
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
   По совету куратора, чтобы не поломать уже настроенный кластер я выполнял только команду terraform plan. 
   Из нюансов, можно было бы вначале засетить создание токена YC, который живет сутки, но этого делать не стал, так как 
   это не очень безопасно тем более, что мой дженкинс работает на открытом протоколе http. А через сутки пайп перестанет работать.
   Тут ещё как решение, можно было бы найти как сделать постоянный токен, но надеюсь в этом нет необходимости.
   - WebHook github

![terraform_CI_github_webhook.png](screenshots%2Fterraform_CI_github_webhook.png)

   - Jenkins build http://51.250.8.232:8080/job/terraform%20CI/

![terraform_CI_jenkins_build.png](screenshots%2Fterraform_CI_jenkins_build.png)

   - Jenkins build console terraform plan http://51.250.8.232:8080/job/terraform%20CI/13/console

![terraform_CI_jenkins_console.png](screenshots%2Fterraform_CI_jenkins_console.png)

3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
    Делал через kube-spray.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.

https://hub.docker.com/repository/docker/ledok/jm_my_web4_spring_boot/general

[Dockerfile](docker%2FDockerfile)

5. Репозиторий с конфигурацией Kubernetes кластера.

[inventory](inventory)

6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.

http://158.160.87.3:30037/ - test app

http://158.160.87.3:30036 - grafana 

7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

