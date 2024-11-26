# Валидатор openApi контрактов для 1С


[![Chat on Telegram DevOps_onec](https://img.shields.io/badge/DevOps_в_1с-channel-brightgreen.svg?logo=telegram)](https://t.me/DevOps_onec)
[![GitHub release](https://img.shields.io/github/release/Segate-ekb/1c_OpenApi_validation.svg)](https://github.com/Segate-ekb/1c_OpenApi_validation/releases)
[![Статус порога качества](https://sonar.1cdevelopers.ru/api/project_badges/measure?project=1c_openApi_validation&metric=alert_status&token=sqb_a6afeb91a4cb1185085025558c3c520f03600a43)](https://sonar.1cdevelopers.ru/dashboard?id=1c_openApi_validation)
[![Рейтинг сопровождаемости](https://sonar.1cdevelopers.ru/api/project_badges/measure?project=1c_openApi_validation&metric=sqale_rating&token=sqb_a6afeb91a4cb1185085025558c3c520f03600a43)](https://sonar.1cdevelopers.ru/dashboard?id=1c_openApi_validation)
[![Статья на инфостарт](./doc/infostart.svg)](https://infostart.ru/1c/tools/2246023/)

В современном мире OpenAPI (Swagger) является стандартом для описания RESTful API.
Данная подсистема позволит вам проверять входящие и исходящие пакеты данных на соответствие контракту OpenAPI.

## Установка

Для установки необходимо:

1. Скачать последнюю версию подсистемы из раздела [releases](https://github.com/Segate-ekb/1c_OpenApi_validation/releases)
2. Сравнить/объединить полученные файлы с вашим проектом.

## Использование

Тут все максимально просто.

Вызываем метод `ВалидаторПакетов.Валидировать` с параметрами:

- МодельДанных - Строка, Число, Массив, Структура, Соответствие - Это ваш пакет, который вы хотите валидировать.
- ИмяСхемы - Строка - Имя схемы данных по которой вы хотите валидировать модель.
- Спецификация - Строка - Спецификация OpenAPI 3.0 в формате JSON.

Метод вернет массив с ошибками валидации. Если ошибок нет, то метод вернет пустой массив.

## Пример использования

Как это выглядит в коде:

```bsl
    СхемаOpenApi = "{
    |""openapi"": ""3.0.0"",
    |""info"": {
    |    ""title"": ""Example"",
    |    ""version"": ""1.0.0""
    |},
    |""paths"": {}
    |""components"": {
    |    ""schemas"": {
    |        ""complex_object"": {
    |            ""type"": ""object"",
    |            ""properties"": {
    |                ""name"": {
    |                    ""type"": ""string"",
    |                    ""minLength"": 3,
    |                    ""maxLength"": 10
    |                },
    |                ""age"": {
    |                    ""type"": ""integer"",
    |                    ""minimum"": 18,
    |                    ""maximum"": 100
    |                }
    |            },
    |            ""additionalProperties"": false,
    |            ""required"": [""name"", ""age""]
    |        }
    |    }
    |}";
    МодельДанных = Новый Структура("name, age", "John", 30);
    МассивОшибок = ВалидаторПакетов.Валидировать(МодельДанных, "complex_object", СхемаOpenApi);

	Если МассивОшибок.количество() = 0 Тогда
		Сообщить("Валидация прошла успешно!");
		Возврат;
	КонецЕсли;

	Для каждого Ошибка Из МассивОшибок Цикл
		Сообщить(Ошибка,СтатусСообщения.Внимание);
	КонецЦикла;
```

### Обработка-пример

В конфигурации есть пример использования подсистемы. Посмотрите обработку `ПримерРаботыВалидатора`.

## Возможности

### Валидация строк

Реализована валидация строк по следующим правилам:

- [x] minLength
- [x] maxLength
- [x] pattern
- [ ] format
  - [x] date
    - Валидацию пройдет как строка в нужном формате, так и дата.
  - [x] date-time
    - Валидацию пройдет как строка в нужном формате, так и дата.
  - [x] email
  - [x] hostname
  - [x] ipv4
  - [x] ipv6
  - [x] uri
  - [x] uuid
    - Валидацию пройдет как строка в нужном формате, так и УникальныйИдентификатор.
  - [ ] binary
  - [x] byte
  - [x] enum

### Валидация чисел

Реализована валидация чисел по следующим правилам:

- [x] minimum
- [x] maximum
- [x] exclusiveMinimum
- [x] exclusiveMaximum
- [x] multipleOf
- [ ] format
  - [ ] int32
  - [ ] int64
  - [ ] float
  - [ ] double

### Валидация массивов

Реализована валидация массивов по следующим правилам:

- [x] items
- [x] minItems
- [x] maxItems
- [x] uniqueItems

### Валидация объектов

Реализована валидация объектов по следующим правилам:

- [x] maxProperties
- [x] minProperties
- [x] required
- [x] additionalProperties

### Общие свойства

- [x] nullable
- [x] $ref
- [ ] deprecated
- [ ] readOnly
- [ ] writeOnly
- [ ] oneOf
- [ ] anyOf
- [ ] allOf
- [ ] not

## Ближайшие планы

- [ ] Добавить возможность валидации по URL спецификации.
- [ ] Добавить обработку конструкций `allOf`, `anyOf`, `oneOf`, `not`.
- [ ] Добавить поддержку свойства `format` для числовых типов.
- [ ] Добавить валидацию формата `binary` для строк.
- [ ] Добавить поддержку свойств `readOnly`, `writeOnly`.

## Как помочь проекту

- Ознакомьтесь с [процессом разработки](CONTRIBUTING.md)
- Поддержите проект звездой

## Лицензия

[MIT](LICENSE)

## Благодарности

- Основная идея и большая часть решений была позаимствована из проекта [swaggerDataValidation1C](https://github.com/KokorishviliK/swaggerDataValidation1C)
- Создателям [YaXunit](https://github.com/bia-technologies/yaxunit) - за лучший фреймворк для юнит-тестирования в 1С.
- Создателям [jenkins-lib](https://github.com/firstBitMarksistskaya/jenkins-lib) - за удобство и простоту в создании CI.
