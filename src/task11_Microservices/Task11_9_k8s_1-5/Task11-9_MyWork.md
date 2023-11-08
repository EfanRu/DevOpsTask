# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Решение 1.

[manifest.yaml](manifest.yaml)

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_9_k8s_1-5/manifest.yaml
deployment.apps/front-nginx-multitool-deployment unchanged
deployment.apps/backend-multitool-deployment configured
service/front-svc unchanged
service/back-svc unchanged
slava@slava-FLAPTOP-r:~$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP           11d
front-svc    ClusterIP   10.152.183.103   <none>        80/TCP,8080/TCP   49m
back-svc     ClusterIP   10.152.183.34    <none>        80/TCP            49m
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide
NAME                                                READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
front-nginx-multitool-deployment-8558db4dd4-tcgm7   2/2     Running   0          53m   10.1.128.238   microk8s   <none>           <none>
front-nginx-multitool-deployment-8558db4dd4-cx8kv   2/2     Running   0          53m   10.1.128.255   microk8s   <none>           <none>
front-nginx-multitool-deployment-8558db4dd4-kbspr   2/2     Running   0          53m   10.1.128.240   microk8s   <none>           <none>
backend-multitool-deployment-689d7cfbc7-wflhs       1/1     Running   0          19s   10.1.128.241   microk8s   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl exec pods/backend-multitool-deployment-689d7cfbc7-wflhs -- curl front-svc:80
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   355k      0 --:--:-- --:--:-- --:--:--  597k
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
slava@slava-FLAPTOP-r:~$ kubectl exec pods/backend-multitool-deployment-689d7cfbc7-wflhs -- curl front-svc:8080
WBITT Network MultiTool (with NGINX) - front-nginx-multitool-deployment-8558db4dd4-tcgm7 - 10.1.128.238 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   168  100   168    0     0  97902      0 --:--:-- --:--:-- --:--:--  164k
slava@slava-FLAPTOP-r:~$ kubectl exec pods/backend-multitool-deployment-689d7cfbc7-wflhs -- curl front-svc:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   168  100   168    0     0   151k      0 --:--:-- --:--:-- --:--:--  164k
WBITT Network MultiTool (with NGINX) - front-nginx-multitool-deployment-8558db4dd4-cx8kv - 10.1.128.255 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
slava@slava-FLAPTOP-r:~$ kubectl exec -c multitool pods/front-nginx-multitool-deployment-8558db4dd4-kbspr -- curl back-svc:80
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - backend-multitool-deployment-689d7cfbc7-wflhs - 10.1.128.241 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
100   162  100   162    0     0  57795      0 --:--:-- --:--:-- --:--:-- 81000
```

</details>

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Решение 2.

1. Включить Ingress-controller в MicroK8S.

<details><summary>Вывод в консоль:</summary>

```commandline
slava@microk8s:~$ microk8s enable ingress
Infer repository core for addon ingress
Enabling Ingress
ingressclass.networking.k8s.io/public created
ingressclass.networking.k8s.io/nginx created
namespace/ingress created
serviceaccount/nginx-ingress-microk8s-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
configmap/nginx-load-balancer-microk8s-conf created
configmap/nginx-ingress-tcp-microk8s-conf created
configmap/nginx-ingress-udp-microk8s-conf created
daemonset.apps/nginx-ingress-microk8s-controller created
Ingress is enabled
```

</details>

2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
[ingress.yaml](ingress.yaml)

3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ curl http://51.250.13.39/
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
slava@slava-FLAPTOP-r:~$ curl http://51.250.13.39/front-api
WBITT Network MultiTool (with NGINX) - front-nginx-multitool-deployment-8558db4dd4-tcgm7 - 10.1.128.238 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
slava@slava-FLAPTOP-r:~$ curl http://51.250.13.39/backend-api
WBITT Network MultiTool (with NGINX) - backend-multitool-deployment-689d7cfbc7-wflhs - 10.1.128.241 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                                READY   STATUS    RESTARTS   AGE
front-nginx-multitool-deployment-8558db4dd4-tcgm7   2/2     Running   0          3h50m
front-nginx-multitool-deployment-8558db4dd4-cx8kv   2/2     Running   0          3h50m
front-nginx-multitool-deployment-8558db4dd4-kbspr   2/2     Running   0          3h50m
backend-multitool-deployment-689d7cfbc7-wflhs       1/1     Running   0          177m
```

</details>

4. Предоставить манифесты и скриншоты или вывод команды п.2.
[manifest.yaml](manifest.yaml)
[ingress.yaml](ingress.yaml)

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
