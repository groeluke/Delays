    ; Luke Groesbeck
    ; RCET3373
    ; LAB 3
    ; https://github.com/groeluke/Delays/tree/main/LAB_3_Part_4_Delays.X
    
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
	MOVLW 0x05         ;1 Tcy toggle the display 5 and 0
	XORWF 0x07,1       ;1 Tcy send 5 to PortC to display

	CALL LongDelay     ;2 Tcy CALL does the whole delay, then returns here

    GOTO Main            ;2 Tcy

    LongDelay:
	MOVLW 0x4F         ;1 Tcy move W 79 to count
        MOVWF maincount     ;1 Tcy make count 79

    MainDelayLoop:
	MOVLW 0x17         ;1 Tcy move W 23 to count
        MOVWF outcount     ;1 Tcy make count 23

    OutDelayLoop:
        CALL ShortDelay    ;2 Tcy CALL, runs ShortDelay, then returns here

	DECFSZ outcount,1  ;1 Tcy if not zero, 2 Tcy if zero
	GOTO OutDelayLoop  ;2 Tcy runs 23 times before skipping

	DECFSZ maincount,1  ;1 Tcy if not zero, 2 Tcy if zero
	GOTO MainDelayLoop  ;2 Tcy runs 79 times before skipping

	RETURN             ;2 Tcy back to Main

    ShortDelay:
        MOVLW 0x59         ;1 Tcy move W 89 to count
        MOVWF incount      ;1 Tcy make count 89

    InDelayLoop:
        DECFSZ incount,1   ;1 Tcy if not zero, 2 Tcy if zero
        GOTO InDelayLoop   ;2 Tcy runs 89 times before skipping

	RETURN             ;2 Tcy back to OutDelayLoop
    
    End