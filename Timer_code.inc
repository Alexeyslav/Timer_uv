Timer_countdown: // ���������� ������� "-1" ���. 
                 // ������������ ������ timer_sec, timer_sec10, timer_min, timer_min10.

ret

Timer_visualize: // ���������� �������� �������� � ������� ������ ������(� ������ led_digits) ������������ � ��������.
LDS ACCUM, timer_min10 // ����� �� ������ ������ ������ �����
rcall conv_numtosegment
STS led_digits, ACCUM

LDS ACCUM, timer_min // ����� �� ������ ������ ������ �����
rcall conv_numtosegment
ORI ACCUM, led_segment_h  // ����� ����� �������������� �����!
STS led_digits+1, ACCUM

LDS ACCUM, timer_sec10 // ����� �� ������ ������ ������ �����
rcall conv_numtosegment
STS led_digits+2, ACCUM

LDS ACCUM, timer_sec // ����� �� ������ ������ ��������� �����
rcall conv_numtosegment
STS led_digits+3, ACCUM
ret
