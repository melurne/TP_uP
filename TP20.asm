.equ PINA = 0x00
.equ DDRA = 0x01
.equ PORTA = 0x02

.equ WDTCSR = 0x60

.org 0x0000
	jmp debut

.org 0x0080

debut:
    ; 	DDRA@IO <- 0x01
    LDI R16,0x01
    OUT DDRA,R16

    ; 	PORTA@IO <- 0x00
    LDI R16,0x00
    OUT PORTA,R16


    ; 	WDTCSR <- 0x10
    LDI R16,0x10
    STS WDTCSR,R16

    ; 	WDTCSR <- 0x0E
    LDI R16,0x0E
    STS WDTCSR,R16

	sei

boucle:
    ; 	si (PINA@IO & 0x02) == 0 alors saut boucle
    IN R16,PINA
    ANDI R16,0x02
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
    JMP boucle
eti2:


    ; 	PORTA@IO <- 0x01
    LDI R16,0x01
    OUT PORTA,R16

	wdr
	jmp boucle

