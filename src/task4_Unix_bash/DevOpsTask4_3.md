### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    {
      "info": "Sample JSON output from our service\t",
      "elements": [
        {
          "name": "first",
          "type": "server",
          "ip": 7175
        },
        {
          "name": "second",
          "type": "proxy",
          "ip": "71.78.22.43"
        }
      ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import json

import yaml

if __name__ == '__main__':
    ip_dict = {
        'google.com': '',
        'mail.google.com': '',
        'drive.google.com': ''
    }
    is_error_find = False

    while True:
        for k, v in ip_dict.items():
            ip = socket.gethostbyname(k)
            if v == '':
                ip_dict[k] = ip
            elif v != ip:
                ip_dict[k] = ip
                print(f'[ERROR] {k} IP mismatch: {v} -> {ip}')
                is_error_find = True
        if is_error_find:
            break
        else:
            time.sleep(0.2)

    json_ip_dict = json.dumps(ip_dict)
    with open('ip_dict2.json', 'w') as out_f:
        out_f.write(json_ip_dict)

    yaml_ip_dict = yaml.dump(ip_dict)
    with open('ip_dict.yaml', 'w') as out_f:
        out_f.write(yaml_ip_dict)
```

### Вывод скрипта при запуске при тестировании:
```
[ERROR] google.com IP mismatch: 173.194.220.102 -> 173.194.220.101
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "google.com": "173.194.220.101",
  "mail.google.com": "108.177.14.19",
  "drive.google.com": "173.194.222.194"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 173.194.222.194
google.com: 173.194.220.101
mail.google.com: 108.177.14.19
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
#!/usr/bin/env python3

import json
import sys

import yaml


def read_json():
    with open(sys.argv[1]) as f:
        return json.load(f)


def read_yaml():
    with open(sys.argv[1]) as f:
        return yaml.load(f, Loader=yaml.FullLoader)


if __name__ == '__main__':
    undefined = 'Undefined'
    error = undefined
    file_name = sys.argv[1].split('.')[0]

    try:
        result = read_json()
        with open(f'{file_name}.yaml', 'w') as out_f:
            out_f.write(yaml.dump(result))
    except ValueError as e:
        error = 'invalid json: %s' % e

    if not error.__eq__(undefined):
        try:
            result = read_yaml()
            with open(f'{file_name}.json', 'w') as out_f:
                out_f.write(json.dumps(result))
                error = undefined
        except ValueError as e:
            error = error + '\n' + 'invalid yaml: %s' % e

    if not error.__eq__(undefined):
        raise ValueError(error)

```

### Пример работы скрипта:
drive.google.com: 64.233.164.194
google.com: 142.251.1.139
mail.google.com: 64.233.162.17

{"drive.google.com": "64.233.164.194", "google.com": "142.251.1.139", "mail.google.com": "64.233.162.17"}

Туда обратно все работает.
