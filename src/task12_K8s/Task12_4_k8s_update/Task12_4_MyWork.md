# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

-----

### Решение 1. Выбрать стратегию обновления приложения и описать ваш выбор

    В задании не сказано касательно нагрузки на реплики. Ведь если у нас есть возможность уменьшить количество реплик,
    то мы получем свободные ресурсы, которые необходимы нам для развертывания любой из стратегий.
    Хотя тут можно трактовать пункт 2 как раз как невозможность уменьшения количества реплик и как следствие, увеличение 
    ресурсов.
    Но так и не над чем думать. Так что будем считать, что количество реплик мы не можем уменьшить.

    Для начала проведем анализ требований и исключим стратегии, которые нам точно не подходяят:
     - Согласно пункту 4 у нас нет обратной совместимости, то есть полноценная работоспособность будет достигнута
     только после полного разворачивания всех pods. Следовательно rolling strategy нам не подходит, хотя с учетом 
     ограничения по ресурсам, было бы удобно использовать именно её. А так же canary strategy тоже не подходит.
    - Согласно пункту 3 у нас ограничены ресурсы, то есть варианты с Blue/green, dark, A/B и т.п., которым 
    требуется много ресурсов.

    Остается только Recreate strategy, которое нужно будет применить в самый незагруженный момент времени, так как наше 
    приложение не будет доступно какое-то время. Из положительных моментов, нам не нужно будет решать коллизии данных 
    между новой и старой версией, если бы какое-то время они работали одновременно.

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pods -n app-upd -o wide
NAME                                          READY   STATUS    RESTARTS   AGE   IP               NODE          NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-6c699bff67-2xb9d   2/2     Running   0          45s   192.168.77.135   master-node   <none>           <none>
nginx-multitool-deployment-6c699bff67-55vd7   2/2     Running   0          45s   192.168.77.136   master-node   <none>           <none>
nginx-multitool-deployment-6c699bff67-8h57s   2/2     Running   0          45s   192.168.77.139   master-node   <none>           <none>
nginx-multitool-deployment-6c699bff67-spnrn   2/2     Running   0          45s   192.168.77.138   master-node   <none>           <none>
nginx-multitool-deployment-6c699bff67-zrm4d   2/2     Running   0          45s   192.168.77.137   master-node   <none>           <none>

slava@slava-FLAPTOP-r:~$ kubectl describe pods/nginx-multitool-deployment-6c699bff67-2xb9d -n app-upd
...
Controlled By:  ReplicaSet/nginx-multitool-deployment-6c699bff67
Containers:
  nginx:
    Container ID:   containerd://4fb546509df91a26c456157dd7217c3f52fba267b4ac7236b265bc210489c71f
    Image:          nginx:1.19.0
...
```
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
    
     Так как наше приложение должно быть доступным, то из нативных вариантов нам подходит strategy Rolling.
     Мы должно обновиться максимально быстро и при этом приложение должно быть доступным, то будем обновлять по 3 из 5
     pods, так как это ровно половина и мы справимся за 2 подхода и приложение будет достыпным. По нагрузке и ресурсам 
     ничего не сказано, значит упустим этот момент, считая, что все ок:)

    Не очень ясно что является минимальной скоростью. Так что будем считать, что обновляя половину подов - это быстро :)
```commandline
slava@slava-FLAPTOP-r:~$ kubectl set image deployments/nginx-multitool-deployment nginx=nginx:1.20.0 -n app-upd
deployment.apps/nginx-multitool-deployment image updated
slava@slava-FLAPTOP-r:~$ kubectl get pods -n app-upd -o wide
NAME                                         READY   STATUS    RESTARTS   AGE    IP               NODE          NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-d964fccd7-bcx5s   2/2     Running   0          100s   192.168.77.143   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-f8nvv   2/2     Running   0          99s    192.168.77.142   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-ldk6b   2/2     Running   0          99s    192.168.77.144   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-ltnjh   2/2     Running   0          100s   192.168.77.140   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-v85cf   2/2     Running   0          100s   192.168.77.141   master-node   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl rollout status deployments/nginx-multitool-deployment -n app-upd
deployment "nginx-multitool-deployment" successfully rolled out
slava@slava-FLAPTOP-r:~$ kubectl get pods -n app-upd -o wide
NAME                                         READY   STATUS    RESTARTS   AGE     IP               NODE          NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-d964fccd7-bcx5s   2/2     Running   0          2m10s   192.168.77.143   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-f8nvv   2/2     Running   0          2m9s    192.168.77.142   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-ldk6b   2/2     Running   0          2m9s    192.168.77.144   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-ltnjh   2/2     Running   0          2m10s   192.168.77.140   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-v85cf   2/2     Running   0          2m10s   192.168.77.141   master-node   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl describe pods/nginx-multitool-deployment-d964fccd7-bcx5s -n app-upd

...
Containers:
  nginx:
    Container ID:   containerd://6b404158389f7d66a26640ef5d6dec9e9834065d3cc596ff1e7611056a06799a
    Image:          nginx:1.20.0
...
```

3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
    Неудачное обновление
```commandline
slava@slava-FLAPTOP-r:~$ kubectl set image deployments/nginx-multitool-deployment nginx=nginx:1.28.0 -n app-upd
deployment.apps/nginx-multitool-deployment image updated
slava@slava-FLAPTOP-r:~$ kubectl rollout status deployments/nginx-multitool-deployment -n app-upd
Waiting for deployment "nginx-multitool-deployment" rollout to finish: 2 old replicas are pending termination...
^Cslava@slava-FLAPTOP-r:~$ kubectget pods -n app-upd -o wide
NAME                                          READY   STATUS             RESTARTS   AGE     IP               NODE          NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-595d889995-7jrhs   1/2     ErrImagePull       0          56s     192.168.77.145   master-node   <none>           <none>
nginx-multitool-deployment-595d889995-hcqdx   1/2     ImagePullBackOff   0          56s     192.168.77.146   master-node   <none>           <none>
nginx-multitool-deployment-595d889995-kwgfb   1/2     ImagePullBackOff   0          56s     192.168.77.149   master-node   <none>           <none>
nginx-multitool-deployment-595d889995-mn67k   1/2     ImagePullBackOff   0          56s     192.168.77.148   master-node   <none>           <none>
nginx-multitool-deployment-595d889995-r7l2z   1/2     ImagePullBackOff   0          56s     192.168.77.147   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-ldk6b    2/2     Running            0          6m42s   192.168.77.144   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-v85cf    2/2     Running            0          6m43s   192.168.77.141   master-node   <none>           <none>
```

4. Откатиться после неудачного обновления.
    "Халла, отмена!!!"
```commandline
slava@slava-FLAPTOP-r:~$ kubectl rollout undo deployments/nginx-multitool-deployment -n app-upd
deployment.apps/nginx-multitool-deployment rolled back
slava@slava-FLAPTOP-r:~$ kubectl get pods -n app-upd -o wide
NAME                                         READY   STATUS    RESTARTS   AGE     IP               NODE          NOMINATED NODE   READINESS GATES
nginx-multitool-deployment-d964fccd7-55xfk   2/2     Running   0          13s     192.168.77.151   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-ldk6b   2/2     Running   0          8m48s   192.168.77.144   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-rccns   2/2     Running   0          13s     192.168.77.150   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-v85cf   2/2     Running   0          8m49s   192.168.77.141   master-node   <none>           <none>
nginx-multitool-deployment-d964fccd7-x2mm2   2/2     Running   0          13s     192.168.77.152   master-node   <none>           <none>
slava@slava-FLAPTOP-r:~$ kubectl describe pods/nginx-multitool-deployment-d964fccd7-55xfk -n app-upd

...
Containers:
  nginx:
    Container ID:   containerd://d87cb9441fa167d6d2e01f8e2d7331248a30f5d9915e4f7412ca0b50c30169bf
    Image:          nginx:1.20.0
...
```

## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
