﻿////////////////////////////////////////////////////////////////////////////////
// ВалидаторПакетовПовтИсп
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Функция - Схемы данных спецификации
//
// Параметры:
//  Спецификация -  Строка - OpenApi Схема.
// 
// Возвращаемое значение:
//  Соответствие - Схемы данных в виде соответствия.
//
Функция СхемыДанныхСпецификации(Знач Спецификация) Экспорт
    	    
    СпецификацияВФорматеOpenAPI = JsonВОбъект(Спецификация);
	
	КомпонентыСпецификации = СпецификацияВФорматеOpenAPI.Получить("components");
	Если Не ЗначениеЗаполнено(КомпонентыСпецификации) Тогда
		ВызватьИсключение "В спецификации отсутствует блок <components>";
	КонецЕсли;
	
	СхемыДанныхСпецификации = КомпонентыСпецификации.Получить("schemas");
	
	Если Не ЗначениеЗаполнено(СхемыДанныхСпецификации) Тогда
		ВызватьИсключение "В спецификации отсутствует блок <schemas>";
	КонецЕсли;
	
	Возврат СхемыДанныхСпецификации;
	
КонецФункции

// Функция - Схема по строковому пути
//
// Параметры:
//  СтроковыйПуть 	- Строка	 - Путь к получению схемы или части схемы. 
//  Спецификация 	- Строка	 - Спецификация openApi котора будет использоваться для разыменования
// 
// Возвращаемое значение:
//  Соответствие - Найденная схема данных.
//
Функция СхемаПоСтроковомуПути(Знач СтроковыйПуть, Знач Спецификация) Экспорт
	
	СхемаПоСтроковомуПути = Неопределено;
	СтроковыйПутьБезРешетки = СтрЗаменить(СтроковыйПуть, "#", "");
	МассивЧастейПути = СтрРазделить(СтроковыйПутьБезРешетки, "/", Ложь);
	
	СхемаПоСтроковомуПути = JsonВОбъект(Спецификация);
	Для Каждого ЭлементПути Из МассивЧастейПути Цикл
		СхемаПоСтроковомуПути = СхемаПоСтроковомуПути.Получить(ЭлементПути);
		Если СхемаПоСтроковомуПути = Неопределено Тогда
			ТекстОшибки = СтрШаблон("Ошибка при разборе схемы! Не удается получить схему по пути <%1>",
									СтроковыйПуть);
			ЗаписьЖурналаРегистрации("ВалидаторПакетов", // BSLLS:Typo-off
										УровеньЖурналаРегистрации.Ошибка, , ,
										ТекстОшибки);
										
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	КонецЦикла;
		
	Возврат СхемаПоСтроковомуПути;
	
КонецФункции

// Преобразование JSON в Объект.
//
// Параметры:
//   Json - Поток, ДвоичныеДанные, Строка - данные в формате JSON.
//   Кодировка - Строка - кодировка текста JSON. Значение по умолчанию - utf-8.
//
// Возвращаемое значение:
//   Произвольный - значение, десериализованное из JSON.
//
Функция JsonВОбъект(Json, Кодировка = "utf-8") Экспорт

	ПараметрыПреобразованияJSON = ПараметрыПреобразованияJSONПоУмолчанию();

	ЧтениеJSON = Новый ЧтениеJSON;
	Если ТипЗнч(Json) = Тип("ДвоичныеДанные") Тогда
		ЧтениеJSON.ОткрытьПоток(Json.ОткрытьПотокДляЧтения(), Кодировка);
	ИначеЕсли ТипЗнч(Json) = Тип("Строка") Тогда
		ЧтениеJSON.УстановитьСтроку(Json);
	Иначе
		ЧтениеJSON.ОткрытьПоток(Json, Кодировка);
	КонецЕсли;
	Объект = ПрочитатьJSON(
		ЧтениеJSON,
		ПараметрыПреобразованияJSON.ПрочитатьВСоответствие,
		ПараметрыПреобразованияJSON.ИменаСвойствСоЗначениямиДата,
		ПараметрыПреобразованияJSON.ФорматДатыJSON,
		ПараметрыПреобразованияJSON.ИмяФункцииВосстановления,
		ПараметрыПреобразованияJSON.МодульФункцииВосстановления,
		ПараметрыПреобразованияJSON.ДополнительныеПараметрыФункцииВосстановления,
		ПараметрыПреобразованияJSON.ИменаСвойствДляОбработкиВосстановления,
		ПараметрыПреобразованияJSON.МаксимальнаяВложенность);
	ЧтениеJSON.Закрыть();

	Возврат Объект;

КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыПреобразованияJSONПоУмолчанию() // BSLLS:LatinAndCyrillicSymbolInWord-off

	ПараметрыПреобразованияПоУмолчанию = Новый Структура;
	ПараметрыПреобразованияПоУмолчанию.Вставить("ПрочитатьВСоответствие", Истина);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ФорматДатыJSON", ФорматДатыJSON.ISO);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ИменаСвойствСоЗначениямиДата", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ВариантЗаписиДатыJSON", ВариантЗаписиДатыJSON.ЛокальнаяДата);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ИмяФункцииПреобразования",
													 "ПреобразованиеПоУмолчаниюПриСериализацииJSON"); // BSLLS:Typo-off
	ПараметрыПреобразованияПоУмолчанию.Вставить("МодульФункцииПреобразования", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ДополнительныеПараметрыФункцииПреобразования", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ИмяФункцииВосстановления", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("МодульФункцииВосстановления", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ДополнительныеПараметрыФункцииВосстановления", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("ИменаСвойствДляОбработкиВосстановления", Неопределено);
	ПараметрыПреобразованияПоУмолчанию.Вставить("МаксимальнаяВложенность", 500); // BSLLS:MagicNumber-off

	Возврат ПараметрыПреобразованияПоУмолчанию;

КонецФункции

#КонецОбласти
