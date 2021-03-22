.equ DDRA=0x01
.equ PORTA = 0x02

;.equ DDRC=0x07
;.equ PORTC=0x08
;.equ PINC=0x06

.equ WDTCSR = 0x60

.org 0x0000
	jmp setup

.org 0x0018
	JMP IRQ_WD

.org 0x0080



codeAff: .DB 0b01111110, 0b00001100, 0b00110111, 0b00011111, 0b01001101, 0b01011011, 0b01111011, 0b00001110, 0b01111111, 0x5f, 0b01101111, 0b01111001, 0b00110001, 0b00111101, 0b01110011, 0b01100011

setup:
    ; 	DDRA@IO <- 0xFF
    LDI R16,0xFF
    OUT DDRA,R16

	;DDRC@IO <- 0xF0
    ; 	PORTA@IO <- 0x00
    LDI R16,0x00
    OUT PORTA,R16


    ; 	WDTCSR <- 0x10
    LDI R16,0x10
    STS WDTCSR,R16

    ; 	WDTCSR <- 0b01000110
    LDI R16,0b01000110
    STS WDTCSR,R16

	sei

	CLR r20
    ; 	portA@IO <- 0xFF
    LDI R16,0xFF
    OUT portA,R16


boucle:
	;INC r20
	CALL affiche
	jmp boucle

IRQ_WD:
    ; 	si (r20 >= 15) alors saut res
    MOV R16,R20
    PUSH R16
    LDI R16,15
    POP R17
    CP R17,R16
    BRSH eti0
    CLR R16
    RJMP eti1
eti0:
    LDI R16,0x01
eti1:
    TST R16
    BREQ eti2
    JMP res
eti2:

		INC r20
		reti
	res:
		CLR r20
	reti

affiche:
    ; 	PORTA@IO <- codeAff[r20]
    MOV R16,R20
    LDI R26,low(codeAff)
    LDI R27,high(codeAff)
    CLR R17
    ADD R26,R16
    ADC R27,R17
    LD R16,X
    OUT PORTA,R16

	ret

affiche_:
	LDI R30,low(codeAff<<1)
	LDI R31,high(codeAff<<1)
	ADD R30,r20
	LPM r19,Z
	;ldi r21,0x80
	;out PORTC,r21
	out PORTA,r19
	;call Pause
ret

Pause:
	ldi r24,8
tempo:
	subi r22,1
	sbci r23,0
	sbci r24,0
	brcc tempo
	ret
