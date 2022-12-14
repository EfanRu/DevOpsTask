### Домашнее задание 6-6

# Задание 1
	Перед выполнением задания ознакомьтесь с документацией по администрированию MongoDB.
	Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её нужно прервать.
	Вы как инженер поддержки решили произвести данную операцию:

	    напишите список операций, которые вы будете производить для остановки запроса пользователя
	    предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

# Решение 1
	Напишите список операций, которые вы будете производить для остановки запроса пользователя
		Зайти в Prometeus (или другую систему мониторинга) и посмотреть на запросы более 3 минут. Проверяем, что это наш "корявый запрос" и убиваем его, если это запрос SELECT, если это UPDATE, DELETE, INSERT, то тут сложнее. Так как убитие этого процесса приведет нашу БД к некосистентности. Нужно оценить запрос, как долго он будет выполнять и последствия его удаления.
		И не все селекты более 3 минут могут быть плохими, ведь могут быть запросы собирающие отчёты, которые висят неделями и убить его бы не хотелось.
		Если система мониторинга не настроена, то настраиваем, ну или идем в консоль mongoDB и через команду db.currentOp({"secs_running":{$gte: 180}}) получаем список операций в БД. 
		
	Предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB
		Таких запросов быть не должно по хорошему, а подобные запросы скорее всего делают неопытные пользователи, вопрос что их не должно быть на БД. Можно написать скрипт, который будет проверять и убивать долгие запросы. Исключение сбор статистик и запросы, которые спеециально могут жить днями. Чтобы те кто их пишут приходили к нам, но это достаточно радикальный метод.
		Но если долгие запросы реально необходимо кому-то, то нужно идти разбираться в причинах, так как может быть, что приложение открывает транзакцию, а потом ждет ответа от другого сервиса, хотя вполне могла бы открыть её после ответа. Конечно, может быть и из-за неоптимальной организщации БД и нужно проверять через Explain, почему определенные операции так долго выполняются. Может быть нет индексов. Или убедиться, что проблема не в БД, а в коде приложения.
	
# Задание 2
	Перед выполнением задания познакомьтесь с документацией по Redis latency troobleshooting.
	Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и увеличивается пропорционально количеству реплик сервиса.
	При масштабировании сервиса до N реплик вы увидели, что:

	    сначала рост отношения записанных значений к истекшим
	    Redis блокирует операции записи

	Как вы думаете, в чем может быть проблема?
	
# Решение 2
	Cначала рост отношения записанных значений к истекшим
			Рост отношения записанных значений к истекшим после масштабирования сервиса логичен, так как после масштабирования увеличится поток записанных значений, а количество истекших не изменится. При прохождении времени TTL с момента масштабирования сервиса отношение записанных и истекщих должно выровняться.

	Redis блокирует операции записи
		Учитывая контекст, то возможны 2 варианта:
		- Redis после масштабирования занял всю сеть репликацией;
		- Redis начнет удалять истекщие ключи, которые пришли единовременно после репликации и так как их много и созданы они в одно время, то это вызовет задержку в их удалении, а при удалении ключей блокируются операции записи, если общий процент истекщих ключей становится более 25%.
	
	
# Здание 3
	Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы, пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

	Как вы думаете, почему это начало происходить и как локализовать проблему?
	Какие пути решения данной проблемы вы можете предложить?
	
# Решение 3
	Как вы думаете, почему это начало происходить и как локализовать проблему?
		ГИС система характерна тем, что в ней будут получаться большие ответы на запросы. И при росте БД мы можем начать выходить за некоторые лимиты. Следовательно нужной найти лимит, за который мы вышли и решить проблему.
		Нужно провести анализ TCP dump и понять на чьей стороне происходит потеря соединения: приложение ли блокирует соедение по своему таймауту или же со стороны БД.
	
	Возможно несколько вариантов проблемы и их решения:
	1.	Один из возможных вариантов в том, что ответ от сервера получается слишком большой. По умолчанию max_allowed_packet = 1MB. 
		
		Какие пути решения данной проблемы вы можете предложить?
			Можно увеличить это значение или же просить пользователей делать менее ёмкие запросы, а то вдруг кто-то показал им что можно селектить без уловий, и они при каждом запросе грузят всю таблицу.
	
	2.	Ещё одним вариантом является то, что в приложении откуда отправлялся запрос стоит короткий таймаут и оно самозакрывает коннект.
		Какие пути решения данной проблемы вы можете предложить?
			Увеличить таймаут в приложении.
	
# Здание 4
	Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
	большим объемом данных лучше, чем MySQL.
	После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

	`postmaster invoked oom-killer`

	Как вы думаете, что происходит?
	Как бы вы решили данную проблему?
	
# Решение 4
	Как вы думаете, что происходит?
		PostgreSQL утекает по памяти. Когда недостаточно оперативной памяти для ОС, то oom-killer убивает самый жирный процесс, а это БД.

	Как бы вы решили данную проблему?
		Нужно временно добавить ресурсов и если не подключен мониторинг процессов БД, то подключить его. Начать искать, что именно и при каких условиях пожирает память.
		Так как это ГИС, то возможно, что оперативки не хватает при большом количестве подключений, так как каждое подключение из-за нашей специфики ГИС будет много весить, то логично ограничить количество потоков. Ещё вариант поискать как проапдейтить нашу БД и приложения, чтобы она работала эффективнее с большими по весу запросами. 
