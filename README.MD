## Задание 1

![Задание 1_1](https://github.com/arccos2x-lwr/terraform_03_hw/blob/terraform-03/IMG/01-01.png)

![Задание 1_2](https://github.com/arccos2x-lwr/terraform_03_hw/blob/terraform-03/IMG/01-02.png)

## Задание 2

### 2.1 Веб-серверы (count)
Созданы две одинаковые ВМ `web-1` и `web-2` с помощью мета-аргумента `count`.

### 2.2 Базы данных (for_each)
Созданы две ВМ `main` и `replica` с разными характеристиками
(CPU/RAM/диск) через мета-аргумент `for_each`.

### 2.3 Порядок создания
ВМ `web-*` создаются после `db` благодаря `depends_on`.

### 2.4 SSH-ключ
Публичный ключ `~/.ssh/id_ed25519.pub` читается через `file()`
и передаётся в `metadata`.

![Задание 2_1](https://github.com/arccos2x-lwr/terraform_03_hw/blob/terraform-03/IMG/02-01.png)

## Задание 3

Созданы:
- 3 одинаковых диска по 1 ГБ через `count`
- ВМ `storage` с динамическим подключением дисков через блок `dynamic "secondary_disk"` и `for_each`

![Задание 3_1](https://github.com/arccos2x-lwr/terraform_03_hw/blob/terraform-03/IMG/03-01.png)

![Задание 3_2](https://github.com/arccos2x-lwr/terraform_03_hw/blob/terraform-03/IMG/03-02.png)

## Задание 4

Сгенерирован файл `inventory.ini` через `templatefile`.

Инвентарь содержит 3 группы: `[webservers]`, `[databases]`, `[storage]`.

Для каждой ВМ указаны `ansible_host` и `fqdn`.

![Задание 4_1](https://github.com/arccos2x-lwr/terraform_03_hw/blob/terraform-03/IMG/04-01.png)