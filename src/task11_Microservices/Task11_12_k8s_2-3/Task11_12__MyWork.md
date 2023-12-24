# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Решение 1.

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
[manifest_1.yaml](manifest_1.yaml)

3. Продемонстрировать, что pod стартовал и оба конейнера работают.
```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_12_k8s_2-3/manifest_1.yaml
deployment.apps/nginx-multitool-deployment created
service/busybox-multitool-svc unchanged
configmap/my-configmap unchanged
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                          READY   STATUS    RESTARTS   AGE
nginx-multitool-deployment-5b88bc5df4-8w98s   2/2     Running   0          5s
```

4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_12_k8s_2-3/manifest_2.yaml
deployment.apps/nginx-multitool-deployment created
service/busybox-multitool-svc unchanged
configmap/my-configmap unchanged
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                          READY   STATUS    RESTARTS      AGE
multitool-daemonset-cqrcc                     1/1     Running   2 (74m ago)   5d3h
nginx-multitool-deployment-77585f9c57-rcnkd   2/2     Running   0             13s
slava@slava-FLAPTOP-r:~$ kubectl exec pods/nginx-multitool-deployment-77585f9c57-rcnkd nginx -it -- sh
Defaulted container "nginx" out of: nginx, multitool
# cat /usr/share/nginx/html/index.html
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
<h1>Welcome to netology task with nginx in k8s!!!</h1>
<p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

<p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
slava@slava-FLAPTOP-r:~$ kubectl port-forward pod/nginx-multitool-deployment-77585f9c57-xvn6m 8181:80
Forwarding from 127.0.0.1:8181 -> 80
Forwarding from [::1]:8181 -> 80
Handling connection for 8181

```
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
![my_nginx.png](ScreenShoots%2Fmy_nginx.png)
[manifest_2.yaml](manifest_2.yaml)
------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Решение 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.

```commandline
openssl req -x509 \
            -sha256 -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=demo.mlopshub.com/C=US/L=San Fransisco" \
            -keyout rootCA.key -out rootCA.crt 
```

4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
[manifest_3.yaml](manifest_3.yaml)
```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_12_k8s_2-3/manifest_3.yaml
deployment.apps/nginx-multitool-deployment created
service/busybox-multitool-svc created
configmap/my-configmap unchanged
secret/my-app-secret-tls created
ingress.networking.k8s.io/http-ingress configured
slava@slava-FLAPTOP-r:~$ kubectl port-forward pods/nginx-multitool-deployment-6f68cdfc54-x6pmn 30080:443
Forwarding from 127.0.0.1:30080 -> 443
Forwarding from [::1]:30080 -> 443
Handling connection for 30080

```

    Получилось подключиться через https к multitool, а к моему nginx не получается. Пробовал менять nginx.conf в контейнере 
    руками и рестартовал nginx, так же пробовал сетить файл конфигурации nginx из multitool в nginx (акомменченные строки), 
    но ничего не получилось :( Технически настроить ingress и подключиться по https получилось. 
![https_connection_multitool.png](ScreenShoots%2Fhttps_connection_multitool.png)
![https_connection_nginx.png](ScreenShoots%2Fhttps_connection_nginx.png)


------
### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
