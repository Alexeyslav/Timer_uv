Timer_countdown: // реализаци€ отсчета "-1" сек. 
                 // »спользуютс€ €чейки timer_sec, timer_sec10, timer_min, timer_min10.

ret

Timer_visualize: // отображает значение счетчика в область пам€ти вывода(в €чейки led_digits) преобразовав в сегменты.
LDS ACCUM, timer_min10 // берем из €чейки пам€ти первую цифру
rcall conv_numtosegment
STS led_digits, ACCUM

LDS ACCUM, timer_min // берем из €чейки пам€ти вторую цифру
rcall conv_numtosegment
ORI ACCUM, led_segment_h  // «десь нужна разделительна€ точка!
STS led_digits+1, ACCUM

LDS ACCUM, timer_sec10 // берем из €чейки пам€ти третью цифру
rcall conv_numtosegment
STS led_digits+2, ACCUM

LDS ACCUM, timer_sec // берем из €чейки пам€ти четвертую цифру
rcall conv_numtosegment
STS led_digits+3, ACCUM
ret
