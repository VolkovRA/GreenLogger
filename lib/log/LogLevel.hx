package log;

/**
 * Уровень важности логируемых сообщений.
 * Необходим для разделения сообщений журнала по уровню важности.
 * @author VolkovRA
 */
@:enum
abstract LogLevel(Int)
{
	/**
	 * Критическая ошибка.
	 * Приложение в критическом состоянии, требуется вмешательство человека.
	 */
	var ERROR = 0;
	
	/**
	 * Предупреждение.
	 * Возникли осложнения, но программа умная и смогла их разрешить самостоятельно.
	 */
	var WARN = 1;
	
	/**
	 * Общая информация.
	 * Что сейчас происходит.
	 */
	var INFO = 2;
	
	/**
	 * Отладочные сообщения.
	 * Дополнительная информация, которая может быть полезна для диагностики или отладки.
	 */
	var DEBUG = 3;
	
	/**
	 * Всё подряд.
	 * Пишем всё подряд.
	 */
	var TRACE = 4;
	
	@:op(A < B) static function lt(a:LogLevel, b:LogLevel):Bool;
	@:op(A <= B) static function lte(a:LogLevel, b:LogLevel):Bool;
	@:op(A > B) static function gt(a:LogLevel, b:LogLevel):Bool;
	@:op(A >= B) static function gte(a:LogLevel, b:LogLevel):Bool;
	@:op(A == B) static function eq(a:LogLevel, b:LogLevel):Bool;
	@:op(A != B) static function ne(a:LogLevel, b:LogLevel):Bool;
}