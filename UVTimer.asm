.nolist
.include "m48def.inc"
.include "macros.inc" // ����� ����������������
.list

.include "led_register_def.inc" // ����������� ��� �������� ��������� � ��������.


.def temp 			= R1
.def last_key		= R2
.def last_key_count	= R3

.def int_sreg = R15
.def ACCUM = R16
.def tempi = R17


; ###########################################################################################
;�� ����������� ����������, ������������� � RAM
.dseg
led_dgits_pos:	.BYTE 1 ; ������� ���������, � �������� ������� ����� ������������ ������� ������������ ���������
led_digits:		.BYTE 4 ; ������ �� 4 �������, �������� ���� �������� ������������� ������� �� �� ���������.

timer_sec:		.BYTE 1 ; ������� ������� �������
timer_sec10:	.BYTE 1
timer_min:		.BYTE 1
timer_min10:	.BYTE 1
//timer_start_value: .BYTE 4 ; ����������� �������� �������... {����� �� ���?}

timer_mode:		.BYTE 1 ; ����� ������ �������.
.EQU tm_stop	= 0x01 // ������ ���������� - ����� ������� ����� �������� ��� ���������
.EQU tm_run		= 0x02 // ������ ������� - ���� ��������, ����� ������ ����������.




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

TIM2_OVF: // ���������� �� ������� ������������ ���������.
//����� ��������������� �������� �� ������� RAM Led_Digits � ������� � �������, ���������� �������.
IN		int_sreg, SREG
PUSH	ACCUM
PUSH	tempi

// ������� ��������� ������
 LDS ACCUM, led_dgits_pos ; ������� ���������, � �������� ������� ����� ������������ ������� ������������ ���������
 INC ACCUM
 ANDI ACCUM, 0x03
 STS led_dgits_pos, ACCUM
 LDI YH, high(led_digits)
 LDI YL, low (led_digits)
 Add YL, ACCUM ; ������ ���� ���������� � ������ led_digits ������� �� ����� ���������� ������� 256 ����.(���������� ����� 3 ����!!!)
//BRCC PC+1	; ���� � ���������� ������� ������� 256-������� ��������, ���� ������� �� ����� ��������
// INC YH
 LD ACCUM, Y
// ��������� �������
rcall LED_OFF
// ��������� ������
rcall LED_SET_REG
// �������� ������� �� ������ �������


POP		tempi
POP		ACCUM
OUT	SREG, int_sreg
RETI

RESET:
 ldi	ACCUM,	high(RAMEND)
 out	SPH,	ACCUM        ; Set Stack Pointer to top of RAM
 ldi	ACCUM,	low(RAMEND)
 out	SPL,	ACCUM

// �������������
set_io PORTB, 0 // ��� ��������� ��������� ������ - �� �����.
set_io PORTC, 0
set_io PORTD, 0
//If DDxn is written logic one , Pxn is configured as an output.
//If DDxn is written logic zero, Pxn is configured as an input.
set_io DDRB, 0b00111111  //������� ������� - ��������� ���������
set_io DDRC, 0b00111111  //������� ������� �� ����������� �� �����
set_io DDRD, 0b11111100  //RX-TX ��������� ��� �����, ��� ��������� ����������������� �� ������� ����� ����� ��������� ��� ���������� �����.




MAIN_LOOP:


RJMP MAIN_LOOP

.include "led_register_code.inc"	// ������������ ����������� ������ ������������� ����������
.include "timer_code.inc" 			// ������������ ����������� ������� �������
.include "keyboard_code.inc" 		// ������������ ����������� ������� ����������
