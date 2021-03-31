.equ DDRA=0x01
.equ PORTA = 0x02

.equ DDRB = 0x04
.equ PORTB = 0x05

.equ DDRD = 0x0A
.equ PORTD = 0x0B

.equ EIMSK = 0x3D
.equ EICRA = 0x69

.equ WDTCSR = 0x60

.org 0x0000
	jmp setup

.org 0x0002
	JMP IRQ_plus10

.org 0x0004
	JMP IRQ_plus1

.org 0x0006
	JMP IRQ_marche

.org 0x0008
	JMP IRQ_arret	


.org 0x0018
	JMP IRQ_WD

.org 0x0080

codeAff: .DB 0b01111110, 0b00001100, 0b00110111, 0b00011111, 0b01001101, 0b01011011, 0b01111011, 0b00001110, 0b01111111, 0x5f, 0b01101111, 0b01111001, 0b00110001, 0b00111101, 0b01110011, 0b01100011

setup:
    ; 	DDRA@IO <- 0xFF
    LDI R16,0xFF
    OUT DDRA,R16

    ; 	PORTA@IO <- 0x00
    LDI R16,0x00
    OUT PORTA,R16

    ; 	DDRB@IO <- 0xFF
    LDI R16,0xFF
    OUT DDRB,R16

    ; 	PORTB@IO <- 0x00
    LDI R16,0x00
    OUT PORTB,R16

    ; 	DDRD@IO <- 0x80
    LDI R16,0x80
    OUT DDRD,R16

    ; 	PORTD@IO <- 0x00
    LDI R16,0x00
    OUT PORTD,R16


    ; 	EIMSK <- 0x0F
    LDI R16,0x0F
    STS EIMSK,R16

    ; 	EICRA <- 0xFF
    LDI R16,0xFF
    STS EICRA,R16

	sei

	CLR r20
	CLR r21
    ; 	portA@IO <- 0xFF
    LDI R16,0xFF
    OUT portA,R16


boucle:
	CALL affiche
	jmp boucle

IRQ_WD:
    ; 	si (r20 == 0) alors saut res
    MOV R16,R20
    PUSH R16
    LDI R16,0
    POP R17
    CP R17,R16
    BREQ eti0
    CLR R16
    RJMP eti1
eti0:
    LDI R16,0x01
eti1:
    TST R16
    BREQ eti2
    JMP res
eti2:

		DEC r20
		reti
	res:
    ; 		si (r21 == 0) saut reset
    MOV R16,R21
    PUSH R16
    LDI R16,0
    POP R17
    CP R17,R16
    BREQ eti3
    CLR R16
    RJMP eti4
eti3:
    LDI R16,0x01
eti4:
    TST R16
    BREQ eti5
    JMP reset
eti5:

    ; 		r20 <- 9
    LDI R16,9
    MOV R20,R16

		DEC r21
		reti
	reset:
		CLR r21
		CLR r20
    ; 		WDTCSR <- 0x10
    LDI R16,0x10
    STS WDTCSR,R16

    ; 		WDTCSR <- 0x00
    LDI R16,0x00
    STS WDTCSR,R16

    ; 		PORTD@IO <- 0x00
    LDI R16,0x00
    OUT PORTD,R16

	end:	
	reti

IRQ_plus10:
    ; 	si (r21 >= 9) alors saut end10
    MOV R16,R21
    PUSH R16
    LDI R16,9
    POP R17
    CP R17,R16
    BRSH eti6
    CLR R16
    RJMP eti7
eti6:
    LDI R16,0x01
eti7:
    TST R16
    BREQ eti8
    JMP end10
eti8:

	INC r21
	end10:
	reti

IRQ_plus1:
    ; 	si (r20 >= 9) alors saut res1
    MOV R16,R20
    PUSH R16
    LDI R16,9
    POP R17
    CP R17,R16
    BRSH eti9
    CLR R16
    RJMP eti10
eti9:
    LDI R16,0x01
eti10:
    TST R16
    BREQ eti11
    JMP res1
eti11:

		INC r20
		reti
	res1:
    ; 	si (r21 >= 9) alors saut end1
    MOV R16,R21
    PUSH R16
    LDI R16,9
    POP R17
    CP R17,R16
    BRSH eti12
    CLR R16
    RJMP eti13
eti12:
    LDI R16,0x01
eti13:
    TST R16
    BREQ eti14
    JMP end1
eti14:

		CLR r20
		INC r21
	end1:	
	reti


IRQ_marche:
    ; 	WDTCSR <- 0x10
    LDI R16,0x10
    STS WDTCSR,R16

    ; 	WDTCSR <- 0b01000110
    LDI R16,0b01000110
    STS WDTCSR,R16

    ; 	PORTD@IO <- 0x80
    LDI R16,0x80
    OUT PORTD,R16

	reti

IRQ_arret:
    ; 	WDTCSR <- 0x10
    LDI R16,0x10
    STS WDTCSR,R16

    ; 	WDTCSR <- 0x00
    LDI R16,0x00
    STS WDTCSR,R16

    ; 	PORTD@IO <- 0x00
    LDI R16,0x00
    OUT PORTD,R16

	reti

affiche:
    ; 	PORTB@IO <- codeAff@ROM[r20]
    MOV R16,R20
    LDI R30,low(codeAff<<1)
    LDI R31,high(codeAff<<1)
    CLR R17
    ADD R30,R16
    ADC R31,R17
    LPM R16,Z
    OUT PORTB,R16

    ; 	PORTA@IO <- codeAff@ROM[r21]
    MOV R16,R21
    LDI R30,low(codeAff<<1)
    LDI R31,high(codeAff<<1)
    CLR R17
    ADD R30,R16
    ADC R31,R17
    LPM R16,Z
    OUT PORTA,R16

	ret

