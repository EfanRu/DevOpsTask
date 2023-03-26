# Домашнее задание к занятию 7 «Жизненный ци
кл ПО»

## Подготовка к выполнению

### Задание 1
   Получить бесплатную версию [Jira](https://www.atlassian.com/ru/software/jira/free).

### Решение 1
![Attlasian_canceled_in_Russia.png](data%2FAttlasian_canceled_in_Russia.png)
   Так как jira недоступна в России, то не будем её использовать, а поищем аналог.
   Возьмем вместо неё Yandex Tracker.

### Задание 2
   Настроить её для своей команды разработки.

### Решение 2
   Сделано.

### Задание 3
   Создать доски Kanban и Scrum.

### Решение 3
![Kanban_create.png](data%2FKanban_create.png)

![Scram_create.png](data%2FScram_create.png)


## Основная часть
   Так как в Yandex Tracker нет некоторых статусов, то пришлось их добавить

### Задание 1
    Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done.

### Решение 1
![Workflow_create.png](data%2FWorkflow_create.png)

### Задание 2
    Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 

### Решение 2
![Epic_and_tasks.png](data%2FEpic_and_tasks.png)

### Задание 3
    При проведении обеих задач по статусам используйте kanban.

### Решение 3
   Своевременно.
![Kanban history.png](data/Kanban_history.png)
![Kanban_2_task.png](data%2FKanban_2_task.png)

### Задание 4
    Верните задачи в статус Open

### Решение 4
![Reopen_tasks.png](data%2FReopen_tasks.png)

### Задание 5
   Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
    
### Решение 5
   Баг закрыл, но спринт закрыть раньше времени нельзя, он сам закроется.
![Close_scram_bug.png](data%2FClose_scram_bug.png)

### Задание 6
    Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow приложите к решению задания.

### Решение 6
   Видимо в Yandex Tracker нет такой возможности, при выгрузке из очередей (workflow) он выгружает списки задач по ним.
   Вот примеры файлов.
[BUG_26-03.xml](data/BUG_26-03.xml)
[KANBAN_26-03.xml](data/KANBAN_26-03.xml)
[TASK_26-03.xml](data/TASK_26-03.xml)
---