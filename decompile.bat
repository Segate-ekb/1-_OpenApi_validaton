@chcp 65001

@rem запустить выгрузку исходников основной конфигурации
call vrunner decompile --out src/cf --current

@rem запустить выгрузку исходников расширения ИмяРасширения
call vrunner decompileext YAXUnit src/cfe/YAXUnit

