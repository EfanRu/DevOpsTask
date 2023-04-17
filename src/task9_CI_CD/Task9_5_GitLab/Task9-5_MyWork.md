# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению

### Задание 1
    Подготовьте к работе GitLab по инструкции.

### Решение 1
    Done.
    Перед повторным запуском нужно прописать в консоли:
```commandline
slava@slava-MS-7677:~$ export TF_VAR_YC_TOKEN=$(yc iam create-token)
slava@slava-MS-7677:~$ export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
slava@slava-MS-7677:~$ export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
slava@slava-MS-7677:~$ terraform apply
```

```commandline
slava@slava-FLAPTOP-r:~/Documents/DevOpsTask/src/task9_CI_CD/Task9_5_GitLab/terraform$ terraform validate
Success! The configuration is valid.
```

```commandline
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

```commandline
slava@slava-FLAPTOP-r:~$ yc managed-kubernetes cluster   get-credentials k8s-cluster   --external

Context 'yc-k8s-cluster' was added as default to kubeconfig '/home/slava/.kube/config'.
Check connection to cluster using 'kubectl cluster-info --kubeconfig /home/slava/.kube/config'.

Note, that authentication depends on 'yc' and its config profile 'sa-terraform'.
To access clusters using the Kubernetes API, please use Kubernetes Service Account.
slava@slava-FLAPTOP-r:~$ kubectl cluster-info
Kubernetes control plane is running at https://51.250.92.149
CoreDNS is running at https://51.250.92.149/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### Задание 2
    Создайте свой новый проект.

### Решение 2
[My gitlab project](https://efan-git-lab.gitlab.yandexcloud.net/slava/netology)


### Задание 3
    Создайте новый репозиторий в GitLab, наполните его файлами.

### Решение 3
![Create_gitlab_repo.png](Screenshots%2FCreate_gitlab_repo.png)

### Задание 4
    Проект должен быть публичным, остальные настройки по желанию.

### Решение 4
![Add_files.png](Screenshots%2FAdd_files.png)

## Основная часть

## DevOps
    В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

### Задание 1
    Образ собирается на основе centos:7.

### Решение 1
```yaml
FROM centos:7
```

### Задание 2
    Python версии не ниже 3.7.

### Решение 2
```yaml
RUN yum install python3 python-pip -y
```

### Задание 3
    Установлены зависимости: flask flask-jsonpify flask-restful.

### Решение 3
Add in file requrements:
```text
flask
flask_restful
flask_jsonpify
```


### Задание 4
    Создана директория /python_api.

### Решение 4
    Done.

### Задание 5
    Скрипт из репозитория размещён в /python_api.

### Решение 5
![Script_path.png](Screenshots%2FScript_path.png)

### Задание 6
    Точка вызова: запуск скрипта.

### Решение 6
```yaml
  script:
    - docker build -t my_docker_build:latest .
```

### Задание 7
    Если сборка происходит на ветке master: должен подняться pod kubernetes на основе образа python-api, иначе этот шаг нужно пропустить.

### Решение 7
    Ну у нас мастер ветка это main.
[gitlab-ci.yml](gitlab-ci.yml)
[Dockerfile](Dockerfile)

## Product Owner
    Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET /rest/api/get_info, необходимо создать Issue в котором указать:

### Задание 1
    Какой метод необходимо исправить.

### Решение 1
![Create_issues.png](Screenshots%2FCreate_issues.png)

### Задание 2
    Текст с { "message": "Already started" } на { "message": "Running"}.

### Решение 2
![Issues_text1.png](Screenshots%2FIssues_text1.png)
![Issues_text2.png](Screenshots%2FIssues_text2.png)


### Задание 3
    Issue поставить label: feature.

### Решение 3
![Issues_label.png](Screenshots%2FIssues_label.png)


## Developer
    Пришёл новый Issue на доработку, вам нужно:

### Задание 1
    Создать отдельную ветку, связанную с этим Issue.

### Решение 1
![Issues_create_branch.png](Screenshots%2FIssues_create_branch.png)

### Задание 2
    Внести изменения по тексту из задания.

### Решение 2
    Done.

### Задание 3
    Подготовить Merge Request, влить необходимые изменения в master, проверить, что сборка прошла успешно.

### Решение 3
![Issues_MR.png](Screenshots%2FIssues_MR.png)
    Почему-то локальный запуск работает корректно, но через раннер, который я установил на своем компе ошибка.
![Issue_pipe.png](Screenshots%2FIssue_pipe.png)

## Tester
    Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

### Задание 1
    Поднять докер-контейнер с образом python-api:latest и проверить возврат метода на корректность.

### Решение 1
![Run_docker_container.png](Screenshots%2FRun_docker_container.png)
![Test_py_script.png](Screenshots%2FTest_py_script.png)

### Задание 2
    Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

### Решение 2
![Close_issue.png](Screenshots%2FClose_issue.png)


### Итог

    В качестве ответа пришлите подробные скриншоты по каждому пункту задания:
        файл gitlab-ci.yml;
[gitlab-ci.yml](gitlab-ci.yml)
        Dockerfile;
[Dockerfile](Dockerfile)
        лог успешного выполнения пайплайна;
    Успешно получить pipeline не получилось((
```text
      Checking out 74b7264b as detached HEAD (ref is 1-change-get-rest-api-get_info)...

Skipping Git submodules setup
Executing "step_script" stage of the job script
Using docker image sha256:1588477122de4fdfe9fcb9ddeeee6ac6b93e9e05a65c68a6e22add0a98b8e0fe for docker:20.10.5 with digest docker@sha256:7ed427295687586039ff3433bb9b4419c5cf1e6294025dadf7641126665a78f5 ...
$ docker build -t my_docker_build:latest .
error during connect: Post http://docker:2375/v1.24/build?buildargs=%7B%7D&cachefrom=%5B%5D&cgroupparent=&cpuperiod=0&cpuquota=0&cpusetcpus=&cpusetmems=&cpushares=0&dockerfile=Dockerfile&labels=%7B%7D&memory=0&memswap=0&networkmode=default&rm=1&shmsize=0&t=my_docker_build%3Alatest&target=&ulimits=null&version=1: dial tcp: lookup docker on 192.168.1.1:53: no such host
Cleaning up project directory and file based variables
ERROR: Job failed: exit code 1
```
        решённый Issue.
![Close_issue.png](Screenshots%2FClose_issue.png)

### Необязательная часть

### Задание 1
    Автомазируйте работу тестировщика — пусть у вас будет отдельный конвейер, который автоматически поднимает контейнер и выполняет проверку, например, при помощи curl. На основе вывода будет приниматься решение об успешности прохождения тестирования.

### Решение 1
    Не сделал.

---