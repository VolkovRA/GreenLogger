# Цветной логгер

Описание
------------------------------

Простенький логгер, написанный для собственных проектов.
Имеются уровни логирования и цветное оформление текста (По желанию). Транспорт настраивается пользователем.

Может не работать в Windows, если терминал не поддерживает управляющие ANSI коды, но работает в NodeJS под Windows.
Подробнее [тут](https://ru.wikipedia.org/wiki/%D0%A3%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D1%8F%D1%8E%D1%89%D0%B8%D0%B5_%D0%BF%D0%BE%D1%81%D0%BB%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE%D1%81%D1%82%D0%B8_ANSI "Управляющие последовательности ANSI").

Пример использования
------------------------------
```
package;

import log.Logger;
import log.LogLevel;
import js.Node;

class Main 
{
	
	static public var log:Logger;
	
	static function main() {
		log = new Logger(onLog, LogLevel.TRACE);
		log.headMC = true;
		
		log.info("Информационное сообщение");
		log.debug("Сообщение отладки");
		log.trace("Любой, произвольный текст");
		log.warn("Предупреждение");
		log.error("Пример текста фатальной ошибки");
		
		log.info("Недостижимый код");
	}
	
	static private function onLog(msg:String):Void {
		Node.process.stderr.write(msg);
	}
}
```
![Пример вывода](https://github.com/VolkovRA/GreenLogger/blob/master/example.png)
