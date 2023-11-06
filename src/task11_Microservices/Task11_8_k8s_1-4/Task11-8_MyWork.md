# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Решение 2.

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
[deployment_1.yaml](deployment_1.yaml)

2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
[service_1.yaml](service_1.yaml)

3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
[pod_multitool.yaml](pod_multitool.yaml)
[service_multitool.yaml](service_multitool.yaml)

4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl exec pods/multitool -- curl nginx-multitool-svc:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   453k      0 --:--:-- --:--:-- --:--:--  597k
slava@slava-FLAPTOP-r:~$ kubectl exec pods/multitool -- curl nginx-multitool-svc:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   161  100   161    0     0   1734      0 --:--:-- --:--:-- --:--:--  1750
WBITT Network MultiTool (with NGINX) - nginx-multitool-deployment-648d6f8c9-vkznr - 10.1.128.225 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

</details>


5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.
    Done.

______

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Решение 2.

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.
[service_2.yaml](service_2.yaml)

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl get svc -o wide
NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                       AGE   SELECTOR
kubernetes            ClusterIP   10.152.183.1     <none>        443/TCP                       9d    <none>
multitool-svc         ClusterIP   10.152.183.189   <none>        80/TCP                        20m   app=multitool
nginx-multitool-svc   NodePort    10.152.183.70    <none>        80:30689/TCP,8080:32307/TCP   94s   app=nginx-multitool
slava@slava-FLAPTOP-r:~$ curl 84.201.172.59:30689
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
slava@slava-FLAPTOP-r:~$ curl 84.201.172.59:32307
WBITT Network MultiTool (with NGINX) - nginx-multitool-deployment-648d6f8c9-jqlh9 - 10.1.128.231 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

</details>

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

