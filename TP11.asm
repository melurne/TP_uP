.equ DDRA=0x01
.equ PORTA = 0x02

.equ DDRB = 0x04
.equ PORTB = 0x05

.org 0x0000
	jmp debut

.org 0x0080

debut:
	ldi r16,0xff
	out DDRA,r16
	out DDRB,r16
	ldi r16,0x01
	CLR r20
	CLR r17
boucleA:
	out PORTB,r17
	out PORTA,r16
	lsl r16
	INC r20
	CALL Pause
	CPI r20,8
	BRNE boucleA
ldi r16,0b10000000
CLR r20
boucleB:
	out PORTA,r17
	out PORTB,r16
	lsr r16
	INC r20
	CALL Pause
	CPI r20,8
	BRNE boucleB
jmp debut

Pause:
	ldi r24,8
tempo:
	subi r22,1
	sbci r23,0
	sbci r24,0
	brcc tempo
	ret