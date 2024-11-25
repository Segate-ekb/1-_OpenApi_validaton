@chcp 65001

@rem Сборка основной разработческой ИБ. по умолчанию в каталоге build/ib
call vrunner init-dev --src src/cf %*

@rem обновление конфигурации основной разработческой ИБ из хранилища. для включения раскомментируйте код ниже
@rem call vrunner loadrepo %*
@rem call vrunner updatedb %*

@rem собрать внешние обработчики и отчеты в каталоге build
@rem call vrunner compileepf src/epf/МояВнешняяОбработка build %*
@rem call vrunner compileepf src/erf/МойВнешнийОтчет build %*

@rem собрать расширения конфигурации внутри ИБ
call vrunner compileexttocfe --src src/cfe/YAXUNIT --out build/YAXUNIT.cfe %*

call vrunner run --command "Путь=build/YAXUNIT.cfe;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗагрузитьРасширениеВРежимеПредприятия.epf %*

@rem Обновление в режиме Предприятия
call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*
