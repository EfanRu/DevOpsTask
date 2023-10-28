# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Решение 1.
[pod_hello_world.yaml](pod_hello_world.yaml)

```commandline
slava@slava-FLAPTOP-r:~/..$ kubectl apply -f ./pod_hello_world.yaml 
pod/hello-world created
slava@slava-FLAPTOP-r:~/..$ kubectl port-forward pod/hello-world-svc 8181:8080
Forwarding from 127.0.0.1:8181 -> 8080
Forwarding from [::1]:8181 -> 8080
Handling connection for 8181
```

    Ошибка с которой я потратил кучу времени была в том, что порты были закрыты и по умолчанию работает только с портом 8080:
```commandline
slava@slava-FLAPTOP-r:~/Documents/DevOpsTask/src/task11_Microservices/Task11_6_k8s_1-2$ Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
E1028 11:13:25.215757  208803 portforward.go:409] an error occurred forwarding 8080 -> 80: error forwarding port 80 to pod cda20f88c711e3ad17eac11bff750b76d674d47d58e12ac3e8170c870e2be24c, uid : failed to execute portforward in network namespace "/var/run/netns/cni-c1b24c67-0aab-0239-816c-bfc7b3ce9fd2": failed to connect to localhost:80 inside namespace "cda20f88c711e3ad17eac11bff750b76d674d47d58e12ac3e8170c870e2be24c", IPv4: dial tcp4 127.0.0.1:80: connect: connection refused IPv6 dial tcp6 [::1]:80: connect: connection refused 
error: lost connection to pod
```
------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Решение 2.
[pod_netology_web.yaml](pod_netology_web.yaml)
[service_netology_svc.yaml](service_netology_svc.yaml)
```commandline
slava@slava-FLAPTOP-r:~/..$ kubectl apply -f ./pod_netology_web.yaml 
pod/netology-web created
slava@slava-FLAPTOP-r:~/..$ kubectl apply -f ./service_netology_svc.yaml 
service/netology-svc created
slava@slava-FLAPTOP-r:~/..$ kubectl port-forward svc/netology-svc 8181:8080
Forwarding from 127.0.0.1:8181 -> 8080
Forwarding from [::1]:8181 -> 8080
Handling connection for 8181
```
![Connect_to_SVC_netology-web.png](ScreenShoots%2FConnect_to_SVC_netology-web.png)
------
