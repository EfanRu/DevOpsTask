# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

------

### Решение 1.
1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
    Если создавать deployment c контейнерами nginx и multitool, которые оба используют nginx и 80 порт, то будет возникать ошибка.
    Решением является передать в контейнер multitool переменную HTTP_PORT, которая поменяет порт nginx с 80 порта.

[deployment_1.yaml](deployment_1.yaml)
```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/deployment_1.yaml
deployment.apps/nginx-multitool-deployment created
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                          READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-78b6f69685-mpw9l   2/2     Running   0          5s    10.1.128.210   microk8s   <none>           <none>
```

2. После запуска увеличить количество реплик работающего приложения до 2.

[deployment_2.yaml](deployment_2.yaml)    
```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/deployment_2.yaml
deployment.apps/nginx-multitool-deployment created
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                         READY   STATUS              RESTARTS   AGE   IP       NODE       NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-b88697485-9gbtv   0/2     ContainerCreating   0          2s    <none>   microk8s   <none>           <none>
nginx-multitool-deployment-b88697485-4fwq2   0/2     ContainerCreating   0          2s    <none>   microk8s   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                         READY   STATUS              RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-b88697485-4fwq2   0/2     ContainerCreating   0          4s    <none>         microk8s   <none>           <none>
nginx-multitool-deployment-b88697485-9gbtv   2/2     Running             0          4s    10.1.128.248   microk8s   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                         READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-b88697485-9gbtv   2/2     Running   0          6s    10.1.128.248   microk8s   <none>           <none>
nginx-multitool-deployment-b88697485-4fwq2   2/2     Running   0          6s    10.1.128.249   microk8s   <none>           <none>
```

3. Продемонстрировать количество подов до и после масштабирования.
    Done.

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

[service.yaml](service.yaml)

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/service.yaml 
service/nginx-multitool-svc created
slava@slava-FLAPTOP-r:~$ kubectl get svc
NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes            ClusterIP   10.152.183.1     <none>        443/TCP             6d23h
nginx-multitool-svc   ClusterIP   10.152.183.154   <none>        8080/TCP,8081/TCP   5s
```

5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.
[pod_multitool.yaml](pod_multitool.yaml)

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                         READY   STATUS    RESTARTS     AGE   IP             NODE       NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-b88697485-vsxv4   2/2     Running   0            27s   10.1.128.232   microk8s   <none>           <none>
nginx-multitool-deployment-b88697485-qxvhj   2/2     Running   1 (6s ago)   27s   10.1.128.233   microk8s   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/pod_multitool.yaml 
pod/multitool created
slava@slava-FLAPTOP-r:~$ kubectl exec multitool -- curl 10.1.128.232
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   916k      0 --:--:-- --:--:-- --:--:--  597k
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
<h1>Welcome to nginx!</h1>slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                         READY   STATUS    RESTARTS     AGE   IP             NODE       NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-b88697485-vsxv4   2/2     Running   0            27s   10.1.128.232   microk8s   <none>           <none>
nginx-multitool-deployment-b88697485-qxvhj   2/2     Running   1 (6s ago)   27s   10.1.128.233   microk8s   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/pod_multitool.yaml 
pod/multitool created
slava@slava-FLAPTOP-r:~$ kubectl exec multitool -- curl 10.1.128.232
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   916k      0 --:--:-- --:--:-- --:--:--  597k
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

<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
slava@slava-FLAPTOP-r:~$ kubectl exec multitool -- curl 10.1.128.233
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   790k      0 --:--:-- --:--:-- --:--:--  597k
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
```

</details>

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

------

### Решение 2.

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

    Прописываем в initContainer запрос на проверку запуска сервиса "nslookup nginx-svc" и проверяем с подняты сервисом и наоборот

[deployment_3.yaml](deployment_3.yaml)
[service_3.yaml](service_3.yaml)

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/deployment_3.yaml 
deployment.apps/nginx-deployment created
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-6cbb9979cc-qnr59   1/1     Running   0          3s
slava@slava-FLAPTOP-r:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP    8d
nginx-svc    ClusterIP   10.152.183.134   <none>        8080/TCP   6h39m
slava@slava-FLAPTOP-r:~$ kubectl delete deployment/nginx-deployment
deployment.apps "nginx-deployment" deleted
slava@slava-FLAPTOP-r:~$ kubectl delete svc/nginx-svc
service "nginx-svc" deleted
slava@slava-FLAPTOP-r:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   8d
slava@slava-FLAPTOP-r:~$ kubectl get pods
No resources found in default namespace.
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/deployment_3.yaml 
deployment.apps/nginx-deployment created
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                READY   STATUS     RESTARTS   AGE
nginx-deployment-6cbb9979cc-hltnv   0/1     Init:0/1   0          4s
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                READY   STATUS     RESTARTS   AGE
nginx-deployment-6cbb9979cc-hltnv   0/1     Init:0/1   0          9s
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_7_k8s_1-3/service_3.yaml 
service/nginx-svc created
slava@slava-FLAPTOP-r:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP    8d
nginx-svc    ClusterIP   10.152.183.203   <none>        8080/TCP   4s
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-6cbb9979cc-hltnv   1/1     Running   0          28s
```

</details>
------



### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
