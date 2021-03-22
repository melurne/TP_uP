.equ DDRA = 0x01
.equ PORTA = 0x02

.equ DDRB = 0x04
.equ PORTB = 0x05

.equ DDRD = 0x0A
.equ PORTD = 0x0B

.equ EIMSK = 0x3D
.equ EICRA = 0x69

.org 0x0000
	JMP debut

; vecteur interupt INT0
.org 0x0002
	JMP IRQ_H
; vecteur interupt INT1
.org 0x0004
	JMP IRQ_antiH

.org 0x0080

debut:
    ; 	DDRA@IO <- 0xFF
    LDI R16,0xFF
    OUT DDRA,R16

    ; 	DDRB@IO <- 0xFF
    LDI R16,0xFF
    OUT DDRB,R16


    ; 	EIMSK <- 0x03
    LDI R16,0x03
    STS EIMSK,R16

    ; 	EICRA <- 0x0F
    LDI R16,0x0F
    STS EICRA,R16


    ; 	PORTA@IO <- 0x00
    LDI R16,0x00
    OUT PORTA,R16

    ; 	PORTB@IO <- 0x00
    LDI R16,0x00
    OUT PORTB,R16


	LDI r18,0x01
	CLR r19

	SEI

    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16


boucle:
	SLEEP
	JMP boucle

IRQ_H:
    ; 	si (r18 == 0x80) alors saut endA
    MOV R16,R18
    PUSH R16
    LDI R16,0x80
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
    JMP endA
eti2:

    ; 	si r19 == 0x01 || (r19 == 0x00 && r18 == 0x00) alors saut startH
    MOV R16,R19
    PUSH R16
    LDI R16,0x01
    POP R17
    CP R17,R16
    BREQ eti3
    CLR R16
    RJMP eti4
eti3:
    LDI R16,0x01
eti4:
    TST R16
    BRNE eti10
    MOV R16,R19
    PUSH R16
    LDI R16,0x00
    POP R17
    CP R17,R16
    BREQ eti5
    CLR R16
    RJMP eti6
eti5:
    LDI R16,0x01
eti6:
    TST R16
    BREQ eti9
    MOV R16,R18
    PUSH R16
    LDI R16,0x00
    POP R17
    CP R17,R16
    BREQ eti7
    CLR R16
    RJMP eti8
eti7:
    LDI R16,0x01
eti8:
eti9:
eti10:
    TST R16
    BREQ eti11
    JMP startH
eti11:

    ; 	si (r18 != 0) alors saut inA
    MOV R16,R18
    PUSH R16
    LDI R16,0
    POP R17
    CP R17,R16
    BRNE eti12
    CLR R16
    RJMP eti13
eti12:
    LDI R16,0x01
eti13:
    TST R16
    BREQ eti14
    JMP inA
eti14:

	;sinon
	LSR r19
    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16

	RETI

endA:
	CLR r18
	LDI r19,0x80
    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16

	RETI

startH:
	CLR r19
	LDI r18,0x01
    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16

	RETI

inA:
	LSL r18
    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

	RETI


IRQ_antiH:
    ; 	si (r19 == 0x80) alors saut endB
    MOV R16,R19
    PUSH R16
    LDI R16,0x80
    POP R17
    CP R17,R16
    BREQ eti15
    CLR R16
    RJMP eti16
eti15:
    LDI R16,0x01
eti16:
    TST R16
    BREQ eti17
    JMP endB
eti17:

    ; 	si r18 == 0x01 || (r19 == 0x00 && r18 == 0x00) alors saut startAH
    MOV R16,R18
    PUSH R16
    LDI R16,0x01
    POP R17
    CP R17,R16
    BREQ eti18
    CLR R16
    RJMP eti19
eti18:
    LDI R16,0x01
eti19:
    TST R16
    BRNE eti25
    MOV R16,R19
    PUSH R16
    LDI R16,0x00
    POP R17
    CP R17,R16
    BREQ eti20
    CLR R16
    RJMP eti21
eti20:
    LDI R16,0x01
eti21:
    TST R16
    BREQ eti24
    MOV R16,R18
    PUSH R16
    LDI R16,0x00
    POP R17
    CP R17,R16
    BREQ eti22
    CLR R16
    RJMP eti23
eti22:
    LDI R16,0x01
eti23:
eti24:
eti25:
    TST R16
    BREQ eti26
    JMP startAH
eti26:

    ; 	si (r18 != 0) alors saut inB
    MOV R16,R18
    PUSH R16
    LDI R16,0
    POP R17
    CP R17,R16
    BRNE eti27
    CLR R16
    RJMP eti28
eti27:
    LDI R16,0x01
eti28:
    TST R16
    BREQ eti29
    JMP inB
eti29:

	;sinon
	LSL r19
    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16

	RETI

endB:
	CLR r19
	LDI r18,0x80
    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16

	RETI

startAH:
	CLR r18
	LDI r19,0x01
    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

    ; 	PORTB@IO <- r19
    MOV R16,R19
    OUT PORTB,R16

	RETI

inB:
	LSR r18
    ; 	PORTA@IO <- r18
    MOV R16,R18
    OUT PORTA,R16

	RETI
