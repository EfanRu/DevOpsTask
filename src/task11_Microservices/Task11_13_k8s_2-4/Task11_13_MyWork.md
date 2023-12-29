# Домашнее задание к занятию «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Решение 1. 

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
```commandline
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ openssl genrsa -out my_ca.key 2048
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ openssl req -new -key my_ca.key -out my_ca.csr -subj "/CN=slava/O=aqa"
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ openssl x509 -req -in my_ca.csr -CA server_ca.crt -CAkey server_ca.key
Certificate request self-signature ok
subject=CN = slava, O = aqa
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ openssl x509 -req -in my_ca.csr -CA server_ca.crt -CAkey server_ca.key -CAcreateserial -out my_ca.crt -days 10
Certificate request self-signature ok
subject=CN = slava, O = aqa

```
2. Настройте конфигурационный файл kubectl для подключения.
```commandline
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_13_k8s_2-4/secret.yaml
secret/rbac-secret created
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl get secrets
NAME                TYPE                                  DATA   AGE
my-app-secret-tls   kubernetes.io/tls                     2      7d19h
rbac-secret         kubernetes.io/service-account-token   3      68s
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl describe secret rbac-secret
Name:         rbac-secret
Namespace:    default
...
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl config set-credentials slava --client-certificate my_ca.crt --client-key my_ca.key 
User "slava" set.
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://158.160.45.218:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
...
- name: slava
  user:
    client-certificate: /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_13_k8s_2-4/my_ca.crt
    client-key: /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_13_k8s_2-4/my_ca.key
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl config set-context slava-context --cluster=microk8s-cluster --user=slava --namespace=default 
Context "slava-context" created.
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl config get-contexts
CURRENT   NAME            CLUSTER            AUTHINFO   NAMESPACE
*         microk8s        microk8s-cluster   admin      
          slava-context   microk8s-cluster   slava      default
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_13_k8s_2-4/role.yaml
roservices/Task11_13_k8s_2-4/role.yaml
role.rbac.authorization.k8s.io/pod-access unchanged
rolebinding.rbac.authorization.k8s.io/pod-access-rb unchanged
```
3. Создайте роли и все необходимые настройки для пользователя.
```commandline
slava@microk8s:~$ microk8s enable rbac
Infer repository core for addon rbac
Enabling RBAC
Reconfiguring apiserver
Restarting apiserver
RBAC is enabled
```
[role.yaml](role.yaml)
```commandline
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl apply -f /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_13_k8s_2-4/role.yaml
role.rbac.authorization.k8s.io/pod-access unchanged
rolebinding.rbac.authorization.k8s.io/pod-access-rb created
```
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
```commandline
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl config use-context slava-context 
Switched to context "slava-context".
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl get pods
NAME                                          READY   STATUS    RESTARTS        AGE
multitool-daemonset-zpg47                     1/1     Running   6 (2m1s ago)    5d5h
nginx-multitool-deployment-76c8548cfb-zxfzl   2/2     Running   12 (2m1s ago)   5d4h
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl logs pods/nginx-multitool-deployment-76c8548cfb-zxfzl
Defaulted container "nginx" out of: nginx, multitool
slava@slava-FLAPTOP-r:~/.../Task11_13_k8s_2-4$ kubectl describe pods/nginx-multitool-deployment-76c8548cfb-zxfzl
Name:             nginx-multitool-deployment-76c8548cfb-zxfzl
Namespace:        default
Priority:         0
Service Account:  default
Node:             microk8s/10.1.0.12
Start Time:       Sun, 24 Dec 2023 13:30:56 +0300
Labels:           app=nginx-multitool
                  pod-template-hash=76c8548cfb
Annotations:      cni.projectcalico.org/containerID: b5912f8c8d73fe04d474743b159a57718247bcbe465f30fcf31369070b0c26bb
                  cni.projectcalico.org/podIP: 10.1.128.241/32
                  cni.projectcalico.org/podIPs: 10.1.128.241/32
Status:           Running
IP:               10.1.128.241
IPs:
  IP:           10.1.128.241
...

```
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.
[secret.yaml](secret.yaml)
[role.yaml](role.yaml)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------

