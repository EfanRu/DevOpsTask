# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.

[manifest_back.yaml](manifest_back.yaml)
[manifest_chache.yaml](manifest_chache.yaml)
[manifest_front.yaml](manifest_front.yaml)

```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide -n app
NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE          NOMINATED NODE   READINESS GATES
backend-deployment-74694b5b9-xn678     1/1     Running   0          23h   192.168.77.136   master-node   <none>           <none>
cache-deployment-6b4d776c85-xz9q2      1/1     Running   0          23h   192.168.77.137   master-node   <none>           <none>
frontend-deployment-7d4d5b7597-5sr5r   1/1     Running   0          23h   192.168.77.135   master-node   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl get svc -o wide -n app
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   SELECTOR
app-backend-svc    ClusterIP   10.102.58.7     <none>        81/TCP     16h   app=backend
app-cache-svc      ClusterIP   10.106.192.18   <none>        82/TCP     16h   app=cache
app-frontend-svc   ClusterIP   10.99.162.96    <none>        8080/TCP   39h   app=frontend

```

2. В качестве образа использовать network-multitool.

    Done.

3. Разместить поды в namespace App.

[manifest_namespace.yaml](manifest_namespace.yaml)
```commandline
slava@slava-FLAPTOP-r:~$ kubectl get ns -o wide
NAME               STATUS   AGE
app                Active   47h
calico-apiserver   Active   5d23h
calico-system      Active   5d23h
default            Active   5d23h
kube-node-lease    Active   5d23h
kube-public        Active   5d23h
kube-system        Active   5d23h
tigera-operator    Active   5d23h
```

4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.

[manifest_network_back.yaml](manifest_network_back.yaml)
[manifest_network_cache.yaml](manifest_network_cache.yaml)
[manifest_network_front.yaml](manifest_network_front.yaml)

5. Продемонстрировать, что трафик разрешён и запрещён.

   Делал в точности по заданию: frontend -> backend -> cache и заблокировал обратную связь backend -> fronend и cache -> backend.

```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pods -o wide -n app
NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE          NOMINATED NODE   READINESS GATES
backend-deployment-74694b5b9-xn678     1/1     Running   0          23h   192.168.77.136   master-node   <none>           <none>
cache-deployment-6b4d776c85-xz9q2      1/1     Running   0          23h   192.168.77.137   master-node   <none>           <none>
frontend-deployment-7d4d5b7597-5sr5r   1/1     Running   0          23h   192.168.77.135   master-node   <none>           <none>

slava@slava-FLAPTOP-r:~$ kubectl exec pods/frontend-deployment-7d4d5b7597-5sr5r -n app -it -- sh
/ # curl --connect-timeout 5 192.168.77.137
curl: (28) Failed to connect to 192.168.77.137 port 80 after 5001 ms: Timeout was reached
/ # curl --connect-timeout 5 192.168.77.136
WBITT Network MultiTool (with NGINX) - backend-deployment-74694b5b9-xn678 - 192.168.77.136 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
/ # exit
slava@slava-FLAPTOP-r:~$ kubectl exec pods/backend-deployment-74694b5b9-xn678 -n app -it -- sh
/ # curl --connect-timeout 5 192.168.77.137
WBITT Network MultiTool (with NGINX) - cache-deployment-6b4d776c85-xz9q2 - 192.168.77.137 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
/ # curl --connect-timeout 5 192.168.77.135
curl: (28) Failed to connect to 192.168.77.135 port 80 after 5000 ms: Timeout was reached
/ # exit
slava@slava-FLAPTOP-r:~$ kubectl exec pods/cache-deployment-6b4d776c85-xz9q2 -n app -it -- sh
/ # curl --connect-timeout 5 192.168.77.136
curl: (28) Failed to connect to 192.168.77.136 port 80 after 5001 ms: Timeout was reached
/ # curl --connect-timeout 5 192.168.77.135
curl: (28) Failed to connect to 192.168.77.135 port 80 after 5000 ms: Timeout was reached
/ # exit
```

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
