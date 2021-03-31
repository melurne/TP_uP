.equ DDRA=0x01
.equ PORTA = 0x02

.equ DDRB = 0x04
.equ PORTB = 0x05

.equ DDRC=0x07
.equ PORTC=0x08

.equ OCRA = 0x47
.equ TCCRA = 0x44
.equ TCCRB = 0x45
.equ TIMSK = 0x6E

.org 0x0000
	jmp setup

.org 0x002A
	JMP IRQ_timer	

.org 0x0080

codeAff: .DB 0b01111110, 0b00001100, 0b00110111, 0b00011111, 0b01001101, 0b01011011, 0b01111011, 0b00001110, 0b01111111, 0x5f, 0b01101111, 0b01111001, 0b00110001, 0b00111101, 0b01110011, 0b01100011

setup:
    ; 	DDRA@IO <- 0xFF
    LDI R16,0xFF
    OUT DDRA,R16

    ; 	PORTA@IO <- 0x00
    LDI R16,0x00
    OUT PORTA,R16

    ; 	DDRC@IO <- 0xE0
    LDI R16,0xE0
    OUT DDRC,R16

    ; 	PORTC@IO <- 0x00
    LDI R16,0x00
    OUT PORTC,R16


    ; 	OCRA <- 40
    LDI R16,40
    STS OCRA,R16

    ; 	TCCRA <- 0x02
    LDI R16,0x02
    STS TCCRA,R16

    ; 	TCCRB <- 0x05
    LDI R16,0x05
    STS TCCRB,R16

    ; 	TIMSK <- 0x02
    LDI R16,0x02
    STS TIMSK,R16


	sei

	CLR r18
    ; 	r23 <- 0x20
    LDI R16,0x20
    MOV R23,R16


	CLR r19
	CLR r20
	CLR r21
	CLR r22
    ; 	portA@IO <- 0xFF
    LDI R16,0xFF
    OUT portA,R16


boucle:

	CALL affiche
	jmp boucle

IRQ_timer:
	INC r18
    ; 	si (r18 >= 100) alors saut increm
    MOV R16,R18
    PUSH R16
    LDI R16,100
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
    JMP increm
eti2:

    ; 		si (r23 == 0x80) alors saut etc80
    MOV R16,R23
    PUSH R16
    LDI R16,0x80
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
    JMP etc80
eti5:

    ; 			si (r23 == 0x40) alors saut etc40
    MOV R16,R23
    PUSH R16
    LDI R16,0x40
    POP R17
    CP R17,R16
    BREQ eti6
    CLR R16
    RJMP eti7
eti6:
    LDI R16,0x01
eti7:
    TST R16
    BREQ eti8
    JMP etc40
eti8:


    ; 				r23 <- 0x40
    LDI R16,0x40
    MOV R23,R16

    ; 				PORTC@IO <- r23
    MOV R16,R23
    OUT PORTC,R16

				MOV r19,r21
				reti
		etc40:
    ; 			r23 <- 0x80
    LDI R16,0x80
    MOV R23,R16

    ; 			PORTC@IO <- r23
    MOV R16,R23
    OUT PORTC,R16

			MOV r19,r22
			reti

		etc80:
    ; 			r23 <- 0x20
    LDI R16,0x20
    MOV R23,R16

    ; 			PORTC@IO <- r23
    MOV R16,R23
    OUT PORTC,R16

			MOV r19,r20
			reti
	increm:
	CLR r18
    ; 	si (r20 >= 9) alors saut res
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
    JMP res
eti11:

		INC r20

		reti
	res:
		CLR r20
		INC r21
    ; 	si (r21 <= 9) alors saut end
    MOV R16,R21
    PUSH R16
    LDI R16,9
    POP R17
    CP R17,R16
    BREQ eti12
    BRLO eti12
    CLR R16
    RJMP eti13
eti12:
    LDI R16,0x01
eti13:
    TST R16
    BREQ eti14
    JMP end
eti14:

		CLR r21
		INC r22
    ; 	si (r22 <= 9) alors saut end
    MOV R16,R22
    PUSH R16
    LDI R16,9
    POP R17
    CP R17,R16
    BREQ eti15
    BRLO eti15
    CLR R16
    RJMP eti16
eti15:
    LDI R16,0x01
eti16:
    TST R16
    BREQ eti17
    JMP end
eti17:

		CLR r20
		CLR r21
		CLR r22
	end:	
	reti

affiche:
    ; 	PORTA@IO <- codeAff@ROM[r19]
    MOV R16,R19
    LDI R30,low(codeAff<<1)
    LDI R31,high(codeAff<<1)
    CLR R17
    ADD R30,R16
    ADC R31,R17
    LPM R16,Z
    OUT PORTA,R16

	ret

