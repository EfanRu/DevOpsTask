# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

-----

### Решение 1. Установить кластер k8s с 1 master node

    В качестве решения привожу скрины из клауда и мастера, а так же выводы в консоль.
    Извиняюсь за большой объем решил не тратить силы на вывод отдельных строк из консоли, зато виден весь мой путь.
    Возможно решение не самое правильное, но учитывая что я автотестер и собираюсь им оставаться, то думаю можно меня 
    понять и принять работу :)
    На задание со * сил и времени сейчас нет, да ещё и отстаю :(

<details><summary>Скрины из клауда и консоли мастера:</summary>

![cloud.png](Screenshoots%2Fcloud.png)

![console.png](Screenshoots%2Fconsole.png)

</details>

<details><summary>Вывод в консоль мастера:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ ssh slava@84.201.133.190
The authenticity of host '84.201.133.190 (84.201.133.190)' can't be established.
ED25519 key fingerprint is SHA256:...
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '84.201.133.190' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jan  8 11:33:48 AM UTC 2024

  System load:  0.123046875        Processes:             135
  Usage of /:   23.6% of 17.63GB   Users logged in:       0
  Memory usage: 11%                IPv4 address for eth0: 10.1.0.8
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

slava@fhm92jv77fr9o7egdr0p:~$ adduser k8s_adm
adduser: Only root may add a user or group to the system.
slava@fhm92jv77fr9o7egdr0p:~$ sudo adduser k8s_adm
Adding user `k8s_adm' ...
Adding new group `k8s_adm' (1002) ...
Adding new user `k8s_adm' (1001) with group `k8s_adm' ...
Creating home directory `/home/k8s_adm' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for k8s_adm
Enter the new value, or press ENTER for the default
	Full Name []: admin
	Room Number []: 
	Work Phone []: 
	Home Phone []: 
	Other []: 
Is the information correct? [Y/n] y
slava@fhm92jv77fr9o7egdr0p:~$ sudo usermod -aG sudo k8s_adm
slava@fhm92jv77fr9o7egdr0p:~$ su k8s_adm
Password: 
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo swapoff -a  
[sudo] password for k8s_adm: 
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt update
Hit:1 http://mirror.yandex.ru/ubuntu jammy InRelease
Get:2 http://mirror.yandex.ru/ubuntu jammy-updates InRelease [119 kB]
Hit:3 http://mirror.yandex.ru/ubuntu jammy-backports InRelease               
Get:4 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]    
Get:5 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 Packages [1268 kB]
Get:6 http://mirror.yandex.ru/ubuntu jammy-updates/main Translation-en [260 kB]
Get:7 http://mirror.yandex.ru/ubuntu jammy-updates/restricted amd64 Packages [1257 kB]
Get:8 http://mirror.yandex.ru/ubuntu jammy-updates/restricted Translation-en [205 kB]
Get:9 http://mirror.yandex.ru/ubuntu jammy-updates/universe amd64 Packages [1021 kB]
Get:10 http://mirror.yandex.ru/ubuntu jammy-updates/universe Translation-en [227 kB]
Get:11 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [1056 kB]
Get:12 http://security.ubuntu.com/ubuntu jammy-security/main Translation-en [200 kB]
Get:13 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [1233 kB]
Get:14 http://security.ubuntu.com/ubuntu jammy-security/restricted Translation-en [202 kB]
Get:15 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [824 kB]
Get:16 http://security.ubuntu.com/ubuntu jammy-security/universe Translation-en [156 kB]
Fetched 8139 kB in 2s (4661 kB/s)                                
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
11 packages can be upgraded. Run 'apt list --upgradable' to see them.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt install docker.io -y
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)      
^Citing for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 1999 (unattended-upgr)... 7s
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt upgrade
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following packages have been kept back:
  python3-update-manager update-manager-core
The following packages will be upgraded:
  distro-info distro-info-data python3-distro-info python3-software-properties software-properties-common
5 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
Need to get 73.2 kB of archives.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 distro-info-data all 0.52ubuntu0.6 [5160 B]
Get:2 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 distro-info amd64 1.1ubuntu0.2 [18.7 kB]
Get:3 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 python3-distro-info all 1.1ubuntu0.2 [6554 B]
Get:4 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 software-properties-common all 0.99.22.9 [14.1 kB]
Get:5 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 python3-software-properties all 0.99.22.9 [28.8 kB]
Fetched 73.2 kB in 0s (2875 kB/s)                      
(Reading database ... 109919 files and directories currently installed.)
Preparing to unpack .../distro-info-data_0.52ubuntu0.6_all.deb ...
Unpacking distro-info-data (0.52ubuntu0.6) over (0.52ubuntu0.5) ...
Preparing to unpack .../distro-info_1.1ubuntu0.2_amd64.deb ...
Unpacking distro-info (1.1ubuntu0.2) over (1.1ubuntu0.1) ...
Preparing to unpack .../python3-distro-info_1.1ubuntu0.2_all.deb ...
Unpacking python3-distro-info (1.1ubuntu0.2) over (1.1ubuntu0.1) ...
Preparing to unpack .../software-properties-common_0.99.22.9_all.deb ...
Unpacking software-properties-common (0.99.22.9) over (0.99.22.8) ...
Preparing to unpack .../python3-software-properties_0.99.22.9_all.deb ...
Unpacking python3-software-properties (0.99.22.9) over (0.99.22.8) ...
Setting up distro-info-data (0.52ubuntu0.6) ...
Setting up python3-software-properties (0.99.22.9) ...
Setting up python3-distro-info (1.1ubuntu0.2) ...
Setting up distro-info (1.1ubuntu0.2) ...
Setting up software-properties-common (0.99.22.9) ...
Processing triggers for man-db (2.10.2-1) ...
Processing triggers for dbus (1.12.20-2ubuntu4.1) ...
Scanning processes...                                                                                                                                                  
Scanning candidates...                                                                                                                                                 
Scanning linux images...                                                                                                                                               

Running kernel seems to be up-to-date.

Restarting services...
 systemctl restart packagekit.service

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt install docker.io -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  bridge-utils containerd dns-root-data dnsmasq-base pigz runc ubuntu-fan
Suggested packages:
  ifupdown aufs-tools cgroupfs-mount | cgroup-lite debootstrap docker-doc rinse zfs-fuse | zfsutils
The following NEW packages will be installed:
  bridge-utils containerd dns-root-data dnsmasq-base docker.io pigz runc ubuntu-fan
0 upgraded, 8 newly installed, 0 to remove and 2 not upgraded.
Need to get 69.7 MB of archives.
After this operation, 267 MB of additional disk space will be used.
Get:1 http://mirror.yandex.ru/ubuntu jammy/universe amd64 pigz amd64 2.6-1 [63.6 kB]
Get:2 http://mirror.yandex.ru/ubuntu jammy/main amd64 bridge-utils amd64 1.7-1ubuntu3 [34.4 kB]
Get:3 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 runc amd64 1.1.7-0ubuntu1~22.04.1 [4249 kB]
Get:4 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 containerd amd64 1.7.2-0ubuntu1~22.04.1 [36.0 MB]
Get:5 http://mirror.yandex.ru/ubuntu jammy/main amd64 dns-root-data all 2021011101 [5256 B]
Get:6 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 dnsmasq-base amd64 2.86-1.1ubuntu0.3 [354 kB]
Get:7 http://mirror.yandex.ru/ubuntu jammy-updates/universe amd64 docker.io amd64 24.0.5-0ubuntu1~22.04.1 [28.9 MB]
Get:8 http://mirror.yandex.ru/ubuntu jammy/universe amd64 ubuntu-fan all 0.12.16 [35.2 kB]
Fetched 69.7 MB in 3s (20.9 MB/s)      
Preconfiguring packages ...
Selecting previously unselected package pigz.
(Reading database ... 109919 files and directories currently installed.)
Preparing to unpack .../0-pigz_2.6-1_amd64.deb ...
Unpacking pigz (2.6-1) ...
Selecting previously unselected package bridge-utils.
Preparing to unpack .../1-bridge-utils_1.7-1ubuntu3_amd64.deb ...
Unpacking bridge-utils (1.7-1ubuntu3) ...
Selecting previously unselected package runc.
Preparing to unpack .../2-runc_1.1.7-0ubuntu1~22.04.1_amd64.deb ...
Unpacking runc (1.1.7-0ubuntu1~22.04.1) ...
Selecting previously unselected package containerd.
Preparing to unpack .../3-containerd_1.7.2-0ubuntu1~22.04.1_amd64.deb ...
Unpacking containerd (1.7.2-0ubuntu1~22.04.1) ...
Selecting previously unselected package dns-root-data.
Preparing to unpack .../4-dns-root-data_2021011101_all.deb ...
Unpacking dns-root-data (2021011101) ...
Selecting previously unselected package dnsmasq-base.
Preparing to unpack .../5-dnsmasq-base_2.86-1.1ubuntu0.3_amd64.deb ...
Unpacking dnsmasq-base (2.86-1.1ubuntu0.3) ...
Selecting previously unselected package docker.io.
Preparing to unpack .../6-docker.io_24.0.5-0ubuntu1~22.04.1_amd64.deb ...
Unpacking docker.io (24.0.5-0ubuntu1~22.04.1) ...
Selecting previously unselected package ubuntu-fan.
Preparing to unpack .../7-ubuntu-fan_0.12.16_all.deb ...
Unpacking ubuntu-fan (0.12.16) ...
Setting up dnsmasq-base (2.86-1.1ubuntu0.3) ...
Setting up runc (1.1.7-0ubuntu1~22.04.1) ...
Setting up dns-root-data (2021011101) ...
Setting up bridge-utils (1.7-1ubuntu3) ...
Setting up pigz (2.6-1) ...
Setting up containerd (1.7.2-0ubuntu1~22.04.1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up ubuntu-fan (0.12.16) ...
Created symlink /etc/systemd/system/multi-user.target.wants/ubuntu-fan.service → /lib/systemd/system/ubuntu-fan.service.
Setting up docker.io (24.0.5-0ubuntu1~22.04.1) ...
Adding group `docker' (GID 119) ...
Done.
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
Processing triggers for dbus (1.12.20-2ubuntu4.1) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...                                                                                                                                                  
Scanning candidates...                                                                                                                                                 
Scanning linux images...                                                                                                                                               

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-01-08 11:37:37 UTC; 29s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 3352 (dockerd)
      Tasks: 9
     Memory: 26.5M
        CPU: 221ms
     CGroup: /system.slice/docker.service
             └─3352 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jan 08 11:37:36 fhm92jv77fr9o7egdr0p systemd[1]: Starting Docker Application Container Engine...
Jan 08 11:37:36 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:36.049455501Z" level=info msg="Starting up"
Jan 08 11:37:36 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:36.050386123Z" level=info msg="detected 127.0.0.53 nameserver, assuming systemd-resolved, s>
Jan 08 11:37:36 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:36.694134374Z" level=info msg="Loading containers: start."
Jan 08 11:37:36 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:36.985686378Z" level=info msg="Loading containers: done."
Jan 08 11:37:37 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:37.100782396Z" level=info msg="Docker daemon" commit="24.0.5-0ubuntu1~22.04.1" graphdriver=>
Jan 08 11:37:37 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:37.100900927Z" level=info msg="Daemon has completed initialization"
Jan 08 11:37:37 fhm92jv77fr9o7egdr0p dockerd[3352]: time="2024-01-08T11:37:37.152406839Z" level=info msg="API listen on /run/docker.sock"
Jan 08 11:37:37 fhm92jv77fr9o7egdr0p systemd[1]: Started Docker Application Container Engine.

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt update
Hit:1 http://mirror.yandex.ru/ubuntu jammy InRelease
Hit:2 http://mirror.yandex.ru/ubuntu jammy-updates InRelease                                            
Hit:3 http://mirror.yandex.ru/ubuntu jammy-backports InRelease                                          
Hit:5 http://security.ubuntu.com/ubuntu jammy-security InRelease                                        
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [8993 B]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [69.9 kB]
Fetched 78.9 kB in 1s (98.1 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
2 packages can be upgraded. Run 'apt list --upgradable' to see them.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt install kubeadm kubelet kubectl
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  conntrack cri-tools ebtables kubernetes-cni socat
The following NEW packages will be installed:
  conntrack cri-tools ebtables kubeadm kubectl kubelet kubernetes-cni socat
0 upgraded, 8 newly installed, 0 to remove and 2 not upgraded.
Need to get 87.1 MB of archives.
After this operation, 336 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://mirror.yandex.ru/ubuntu jammy/main amd64 conntrack amd64 1:1.4.6-2build2 [33.5 kB]
Get:2 http://mirror.yandex.ru/ubuntu jammy/main amd64 ebtables amd64 2.0.11-4build2 [84.9 kB]
Get:3 http://mirror.yandex.ru/ubuntu jammy/main amd64 socat amd64 1.7.4.1-3ubuntu4 [349 kB]
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 cri-tools amd64 1.26.0-00 [18.9 MB]
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 1.2.0-00 [27.6 MB]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.28.2-00 [19.5 MB]
Get:7 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.28.2-00 [10.3 MB]
Get:8 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.28.2-00 [10.3 MB]
Fetched 87.1 MB in 1s (70.1 MB/s)
Selecting previously unselected package conntrack.
(Reading database ... 110284 files and directories currently installed.)
Preparing to unpack .../0-conntrack_1%3a1.4.6-2build2_amd64.deb ...
Unpacking conntrack (1:1.4.6-2build2) ...
Selecting previously unselected package cri-tools.
Preparing to unpack .../1-cri-tools_1.26.0-00_amd64.deb ...
Unpacking cri-tools (1.26.0-00) ...
Selecting previously unselected package ebtables.
Preparing to unpack .../2-ebtables_2.0.11-4build2_amd64.deb ...
Unpacking ebtables (2.0.11-4build2) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../3-kubernetes-cni_1.2.0-00_amd64.deb ...
Unpacking kubernetes-cni (1.2.0-00) ...
Selecting previously unselected package socat.
Preparing to unpack .../4-socat_1.7.4.1-3ubuntu4_amd64.deb ...
Unpacking socat (1.7.4.1-3ubuntu4) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../5-kubelet_1.28.2-00_amd64.deb ...
Unpacking kubelet (1.28.2-00) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../6-kubectl_1.28.2-00_amd64.deb ...
Unpacking kubectl (1.28.2-00) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../7-kubeadm_1.28.2-00_amd64.deb ...
Unpacking kubeadm (1.28.2-00) ...
Setting up conntrack (1:1.4.6-2build2) ...
Setting up kubectl (1.28.2-00) ...
Setting up ebtables (2.0.11-4build2) ...
Setting up socat (1.7.4.1-3ubuntu4) ...
Setting up cri-tools (1.26.0-00) ...
Setting up kubernetes-cni (1.2.0-00) ...
Setting up kubelet (1.28.2-00) ...
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
Setting up kubeadm (1.28.2-00) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...                                                                                                                                                  
Scanning candidates...                                                                                                                                                 
Scanning linux images...                                                                                                                                               

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt-mark hold kubeadm kubelet kubectl
kubeadm set on hold.
kubelet set on hold.
kubectl set on hold.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.2", GitCommit:"89a4ea3e1e4ddd7f7572286090359983e0387b2f", GitTreeState:"clean", BuildDate:"2023-09-13T09:34:32Z", GoVersion:"go1.20.8", Compiler:"gc", Platform:"linux/amd64"}
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/modules-load.d/containerd.conf
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/modules-load.d/containerd.conf
overlay
br_netfilter
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo modprobe overlay
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo modprobe br_netfilter
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/sysctl.d/kubernetes.conf
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo sysctl --system
* Applying /etc/sysctl.d/10-console-messages.conf ...
kernel.printk = 4 4 1 7
* Applying /etc/sysctl.d/10-ipv6-privacy.conf ...
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
* Applying /etc/sysctl.d/10-kernel-hardening.conf ...
kernel.kptr_restrict = 1
* Applying /etc/sysctl.d/10-magic-sysrq.conf ...
kernel.sysrq = 176
* Applying /etc/sysctl.d/10-network-security.conf ...
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
* Applying /etc/sysctl.d/10-ptrace.conf ...
kernel.yama.ptrace_scope = 1
* Applying /etc/sysctl.d/10-zeropage.conf ...
vm.mmap_min_addr = 65536
* Applying /usr/lib/sysctl.d/50-default.conf ...
kernel.core_uses_pid = 1
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.default.accept_source_route = 0
sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
net.ipv4.conf.default.promote_secondaries = 1
sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument
net.ipv4.ping_group_range = 0 2147483647
net.core.default_qdisc = fq_codel
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.protected_regular = 1
fs.protected_fifos = 1
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
kernel.pid_max = 4194304
* Applying /usr/lib/sysctl.d/99-protect-links.conf ...
fs.protected_fifos = 1
fs.protected_hardlinks = 1
fs.protected_regular = 2
fs.protected_symlinks = 1
* Applying /etc/sysctl.d/99-sysctl.conf ...
* Applying /etc/sysctl.d/kubernetes.conf ...
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
* Applying /etc/sysctl.conf ...
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo hostnamectl set-hostname master-node
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cp /etc/hosts /etc/hosts.bak
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/hosts
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/hosts
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
127.0.1.1 fhm92jv77fr9o7egdr0p.auto.internal fhm92jv77fr9o7egdr0p
127.0.0.1 localhost
84.201.133.190 master-node

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/default/kubelet
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/default/kubelet
KUBELET_EXTRA_ARGS="--cgroup-driver=cgroupfs"
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl daemon-reload && sudo systemctl restart kubelet
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: activating (auto-restart) (Result: exit-code) since Mon 2024-01-08 11:45:30 UTC; 292ms ago
       Docs: https://kubernetes.io/docs/home/
    Process: 4740 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=1/FAILURE)
   Main PID: 4740 (code=exited, status=1/FAILURE)
        CPU: 52ms

Jan 08 11:45:30 master-node systemd[1]: kubelet.service: Main process exited, code=exited, status=1/FAILURE
Jan 08 11:45:30 master-node systemd[1]: kubelet.service: Failed with result 'exit-code'.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/docker/daemon.json
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/docker/daemon.json
    {
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
      "log-opts": {
      "max-size": "100m"
   },

       "storage-driver": "overlay2"
       }
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl daemon-reload && sudo systemctl restart docker
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl daemon-reload && sudo systemctl restart kubelet
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: activating (auto-restart) (Result: exit-code) since Mon 2024-01-08 11:47:17 UTC; 536ms ago
       Docs: https://kubernetes.io/docs/home/
    Process: 5030 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=1/FAILURE)
   Main PID: 5030 (code=exited, status=1/FAILURE)
        CPU: 52ms
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo apt install containerd
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
containerd is already the newest version (1.7.2-0ubuntu1~22.04.1).
containerd set to manually installed.
0 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubeadm init \
--apiserver-advertise-address=10.1.0.8 \
--pod-network-cidr 10.244.0.0/16 \
--apiserver-cert-extra-sans=84.201.133.190 \
--control-plane-endpoint=84.201.133.190
I0108 11:49:04.734511    5169 version.go:256] remote version is much newer: v1.29.0; falling back to: stable-1.28
[init] Using Kubernetes version: v1.28.5
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR IsPrivilegedUser]: user is not running as root
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo kubeadm init --apiserver-advertise-address=10.1.0.8 --pod-network-cidr 10.244.0.0/16 --apiserver-cert-extra-sans=84.201.133.190 --control-plane-endpoint=84.201.133.190
I0108 11:49:16.398768    5185 version.go:256] remote version is much newer: v1.29.0; falling back to: stable-1.28
[init] Using Kubernetes version: v1.28.5
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W0108 11:49:40.310162    5185 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local master-node] and IPs [10.96.0.1 10.1.0.8 84.201.133.190]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [localhost master-node] and IPs [10.1.0.8 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [localhost master-node] and IPs [10.1.0.8 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 14.002734 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node master-node as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node master-node as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: voi352.k68dec25owctr23s
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 84.201.133.190:6443 --token ... \
	--discovery-token-ca-cert-hash sha256:...2 \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 84.201.133.190:6443 --token ... \
	--discovery-token-ca-cert-hash sha256:... 
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ cat $HOME
cat: /home/k8s_adm: Is a directory
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ echo $HOME
/home/k8s_adm
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ mkdir -p $HOME/.kube
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Mon 2024-01-08 11:50:26 UTC; 8min ago
       Docs: https://kubernetes.io/docs/home/
   Main PID: 5866 (kubelet)
      Tasks: 10 (limit: 2219)
     Memory: 36.0M
        CPU: 6.363s
     CGroup: /system.slice/kubelet.service
             └─5866 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet>

Jan 08 11:57:42 master-node kubelet[5866]: E0108 11:57:42.086887    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:57:47 master-node kubelet[5866]: E0108 11:57:47.088695    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:57:52 master-node kubelet[5866]: E0108 11:57:52.089459    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:57:57 master-node kubelet[5866]: E0108 11:57:57.091404    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:58:02 master-node kubelet[5866]: E0108 11:58:02.092594    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:58:07 master-node kubelet[5866]: E0108 11:58:07.093320    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:58:12 master-node kubelet[5866]: E0108 11:58:12.094540    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:58:17 master-node kubelet[5866]: E0108 11:58:17.095204    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:58:22 master-node kubelet[5866]: E0108 11:58:22.096656    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
Jan 08 11:58:27 master-node kubelet[5866]: E0108 11:58:27.097353    5866 kubelet.go:2855] "Container runtime network not ready" networkReady="NetworkReady=false reaso>
lines 1-23/23 (END)
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
namespace/kube-flannel created
serviceaccount/flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl taint nodes --all node-role.kubernetes.io/control-plane-
node/master-node untainted
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes
NAME          STATUS   ROLES           AGE     VERSION
master-node   Ready    control-plane   9m16s   v1.28.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes
NAME                   STATUS   ROLES           AGE   VERSION
fhmc0qdar9mn5lonlrhu   Ready    <none>          15s   v1.28.2
master-node            Ready    control-plane   23m   v1.28.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl delete nodes fhmc0qdar9mn5lonlrhu
node "fhmc0qdar9mn5lonlrhu" deleted
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/hosts
[sudo] password for k8s_adm: 
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/hosts
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
127.0.1.1 fhm92jv77fr9o7egdr0p.auto.internal fhm92jv77fr9o7egdr0p
127.0.0.1 localhost
84.201.133.190 master-node
158.160.34.198 worker01

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes
NAME          STATUS   ROLES           AGE   VERSION
master-node   Ready    control-plane   31m   v1.28.2
worker01      Ready    <none>          6s    v1.28.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node   Ready    control-plane   31m   v1.28.2   10.1.0.8      <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker01      Ready    <none>          52s   v1.28.2   10.1.0.21     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/hosts
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes -o wide
NAME          STATUS     ROLES           AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node   Ready      control-plane   38m    v1.28.2   10.1.0.8      <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker01      Ready      <none>          7m9s   v1.28.2   10.1.0.21     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker02      NotReady   <none>          5s     v1.28.2   10.1.0.30     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo nano /etc/hosts
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/hosts
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
127.0.1.1 fhm92jv77fr9o7egdr0p.auto.internal fhm92jv77fr9o7egdr0p
127.0.0.1 localhost
84.201.133.190 master-node
158.160.34.198 worker01
158.160.32.8 worker02
158.160.113.34 worker03

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes -o wide
NAME          STATUS     ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node   Ready      control-plane   43m     v1.28.2   10.1.0.8      <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker01      Ready      <none>          12m     v1.28.2   10.1.0.21     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker02      Ready      <none>          5m39s   v1.28.2   10.1.0.30     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker03      NotReady   <none>          7s      v1.28.2   10.1.0.34     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes -o wide
NAME          STATUS     ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node   Ready      control-plane   43m     v1.28.2   10.1.0.8      <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker01      Ready      <none>          12m     v1.28.2   10.1.0.21     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker02      Ready      <none>          5m45s   v1.28.2   10.1.0.30     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker03      NotReady   <none>          13s     v1.28.2   10.1.0.34     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node   Ready    control-plane   44m     v1.28.2   10.1.0.8      <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker01      Ready    <none>          13m     v1.28.2   10.1.0.21     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker02      Ready    <none>          6m10s   v1.28.2   10.1.0.30     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker03      Ready    <none>          38s     v1.28.2   10.1.0.34     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ sudo cat /etc/hosts
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
127.0.1.1 fhm92jv77fr9o7egdr0p.auto.internal fhm92jv77fr9o7egdr0p
127.0.0.1 localhost
84.201.133.190 master-node
158.160.34.198 worker01
158.160.32.8 worker02
158.160.113.34 worker03

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

k8s_adm@fhm92jv77fr9o7egdr0p:/home/slava$ kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node   Ready    control-plane   45m   v1.28.2   10.1.0.8      <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker01      Ready    <none>          14m   v1.28.2   10.1.0.21     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker02      Ready    <none>          7m    v1.28.2   10.1.0.30     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2
worker03      Ready    <none>          88s   v1.28.2   10.1.0.34     <none>        Ubuntu 22.04.3 LTS   5.15.0-91-generic   containerd://1.7.2

```

</details>

<details><summary>Вывод в консоль одного из воркеров:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ ssh slava@158.160.34.198
The authenticity of host '158.160.34.198 (158.160.34.198)' can't be established.
ED25519 key fingerprint is SHA256:...
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.34.198' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jan  8 12:07:25 PM UTC 2024

  System load:  1.2861328125       Processes:             135
  Usage of /:   23.6% of 17.63GB   Users logged in:       0
  Memory usage: 11%                IPv4 address for eth0: 10.1.0.21
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

slava@fhmc0qdar9mn5lonlrhu:~$ sudo apt update
Hit:1 http://mirror.yandex.ru/ubuntu jammy InRelease
Get:2 http://mirror.yandex.ru/ubuntu jammy-updates InRelease [119 kB]
Hit:3 http://mirror.yandex.ru/ubuntu jammy-backports InRelease                        
Get:4 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
Get:5 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 Packages [1268 kB]
Get:6 http://mirror.yandex.ru/ubuntu jammy-updates/main Translation-en [260 kB] 
Get:7 http://mirror.yandex.ru/ubuntu jammy-updates/restricted amd64 Packages [1257 kB]          
Get:8 http://mirror.yandex.ru/ubuntu jammy-updates/restricted Translation-en [205 kB]           
Get:9 http://mirror.yandex.ru/ubuntu jammy-updates/universe amd64 Packages [1021 kB]       
Get:10 http://mirror.yandex.ru/ubuntu jammy-updates/universe Translation-en [227 kB]  
Get:11 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [1056 kB]       
Get:12 http://security.ubuntu.com/ubuntu jammy-security/main Translation-en [200 kB]
Get:13 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [1233 kB]
Get:14 http://security.ubuntu.com/ubuntu jammy-security/restricted Translation-en [202 kB]
Get:15 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [824 kB]
Get:16 http://security.ubuntu.com/ubuntu jammy-security/universe Translation-en [156 kB]
Fetched 8139 kB in 2s (4002 kB/s)                            
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
7 packages can be upgraded. Run 'apt list --upgradable' to see them.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo apt install docker.io -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  bridge-utils containerd dns-root-data dnsmasq-base pigz runc ubuntu-fan
Suggested packages:
  ifupdown aufs-tools cgroupfs-mount | cgroup-lite debootstrap docker-doc rinse zfs-fuse | zfsutils
The following NEW packages will be installed:
  bridge-utils containerd dns-root-data dnsmasq-base docker.io pigz runc ubuntu-fan
0 upgraded, 8 newly installed, 0 to remove and 7 not upgraded.
Need to get 69.7 MB of archives.
After this operation, 267 MB of additional disk space will be used.
Get:1 http://mirror.yandex.ru/ubuntu jammy/universe amd64 pigz amd64 2.6-1 [63.6 kB]
Get:2 http://mirror.yandex.ru/ubuntu jammy/main amd64 bridge-utils amd64 1.7-1ubuntu3 [34.4 kB]
Get:3 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 runc amd64 1.1.7-0ubuntu1~22.04.1 [4249 kB]
Get:4 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 containerd amd64 1.7.2-0ubuntu1~22.04.1 [36.0 MB]
Get:5 http://mirror.yandex.ru/ubuntu jammy/main amd64 dns-root-data all 2021011101 [5256 B]
Get:6 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 dnsmasq-base amd64 2.86-1.1ubuntu0.3 [354 kB]
Get:7 http://mirror.yandex.ru/ubuntu jammy-updates/universe amd64 docker.io amd64 24.0.5-0ubuntu1~22.04.1 [28.9 MB]
Get:8 http://mirror.yandex.ru/ubuntu jammy/universe amd64 ubuntu-fan all 0.12.16 [35.2 kB]
Fetched 69.7 MB in 3s (22.6 MB/s)     
Preconfiguring packages ...
Selecting previously unselected package pigz.
(Reading database ... 109919 files and directories currently installed.)
Preparing to unpack .../0-pigz_2.6-1_amd64.deb ...
Unpacking pigz (2.6-1) ...
Selecting previously unselected package bridge-utils.
Preparing to unpack .../1-bridge-utils_1.7-1ubuntu3_amd64.deb ...
Unpacking bridge-utils (1.7-1ubuntu3) ...
Selecting previously unselected package runc.
Preparing to unpack .../2-runc_1.1.7-0ubuntu1~22.04.1_amd64.deb ...
Unpacking runc (1.1.7-0ubuntu1~22.04.1) ...
Selecting previously unselected package containerd.
Preparing to unpack .../3-containerd_1.7.2-0ubuntu1~22.04.1_amd64.deb ...
Unpacking containerd (1.7.2-0ubuntu1~22.04.1) ...
Selecting previously unselected package dns-root-data.
Preparing to unpack .../4-dns-root-data_2021011101_all.deb ...
Unpacking dns-root-data (2021011101) ...
Selecting previously unselected package dnsmasq-base.
Preparing to unpack .../5-dnsmasq-base_2.86-1.1ubuntu0.3_amd64.deb ...
Unpacking dnsmasq-base (2.86-1.1ubuntu0.3) ...
Selecting previously unselected package docker.io.
Preparing to unpack .../6-docker.io_24.0.5-0ubuntu1~22.04.1_amd64.deb ...
Unpacking docker.io (24.0.5-0ubuntu1~22.04.1) ...
Selecting previously unselected package ubuntu-fan.
Preparing to unpack .../7-ubuntu-fan_0.12.16_all.deb ...
Unpacking ubuntu-fan (0.12.16) ...
Setting up dnsmasq-base (2.86-1.1ubuntu0.3) ...
Setting up runc (1.1.7-0ubuntu1~22.04.1) ...
Setting up dns-root-data (2021011101) ...
Setting up bridge-utils (1.7-1ubuntu3) ...
Setting up pigz (2.6-1) ...
Setting up containerd (1.7.2-0ubuntu1~22.04.1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up ubuntu-fan (0.12.16) ...
Created symlink /etc/systemd/system/multi-user.target.wants/ubuntu-fan.service → /lib/systemd/system/ubuntu-fan.service.
Setting up docker.io (24.0.5-0ubuntu1~22.04.1) ...
Adding group `docker' (GID 119) ...
Done.
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
Processing triggers for dbus (1.12.20-2ubuntu4.1) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...                                                                                                                                                  
Scanning linux images...                                                                                                                                               

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo apt upgrade
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following packages have been kept back:
  python3-update-manager update-manager-core
The following packages will be upgraded:
  distro-info distro-info-data python3-distro-info python3-software-properties software-properties-common
5 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
Need to get 73.2 kB of archives.
After this operation, 5120 B of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 distro-info-data all 0.52ubuntu0.6 [5160 B]
Get:2 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 distro-info amd64 1.1ubuntu0.2 [18.7 kB]
Get:3 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 python3-distro-info all 1.1ubuntu0.2 [6554 B]
Get:4 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 software-properties-common all 0.99.22.9 [14.1 kB]
Get:5 http://mirror.yandex.ru/ubuntu jammy-updates/main amd64 python3-software-properties all 0.99.22.9 [28.8 kB]
Fetched 73.2 kB in 0s (2454 kB/s)                      
(Reading database ... 110284 files and directories currently installed.)
Preparing to unpack .../distro-info-data_0.52ubuntu0.6_all.deb ...
Unpacking distro-info-data (0.52ubuntu0.6) over (0.52ubuntu0.4) ...
Preparing to unpack .../distro-info_1.1ubuntu0.2_amd64.deb ...
Unpacking distro-info (1.1ubuntu0.2) over (1.1build1) ...
Preparing to unpack .../python3-distro-info_1.1ubuntu0.2_all.deb ...
Unpacking python3-distro-info (1.1ubuntu0.2) over (1.1build1) ...
Preparing to unpack .../software-properties-common_0.99.22.9_all.deb ...
Unpacking software-properties-common (0.99.22.9) over (0.99.22.7) ...
Preparing to unpack .../python3-software-properties_0.99.22.9_all.deb ...
Unpacking python3-software-properties (0.99.22.9) over (0.99.22.7) ...
Setting up distro-info-data (0.52ubuntu0.6) ...
Setting up python3-software-properties (0.99.22.9) ...
Setting up python3-distro-info (1.1ubuntu0.2) ...
Setting up distro-info (1.1ubuntu0.2) ...
Setting up software-properties-common (0.99.22.9) ...
Processing triggers for man-db (2.10.2-1) ...
Processing triggers for dbus (1.12.20-2ubuntu4.1) ...
Scanning processes...                                                                                                                                                  
Scanning linux images...                                                                                                                                               

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-01-08 12:08:22 UTC; 49s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 2058 (dockerd)
      Tasks: 9
     Memory: 26.7M
        CPU: 248ms
     CGroup: /system.slice/docker.service
             └─2058 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jan 08 12:08:21 fhmc0qdar9mn5lonlrhu systemd[1]: Starting Docker Application Container Engine...
Jan 08 12:08:21 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:21.315706735Z" level=info msg="Starting up"
Jan 08 12:08:21 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:21.316666836Z" level=info msg="detected 127.0.0.53 nameserver, assuming systemd-resolved, s>
Jan 08 12:08:21 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:21.577054554Z" level=info msg="Loading containers: start."
Jan 08 12:08:21 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:21.939635629Z" level=info msg="Loading containers: done."
Jan 08 12:08:22 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:22.053356071Z" level=info msg="Docker daemon" commit="24.0.5-0ubuntu1~22.04.1" graphdriver=>
Jan 08 12:08:22 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:22.053560030Z" level=info msg="Daemon has completed initialization"
Jan 08 12:08:22 fhmc0qdar9mn5lonlrhu dockerd[2058]: time="2024-01-08T12:08:22.113643330Z" level=info msg="API listen on /run/docker.sock"
Jan 08 12:08:22 fhmc0qdar9mn5lonlrhu systemd[1]: Started Docker Application Container Engine.

slava@fhmc0qdar9mn5lonlrhu:~$ curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
slava@fhmc0qdar9mn5lonlrhu:~$ echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main
slava@fhmc0qdar9mn5lonlrhu:~$ sudo apt install kubeadm
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done

No apt package "kubeadm", but there is a snap with that name.
Try "snap install kubeadm"

E: Unable to locate package kubeadm
slava@fhmc0qdar9mn5lonlrhu:~$ sudo apt update
Hit:1 http://mirror.yandex.ru/ubuntu jammy InRelease
Hit:2 http://mirror.yandex.ru/ubuntu jammy-updates InRelease                                            
Hit:3 http://mirror.yandex.ru/ubuntu jammy-backports InRelease                                          
Hit:5 http://security.ubuntu.com/ubuntu jammy-security InRelease                                        
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [8993 B]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [69.9 kB]
Fetched 78.9 kB in 1s (95.4 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
2 packages can be upgraded. Run 'apt list --upgradable' to see them.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo apt install kubeadm
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  conntrack cri-tools ebtables kubectl kubelet kubernetes-cni socat
The following NEW packages will be installed:
  conntrack cri-tools ebtables kubeadm kubectl kubelet kubernetes-cni socat
0 upgraded, 8 newly installed, 0 to remove and 2 not upgraded.
Need to get 87.1 MB of archives.
After this operation, 336 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://mirror.yandex.ru/ubuntu jammy/main amd64 conntrack amd64 1:1.4.6-2build2 [33.5 kB]
Get:2 http://mirror.yandex.ru/ubuntu jammy/main amd64 ebtables amd64 2.0.11-4build2 [84.9 kB]
Get:3 http://mirror.yandex.ru/ubuntu jammy/main amd64 socat amd64 1.7.4.1-3ubuntu4 [349 kB]
Get:4 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 cri-tools amd64 1.26.0-00 [18.9 MB]
Get:5 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubernetes-cni amd64 1.2.0-00 [27.6 MB]
Get:6 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.28.2-00 [19.5 MB]
Get:7 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.28.2-00 [10.3 MB]
Get:8 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.28.2-00 [10.3 MB]
Fetched 87.1 MB in 1s (64.9 MB/s)
Selecting previously unselected package conntrack.
(Reading database ... 110284 files and directories currently installed.)
Preparing to unpack .../0-conntrack_1%3a1.4.6-2build2_amd64.deb ...
Unpacking conntrack (1:1.4.6-2build2) ...
Selecting previously unselected package cri-tools.
Preparing to unpack .../1-cri-tools_1.26.0-00_amd64.deb ...
Unpacking cri-tools (1.26.0-00) ...
Selecting previously unselected package ebtables.
Preparing to unpack .../2-ebtables_2.0.11-4build2_amd64.deb ...
Unpacking ebtables (2.0.11-4build2) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../3-kubernetes-cni_1.2.0-00_amd64.deb ...
Unpacking kubernetes-cni (1.2.0-00) ...
Selecting previously unselected package socat.
Preparing to unpack .../4-socat_1.7.4.1-3ubuntu4_amd64.deb ...
Unpacking socat (1.7.4.1-3ubuntu4) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../5-kubelet_1.28.2-00_amd64.deb ...
Unpacking kubelet (1.28.2-00) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../6-kubectl_1.28.2-00_amd64.deb ...
Unpacking kubectl (1.28.2-00) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../7-kubeadm_1.28.2-00_amd64.deb ...
Unpacking kubeadm (1.28.2-00) ...
Setting up conntrack (1:1.4.6-2build2) ...
Setting up kubectl (1.28.2-00) ...
Setting up ebtables (2.0.11-4build2) ...
Setting up socat (1.7.4.1-3ubuntu4) ...
Setting up cri-tools (1.26.0-00) ...
Setting up kubernetes-cni (1.2.0-00) ...
Setting up kubelet (1.28.2-00) ...
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
Setting up kubeadm (1.28.2-00) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...                                                                                                                                                  
Scanning linux images...                                                                                                                                               

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo systemctl stop apparmor && sudo systemctl disable apparmor
Synchronizing state of apparmor.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable apparmor
Removed /etc/systemd/system/sysinit.target.wants/apparmor.service.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo systemctl restart containerd.service
slava@fhmc0qdar9mn5lonlrhu:~$ kubeadm join 84.201.133.190:6443 --token ... \
        --discovery-token-ca-cert-hash sha256:...
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR IsPrivilegedUser]: user is not running as root
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:...
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

slava@fhmc0qdar9mn5lonlrhu:~$ sudo hostnamectl set-hostname worker01
slava@fhmc0qdar9mn5lonlrhu:~$ sudo nano /etc/hosts
slava@fhmc0qdar9mn5lonlrhu:~$ sudo cat /etc/hosts
# Your system has configured 'manage_etc_hosts' as True.
# As a result, if you wish for changes to this file to persist
# then you will need to either
# a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
# b.) change or remove the value of 'manage_etc_hosts' in
#     /etc/cloud/cloud.cfg or cloud-config from user-data
#
127.0.1.1 fhmc0qdar9mn5lonlrhu.auto.internal fhmc0qdar9mn5lonlrhu
127.0.0.1 localhost
84.201.133.190 master-node
158.160.34.198 worker01

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:...
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR FileAvailable--etc-kubernetes-kubelet.conf]: /etc/kubernetes/kubelet.conf already exists
	[ERROR Port-10250]: Port 10250 is in use
	[ERROR FileAvailable--etc-kubernetes-pki-ca.crt]: /etc/kubernetes/pki/ca.crt already exists
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:... --ignore-preflight-errors
flag needs an argument: --ignore-preflight-errors
To see the stack trace of this error execute with --v=5 or higher
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:... --ignore-preflight-errors=true
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR FileAvailable--etc-kubernetes-kubelet.conf]: /etc/kubernetes/kubelet.conf already exists
	[ERROR Port-10250]: Port 10250 is in use
	[ERROR FileAvailable--etc-kubernetes-pki-ca.crt]: /etc/kubernetes/pki/ca.crt already exists
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:... --force
unknown flag: --force
To see the stack trace of this error execute with --v=5 or higher
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:... --^C
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm reset
W0108 12:21:12.917402    5598 preflight.go:56] [reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted.
[reset] Are you sure you want to proceed? [y/N]: y
[preflight] Running pre-flight checks
W0108 12:21:14.116776    5598 removeetcdmember.go:106] [reset] No kubeadm config, using etcd pod spec to get data directory
[reset] Deleted contents of the etcd data directory: /var/lib/etcd
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Deleting contents of directories: [/etc/kubernetes/manifests /var/lib/kubelet /etc/kubernetes/pki]
[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]

The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the $HOME/.kube/config file.
slava@fhmc0qdar9mn5lonlrhu:~$ sudo kubeadm join 84.201.133.190:6443 --token ...     --discovery-token-ca-cert-hash sha256:...
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.


```

</details>

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
