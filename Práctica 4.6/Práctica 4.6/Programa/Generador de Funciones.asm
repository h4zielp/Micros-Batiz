; CECYT 9 JUAN DE DIOS BATIZ.
;
; PRACTICA 0';.
; MANEJO DE UN LED OSCILANDO A 1 Hz.
;
; EQUIPO: 	GRUPO: 6IMX.
;
; INTEGRANTES:
;
; FECHA DE ENTREGA DEL REPORTE.
;
; ESTE PROGRAMA CONTROLA UN LED HACIENDOLO OSCILAR A UNA
; FRECUENCIA DE UN SEGUNDO, UTILIZANDO
; INTERRUPCIONES CON EL TMR0.
;
;--------------------------------------------------------------------------------------------------
 List 	p=16f877A;
 
 #include "c:\Program files (x86)\Microchip\Mpasm Suite\p16f877a.inc"; Cambia la direccion

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
cont_seg		equ 0x26;
cont_milis 		equ 0x27;
cont_mils		equ 0x28;
select_funcion	equ 0x29;
cont_list		equ 0x2A;
cont_señal      equ 0x2B;
;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.133;
;---------------------------------------------------------------------------------------------------

; Def. de Ptos. I/0.

; Puerto A.
LCD_R#s equ .0;
LCD_E equ .1;
Sin_UsoRA2 equ .2;
Sin_UsoRA3 equ .3;
Sin_UsoRA4 equ .4;
Sin_UsoRA5 equ .5;

progA equ b'111100';Def. la config. de los bits del pto. a.

;Puerto B.
Renglon_1 equ .0;
Renglon_2 equ .1;
Renglon_3 equ .2;
Renglon_4 equ .3;
Columna_1 equ .4;
Columna_2 equ .5;
Columna_3 equ .6;
Columna_4 equ .7;

progb equ b'11110000'; // Programación inicial del puerto B.

;Puerto C.
LCD_D0 equ .0;
LCD_D1 equ .1;
LCD_D2 equ .2;
LCD_D3 equ .3;
LCD_D4 equ .4;
LCD_D5 equ .5;
LCD_D6 equ .6;
LCD_D7 equ .7;

progC equ b'00000000';Def.

;Puerto D.
DAC_0 equ .0;
DAC_1 equ .1;
DAC_2 equ .2;
DAC_3 equ .3;
DAC_4 equ .4;
DAC_5 equ .5;
DAC_6 equ .6;
DAC_7 equ .7;

progD equ b'00000000'; // Programación inicial del puerto C como 
						 ;Entrada.
						 
; Puerto E.
Sin_UsoRE0 equ .0;
Sin_UsoRE1 equ .1;
Led_Rojo   equ .2;

progE equ b'011';Def. la encua.
;-------------------------------------------------------------------------------------------------

			;=================
			;== Vector Reset ==
			;=================
			org 0x00;
vec_reset 	clrf pclath;
			goto prog_prin;
;-------------------------------------------------------------------------------------------------

			;=============================
			;== Subrutina de Interrupciones ==
			;=============================
			
			org 0x04;
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
			movlw 0x02;
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
			
			movlw 0x00;
			movwf portc;
			movwf portd;
			movwf cont_list;
			movwf select_funcion;
			
			movlw 0xFF;
			movwf portb;			
			return;
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
			incf cont_mils,f;
			goto sig_int;

sig_int 	clrf presc_1;
			incf presc_2,f;
			movlw .10;
			xorwf presc_2,w;
			btfss status,z;
			goto sal_rutint;
			clrf presc_1;
			clrf presc_2;
			
			incf cont_seg,f;
			
			btfss porte,Led_Rojo;
			goto sec_led;
			bcf porte,Led_Rojo; Prende el led.
			goto sal_rutint;
			
sec_led 	bsf porte,Led_Rojo; Apaga el led.

sal_rutint 	bcf intcon,t0if;
			
			return;
;--------------------------------------------------------------------------------------------------
			;=====================
			;== Inicializar LCD ==
			;=====================
LCD_ini		bsf porta,LCD_E;	;Pulso en alto inicial del Enable

			movlw 0x38;
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
;---------------------------------------------------------------------------------------------
;Listas
			;A quí van las listas que se requieran			

			;========================
			;== Lista de funciones ==
			;========================
List_fun	movf select_funcion,w;	|
			addwf pcl,f;			 |
			goto no_signal;			  |
			goto sñal_squre;		    |
	        goto sñal_trian;		     | Esta es la estructura básica de una lista
			goto sñal_senoi;		    |
			nop;					  |
			nop;					 |
			return;					|

no_signal	movlw 0x80;
			movwf portd;
			call RETARDO_0.08s;
			call RETARDO_0.08s;
			return;
			
sñal_squre	movlw 0xFF;
			movwf portd;
			call RETARDO_0.08s;		El la tasa de muestreo depende de la cantidad de muestras que tengas
			movlw 0x80;
			movwf portd;
			call RETARDO_0.08s;
			return;

sñal_trian  clrf cont_señal;
            call ciclo_t1;  
            return;

sñal_senoi  clrf cont_señal;
            call ciclo_sup1;  
            return;
			
;----------------------------------------------------------------------------------------------
;CICLOS SEÑAL SENOIDAL
seno_list1	movf cont_list,w;
			addwf pcl,f;
			nop;

			retlw 0X7F; Se representara en el DAC 2.50V
			retlw 0X8B; Se representara en el DAC 2.75V
			retlw 0X98; Se representara en el DAC 2.99V
			retlw 0XA4; Se representara en el DAC 3.23V
			retlw 0XB0; Se representara en el DAC 3.46V
			retlw 0XBB; Se representara en el DAC 3.68V
			retlw 0XC6; Se representara en el DAC 3.89V
			retlw 0XD0; Se representara en el DAC 4.09V

			retlw 0XD9; Se representara en el DAC 4.27V
			retlw 0XE1; Se representara en el DAC 4.43V
			retlw 0XE9; Se representara en el DAC 4.58V
			retlw 0XEF; Se representara en el DAC 4.70V
			retlw 0XF4; Se representara en el DAC 4.81V
			retlw 0XF9; Se representara en el DAC 4.89V
			retlw 0XFC; Se representara en el DAC 4.95V
			retlw 0XFD; Se representara en el DAC 4.99V
			retlw 0XFF; Se representara en el DAC 5.00V

			return;

seno_list2	movf cont_list,w;
			addwf pcl,f;
			nop;

			retlw 0X7F; Se representara en el DAC 2.50V
			retlw 0X73; Se representara en el DAC 2.25V
			retlw 0X66; Se representara en el DAC 2.01V
			retlw 0X5A; Se representara en el DAC 1.77V
			retlw 0X4E; Se representara en el DAC 3.54V
			retlw 0X43; Se representara en el DAC 3.76V
			retlw 0X38; Se representara en el DAC 3.97V
			retlw 0X2E; Se representara en el DAC 4.16V

			retlw 0X25; Se representara en el DAC 4.33V
			retlw 0X1D; Se representara en el DAC 4.48V
			retlw 0X15; Se representara en el DAC 4.62V
			retlw 0X0F; Se representara en el DAC 4.73V
			retlw 0X0A; Se representara en el DAC 4.83V
			retlw 0X05; Se representara en el DAC 4.90V
			retlw 0X02; Se representara en el DAC 4.96V
			retlw 0X01; Se representara en el DAC 4.98V
			retlw 0X00; Se representara en el DAC 4.99V

			return;

;Leer lista Senoidal
ciclo_sup1  clrf cont_list;
			
read_list1	incf cont_list,f;
			call seno_list1;
			movwf portd;
			call RETARDO_2ms

			movlw .17;
			subwf cont_list,w;
			btfss status,z;
			goto read_list1;

read_list2	decf cont_list,f;
			call seno_list1;
			movwf portd;
			call RETARDO_2ms

			movlw .0;
			subwf cont_list,w;
			btfss status,z;
			goto read_list2;

read_list3	incf cont_list,f;
			call seno_list2;
			movwf portd;
			call RETARDO_2ms

			movlw .17;
			subwf cont_list,w;
			btfss status,z;
			goto read_list3;

read_list4	decf cont_list,f;
			call seno_list2;
			movwf portd;
			call RETARDO_2ms

			movlw .0;
			subwf cont_list,w;
			btfss status,z;
			goto read_list4;

            return;
;---------------------------------------------------------------------------------------------
			;=====================
			;== Programa principal ==
			;=====================

prog_prin 	call prog_ini;
			call LCD_ini;
			org 0x0100;
			call text_ini;
			call RETARDO_5s;
			call text_menu;
			
Loop_prin 	call expl_tecl;
		    call RETARDO_5s;

			goto Loop_prin;
;--------------------------------------------------------------------------------------------------
expl_tecl	movlw 0x0E;
			movwf portb;
			
			btfss portb,Columna_1;
			goto tecla_1;
			
			btfss portb,Columna_2;
			goto tecla_2;
			
			btfss portb,Columna_3;
			goto tecla_3;
			
			movlw 0x0D;
			movwf portb;
			
			btfss portb,Columna_1;
			goto tecla_4;
			
			call List_fun; Genera la función deseada de manera perpetua hasta ser cambiada por el teclado
			goto expl_tecl;
			
tecla_1		call text_square;
			call RETARDO_0.1s;
			movlw .1;
			movwf select_funcion;
			goto expl_tecl;
			
tecla_2		call text_trian;
            call RETARDO_0.1s;
			movlw .2;
			movwf select_funcion;
			goto expl_tecl;
			
tecla_3		call text_senoi;
            call RETARDO_0.1s;
            movlw .3;
            movwf select_funcion;
			goto expl_tecl;
			
tecla_4		call text_menu;
			call RETARDO_0.1s;
			movlw .0;
			movwf select_funcion;
			goto expl_tecl;

;---------------------------------------------------------------------------------------------
;CICLOS SEÑAL TRIANGULAR
ciclo_t1    movlw .15;
			addwf cont_señal,f;
			movf cont_señal,w;
			movwf portd;
			call RETARDO_5ms
			
			movlw .255;
			xorwf cont_señal,w;
			btfss status,z;
			goto ciclo_t1;

ciclo_t2    movlw .15;
			subwf cont_señal,f;
			movf cont_señal,w;
			movwf portd;
			call RETARDO_5ms
			
			movlw 0x00;
			xorwf cont_señal,w;
			btfss status,z;
			goto ciclo_t2;

			return;

;---------------------------------------------------------------------------------------------
			
#include "Textos generador de funciones.inc";			
			end