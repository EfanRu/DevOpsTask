### Домашнее задание 7-2

# Задание 1
	 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).
	 
    Подробная инструкция на русском языке содержится здесь.
    Обратите внимание на период бесплатного использования после регистрации аккаунта.
    Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки базового терраформ конфига.
    Воспользуйтесь инструкцией на сайте терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

# Решение 1
	Делаем все по инструкицям:
		Подключаем yc: https://cloud.yandex.ru/docs/cli/quickstart#install
		Настраиваем service account и создаем файл конфигурации Terraform: https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#before-you-begin
		
        Создание Enviroment переменных, чтобы не хардкодить токен.
```commandline
slava@slava-MS-7677:~$ export TF_VAR_YC_TOKEN=$(yc iam create-token)
slava@slava-MS-7677:~$ export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
slava@slava-MS-7677:~$ export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
slava@slava-MS-7677:~$ terraform apply
```
        
        Остальное можно посмотреть в файлах .tf
