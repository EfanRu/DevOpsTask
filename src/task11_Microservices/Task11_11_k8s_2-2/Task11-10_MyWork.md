# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
6. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Решение 1


1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
[manifest_1.yaml](manifest_1.yaml)

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_11_k8s_2-2/manifest_1.yaml
deployment.apps/busybox-multitool-deployment unchanged
service/busybox-multitool-svc unchanged
persistentvolume/local-volume created
persistentvolumeclaim/pvc-vol created
slava@slava-FLAPTOP-r:~$ kubectl get pvc
NAME      STATUS   VOLUME         CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc-vol   Bound    local-volume   2Gi        RWO            local-storage   4s
slava@slava-FLAPTOP-r:~$ kubectl get pv
NAME           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS    REASON   AGE
local-volume   2Gi        RWO            Delete           Bound    default/pvc-vol   local-storage            7s
```

3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 

```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                            READY   STATUS    RESTARTS   AGE
multitool-daemonset-nbnjq                       1/1     Running   0          6m37s
busybox-multitool-deployment-779b658868-tbhr9   2/2     Running   0          20s
slava@slava-FLAPTOP-r:~$ kubectl exec pods/busybox-multitool-deployment-779b658868-tbhr9 multitool -it -- sh
Defaulted container "multitool" out of: multitool, busybox
/ # ls -la
total 84
drwxr-xr-x    1 root     root          4096 Nov 25 20:19 .
drwxr-xr-x    1 root     root          4096 Nov 25 20:19 ..
drwxr-xr-x    1 root     root          4096 Sep 14 11:11 bin
drwx------    2 root     root          4096 Sep 14 11:11 certs
drwxr-xr-x    5 root     root           360 Nov 25 20:19 dev
drwxr-xr-x    1 root     root          4096 Sep 14 11:11 docker
drwxr-xr-x    1 root     root          4096 Nov 25 20:19 etc
drwxr-xr-x    2 root     root          4096 Aug  7 13:09 home
drwxr-xr-x    2 root     root          4096 Nov 25 20:19 input
...
/ # cat ./input/Way_to_devOps.txt 
Learning again!
Learning again!
...
Learning again!
Learning again!

```

4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
```commandline
slava@slava-FLAPTOP-r:~$ kubectl get deployments
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
busybox-multitool-deployment   1/1     1            1           3m16s
slava@slava-FLAPTOP-r:~$ kubectl delete deployments/busybox-multitool-deployment 
deployment.apps "busybox-multitool-deployment" deleted
slava@slava-FLAPTOP-r:~$ kubectl get pvc
NAME      STATUS   VOLUME         CAPACITY   ACCESS MODES   STORAGECLASS    AGE
pvc-vol   Bound    local-volume   1Gi        RWO            local-storage   3m43s
slava@slava-FLAPTOP-r:~$ kubectl delete pvc/pvc-vol
persistentvolumeclaim "pvc-vol" deleted
slava@slava-FLAPTOP-r:~$ kubectl get pv
NAME           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS    REASON   AGE
`local-volume`   1Gi        RWO            Delete           Failed   default/pvc-vol   local-storage            4m21s

```

    PV local-volume остался, так как это отдельная сущность примонтированная к ноде. В его статусе после удаления Bound изменился на Failed, так как мы удалили PVC и pod, который к нему коннектился.

5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.

    Проверяем, что файл сохранился на локальном диске ноды.
```commandline
slava@microk8s:~$ cat /data/pv/Way_to_devOps.txt 
Learning again!
Learning again!
...
Learning again!

```

    Удаляем PV.
```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pv
NAME           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS    REASON   AGE
local-volume   1Gi        RWO            Delete           Failed   default/pvc-vol   local-storage            4m21s
slava@slava-FLAPTOP-r:~$ kubectl delete pv/local-volume
persistentvolume "local-volume" deleted
slava@slava-FLAPTOP-r:~$ kubectl get pv
No resources found
```

    Снова проверяем, что файл сохранился на локальном диске ноды.
```commandline
slava@microk8s:~$ cat /data/pv/Way_to_devOps.txt 
Learning again!
Learning again!
...
Learning again!

```
    Так как у нашего PV persistentVolumeReclaimPolicy: Delete - то он удаляет только в облачных Storage, чтобы файлы удалились нужно было поставить persistentVolumeReclaimPolicy: Recycle .

6. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
[manifest_1.yaml](manifest_1.yaml)

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Решение 2

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.

```commandline
slava@microk8s:~$ microk8s enable community
slava@microk8s:~$ microk8s enable nfs
...
example
    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: test-dynamic-volume-claim
    spec:
      storageClassName: "nfs"
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi
NFS Server Provisioner is installed

WARNING: Install "nfs-common" package on all MicroK8S nodes to allow Pods with NFS mounts to start: sudo apt update && sudo apt install -y nfs-common
WARNING: NFS Server Provisioner servers by default hostPath storage from a single Node.
slava@microk8s:~$ sudo apt update && sudo apt install -y nfs-common

```

2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
[manifest_2.yaml](manifest_2.yaml)

3. Продемонстрировать возможность чтения и записи файла изнутри пода. 

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_11_k8s_2-2/manifest_2.yaml
deployment.apps/busybox-multitool-deployment created
service/busybox-multitool-svc unchanged
persistentvolume/nfs-volume created
persistentvolumeclaim/pvc-vol created
slava@slava-FLAPTOP-r:~$ kubectl get pv
NAME                            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS        CLAIM                                                  STORAGECLASS   REASON   AGE
data-nfs-server-provisioner-0   1Gi        RWO            Retain           Terminating   nfs-server-provisioner/data-nfs-server-provisioner-0                           16m
nfs-volume                      100Mi      RWO            Delete           Bound         default/pvc-vol                                        nfs                     6s
slava@slava-FLAPTOP-r:~$ kubectl get pvc
NAME      STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-vol   Bound    nfs-volume   100Mi      RWO            nfs            17s
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                            READY   STATUS    RESTARTS      AGE
busybox-multitool-deployment-779b658868-z7tw6   2/2     Running   0             22s
slava@slava-FLAPTOP-r:~$ kubectl exec pods/busybox-multitool-deployment-779b658868-z7tw6 multitool -it -- sh
Defaulted container "multitool" out of: multitool, busybox
/ # cat ./input/Way_to_devOps.txt 
Learning again!
Learning again!
Learning again!
...

```

4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
[manifest_2.yaml](manifest_2.yaml)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
