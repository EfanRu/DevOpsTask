# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

### Решение 1 

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
[manifest_1.yaml](manifest_1.yaml)

2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.

```
    command: ['sh', '-c', 'while true; do echo "Learning again!" > /output/Way_to_devOps.txt; sleep 5; done']
```

3. Обеспечить возможность чтения файла контейнером multitool.

```
      containers:
      - name: multitool
        image: wbitt/network-multitool
        volumeMounts:
          - name: vol
            mountPath: /input
```

4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.

<details><summary>Вывод в консоль:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_10_k8s_2-1/manifest_1.yaml
deployment.apps/busybox-multitool-deployment configured
service/busybox-multitool-svc unchanged
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                                            READY   STATUS        RESTARTS   AGE
busybox-multitool-deployment-7b497f47d7-rt67f   2/2     Running       0          6s
busybox-multitool-deployment-5bb84c4b7c-qsv42   2/2     Terminating   0          177m
slava@slava-FLAPTOP-r:~$ kubectl exec pods/busybox-multitool-deployment-7b497f47d7-rt67f -c multitool -it -- sh
/ # ls -la
total 84
drwxr-xr-x    1 root     root          4096 Nov 11 11:44 .
drwxr-xr-x    1 root     root          4096 Nov 11 11:44 ..
...
drwxr-xr-x    1 root     root          4096 Nov 11 11:44 etc
drwxr-xr-x    2 root     root          4096 Aug  7 13:09 home
drwxr-xr-x    2 root     root          4096 Nov 11 08:00 input
drwxr-xr-x    1 root     root          4096 Sep 14 11:11 lib
...
/ # cat ./input/Way_to_devOps.txt 
Learning again2!
Learning again!
Learning again!
Learning again!
Learning again!
Learning again!
Learning again!
Learning again!
Learning again!
Learning again!
Learning again!
/ # 

```

</details>

5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.
[manifest_1.yaml](manifest_1.yaml)

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------

### Решение 2

1. Создать DaemonSet приложения, состоящего из multitool.
[manifest_2.yaml](manifest_2.yaml)

2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.

```
      containers:
      - name: multitool
        image: wbitt/network-multitool
        volumeMounts:
          - name: vol
            mountPath: /data
      volumes:
      - name: vol
        hostPath:
          path: /var/log
```

3. Продемонстрировать возможность чтения файла изнутри пода.

<details><summary>Вывод в консоль с пода:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_10_k8s_2-1/manifest_2.yaml
daemonset.apps/multitool-daemonset configured
service/multitool-svc unchanged
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                        READY   STATUS              RESTARTS   AGE
multitool-daemonset-qpkbd   0/1     ContainerCreating   0          2s
slava@slava-FLAPTOP-r:~$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool-daemonset-qpkbd   1/1     Running   0          10s
slava@slava-FLAPTOP-r:~$ kubectl exec pods/multitool-daemonset-qpkbd -it -- sh
/ # ls -la ./data
total 23880
drwxrwxr-x   11 root     113           4096 Nov 11 19:15 .
drwxr-xr-x    1 root     root          4096 Nov 11 19:53 ..
-rw-r--r--    1 root     root             0 Nov  1 18:57 alternatives.log
-rw-r--r--    1 root     root          6676 Oct 28 08:25 alternatives.log.1
drwxr-xr-x    2 root     root          4096 Nov  1 20:04 apt
-rw-r-----    1 107      adm        1329856 Nov 11 19:54 auth.log
-rw-r-----    1 107      adm          70346 Nov  5 11:30 auth.log.1
-rw-r-----    1 107      adm          13957 Nov  4 06:24 auth.log.2.gz
-rw-r-----    1 107      adm            279 Oct 28 07:34 auth.log.3.gz
-rw-rw----    1 root     43         1370496 Nov 11 19:54 btmp
-rw-rw----    1 root     43           26112 Oct 28 08:48 btmp.1
-rw-r-----    1 root     adm          40555 Nov 11 19:15 cloud-init-output.log
-rw-r-----    1 107      adm        1170605 Nov 11 19:15 cloud-init.log
drwxr-xr-x    2 root     root          4096 Nov 11 19:53 containers
drwxr-xr-x    2 root     root          4096 Feb 10  2023 dist-upgrade
-rw-r-----    1 root     adm          74664 Nov 11 19:15 dmesg
-rw-r-----    1 root     adm          74769 Nov 11 06:55 dmesg.0
-rw-r-----    1 root     adm          17901 Nov  8 15:38 dmesg.1.gz
-rw-r-----    1 root     adm          17939 Nov  6 18:56 dmesg.2.gz
-rw-r-----    1 root     adm          18071 Nov  5 19:16 dmesg.3.gz
-rw-r-----    1 root     adm          18071 Nov  5 11:30 dmesg.4.gz
-rw-r--r--    1 root     root          9570 Nov  1 20:04 dpkg.log
-rw-r--r--    1 root     root          6161 Oct 28 08:26 dpkg.log.1
drwxr-x---    4 root     adm           4096 Oct 20 19:39 installer
drwxr-sr-x    4 root     nginx         4096 Oct 28 07:34 journal
-rw-r-----    1 107      adm         528028 Nov 11 19:53 kern.log
-rw-r-----    1 107      adm         108132 Nov  5 11:30 kern.log.1
-rw-r-----    1 107      adm          56816 Nov  4 06:24 kern.log.2.gz
-rw-r-----    1 107      adm          17476 Oct 28 07:34 kern.log.3.gz
drwxr-xr-x    2 111      117           4096 Oct 28 07:35 landscape
-rw-rw-r--    1 root     43          292292 Nov 11 19:19 lastlog
drwxr-xr-x    7 root     root          4096 Nov 11 19:54 pods
drwx------    2 root     root          4096 Feb 17  2023 private
-rw-r-----    1 107      adm       12374890 Nov 11 19:54 syslog
-rw-r-----    1 107      adm        6226636 Nov  5 11:30 syslog.1
-rw-r-----    1 107      adm         653172 Nov  4 06:24 syslog.2.gz
-rw-r-----    1 107      adm          24363 Oct 28 07:34 syslog.3.gz
-rw-r--r--    1 root     root          6103 Nov  5 12:50 ubuntu-advantage.log
-rw-r--r--    1 root     root          3054 Oct 28 07:35 ubuntu-advantage.log.1
drwxr-x---    2 root     adm           4096 Nov  1 18:57 unattended-upgrades
-rw-rw-r--    1 root     43           36096 Nov 11 19:19 wtmp
```

</details>

<details><summary>Вывод в консоль с ноды:</summary>

```commandline
slava@microk8s:~$ ls -la /var/log/
total 23836
drwxrwxr-x  11 root      syslog              4096 Nov 11 19:15 .
drwxr-xr-x  14 root      root                4096 Nov 11 08:00 ..
-rw-r--r--   1 root      root                   0 Nov  1 18:57 alternatives.log
-rw-r--r--   1 root      root                6676 Oct 28 08:25 alternatives.log.1
drwxr-xr-x   2 root      root                4096 Nov  1 20:04 apt
-rw-r-----   1 syslog    adm              1329049 Nov 11 19:53 auth.log
-rw-r-----   1 syslog    adm                70346 Nov  5 11:30 auth.log.1
-rw-r-----   1 syslog    adm                13957 Nov  4 06:24 auth.log.2.gz
-rw-r-----   1 syslog    adm                  279 Oct 28 07:34 auth.log.3.gz
-rw-rw----   1 root      utmp             1369344 Nov 11 19:53 btmp
-rw-rw----   1 root      utmp               26112 Oct 28 08:48 btmp.1
-rw-r-----   1 root      adm                40555 Nov 11 19:15 cloud-init-output.log
-rw-r-----   1 syslog    adm              1170605 Nov 11 19:15 cloud-init.log
drwxr-xr-x   2 root      root                4096 Nov 11 19:48 containers
drwxr-xr-x   2 root      root                4096 Feb 10  2023 dist-upgrade
-rw-r-----   1 root      adm                74664 Nov 11 19:15 dmesg
-rw-r-----   1 root      adm                74769 Nov 11 06:55 dmesg.0
-rw-r-----   1 root      adm                17901 Nov  8 15:38 dmesg.1.gz
-rw-r-----   1 root      adm                17939 Nov  6 18:56 dmesg.2.gz
-rw-r-----   1 root      adm                18071 Nov  5 19:16 dmesg.3.gz
-rw-r-----   1 root      adm                18071 Nov  5 11:30 dmesg.4.gz
-rw-r--r--   1 root      root                9570 Nov  1 20:04 dpkg.log
-rw-r--r--   1 root      root                6161 Oct 28 08:26 dpkg.log.1
drwxr-x---   4 root      adm                 4096 Oct 20 19:39 installer
drwxr-sr-x+  4 root      systemd-journal     4096 Oct 28 07:34 journal
-rw-r-----   1 syslog    adm               527913 Nov 11 19:48 kern.log
-rw-r-----   1 syslog    adm               108132 Nov  5 11:30 kern.log.1
-rw-r-----   1 syslog    adm                56816 Nov  4 06:24 kern.log.2.gz
-rw-r-----   1 syslog    adm                17476 Oct 28 07:34 kern.log.3.gz
drwxr-xr-x   2 landscape landscape           4096 Oct 28 07:35 landscape
-rw-rw-r--   1 root      utmp              292292 Nov 11 19:19 lastlog
drwxr-xr-x   7 root      root                4096 Nov 11 19:48 pods
drwx------   2 root      root                4096 Feb 17  2023 private
-rw-r-----   1 syslog    adm             12330745 Nov 11 19:53 syslog
-rw-r-----   1 syslog    adm              6226636 Nov  5 11:30 syslog.1
-rw-r-----   1 syslog    adm               653172 Nov  4 06:24 syslog.2.gz
-rw-r-----   1 syslog    adm                24363 Oct 28 07:34 syslog.3.gz
-rw-r--r--   1 root      root                6103 Nov  5 12:50 ubuntu-advantage.log
-rw-r--r--   1 root      root                3054 Oct 28 07:35 ubuntu-advantage.log.1
drwxr-x---   2 root      adm                 4096 Nov  1 18:57 unattended-upgrades
-rw-rw-r--   1 root      utmp               36096 Nov 11 19:19 wtmp

```

</details>


4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.
[manifest_2.yaml](manifest_2.yaml)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
