package log;

import haxe.PosInfos;
import js.lib.Error;

/**
 * Логгер.
 * По сути, это обычный golang логгер, только с добавлением уровней логгирования и возможностью цветного оформления текста.
 * @author VolkovRA
 */
class Logger 
{
	/**
	 * Цветной текст.
	 * Если true, логгер подкрашивает каждое сообщение.
	 * Работает на основе добавления управляющих ANSI символов, не работает в Windows.
	 * По умолчанию: true.
	 */
	public var color:Bool = true;
	
	/**
	 * Время в UTC.
	 * Если true, логгер будет использовать нулевой часовой пояс, установленный в локальной системе.
	 * По умолчанию: true.
	 */
	public var UTC:Bool = true;
	
	/**
	 * Отображение заголовка. (Целиком)
	 * Если true, логгер добавляет в каждое сообщение заголовок с системной информацией: время, уровень важности и т.п.
	 * По умолчанию: true.
	 */
	public var head:Bool = true;
	
	/**
	 * Отображение уровня важности в заголовке.
	 * Если true, в заголовке каждого сообщения будет присутствовать маркер уровня важности данного сообщения: [LEVEL].
	 * По умолчанию: true.
	 */
	public var headLevel:Bool = true;
	
	/**
	 * Отображение даты в заголовке.
	 * Если true, в заголовке каждого сообщения будет присутствовать дата: DD.MM.YYYY.
	 * По умолчанию: true.
	 */
	public var headDate:Bool = true;
	
	/**
	 * Отображение времени в заголовке.
	 * Если true, в заголовке каждого сообщения будет присутствовать время: HH:MM:SS.
	 * По умолчанию: true.
	 */
	public var headTime:Bool = true;
	
	/**
	 * Отображение миллисекунд в заголовке. (Работает только при включенном HeadTime)
	 * Если true, в заголовке каждого сообщения будут присутствовать миллисекунды: HH:MM:SS.000
	 * По умолчанию: false.
	 */
	public var headMC:Bool = false;
	
	/**
	 * Отображение точки вызова в заголовке.
	 * Если true, в заголовке каждого сообщения будет присутствовать информация о вызывающем коде: src/Main.hx:20.
	 * По умолчанию: true.
	 */
	public var headFile:Bool = true;
	
	/**
	 * Уровень важности логируемых сообщений.
	 * Если сообщение не соответствует уровню важности, оно не попадает в журнал.
	 * По умолчанию: LogLevel.TRACE. (Всё подряд)
	 */
	public var level:LogLevel = LogLevel.TRACE;
	
	/**
	 * Цель вывода сообщений.
	 * Вы должны настроить цель вывода сообщений логгера.
	 * По умолчанию: null. (Сообщения игнорируются)
	 */
	public var out:String->Void = null;
	
	/**
	 * Создать логгер.
	 * @param	out Цель вывода сообщений логера.
	 * @param	level Уровень важности логируемых сообщений.
	 */
	public function new(out:String->Void, level:LogLevel) {
		this.out = out;
		this.level = level;
	}
	
	private function write(level:LogLevel, v:Dynamic, pos:PosInfos):Void {
		if (out == null)
			return;
		
		var str = head ? getHeader(level, pos) : "";
		if (color) {
			if (level == LogLevel.ERROR)
				out(str + AColor.apply(AColor.RED) + Std.string(v) + AColor.clear() + "\n");
			else
				out(str + Std.string(v) + "\n");
		}
		else {
			out(str + Std.string(v) + "\n");
		}
	}
	
	private function getHeader(level:LogLevel, pos:PosInfos):String {
		var str = "";
		
		// Метка уровня:
		if (headLevel)
			str += getHeaderLevel(level);
		
		// Цвет заголовка:
		if (color) {
			if (level == LogLevel.ERROR)
				str += AColor.apply(AColor.RED);
			else
				str += AColor.apply(AColor.BLACK_HI);
		}
		
		// Заголовки:
		if (headDate || headTime) {
			var now = Date.now();
			
			if (headDate) {
				var year:Int;
				var month:Int;
				var day:Int;
				
				if (UTC) {
					year	= now.getUTCFullYear();
					month	= now.getUTCMonth() + 1;
					day		= now.getUTCDate();
				}
				else {
					year	= now.getFullYear();
					month	= now.getMonth() + 1;
					day		= now.getDate();
				}
				
				str += toXX(day) + "." + toXX(month) + "." + year + " ";
			}
			
			if (headTime) {
				var hour:Int;
				var min:Int;
				var sec:Int;
				
				if (UTC) {
					hour	= now.getUTCHours();
					min		= now.getUTCMinutes();
					sec		= now.getUTCSeconds();
				}
				else {
					hour	= now.getHours();
					min		= now.getMinutes();
					sec		= now.getSeconds();
				}
				
				str += toXX(hour) + ":" + toXX(min) + ":" + toXX(sec);
				
				if (headMC) {
					var s = "" + now.getTime();
					str += "." + s.substr(s.length - 3);
				}
				
				str += " ";
			}
		}
		if (headFile) {
			str += pos.fileName + ":" + pos.lineNumber + " ";
		}
		
		// Конец заголовка:
		if (str.length == 0)
			return "";
		
		if (color)
			return str.substr(0, str.length-1) + ": " + AColor.clear();
		else
			return str.substr(0, str.length-1) + ": ";
	}
	
	private function getHeaderLevel(level:LogLevel):String {
		if (color) {
			switch (level) {
			case LogLevel.INFO:		return AColor.apply(AColor.BOLD, AColor.GREEN) + 	"[INFO]  " + AColor.clear();
			case LogLevel.WARN:		return AColor.apply(AColor.BOLD, AColor.YELLOW) + 	"[WARN]  " + AColor.clear();
			case LogLevel.TRACE:	return AColor.apply(AColor.BOLD, AColor.WHITE) + 	"[TRACE] " + AColor.clear();
			case LogLevel.DEBUG:	return AColor.apply(AColor.BOLD, AColor.CYAN) + 	"[DEBUG] " + AColor.clear();
			case LogLevel.ERROR:	return AColor.apply(AColor.BOLD, AColor.RED) + 		"[ERROR] " + AColor.clear();
			default:				return AColor.apply(AColor.BOLD, AColor.WHITE) + 	"[]      " + AColor.clear();
			}
		}
		else {
			switch (level) {
			case LogLevel.INFO:		return "[INFO]  ";
			case LogLevel.WARN:		return "[WARN]  ";
			case LogLevel.TRACE:	return "[TRACE] ";
			case LogLevel.DEBUG:	return "[DEBUG] ";
			case LogLevel.ERROR:	return "[ERROR] ";
			default:				return "[]      ";
			}
		}
	}
	
	private inline function toXX(v:Int):String {
		if (v > 9)
			return "" + v;
		else
			return "0" + v;
	}
	
	/**
	 * Выводит сообщение об ошибке и завершает работу приложения.
	 * Вызов этого метода после записи сообщения генерирует исключение для остановки работы всего приложения. Выполнение потока так-же прерывается.
	 * @param	v Сообщение или объект.
	 * @param	pos Точка в вызываемом коде. Этот объект подставляется компилятором автоматически и содержит информацию о номере строки в вызывающем файле.
	 */
	public inline function error(v:Dynamic, ?pos:PosInfos):Void {
		write(LogLevel.ERROR, v, pos);
		throw new Error(Std.string(v));
	}
	
	/**
	 * Выводит предупреждающее сообщение.
	 * Вызов игнорируется, если уровень важности логируемых сообщений не соответствует: WARN.
	 * @param	v Сообщение или объект.
	 * @param	pos Точка в вызываемом коде. Этот объект подставляется компилятором автоматически и содержит информацию о номере строки в вызывающем файле.
	 */
	public inline function warn(v:Dynamic, ?pos:PosInfos):Void {
		if (isWarn())
			write(LogLevel.WARN, v, pos);
	}
	
	/**
	 * Выводит информационное сообщение.
	 * Вызов игнорируется, если уровень важности логируемых сообщений не соответствует: INFO.
	 * @param	v Сообщение или объект.
	 * @param	pos Точка в вызываемом коде. Этот объект подставляется компилятором автоматически и содержит информацию о номере строки в вызывающем файле.
	 */
	public inline function info(v:Dynamic, ?pos:PosInfos):Void {
		if (isInfo())
			write(LogLevel.INFO, v, pos);
	}
	
	/**
	 * Выводит отладочное сообщение.
	 * Вызов игнорируется, если уровень важности логируемых сообщений не соответствует: DEBUG.
	 * @param	v Сообщение или объект.
	 * @param	pos Точка в вызываемом коде. Этот объект подставляется компилятором автоматически и содержит информацию о номере строки в вызывающем файле.
	 */
	public inline function debug(v:Dynamic, ?pos:PosInfos):Void {
		if (isDebug())
			write(LogLevel.DEBUG, v, pos);
	}
	
	/**
	 * Выводит флудовое сообщение.
	 * Вызов игнорируется, если уровень важности логируемых сообщений не соответствует: TRACE.
	 * @param	v Сообщение или объект.
	 * @param	pos Точка в вызываемом коде. Этот объект подставляется компилятором автоматически и содержит информацию о номере строки в вызывающем файле.
	 */
	public inline function trace(v:Dynamic, ?pos:PosInfos):Void {
		if (isTrace())
			write(LogLevel.TRACE, v, pos);
	}
	
	/**
	 * Проверяет актуальность уровня логирования.
	 * Возвращает true, если указанный уровень логирования пишется в журнал.
	 * @param	level Интересующий уровень логирования.
	 */
	public inline function isLevel(level:LogLevel):Bool {
		return this.level >= level;
	}
	
	/**
	 * Проверяет актуальность уровня логгирования: ERROR.
	 * Возвращает true, если сообщения этого уровня пишутся в журнал.
	 */
	public inline function isError():Bool {
		return this.isLevel(LogLevel.ERROR);
	}
	
	/**
	 * Проверяет актуальность уровня логгирования: WARN.
	 * Возвращает true, если сообщения этого уровня пишутся в журнал.
	 */
	public inline function isWarn():Bool {
		return this.isLevel(LogLevel.WARN);
	}
	
	/**
	 * Проверяет актуальность уровня логгирования: INFO.
	 * Возвращает true, если сообщения этого уровня пишутся в журнал.
	 */
	public inline function isInfo():Bool {
		return this.isLevel(LogLevel.INFO);
	}
	
	/**
	 * Проверяет актуальность уровня логгирования: DEBUG.
	 * Возвращает true, если сообщения этого уровня пишутся в журнал.
	 */
	public inline function isDebug():Bool {
		return this.isLevel(LogLevel.DEBUG);
	}
	
	/**
	 * Проверяет актуальность уровня логгирования: TRACE.
	 * Возвращает true, если сообщения этого уровня пишутся в журнал.
	 */
	public inline function isTrace():Bool {
		return this.isLevel(LogLevel.TRACE);
	}
}