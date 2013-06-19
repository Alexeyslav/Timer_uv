// Подпрограммы реализации интерфейса с сенсорной клавиатурой.
//                  /------- Имя порта
#define key_line_X0 C, PC0
#define key_line_X1 C, PC1
#define key_line_X2 C, PC2
#define key_line_Y0 C, PC3
#define key_line_Y1 C, PC4
#define key_line_Y2 C, PC5
#define key_line_Y3 B, PB5

.macro set_sensor
 SBI PORT@0
.endmacro

.macro clr_sensor
 CBI PORT@0
.endmacro

.macro sensor_input
 CBI DDR@0
.endmacro

.macro sensor_output
 SBI DDR@0
.endmacro

.macro skip_if_sensor
 SBIC PIN@0
.endmacro


.macro sensor_test // Выход - флаг переноса =1 если нажатие есть и =0 если нажатия нет.

 clr_sensor @0
 sensor_output @0
 nop
 nop
 nop
 SEC
 sensor_input @0
 // задержка здесь влияет на чувствительность сенсора! 
 // Чем больше задержка, тем больше нужна емкость для срабатывания сенсора.
 nop
 nop
 skip_if_sensor @0
 CLC
.endmacro

key_press:
 CLR temp
 sensor_test key_line_Y3
 ROL temp
 sensor_test key_line_Y2
 ROL temp
 sensor_test key_line_Y1
 ROL temp
 sensor_test key_line_Y0
 ROL temp
 sensor_test key_line_X2
 ROL temp
 sensor_test key_line_X1
 ROL temp
 sensor_test key_line_X0
 ROL temp

// По таблице определить какая клавиша нажата.
 CLR tempi
 LDI ZH, high(keys_table*2)
 LDI ZL, low (keys_table*2)

kp_loop:
 LPM ACCUM, Z+
 CP temp, ACCUM // Eсли комбинация сенсоров совпадает - нашли нажатую кнопку
 BREQ kp_exit   // Прерываем цикл если нашли нажатую кнопку
 inc tempi
 CPI tempi, 12
 BRLO kp_loop   // если tempi<12 крутимся в цикле
kp_exit:        // на выходе имеем tempi=12 если нет нажатых кнопок, tempi = 0..11 если нажаты.
 mov ACCUM, tempi
ret


keys_table:
// Таблица допустимых состояний клавиатуры:

//     0YYYYXXX     0YYYYXXX
//     03210210     03210210
.DB	0b01000010, 0b00001001 // 0, 1
.DB	0b00001010, 0b00001100 // 2, 3
.DB	0b00010001, 0b00010010 // 4, 5
.DB	0b00010100, 0b00100001 // 6, 7
.DB	0b00100010, 0b00100100 // 8, 9
.DB	0b01000001, 0b01000100 // start, stop
