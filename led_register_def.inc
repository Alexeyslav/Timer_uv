;регистр светодиодов, присвоение физических выводов сегментам
#define  led_serial PB0 ; - serial 
#define  led_clock  PB1 ; - clock   
#define  led_latch  PB2 ; - latch


#define led_serial_1 SBI PORTB, led_serial
#define led_serial_0 CBI PORTB, led_serial
#define led_clock_1  SBI PORTB, led_clock
#define led_clock_0  CBI PORTB, led_clock
#define led_latch_1  SBI PORTB, led_latch
#define led_latch_0  CBI PORTB, led_latch

; ќпределени€ выводов разр€дов

#define  led_digit0 PD3
#define  led_digit1 PD4
#define  led_digit2 PD6
#define  led_digit3 PD7

.EQU led_digit_mask = led_digit0|led_digit1|led_digit2|led_digit3

#define led_digit0_on  SBI PORTD, led_digit0
#define led_digit0_off SBI PORTD, led_digit0
#define led_digit1_on  SBI PORTD, led_digit1
#define led_digit1_off SBI PORTD, led_digit1
#define led_digit2_on  SBI PORTD, led_digit2
#define led_digit2_off SBI PORTD, led_digit2
#define led_digit3_on  SBI PORTD, led_digit3
#define led_digit3_off SBI PORTD, led_digit3
