; CECYT 9 JUAN DE DIOS BATIZ.
;
; PRACTICA 0';.
; MANEJO DE UN LED OSCILANDO A 1 Hz.
;
; EQUIPO: 4 	GRUPO: 6IM1.
;
; INTEGRANTES:
; 
; FECHA DE ENTREGA DEL REPORTE:
;
; [ Descripción del programa ]
;
;--------------------------------------------------------------------------------------------------
 List 	p=16f877A;
 
 #include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC"; Cambia la direccion
 ;#include "C:\Program Files\Microchip\MPASM Suite\P16F877A.INC";

 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _XT_OSC & _WRT_OFF & _LVP_OFF & _CPD_OFF;
;--------------------------------------------------------------------------------------------------
;
; Fosc = 4 MHz.
; Ciclo de trabajo del PIC = (1/fosc)*4 = 1 ï¿½s.
; T int =(256-tmr0)*(P)*((1/4000000)*4) = 1 ms. // Tiempo de interrupciï¿½n.
; tmr0=131, P=8.
; frec int = 1/ t int = 1 KHz.
;----------------------------------------------------------------------------------------------------
;
;Def. de variables del programa en RAM.

resp_w 		equ 0x20;
resp_status equ 0x21;
res_pclath 	equ 0x22;
res_fsr 	equ 0x23;
presc_1 	equ 0x24; .001 100 5
presc_2 	equ 0x25; t int = t intb * presc_1 * presc_2


;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.133;
;---------------------------------------------------------------------------------------------------
; Def. de Ptos. I/0.

; Puerto A.
Sin_uso_RA0 equ .0;
Sin_uso_RA1	equ .1;
Sin_uso_RA2 equ .2;
Sin_uso_RA3 equ .3;
Sin_uso_RA4 equ .4;
Sin_uso_RA5 equ .5;

progA equ b'111111';Def. la config. de los bits del pto. A.

;Puerto B.
Sin_uso_RB0 equ .0;
Sin_uso_RB1 equ .1;
Sin_uso_RB2 equ .2;
Sin_uso_RB3 equ .3;
Sin_uso_RB4 equ .4;
Sin_uso_RB5 equ .5;
Sin_uso_RB6 equ .6;
Sin_uso_RB7 equ .7;

progB equ b'11111111'; // Programacion inicial del puerto B.

;Puerto C.
Sin_uso_RC0 equ .0;
Sin_uso_RC1 equ .1;
Sin_uso_RC2 equ .2;
Sin_uso_RC3 equ .3;
Sin_uso_RC4 equ .4;
Sin_uso_RC5 equ .5;
Sin_uso_RC6 equ .6;
Sin_uso_RC7 equ .7;

progC equ b'11111111'; // Programacion inicial del puerto C.

;Puerto D.
Sin_uso_RD0 equ .0;
Sin_uso_RD1 equ .1;
Sin_uso_RD2 equ .2;
Sin_uso_RD3 equ .3;
Sin_uso_RD4 equ .4;
Sin_uso_RD5 equ .5;
Sin_uso_RD6 equ .6;
Sin_uso_RD7 equ .7;

progD equ b'11111111'; // Programacion inicial del puerto D donde los bits RD0-RD3 serán empleados
					;	  como salidas.
; Puerto E.
Sin_uso_RE0 equ .0;
Sin_uso_RE1 equ .1;
Sin_uso_RE2	equ .2;

progE equ b'111';
;-------------------------------------------------------------------------------------------------
			;=================
			;== Vector Reset ==
			;=================
			org 0x0000;
vec_reset	clrf pclath;
			goto prog_prin;
;-------------------------------------------------------------------------------------------------

			;=============================
			;== Subrutina de Interrupciones ==
			;=============================
			org 0x0004;
vec_int 	movwf resp_w;resp. esl estado del reg. w.
			movf status,w;
			movwf resp_status;resp. banderas de la alu.
			clrf status;
			movf pclath,w;
			movwf res_pclath;
			clrf pclath;
			movf fsr,w;
			movwf res_fsr;

			btfsc intcon,t0if;
			call rutina_int;

sal_int 	movf res_fsr,w;
			movwf fsr;
			movf res_pclath,w;
			movwf pclath;
			movf resp_status,w;
			movwf status;
			movf resp_w,w;
			movlw Tmb;
			movwf tmr0;
			
			retfie;
;--------------------------------------------------------------------------------------------------
			;================================
			;== Subrutina de Ini. de Reg. del Pic ==
			;================================

prog_ini 	bsf status,RP0; Ponte en el banco 1 de ram.
			movlw 0x82;
 			movwf option_reg ^0x80;
			movlw progA;
			movwf trisa ^0x80;
			movlw progb;
			movwf trisB ^0x80;
			movlw progC;
			movwf trisc ^0x80;
			movlw progD;
			movwf trisd ^0x80;
			movlw progE;
			movwf trise ^0x80;
			movlw 0x06;
			movwf adcon1 ^0x80;
			
			bcf status,RP0; Ponte en el banco 0 de ram.
			bcf status,RP1; Ponte en el banco 0 de ram.	
			
			movlw 0xa0;
			movwf intcon;
			movlw Tmb;
			movwf tmr0;
			
			clrf porta;
			clrf portb;
			clrf portc;
			clrf portd;
			clrf porte;
			
			return;
;--------------------------------------------------------------------------------------------------
			;=================================
			;== Subrutina de Interrupciones ==
			;=================================
			
rutina_int 	incf presc_1,f;

			movlw .100;
			xorwf presc_1,w;
			btfss status,z;
			goto sal_rutint;
			goto sig_int;

sig_int 	clrf presc_1;
			incf presc_2,f;
			movlw .10;
			xorwf presc_2,w;
			btfss status,z;
			goto sal_rutint;
			clrf presc_1;
			clrf presc_2;

sal_rutint 	bcf intcon,t0if;
			
			return;

;-------------------------------------------------------------------------------------------------
			;=====================
			;== Programa principal ==
			;=====================

prog_prin 	call prog_ini;

Loop_prin 	
			goto Loop_prin;
;-------------------------------------------------------------------------------------------------
			end