	; INSTITUTO POLITECNICO NACIONAL.
; CECYT 9 JUAN DE DIOS BATIZ.
;
; CRONOMETRO.
;
; GRUPO: 5IM1.
;
; INTEGRANTES:
; 1.- LOPEZ LOPEZ DAVID ISAI.
; 2.- MARTINEZ OSORIO MIGUEL ÁNGEL.
; 3.- PUENTE CASTRO DILAN HAZIEL.
; 4.- RAMIRÉZ VALENCIA ENRIQUE.
;
; RELOJ DE TIEMPO REAL QUE UTILIZANDO LA TÉCNICA TDM CUENTA HASTA 23hrs. 59min. 59s. en
;formato militar.
;---------------------------------------------------------------------------------------------
 list p=16F877A;
 #include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC";
 ;#include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC";

;Bits de configuración
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;ALL
;---------------------------------------------------------------------------------------------
;
;fosc = 3.579545 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1.11 µs.
;t int =(256-R)*(P)*((1/3579545)*4) = 1.0012 ms ;// Tiempo de interrupcion.
;---------------------------------------------------------------------------------------------
;
						; Registros de propósito general Banco 0 de memoria RAM.
;
						; Registros propios de estructura del programa
cuenta_deci_s equ 0x20;
cuenta_unid_s equ 0x21;

cuenta_deci_m equ 0x22;
cuenta_unid_m equ 0x23;

cuenta_deci_h equ 0x24;
cuenta_unid_h equ 0x25;

Cod7seg_dec_s equ 0x26;
Cod7seg_uni_s equ 0x27;

Cod7seg_dec_m equ 0x28;
Cod7seg_uni_m equ 0x29;

Cod7seg_dec_h equ 0x2A;
Cod7seg_uni_h equ 0x2B;
limite	equ 0x2C;

resp_num equ 0x2C;
Contador1 equ 0x2D; // L
Contador2 equ 0x2E; // N
Contador3 equ 0x2F; // M
Contador4 equ 0x30;
;---------------------------------------------------------------------------------------------
;
; Constantes.
M equ .1;
N equ .220; 224
L equ .39; 39

; Constantes de caracteres en siete segmentos.
Car_0 equ b'00111111'; Caracter 0 en siete segmentos.
Car_1 equ b'00000110'; Caracter 1 en siete segmentos.
Car_2 equ b'01011011'; Caracter 2 en siete segmentos.
Car_3 equ b'01001111'; Caracter 3 en siete segmentos.
Car_4 equ b'01100110'; Caracter 4 en siete segmentos.
Car_5 equ b'01101101'; Caracter 5 en siete segmentos.
Car_6 equ b'01111101'; Caracter 6 en siete segmentos.
Car_7 equ b'00000111'; Caracter 7 en siete segmentos.
Car_8 equ b'01111111'; Caracter 8 en siete segmentos.
Car_9 equ b'01100111'; Caracter 9 en siete segmentos.

Car__ equ b'00001000'; Caracter _ en siete segmentos.
Car_null equ b'00000000'; Caracter nulo en siete segmentos.
;---------------------------------------------------------------------------------------------
;
; Asignación de los bits de los puertos de I/O.

; Puerto A.
Sin_UsoRA0 equ .0; // Sin Uso RA0.
Sin_UsoRA1 equ .1; // Sin Uso RA1.
Sin_UsoRA2 equ .2; // Sin Uso RA2.
Sin_UsoRA3 equ .3; // Sin Uso RA3.
Sin_UsoRA4 equ .4; // Sin Uso RA4.
Sin_UsoRA5 equ .5; // Sin Uso RA5.

proga equ b'111111'; // Programación inicial del puerto A.

; Puerto B.
Seg_a equ .0; // Segmento a del bus de segmentos.
Seg_b equ .1; // Segmento b del bus de segmentos.
Seg_c equ .2; // Segmento c del bus de segmentos.
Seg_d equ .3; // Segmento d del bus de segmentos.
Seg_e equ .4; // Segmento e del bus de segmentos.
Seg_f equ .5; // Segmento f del bus de segmentos.
Seg_g equ .6; // Segmento g del bus de segmentos.
Seg_dp equ .7; // Segmento dp del bus de segmentos.

progb equ b'00000000'; // Programación inicial del puerto B.

;Puerto C.
Sin_UsoRC0 equ .0; // Sin Uso RC0.
Sin_UsoRC1 equ .1; // Sin Uso RC1.
Sin_UsoRC2 equ .2; // Sin Uso RC2.
Sin_UsoRC3 equ .3; // Sin Uso RC3.
Sin_UsoRC4 equ .4; // Sin Uso RC4.
Sin_UsoRC5 equ .5; // Sin Uso RC5.
Sin_UsoRC6 equ .6; // Sin Uso RC6.
Sin_UsoRC7 equ .7; // Sin Uso RC7.

progc equ b'11111111'; // Programación inicial del puerto C como entradas.

;Puerto D.
Com_Disp0 equ .0; // Bit que controla el común del display 0.
Com_Disp1 equ .1; // Bit que controla el común del display 1.
Com_Disp2 equ .2; // Bit que controla el común del display 2.
Com_Disp3 equ .3; // Bit que controla el común del display 3.
Com_Disp4 equ .4; // Bit que controla el común del display 4.
Com_Disp5 equ .5; // Bit que controla el común del display 5.
Com_Disp6 equ .6; // Bit que controla el común del display 6.
Com_Disp7 equ .7; // Bit que controla el común del display 7.

progd equ b'00000000'; // Programación inicial del puerto D como salidas.

;Puerto E.
Sin_UsoRE0 equ .0; // Sin Uso RE0.
Sin_UsoRE1 equ .1; // Sin Uso RE1.
Sin_UsoRE2 equ .1; // Sin Uso RE2.

proge equ b'111'; // Programación inicial del puerto E.
;---------------------------------------------------------------------------------------------
			;====================
			;== Vector reset ==
			;====================
			org 0x0000;
vec_reset	clrf pclath;
			goto prog_prin;

;---------------------------------------------------------------------------------------------
			;==============================
			;== Vector de interrupción ==
			;==============================
			org 0x0004;
vec_int 	nop;

			retfie;

;---------------------------------------------------------------------------------------------
			;===========================
			;== Subrutina de inicio ==
			;===========================
prog_ini	bsf status,rp0;
			movlw 0x81;
			movwf option_reg ^0x80;
			movlw proga;
			movwf trisa ^0x80;
			movlw progb;
			movwf trisb ^0x80;
			movlw progc;
			movwf trisc ^0x80;
			movlw progd;
			movwf trisd ^0x80;
			movlw proge;
			movwf trise ^0x80;
			movlw 0x06;
			movwf adcon1 ^0x80;
			bcf status,rp0;

			clrf portb;
			movlw b'11111111';
			movwf portd;

			return;

;---------------------------------------------------------------------------------------------
			;==========================
			;== Programa principal ==
			;==========================
prog_prin	call prog_ini;

			movlw Car_0;
			movwf Cod7seg_dec_s;
			movwf Cod7seg_uni_s;

			movwf Cod7seg_dec_m;
			movwf Cod7seg_uni_m;

			movwf Cod7seg_dec_h;
			movwf Cod7seg_uni_h;

			movwf Cod7seg_dec_h;
			movwf Cod7seg_uni_h;

			clrf cuenta_deci_s;
			clrf cuenta_unid_s;

			clrf cuenta_deci_m;
			clrf cuenta_unid_m;

			clrf cuenta_deci_h;
			clrf cuenta_unid_h;

loop_pri	call muestra_time;
			call cta_tiempo;
			call arma_tiempo;

			goto loop_pri;

;---------------------------------------------------------------------------------------------

				;=======================================
				;== Subrutina que muestra el tiempo ==
				;=======================================
muestra_time	movlw .46;				1u
				movwf Contador2;		1u
loop1 			movlw .248;				1u
				movwf Contador1;		1u

barre_display	movf Cod7seg_dec_h,w;	1u
				movwf portb;			1u
				bcf portd,Com_Disp0;	1u
				call retardo_1ms;		5u
				bsf portd,Com_Disp0;	1u

				movf Cod7seg_uni_h,w;
				movwf portb;
				bcf portd,Com_Disp1;
				call retardo_1ms;
				bsf portd,Com_Disp1;


				movlw b'01000000';		1u
				movwf portb;			1u
				bcf portd,Com_Disp2;	1u
				bcf portd,Com_Disp5;	1u
				call retardo_1ms;		5u
				bsf portd,Com_Disp2;	1u
				bsf portd,Com_Disp5;	1u

				
				movf Cod7seg_dec_m,w;
				movwf portb;
				bcf portd,Com_Disp3;
				call retardo_1ms;
				bsf portd,Com_Disp3;

				movf Cod7seg_uni_m,w;
				movwf portb;
				bcf portd,Com_Disp4;
				call retardo_1ms;
				bsf portd,Com_Disp4;


				movf Cod7seg_dec_s,w;
				movwf portb;
				bcf portd,Com_Disp6;
				call retardo_1ms;
				bsf portd,Com_Disp6;

				movf Cod7seg_uni_s,w;
				movwf portb;
				bcf portd,Com_Disp7;
				call retardo_1ms;
				bsf portd,Com_Disp7;


				decfsz Contador1,f;
				goto barre_display;
				decfsz Contador2,f;
				goto loop1;

				return;

;---------------------------------------------------------------------------------------------
				;======================================
				;== Subrutina que cuenta el tiempo ==
				;======================================
cta_tiempo		incf cuenta_unid_s,f;
				movlw .10;
				subwf cuenta_unid_s,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_s;
				incf cuenta_deci_s,f;

				movlw .6;
				subwf cuenta_deci_s,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_s;
				clrf cuenta_deci_s;

				incf cuenta_unid_m,f;
				movlw .10;
				subwf cuenta_unid_m,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_m;
				incf cuenta_deci_m,f;

				movlw .6;
				subwf cuenta_deci_m,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_m;
				clrf cuenta_deci_m;
				incf cuenta_unid_h,f;
				
				movlw .10;
				subwf cuenta_unid_h,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_h;
				incf cuenta_deci_h,f;

				movlw .2;
				subwf cuenta_deci_h,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_h;
				clrf cuenta_deci_h;


sal_ctatim		return;

;---------------------------------------------------------------------------------------------
				;====================================
				;== Subrutina que arma el tiempo ==
				;====================================
arma_tiempo		movf cuenta_unid_s,w;
				movwf resp_num;
				call conv_A_Hex7seg;
				movf resp_num,w;
				movwf Cod7seg_uni_s;

				movf cuenta_deci_s,w;
				movwf resp_num;
				call conv_A_Hex7seg;
				movf resp_num,w;
				movwf Cod7seg_dec_s;

				movf cuenta_unid_m,w;
				movwf resp_num;
				call conv_A_Hex7seg;
				movf resp_num,w;
				movwf Cod7seg_uni_m;

				movf cuenta_deci_m,w;
				movwf resp_num;
				call conv_A_Hex7seg;
				movf resp_num,w;
				movwf Cod7seg_dec_m;

				movf cuenta_unid_h,w;
				movwf resp_num;
				call conv_A_Hex7seg;
				movf resp_num,w;
				movwf Cod7seg_uni_h;

				movf cuenta_deci_h,w;
				movwf resp_num;
				call conv_A_Hex7seg;
				movf resp_num,w;
				movwf Cod7seg_dec_h;

				return;

;---------------------------------------------------------------------------------------------
				;=======================================
				;== Subrutina que conv. a 7 segmentos ==
				;=======================================
conv_A_Hex7seg	movlw .0;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_0;

				movlw .1;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_1;

				movlw .2;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_2;

				movlw .3;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_3;

				movlw .4;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_4;

				movlw .5;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_5;

				movlw .6;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_6;

				movlw .7;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_7;

				movlw .8;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_8;

				movlw .9;
				subwf resp_num,w;
				btfsc status,Z;
				goto fue_9;

				goto salte_conv;

fue_0			movlw Car_0;
				movwf resp_num;
				goto salte_conv;

fue_1			movlw Car_1;
				movwf resp_num;
				goto salte_conv;

fue_2			movlw Car_2;
				movwf resp_num;
				goto salte_conv;

fue_3			movlw Car_3;
				movwf resp_num;
				goto salte_conv;

fue_4			movlw Car_4;
				movwf resp_num;
				goto salte_conv;

fue_5			movlw Car_5;
				movwf resp_num;
				goto salte_conv;

fue_6			movlw Car_6;
				movwf resp_num;
				goto salte_conv;

fue_7			movlw Car_7;
				movwf resp_num;
				goto salte_conv;

fue_8			movlw Car_8;
				movwf resp_num;
				goto salte_conv;

fue_9			movlw Car_9;
				movwf resp_num;

salte_conv		return;

;---------------------------------------------------------------------------------------------
				;================================================
				;== Subrutina de retardo de tiempo de 7 micros ==
				;================================================
retardo_1ms		movlw .1;
				movwf Contador4;

loop3			decfsz Contador4,f;
				goto loop3;

				return;
;---------------------------------------------------------------------------------------------
				end