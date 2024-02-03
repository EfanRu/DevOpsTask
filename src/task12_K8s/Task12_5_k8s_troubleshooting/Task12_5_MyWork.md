# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

----

### Решение. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

```commandline
slava@master-node:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
```

    Хмм..что-то нет нужных namespace :( Сделаем их!

```commandline
slava@master-node:~$ kubectl create namespace web
namespace/web created
slava@master-node:~$ kubectl create namespace data
namespace/data created
slava@master-node:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created
k8s_adm@master-node:/home/slava$ kubectl get pods -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-5f87765478-dgscv   1/1     Running   0          30s
web-consumer-5f87765478-s2b4k   1/1     Running   0          30s
k8s_adm@master-node:/home/slava$ kubectl get pods -n data
NAME                       READY   STATUS    RESTARTS   AGE
auth-db-7b5cdbdc77-f4qr9   1/1     Running   0          69s
```

    И это все?)))
    Ну ок. Все работает :)

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
