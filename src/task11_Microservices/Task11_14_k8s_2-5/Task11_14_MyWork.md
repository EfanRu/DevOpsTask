# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.


------

### Решение 1. Подготовить Helm-чарт для приложения
    Изменил в файле values.yaml tag на "mainline-bookworm", чтобы установить другую версию nginx.
    Флаг --dry-run использовал для того, чтобы проверить, что будет установлено.
[new_app](new_app)

<details><summary>Вывод в консоль:</summary>

```commandline
image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "mainline-bookworm"
...
slava@slava-FLAPTOP-r:~$ helm install nginx-helm-try --dry-run /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_14_k8s_2-5/new_app/
...
---
# Source: new_app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-helm-try-new_app
  labels:
    helm.sh/chart: new_app-0.1.0
    app.kubernetes.io/name: new_app
    app.kubernetes.io/instance: nginx-helm-try
    app.kubernetes.io/version: "1.16.1"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: new_app
      app.kubernetes.io/instance: nginx-helm-try
  template:
    metadata:
      labels:
        helm.sh/chart: new_app-0.1.0
        app.kubernetes.io/name: new_app
        app.kubernetes.io/instance: nginx-helm-try
        app.kubernetes.io/version: "1.16.1"
        app.kubernetes.io/managed-by: Helm
    spec:
      serviceAccountName: nginx-helm-try-new_app
      securityContext:
        {}
      containers:
      containers:
        - name: new_app
          securityContext:
            {}
          image: "nginx:mainline-bookworm"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}

```

</details>

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

------
### Решение 2. Запустить две версии в разных неймспейсах
    В 1 запросе используем -n app1 --create-namespace так как такого ns ещё нет.
    Имя nginx-helm-try-2 так как 1 попытку запорол и не нашел где удалить :( 

<details><summary>Вывод в консоль создание:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ helm install nginx-helm-try-2 -n app1 --create-namespace /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_14_k8s_2-5/new_app/
NAME: nginx-helm-try-2
LAST DEPLOYED: Fri Jan  5 10:25:46 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app1 -l "app.kubernetes.io/name=new-app,app.kubernetes.io/instance=nginx-helm-try-2" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app1 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app1 port-forward $POD_NAME 8080:$CONTAINER_PORT
  
slava@slava-FLAPTOP-r:~$ helm install nginx-helm-try-3 -n app1 /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_14_k8s_2-5/new_app/
NAME: nginx-helm-try-3
LAST DEPLOYED: Fri Jan  5 10:27:35 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app1 -l "app.kubernetes.io/name=new-app,app.kubernetes.io/instance=nginx-helm-try-3" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app1 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app1 port-forward $POD_NAME 8080:$CONTAINER_PORT
slava@slava-FLAPTOP-r:~$ helm install nginx-helm-try-4 -n app2 --create-namespace /home/slava/Documents/DevOpsTask/src/task11_Microservices/Task11_14_k8s_2-5/new_app/
NAME: nginx-helm-try-4
LAST DEPLOYED: Fri Jan  5 10:28:26 2024
NAMESPACE: app2
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace app2 -l "app.kubernetes.io/name=new-app,app.kubernetes.io/instance=nginx-helm-try-4" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace app2 $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace app2 port-forward $POD_NAME 8080:$CONTAINER_PORT

```

</details>

<details><summary>Вывод в консоль проверка:</summary>

```commandline
slava@slava-FLAPTOP-r:~$ kubectl get pods -n app1
NAME                                        READY   STATUS    RESTARTS   AGE
nginx-helm-try-2-new-app-79956647c5-fgjmr   1/1     Running   0          4m12s
nginx-helm-try-3-new-app-5c5444cfd8-9tt5z   1/1     Running   0          2m23s
slava@slava-FLAPTOP-r:~$ kubectl get pods -n app2
NAME                                       READY   STATUS    RESTARTS   AGE
nginx-helm-try-4-new-app-fbdff67d9-9fbpx   1/1     Running   0          95s
slava@slava-FLAPTOP-r:~$ kubectl get svc -n app1
NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
nginx-helm-try-2-new-app   ClusterIP   10.152.183.206   <none>        80/TCP    5m16s
nginx-helm-try-3-new-app   ClusterIP   10.152.183.117   <none>        80/TCP    3m27s
slava@slava-FLAPTOP-r:~$ kubectl get svc -n app2
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
nginx-helm-try-4-new-app   ClusterIP   10.152.183.49   <none>        80/TCP    2m39s
```

</details>


### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

