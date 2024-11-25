#!/bin/bash

# формирование файла конфигурации. для включения раскомментируйте код ниже
vrunner compile --src src/cf --out build/1cv8.cf "$@"

# обновление конфигурации основной разработческой ИБ из хранилища. для включения раскомментируйте код ниже
# vrunner loadrepo "$@"
# vrunner updatedb "$@"

# собрать внешние обработчики и отчеты в каталоге build
# vrunner compileepf src/epf/МояВнешняяОбработка build "$@"
# vrunner compileepf src/erf/МойВнешнийОтчет build "$@"

# собрать расширения конфигурации внутри ИБ
# vrunner compileext src/cfe/МоеРасширение МоеРасширение "$@"
