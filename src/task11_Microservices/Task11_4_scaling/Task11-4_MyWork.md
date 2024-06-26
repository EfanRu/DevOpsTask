
# Домашнее задание к занятию «Микросервисы: масштабирование»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: Кластеризация

Предложите решение для обеспечения развёртывания, запуска и управления приложениями.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- поддержка контейнеров;
- обеспечивать обнаружение сервисов и маршрутизацию запросов;
- обеспечивать возможность горизонтального масштабирования;
- обеспечивать возможность автоматического масштабирования;
- обеспечивать явное разделение ресурсов, доступных извне и внутри системы;
- обеспечивать возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т. п.

Обоснуйте свой выбор.

## Решение 1:

    Для реализации поддержки контейнеров нам подходят Podman, Docker и k8s (kubernetes). Так как у нас очень крупная организация и большой объем работы, то нужно использовать Docker compose или k8s.
    В целом они обладают большим функционалом, но факт, k8s адаптирован под работу в кластере и к автоматическому масштабированию, поэтому выберем именно его.

    Для обеспечения обнаружени сервисов и маршрутизации запросов будем использовать service registry встроенный в k8s service discovery.

    K8s фактически создан для горизонтального масштабирования. Проблема в том, что нужно проверить поддерживают ли сервисы, которые мы собрались масштабировать, горизонтальное масштабирование. Если нет, то требуется их адаптировать для него.

    Автоматическое масштабирование невозможно использовать без системы мониторинга и сбора логов. Тут я думаю достаточно сослаться на прошлое домашнее задание и использовать ELK как систему для сбора логов и Grafana + Prometheus как систему мониторинга.
    Выбранные решения дадут нам информацию когда нам нужно запускать автомасштабирование.
    И они же отправят команду в k8s на него, а точнее на k8s horizontal Pod Autoscaler.

    В разделение ресурсов из вне и внутри сложно говорить на абстрактном проекте. K8s обеспечивает разделение внутри себя, но без балансировщика для k8s.
    Так как у нас большое приложение, то стандартными решениями для k8s не обойтись, тут нам поможет nginx plus ingress controller, который является open source. В целом можно посмотреть и другие варианты, но на абстрактной системе это теряет смысл.
    Так же сюда можно было бы добавить кеш, но опять же все зависит от архитектуры.

    Возможность конфигурировать приложения с помощью переменных среды, в том числе с возможностью безопасного хранения чувствительных данных таких как пароли, ключи доступа, ключи шифрования и т. п. обеспечиваются в k8s, а секреты хранятся в сущностях secrets.
    Так же можно рассмотреть подключение vault-k8s.

    

## Задача 2: Распределённый кеш * (необязательная)

Разработчикам вашей компании понадобился распределённый кеш для организации хранения временной информации по сессиям пользователей.
Вам необходимо построить Redis Cluster, состоящий из трёх шард с тремя репликами.

### Схема:

![11-04-01](https://user-images.githubusercontent.com/1122523/114282923-9b16f900-9a4f-11eb-80aa-61ed09725760.png)

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
