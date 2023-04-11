# Домашнее задание к занятию 11 «Teamcity»

## Подготовка к выполнению

### Задание 1
    В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа jetbrains/teamcity-server.

### Решение 1
    Done

### Задание 2
    Дождитесь запуска teamcity, выполните первоначальную настройку.

### Решение 2
    Done

### Задание 3
    Создайте ещё один инстанс (2CPU4RAM) на основе образа jetbrains/teamcity-agent. Пропишите к нему переменную окружения SERVER_URL: "http://<teamcity_url>:8111".

### Решение 3
    Done

### Задание 4
    Авторизуйте агент.

### Решение 4
    Done

### Задание 5
    Сделайте fork репозитория.

### Решение 5
    Done

### Задание 6
    Создайте VM (2CPU4RAM) и запустите playbook.

### Решение 6
    Done

## Основная часть

### Задание 1
    Создайте новый проект в teamcity на основе fork.

### Решение 1
![Task_1_create_project_by_fork.png](Screenshoots%2FTask_1_create_project_by_fork.png)

### Задание 2
    Сделайте autodetect конфигурации.

### Решение 2
    Done

### Задание 3
    Сохраните необходимые шаги, запустите первую сборку master.

### Решение 3
![First_run.png](Screenshoots%2FFirst_run.png)

### Задание 4
    Поменяйте условия сборки: если сборка по ветке master, то должен происходит mvn clean deploy, иначе mvn clean test.

### Решение 4
![Change step condition.png](Screenshoots%2FChange%20step%20condition.png)

### Задание 5
    Для deploy будет необходимо загрузить settings.xml в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.

### Решение 5
![Change maven goal.png](Screenshoots%2FChange%20maven%20goal.png)

### Задание 6
    В pom.xml необходимо поменять ссылки на репозиторий и nexus.

### Решение 6
    Done

### Задание 7
    Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.

### Решение 7
![Passed deploy in nexus.png](Screenshoots%2FPassed%20deploy%20in%20nexus.png)
![Excport in nexus.png](Screenshoots%2FExcport%20in%20nexus.png)

### Задание 8
    Мигрируйте build configuration в репозиторий.

### Решение 8
    Вот тут не понятно. Так как в папке example-teamcity пусто и никаких конфигураций я не нашел, то я понял это задание так, 
    что мне нужно в виде кода сохранить текущее состояние своего build в Teamcity.
[build_configuration](build_configuration)

### Задание 9
    Создайте отдельную ветку feature/add_reply в репозитории.

### Решение 9
```commandline
git co -b feature/add_reply
```

### Задание 10
    Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово hunter.

### Решение 10
```java
	public String sayWtf() {
		return "WTF, Hunter?"
	}
```

### Задание 11
    Дополните тест для нового метода на поиск слова hunter в новой реплике.

### Решение 11
```java
	@Test
	public void welcomerSaysWtf() {
		assertThat(welcomer.sayWtf(), containsString("Hunter"));
	}
```

### Задание 12
    Сделайте push всех изменений в новую ветку репозитория.

### Решение 12
<details><summary>Обновляем код:</summary>

```commandline
slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git st
On branch feature/add_reply
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   src/main/java/plaindoll/Welcomer.java
	modified:   src/test/java/plaindoll/WelcomerTest.java

no changes added to commit (use "git add" and/or "git commit -a")
slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git add .
slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git ct -m "Add sayWtf method."[feature/add_reply 8b755bd] Add sayWtf method.
 2 files changed, 8 insertions(+), 1 deletion(-)
slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git push origin
fatal: The current branch feature/add_reply has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin feature/add_reply

slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git push --set-upstream origin feature/add_reply
Enumerating objects: 20, done.
Counting objects: 100% (20/20), done.
Delta compression using up to 12 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (11/11), 782 bytes | 782.00 KiB/s, done.
Total 11 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
remote: 
remote: Create a pull request for 'feature/add_reply' on GitHub by visiting:
remote:      https://github.com/EfanRu/example-teamcity/pull/new/feature/add_reply
remote: 
To github.com:EfanRu/example-teamcity.git
 * [new branch]      feature/add_reply -> feature/add_reply
Branch 'feature/add_reply' set up to track remote branch 'feature/add_reply' from 'origin'.
```

</details>


### Задание 13
    Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.

### Решение 13
![Check bualid auto run and success.png](Screenshoots%2FCheck%20bualid%20auto%20run%20and%20success.png)

### Задание 14
    Внесите изменения из произвольной ветки feature/add_reply в master через Merge.

### Решение 14
```commandline
slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git co master
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
slava@slava-FLAPTOP-r:~/Documents/example-teamcity$ git merge feature/add_reply
Updating 77dd70c..0ab0e39
Fast-forward
 src/main/java/plaindoll/Welcomer.java     | 3 +++
 src/test/java/plaindoll/WelcomerTest.java | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)
```

### Задание 15
    Убедитесь, что нет собранного артефакта в сборке по ветке master.

### Решение 15
![No_artefact_deploy.png](Screenshoots%2FNo_artefact_deploy.png)

### Задание 16
    Настройте конфигурацию так, чтобы она собирала .jar в артефакты сборки.

### Решение 16
    Done

### Задание 17
    Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.

### Решение 17
![Rerun_master.png](Screenshoots%2FRerun_master.png)
![New_version_in_nexus.png](Screenshoots%2FNew_version_in_nexus.png)

### Задание 18
    Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.

### Решение 18
    Done
[build_configuration](build_configuration)

### Задание 19
    В ответе пришлите ссылку на репозиторий.

### Решение 19
    Done

---