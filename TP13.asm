.equ DDRA=0x01
.equ PORTA = 0x02

.equ DDRC=0x07
.equ PORTC=0x08
.equ PINC=0x06

.equ spl=0x3D
.equ sph=0x3E

.org 0x0000
	jmp setup

.org 0x0080

codeClavier: .DB 0b01000001, 0b10001000, 0b01001000, 0b00101000, 0b10000100, 0b01000100, 0b00100100, 0b10000010, 0b01000010, 0b00100010, 0b10000001, 0b00100001, 0b00010001, 0b00010010, 0b00010100, 0b00011000
codeAff: .DB 0b01111110, 0b00001100, 0b00110111, 0b00011111, 0b01001101, 0b01011011, 0b01111011, 0b00001110, 0b01111111, 0x5f, 0b01101111, 0b01111001, 0b00110001, 0b00111101, 0b01110011, 0b01100011

setup:
	ldi r16,0x21
	ldi r17,0xff
	out spl,r17
	out sph,r16
	
	ldi r16,0xFf
	out DDRA,r16
	
	ldi r16,0xF0
	out DDRC,r16
	
	ldi r16,0x01
	out PORTA,r16
	
debut:
	CLR r20
	ldi R21,1
boucle: 
	ldi R30,low(codeClavier<<1)
	ldi R31,high(codeClavier<<1)
	ADD R30,R21
	LPM R17,Z
	OUT PORTC,r17
	
	
	nop
	nop
	nop
	nop
	IN r18,PINC
	; AND r18,r17
	CP r18,r17
	BRNE fin
	MOV r20,R21
	CALL affiche
fin:
	INC R21
	CPI R21,17
	BRNE boucle
jmp debut
	
affiche:
	LDI R30,low(codeAff<<1)
	LDI R31,high(codeAff<<1)
	ADD R30,r20
	LPM r17,Z
	ldi r19,0x80
	out PORTC,r19
	out PORTA,r17
	call Pause
ret
	
Pause:
	ldi r24,8
tempo:
	subi r22,1
	sbci r23,0
	sbci r24,0
	brcc tempo
	ret