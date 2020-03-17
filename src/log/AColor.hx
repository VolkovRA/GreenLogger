package log;

/**
 * Статический класс для раскраски текста, выводимого в консоль.
 * Работает на основе управляющих ANSI символов, может не работать в Windows. (При запуске в NodeJS на винде работает корректно)
 * @see https://ru.wikipedia.org/wiki/%D0%A3%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D1%8F%D1%8E%D1%89%D0%B8%D0%B5_%D0%BF%D0%BE%D1%81%D0%BB%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE%D1%81%D1%82%D0%B8_ANSI
 * @author VolkovRA
 */
class AColor 
{
	// БАЗОВЫЕ КОДЫ
	/// Выключение всех атрибутов.
	static public inline var RESET			= 0;
	/// Жирный или увеличить яркость.
	static public inline var BOLD			= 1;
	/// Блёклый (уменьшить яркость).
	static public inline var FAINT			= 2;
	/// Курсив: вкл.
	static public inline var ITALIC			= 3;
	/// Подчёркнутый: один раз.
	static public inline var UNDERLINE		= 4;
	/// Мигание: Медленно.
	static public inline var BLINK_SLOW		= 5;
	/// Мигание: Часто.
	static public inline var BLINK_RAPID	= 6;
	/// Отображение: Негатив.
	static public inline var REVERSE_VIDEO	= 7;
	/// Скрытый.
	static public inline var CONCEALED		= 8;
	/// Зачёркнутый
	static public inline var CROSSED_OUT	= 9;
	
	// ЦВЕТ ТЕКСТА
	/// Цвет текста - Чёрный.
	static public inline var BLACK			= 30;
	/// Цвет текста - Красный.
	static public inline var RED			= 31;
	/// Цвет текста - Зелёный.
	static public inline var GREEN			= 32;
	/// Цвет текста - Желтый.
	static public inline var YELLOW			= 33;
	/// Цвет текста - Синий.
	static public inline var BLUE			= 34;
	/// Цвет текста - Фиолетовый.
	static public inline var MAGENTA		= 35;
	/// Цвет текста - Пурпурный.
	static public inline var CYAN			= 36;
	/// Цвет текста - Белый.
	static public inline var WHITE			= 37;
	
	// ЦВЕТ ТЕКСТА - ЯРКИЙ (HIGH)
	/// Цвет текста - Чёрный (Светлый).
	static public inline var BLACK_HI		= 90;
	/// Цвет текста - Красный (Яркий).
	static public inline var RED_HI			= 91;
	/// Цвет текста - Зелёный (Яркий).
	static public inline var GREEN_HI		= 92;
	/// Цвет текста - Желтый (Яркий).
	static public inline var YELLOW_HI		= 93;
	/// Цвет текста - Синий (Яркий).
	static public inline var BLUE_HI		= 94;
	/// Цвет текста - Фиолетовый (Яркий).
	static public inline var MAGENTA_HI		= 95;
	/// Цвет текста - Пурпурный (Яркий).
	static public inline var CYAN_HI		= 96;
	/// Цвет текста - Белый (Яркий).
	static public inline var WHITE_HI		= 97;
	
	// ЦВЕТ ФОНА
	/// Цвет фона - Чёрный.
	static public inline var BG_BLACK		= 40;
	/// Цвет фона - Красный.
	static public inline var BG_RED			= 41;
	/// Цвет фона - Зелёный.
	static public inline var BG_GREEN		= 42;
	/// Цвет фона - Желтый.
	static public inline var BG_YELLOW		= 43;
	/// Цвет фона - Синий.
	static public inline var BG_BLUE		= 44;
	/// Цвет фона - Фиолетовый.
	static public inline var BG_MAGENTA		= 45;
	/// Цвет фона - Пурпурный.
	static public inline var BG_CYAN		= 46;
	/// Цвет фона - Белый.
	static public inline var BG_WHITE		= 47;
	
	// ЦВЕТ ФОНА - ЯРКИЙ (HIGH)
	/// Цвет фона - Чёрный (Светлый).
	static public inline var BG_BLACK_HI	= 100;
	/// Цвет фона - Красный (Яркий).
	static public inline var BG_RED_HI		= 101;
	/// Цвет фона - Зелёный (Яркий).
	static public inline var BG_GREEN_HI	= 102;
	/// Цвет фона - Желтый (Яркий).
	static public inline var BG_YELLOW_HI	= 103;
	/// Цвет фона - Синий (Яркий).
	static public inline var BG_BLUE_HI		= 104;
	/// Цвет фона - Фиолетовый (Яркий).
	static public inline var BG_MAGENTA_HI	= 105;
	/// Цвет фона - Пурпурный (Яркий).
	static public inline var BG_CYAN_HI		= 106;
	/// Цвет фона - Белый (Яркий).
	static public inline var BG_WHITE_HI	= 107;
	
	/**
	 * Применить стили.
	 * Возвращает последовательность управляющих символов для применения указанных кодов форматирования.
	 * Вы можете передать один или несколько кодов за один раз.
	 * @param	code Код 1.
	 * @param	code2 Код 2.
	 * @param	code3 Код 3.
	 * @param	code4 Код 4.
	 * @param	code5 Код 5.
	 */
	static public function apply(code:Int, ?code2:Int, ?code3:Int, ?code4:Int, ?code5:Int):String {
		var str = "\x1b[" + code + ";";
		if (code2 != null)	str += code2 + ";";
		if (code3 != null)	str += code3 + ";";
		if (code4 != null)	str += code4 + ";";
		if (code5 != null)	str += code5 + ";";
		
		return str.substr(0, str.length - 1) + "m";
	}
	
	/**
	 * Очистить все стили.
	 * Возвращает последовательность управляющих символов для сброса всех эффектов.
	 */
	static public inline function clear():String {
		return "\x1b[0m";
	}
}