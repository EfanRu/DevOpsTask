# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных
программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:

- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

## Решение 1:

| Требования                                                      | SberCloud API Gateway | Amazon API Gateway and e.t.c | tyk | janus |
|:----------------------------------------------------------------|:---------------------:|-----------------------------:|----:|------:|
| Отечесвенная разработка или open source                         |          Да           |                          Нет |  Да |    Да |
| маршрутизация запросов к нужному сервису на основе конфигурации |          Да           |                            - |  Да |    Да |
| возможность проверки аутентификационной информации в запросах   |          Да           |                            - |  Да |    Да |
| обеспечение терминации HTTPS                                    |          Нет          |                            - |  Да |    Да |

    Обоснование выбора:
    К сожалению, согласно Постановление Правительства РФ № 1236 мы не можем в большинстве проектов использовать иностранное не open-source ПО.
    В ждокументации на SberCloud я не нашел терминации https и информации о балансирощиках. Да и это облачные решения, что не гарантирует надежности и гибкости.
    Open source решения tyk и janus нам подходят одинаково. Но у tyk намного больше звезд и больше информации в сообществах. Так что лучше выбрать именно его.

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:

- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

## Решение 2:

| Требования                                            | Apache Kafka | RabbitMQ | IBM MQ |
|:------------------------------------------------------|:------------:|---------:|-------:|
| Отечесвенная разработка или open source               |      Да      |       Да |    Нет |
| поддержка кластеризации для обеспечения надёжности    |      Да      |       Да |        |
| хранение сообщений на диске в процессе доставки       |      Да      |       Да |        |
| высокая скорость работы                               |      Да      |       Да |        |
| поддержка различных форматов сообщений                |      Да      |       Да |        |
| разделение прав доступа к различным потокам сообщений |      Да      |      Нет |        |
| простота эксплуатации                                 |      Да      |       Да |        |

   Обоснование выбора: Не смог найти информацию о разделение прав доступа к различным потокам для RabbitMQ, в остальном очень схож с Kafka. 
   Оба решения очень часто используются и куча статей: что выбрать Kafka или RabbitMQ? 
   Но по нашим критериям нам подходит Kafka больше.

## Задача 3: API Gateway * (необязательная)

## К сожалению, отстаю от группы. Оставлю на потом или пропущу :(

### Есть три сервиса:

**minio**

- хранит загруженные файлы в бакете images,
- S3 протокол,

**uploader**

- принимает файл, если картинка сжимает и загружает его в minio,
- POST /v1/upload,

**security**

- регистрация пользователя POST /v1/user,
- получение информации о пользователе GET /v1/user,
- логин пользователя POST /v1/token,
- проверка токена GET /v1/token/validation.

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**

1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/user.

**POST /v1/token**

1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/token.

**GET /v1/user**

1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET
   /v1/token/validation/.
2. Запрос направляется в сервис security GET /v1/user.

**POST /v1/upload**

1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET
   /v1/token/validation/.
2. Запрос направляется в сервис uploader POST /v1/upload.

**GET /v1/user/{image}**

1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET
   /v1/token/validation/.
2. Запрос направляется в сервис minio GET /images/{image}.

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл, запустив который можно локально выполнить следующие
команды с успешным результатом.
Предполагается, что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки,
который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации
входящих запросов.
Авторизация
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type:
octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

---

#### [Дополнительные материалы: как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---