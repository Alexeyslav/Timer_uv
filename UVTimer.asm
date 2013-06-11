.nolist
.include "m48def.inc"
.include "macros.inc" // общие макроопределения
.list

.include "led_register_def.inc" // определения для регистра сегментов и разрядов.


.def temp 			= R1
.def last_key		= R2
.def last_key_count	= R3

.def int_sreg = R15
.def ACCUM = R16
.def tempi = R17


; ###########################################################################################
;Не оперативные переменные, располагаются в RAM
.dseg
led_dgits_pos:	.BYTE 1 ; Позиция индикации, у казывает текущий номер засвеченного разряда динамической индикации
led_digits:		.BYTE 4 ; буффер на 4 разряда, внесение сюда значений автоматически выводит их на индикатор.

timer_sec:		.BYTE 1 ; Рабочий счетчик таймера
timer_sec10:	.BYTE 1
timer_min:		.BYTE 1
timer_min10:	.BYTE 1
//timer_start_value: .BYTE 4 ; Сохраненное значение таймера... {нужно ли оно?}

timer_mode:		.BYTE 1 ; Режим работы таймера.
.EQU tm_stop	= 0x01 // таймер остановлен - можно вводить новое значение или запустить
.EQU tm_run		= 0x02 // таймер запущен - ввод запрещен, можно только остановить.




; ###########################################################################################
; ###########################################################################################
; ###########################################################################################
; ###########################################################################################
.cseg
.org 0
rjmp RESET ; Reset Handler
RETI ;rjmp EXT_INT0 ; IRQ0 Handler
RETI ;rjmp EXT_INT1 ; IRQ1 Handler
RETI ;rjmp PCINT0 ; PCINT0 Handler
RETI ;rjmp PCINT1 ; PCINT1 Handler
RETI ;rjmp PCINT2 ; PCINT2 Handler
RETI ;rjmp WDT ; Watchdog Timer Handler
RETI ;rjmp TIM2_COMPA ; Timer2 Compare A Handler
RETI ;rjmp TIM2_COMPB ; Timer2 Compare B Handler
rjmp TIM2_OVF ; Timer2 Overflow Handler
RETI ;rjmp TIM1_CAPT ; Timer1 Capture Handler
RETI ;rjmp TIM1_COMPA ; Timer1 Compare A Handler
RETI ;rjmp TIM1_COMPB ; Timer1 Compare B Handler
RETI ;rjmp TIM1_OVF ; Timer1 Overflow Handler
RETI ;rjmp TIM0_COMPA ; Timer0 Compare A Handler
RETI ;rjmp TIM0_COMPB ; Timer0 Compare B Handler
RETI ;rjmp TIM0_OVF ; Timer0 Overflow Handler
RETI ;rjmp SPI_STC ; SPI Transfer Complete Handler
RETI ;rjmp USART_RXC ; USART, RX Complete Handler
RETI ;rjmp USART_UDRE ; USART, UDR Empty Handler
RETI ;rjmp USART_TXC ; USART, TX Complete Handler
RETI ;rjmp ADC ; ADC Conversion Complete Handler
RETI ;rjmp EE_RDY ; EEPROM Ready Handler
RETI ;rjmp ANA_COMP ; Analog Comparator Handler
RETI ;rjmp TWI ; 2-wire Serial Interface Handler
RETI ;rjmp SPM_RDY ; Store Program Memory Ready Handler

TIM2_OVF: // Прерывание от таймера динамической индикации.
//берем последовательно значения из массива RAM Led_Digits и выводим в регистр, переключая разряды.
IN		int_sreg, SREG
PUSH	ACCUM
PUSH	tempi

// выбрать следующий разряд
 LDS ACCUM, led_dgits_pos ; Позиция индикации, у казывает текущий номер засвеченного разряда динамической индикации
 INC ACCUM
 ANDI ACCUM, 0x03
 STS led_dgits_pos, ACCUM
 LDI YH, high(led_digits)
 LDI YL, low (led_digits)
 Add YL, ACCUM ; обещаю быть аккуратным и массив led_digits никогда не будет пересекать границу 256 байт.(произнести вслух 3 раза!!!)
//BRCC PC+1	; если в результате перешли границу 256-байтной страницы, надо перейти на новую страницу
// INC YH
 LD ACCUM, Y
// отключить дисплей
rcall LED_OFF
// загрузить разряд
rcall LED_SET_REG
// включить дисплей на нужном разряде


POP		tempi
POP		ACCUM
OUT	SREG, int_sreg
RETI

RESET:
 ldi	ACCUM,	high(RAMEND)
 out	SPH,	ACCUM        ; Set Stack Pointer to top of RAM
 ldi	ACCUM,	low(RAMEND)
 out	SPL,	ACCUM

// Инициализация
set_io PORTB, 0 // все начальные состояния портов - по нулям.
set_io PORTC, 0
set_io PORTD, 0
//If DDxn is written logic one , Pxn is configured as an output.
//If DDxn is written logic zero, Pxn is configured as an input.
set_io DDRB, 0b00111111  //старшие разряды - кварцевый генератор
set_io DDRC, 0b00111111  //старшие разряды не реализованы на выход
set_io DDRD, 0b11111100  //RX-TX настроены как ВХОДЫ, при включении приемопередатчика их функция будет иметь приоритет над настройкой порта.




MAIN_LOOP:


RJMP MAIN_LOOP

.include "led_register_code.inc"	// Подпрограммы обеспечения работы светодиодного индикатора
.include "timer_code.inc" 			// Подпрограммы обеспечения функции таймера
.include "keyboard_code.inc" 		// Подпрограммы обеспечения функции клавиатуры
