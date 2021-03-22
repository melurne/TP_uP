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
    ; 	PORTA@IO <- 0xFF
    LDI R16,0xFF
    OUT PORTA,R16

    ; 	PORTB@IO <- 0x00
    LDI R16,0x00
    OUT PORTB,R16

	RETI

IRQ_antiH:
    ; 	PORTA@IO <- 0x00
    LDI R16,0x00
    OUT PORTA,R16

    ; 	PORTB@IO <- 0xFF
    LDI R16,0xFF
    OUT PORTB,R16

	reti
