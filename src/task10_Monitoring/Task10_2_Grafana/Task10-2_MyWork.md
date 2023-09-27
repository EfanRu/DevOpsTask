# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

    **При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно развернит
    grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:
      - grafana;
      - prometheus-server;
      - prometheus node-exporter.
    
    За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.
    
    В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
    использовали в процессе решения задания.
    
    **При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

    В решении приведите скриншоты тестовых событий из каналов нотификаций.

### Задание 1
#### Задание 1-1
    Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.

#### Решение 1-1
```commandline
slava@slava-FLAPTOP-r:~/Documents/DevOpsTask/src/task9_CI_CD/Task9_3_Jenkins/infrastructure$ docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED              STATUS              PORTS                                       NAMES
273d1f03eb2c   grafana/grafana:7.4.0       "/run.sh"                About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   grafana
683e4bdfa9a3   prom/prometheus:v2.24.1     "/bin/prometheus --c…"   About a minute ago   Up About a minute   9090/tcp                                    prometheus
0f4d7a3e3091   prom/node-exporter:v1.0.1   "/bin/node_exporter …"   About a minute ago   Up About a minute   9100/tcp                                    nodeexporter
```

#### Задание 1-2
    Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.

#### Решение 1-2
![EnjoyGrafana.png](ScreenShoots%2FEnjoyGrafana.png)

#### Задание 1-3
    Подключите поднятый вами prometheus, как источник данных.

#### Решение 1-3
![ConnectPrometheus.png](ScreenShoots%2FConnectPrometheus.png)

#### Задание 1-4
    Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

#### Решение 1-4
![ConnectedPrometheus.png](ScreenShoots%2FConnectedPrometheus.png)

### Задание 2
    Изучите самостоятельно ресурсы:
        1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
        2. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
        3. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).
 
    Создайте Dashboard и в ней создайте Panels:
        - утилизация CPU для nodeexporter (в процентах, 100-idle);
        - CPULA 1/5/15;
        - количество свободной оперативной памяти;
        - количество места на файловой системе.
    
    Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

### Решение 2
    - утилизация CPU для nodeexporter (в процентах, 100-idle);
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[30m])) * 100)
![PanelCPUUtilization.png](ScreenShoots%2FPanelCPUUtilization.png)

    - CPULA 1/5/15;
sum(
    rate(node_cpu_seconds_total{mode!="idle"}[1m]) # 1, 5, 15
  ) without (mode)

    - количество свободной оперативной памяти;
node_memory_MemFree_bytes / (1024 ^ 3)
![Free_RAM.png](ScreenShoots%2FFree%20RAM.png)

    - количество места на файловой системе.
node_filesystem_avail_bytes / (1024 ^ 3)
![free_disk_space.png](ScreenShoots%2Ffree_disk_space.png)

### Задание 3
    Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
    В качестве решения задания приведите скриншот вашей итоговой Dashboard.

### Решение 3

    - утилизация CPU для nodeexporter (в процентах, 100-idle);
![CPU_nodeexporter_alert.png](ScreenShoots%2FCPU_nodeexporter_alert.png)

    - CPULA 1/5/15;
![CPU_LA_alert.png](ScreenShoots%2FCPU_LA_alert.png)

    - количество свободной оперативной памяти;
![free_disk_space_alert.png](ScreenShoots%2Ffree_disk_space_alert.png)
    
    - количество места на файловой системе.
![free_disk_space_alert.png](ScreenShoots%2Ffree_disk_space_alert.png)

### Задание 4
    Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
    В качестве решения задания приведите листинг этого файла.

### Решение 4
[dashboard.json](dashboard.json)

---