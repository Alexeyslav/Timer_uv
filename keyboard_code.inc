// ������������ ���������� ���������� � ��������� �����������.
//                  /------- ��� �����
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
 SBIS PIN@0
.endmacro


.macro sensor_test // ����� - ���� �������� =1 ���� ������� ���� � =0 ���� ������� ���.

 clr_sensor @0
 sensor_output @0
 nop
 nop
 nop
 SEC
 sensor_input @0
 // �������� ����� ������ �� ���������������� �������! 
 // ��� ������ ��������, ��� ������ ����� ������� ��� ������������ �������.
 nop
 nop
 skip_if_sensor @0
 ret
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

// �� ������� ���������� ����� ������� ������.
 CLR tempi
 LDI ZH, high(keys_table*2)
 LDI ZL, low (keys_table*2)

kp_loop:
 LPM ACCUM, Z+
 CP temp, ACCUM // E��� ���������� �������� ��������� - ����� ������� ������
 BREQ kp_exit   // ��������� ���� ���� ����� ������� ������
 inc tempi
 CPI tempi, 12
 BRLO kp_loop   // ���� tempi<12 �������� � �����
kp_exit:        // �� ������ ����� tempi=12 ���� ��� ������� ������, tempi = 0..11 ���� ������.
 mov ACCUM, tempi
ret


keys_table:
// ������� ���������� ��������� ����������:

//     0YYYYXXX     0YYYYXXX
//     03210210     03210210
//.DB	0xb01000010, 0xb00001001 // 0, 1
//.DB	0xb00001010, 0xb00001100 // 2, 3
//.DB	0xb00010001, 0xb00010010 // 4, 5
//.DB	0xb00010100, 0xb00100001 // 6, 7
//.DB	0xb00100010, 0xb00100100 // 8, 9
//.DB	0xb01000001, 0xb01000100 // start, stop
// �����-��������!!! ���������� ���� �������� �� �������� �������� �����! �� ���� ����� ��������� ��� ������� ����� � ������� �� 16-������ ������, ����� ��� ��� �������� � �������� �����.
.DB	0x42, 0x09 // 0, 1
.DB	0x0A, 0x0C // 2, 3
.DB	0x11, 0x12 // 4, 5
.DB	0x14, 0x21 // 6, 7
.DB	0x22, 0x24 // 8, 9
.DB	0x41, 0x44 // start, stop