.equ DDRA=0x01
.equ PORTA = 0x02

.equ DDRC=0x07
.equ PORTC=0x08

.org 0x0000
	jmp setup

.org 0x0080

setup:
	ldi r16,0xff
	out DDRC,r16
	ldi r16,0x80
	out PORTC,r16
	ldi r16,0x7f
	out DDRA,r16
	codeAff: .DB 0b01111110, 0b00001100, 0b00110111, 0b00011111, 0b01001101, 0b01011011, 0b01111011, 0b00001110, 0b01111111, 0x5f, 0b01101111, 0b01111001, 0b00110001, 0b00111101, 0b01110011, 0b01100011
debut:
	CLR r20
	
boucle:
	LDI R30,low(codeAff<<1)
	LDI R31,high(codeAff<<1)
	ADD R30,r20
	LPM r17,Z
	out PORTA,r17
	CALL Pause
	INC r20
	CPI r20,16
	BRNE boucle
jmp debut
	
	
Pause:
	ldi r24,8
tempo:
	subi r22,1
	sbci r23,0
	sbci r24,0
	brcc tempo
	ret
