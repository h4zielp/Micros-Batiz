; CECYT 9 JUAN DE DIOS BATIZ.
;
; PRACTICA 0';.
; MANEJO DE UN LED OSCILANDO A 1 Hz.
;
; EQUIPO: 	GRUPO: 6IMX.
;
; INTEGRANTES:
; 1.-RAMIREZ PACHECO.
; 2.-RAMIREZ ESTRADA.
; 3.-VEGA ALTAMIRANO.
; 4.-YASKAWA SANCHEZ.
;
; FECHA DE ENTREGA DEL REPORTE.
;
; ESTE PROGRAMA CONTROLA UN LED HACIENDOLO OSCILAR A UNA
; FRECUENCIA DE UN SEGUNDO, UTILIZANDO
; INTERRUPCIONES CON EL TMR0.
;
;--------------------------------------------------------------------------------------------------
 List 	p=16f877A;
 
 ;#include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC";
 #include "C:\Program Files\Microchip\MPASM Suite\P16F877A.INC";

 
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _XT_OSC & _WRT_OFF & _LVP_OFF & _CPD_OFF;
;--------------------------------------------------------------------------------------------------
;
; Fosc = 4 MHz.
; Ciclo de trabajo del PIC = (1/fosc)*4 = 1 µs.
; T int =(256-tmr0)*(P)*((1/4000000)*4) = 1 ms. // Tiempo de interrupción.
; tmr0=131, P=8.
; frec int = 1/ t int = 1 KHz.
;----------------------------------------------------------------------------------------------------
;
;Def. de variables del programa en RAM.

resp_w 			equ 0x20;
resp_status 	equ 0x21;
res_pclath 		equ 0x22;
res_fsr 		equ 0x23;
presc_1 		equ 0x24; .001 100 5
presc_2 		equ 0x25; t int = t intb * presc_1 * presc_2
banderas 		equ 0x26;
cont_milis 		equ 0x27;

;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.131;

; banderas del registro banderas.
ban_int 		equ .0;
ban_24h			equ .1;
sin_bd2 		equ .2;
sin_bd3 		equ .3;
sin_bd4 		equ .4;
sin_bd5 		equ .5;
sin_bd6 		equ .6;
sin_bd7 		equ .7;
;---------------------------------------------------------------------------------------------------

; Def. de Ptos. I/0.

; Puerto A.
LCD_R#s	   equ .0;
LCD_E      equ .1;
Sin_UsoRA2 equ .2;
Sin_UsoRA3 equ .3;
Sin_UsoRA4 equ .4;
Sin_UsoRA5 equ .5;

progA equ b'000000';Def. la config. de los bits del pto. a.

;Puerto B.
Sin_UsoRB0 equ .0;
Sin_UsoRB1 equ .1;
Sin_UsoRB2 equ .2;
Sin_UsoRB3 equ .3;
Sin_UsoRB4 equ .4;
Sin_UsoRB5 equ .5;
Sin_UsoRB6 equ .6;
Sin_UsoRB7 equ .7;

progb equ b'11111111'; // Programación inicial del puerto B.

;Puerto C.
LCD_D0 equ .0;
LCD_D1 equ .1;
LCD_D2 equ .2;
LCD_D3 equ .3;
LCD_D4 equ .4;
LCD_D5 equ .5;
LCD_D6 equ .6;
LCD_D7 equ .7;

progc equ b'00000000'; // Programación inicial del puerto C como 
						 ;Entrada.
;Puerto D.
Sin_UsoRD0 equ .0;
Sin_UsoRD1 equ .1;
Sin_UsoRD2 equ .2;
Sin_UsoRD3 equ .3;
Sin_UsoRD4 equ .4;
Sin_UsoRD5 equ .5;
Sin_UsoRD6 equ .6;
Sin_UsoRD7 equ .7;

progD equ b'11111111';Def.

; Puerto E.
Sin_UsoRE0 equ .0;
Sin_UsoRE1 equ .1;
Led_Rojo   equ .2;

progE equ b'011';Def. la encua.
;-------------------------------------------------------------------------------------------------

			;=================
			;== Vector Reset ==
			;=================
			org 0000h;
vec_reset 	clrf pclath;

			goto prog_prin;
;-------------------------------------------------------------------------------------------------

			;=============================
			;== Subrutina de Interrupciones ==
			;=============================
			
			org 0004h;
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

			;=============================
			;== Subrutina de Interrupciones ==
			;=============================
			
rutina_int 	incf cont_milis,f;
			incf presc_1,f;

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

 			bsf banderas,ban_int;

sal_rutint 	bcf intcon,t0if;
			
			return;
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

			movlw 0xa0;
			movwf intcon;
			movlw Tmb;
			movwf tmr0;
			
			clrf banderas;
			clrf cont_milis;

			clrf portc;
			movlw 0x03;
			movwf porta;
		
			return;
			
;--------------------------------------------------------------------------------------------------
			;=====================
			;== Inicializar LCD ==
			;=====================

LCD_ini		movlw 0x38;
			call COMANDO_LCD;
			movlw 0x01;
			call COMANDO_LCD;
			movlw 0x06;
			call COMANDO_LCD;
			movlw 0x0C;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
					
			return;

;--------------------------------------------------------------------------------------------------
 
			;=====================
			;== Programa principal ==
			;=====================

prog_prin 	call prog_ini;
			call LCD_ini;

Loop_prin 	call esp_int;
			call blink_Led;
				
			call tryme;
			
			goto Loop_prin;
;--------------------------------------------------------------------------------------------------

tryme		movlw 0x84;
			call COMANDO_LCD;
			movlw 'E';
			call PRINT_LCD;
			return;

;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de HABILITACIÓN DE LCD (E) ==
			;=========================================
	
PRINT_LCD		bsf porta,LCD_R#s;
				goto CARGA;

COMANDO_LCD		bcf porta,LCD_R#s; Modo comando
CARGA			movwf portc;

				bcf porta,LCD_E;
				call RETARDO_1ms;
				bsf porta,LCD_E;

				call RETARDO_40ms; 

				return;

			;=========================================
			;== Subrutina de espera de int. de 1 segundo ==
			;=========================================
			
esp_int 	nop;
			btfss banderas,ban_int;
			goto esp_int;
			bcf banderas,ban_int;
			
			return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de oscilación del LED ==
			;=========================================
			
blink_Led	btfss porte,Led_Rojo;
			goto sec_led;
			bcf porte,Led_Rojo; Prende el led.
			return;
			
sec_led 	bsf porte,Led_Rojo; Apaga el led.
			return;


;---------------------------------------------------------------------------------------------

			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_1ms     clrf cont_milis;
esp_int1ms		movlw .1;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_int1ms;
				return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_40ms    clrf cont_milis;
esp_int40ms		movlw .40;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_int40ms;
				return;
;--------------------------------------------------------------------------------------------------

			end