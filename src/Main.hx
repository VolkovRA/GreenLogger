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