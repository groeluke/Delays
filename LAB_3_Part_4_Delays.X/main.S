    ; Luke Groesbeck
    ; RCET3373
    ; LAB 3
    ; https://github.com/groeluke/Delays/tree/main/LAB_3_Part_3_Delays.X
    
; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

; config statements should precede project file includes.
#include <xc.inc>

; Reset Vector at 0000h. Execution starts here after reset.
PSECT resetVect,class=CODE,delta=2
ResetVector: 
    goto Setup


; Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2
 
Setup:
    ; add device setup here
    
    ;         Bank 0
    BCF 0x03,6  ;Set Bank 0
    BCF 0x03,5  ;Set Bank 0
    CLRF 0x06   ;Setting PortB on reset low
    MOVLW 0x30  ;Load 0 for start up
    MOVWF 0x07  ;Set PortC to display 0
    
    ;         Bank 1
    BCF 0x03,6  ;Set Bank 1
    BSF 0x03,5  ;Set Bank 1
    CLRF 0x86   ;Set PortB as an output TRISB
    CLRF 0x87   ;Set PortC as an Output TRISC
    
    ;         Bank 2
    BSF 0x03,6  ;Set Bank 2
    BCF 0x03,5  ;Set Bank 2
    BSF 0x09,1  ;Setting Bit 1 High for CM2CON1
    
    ;         Bank 3
    BSF 0x03,6  ;Set Bank 3
    BSF 0x03,5  ;Set Bank 3
    CLRF 0x89   ;Setting the I/O to digital ANSELH
    
    ;Reset to Bank 0
    BCF 0x03,6  ;Set Bank 0
    BCF 0x03,5  ;Set Bank 0
    
    GOTO Main
    
    maincount EQU 0x20 ;use data memory address 0x20 as an 8-bit loop counter  
    outcount EQU 0x21 ;use data memory address 0x21 as an 8-bit loop counter
    incount EQU 0x22 ;use data memory address 0x22 as an 8-bit loop counter
 
    Main:
        MOVLW 0x01         ;1 Tcy increment by 1
        XORWF 0x06,1       ;1 Tcy inverter 1
	
	MOVLW 0x05         ;1 Tcy toggle the display 5 and 0
	XORWF 0x07,1       ;1 Tcy send 5 to portc to display
	
	MOVLW 0x0A         ;1 Tcy move W=10 to count
        MOVWF maincount    ;1 Tcy make count equal 10
	NOP                ;1 Tcy
	NOP                ;1 Tcy
	NOP                ;1 Tcy
	
	MainDelayLoop:     ;MainDelay Loop 
	MOVLW 0x63         ;1 Tcy move W=99 to count
        MOVWF outcount     ;1 Tcy make count equal 99
        
	OutDelayLoop:      ;OutDelay Loop
        MOVLW 0xA7         ;1 Tcy move W=167 to count
        MOVWF incount      ;1 Tcy make count equal 167
	
        InDelayLoop:       ;InDelay loop Tcy when count is 167        
        DECFSZ incount,1   ;1 Tcy if not zero, 2 Tcy if zero
        GOTO InDelayLoop   ;2 Tcy delay runs 167 times
	
	DECFSZ outcount,1  ;1 Tcy if not zero, 2 Tcy if zero
	GOTO OutDelayLoop  ;2 Tcy delay runs 99 times before skiping
	
	DECFSZ maincount,1 ;1 Tcy if not zero, 2 Tcy if zero
	Goto MainDelayLoop ;2 Tcy delay runs 10 times before skiping

    GOTO Main            ;2Tcy
    
    End