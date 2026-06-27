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
 
 ;#include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC"; Cambia la direccion
 #include "C:\Program Files\Microchip\MPASM Suite\P16F877A.INC";

 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _XT_OSC & _WRT_OFF & _LVP_OFF & _CPD_OFF;
;--------------------------------------------------------------------------------------------------
;
; Fosc = 4 MHz.
; Ciclo de trabajo del PIC = (1/fosc)*4 = 1 �s.
; T int =(256-tmr0)*(P)*((1/4000000)*4) = 1 ms. // Tiempo de interrupci�n.
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
banderas		equ 0x29;
data_port		equ 0x46;
var_aux			equ 0x45;

;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.133;
;---------------------------------------------------------------------------------------------------
system.esp		equ .1;
data.correct	equ .2;
ban_data		equ .3;

; Def. de Ptos. I/0.

; Puerto A.
LCD_R#s equ .0;
LCD_E	equ .1;
RAM_WE# equ .2;
RAM_OE# equ .3;
RAM_CE# equ .4;
CAT_LED equ .5;

progA equ b'000000';Def. la config. de los bits del pto. a.

;Puerto B.
Renglon_1 equ .0;
Renglon_2 equ .1;
Renglon_3 equ .2;
Renglon_4 equ .3;
Columna_1 equ .4;
Columna_2 equ .5;
Columna_3 equ .6;
Columna_4 equ .7;

progb equ b'11110000'; // Programacion inicial del puerto B.

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
RAM_A0 equ .0;
RAM_A1 equ .1;
RAM_A2 equ .2;
RAM_A3 equ .3;
RAM_A4 equ .4;
RAM_A5 equ .5;
RAM_A6 equ .6;
RAM_A7 equ .7;

progD equ b'00000000'; // Programacion inicial del puerto C como 
						 ;Entrada.
; Puerto E.
RAM_A8 equ .0;
RAM_A9 equ .1;
RAM_A10 equ .2;

progE equ b'000';Def. la encua.
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
			movlw 0x02; Resistencias Pull-up
 			movwf option_reg ^0x80;
			movlw progA;
			movwf trisa ^0x80;
			movlw progb;
			movwf trisB ^0x80;
			movlw progC;
			movwf trisc ^0x80;
			movlw progD;
			movwf trisd ^0x80; Programacion del puerto D (Datos)
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
			
			clrf portc;
			clrf portd;
			movlw 0xFF;
			movwf portb;

			bsf porta,RAM_CE#; Se deshabilita la memoria RAM
			bsf porta,RAM_OE#; Se deshabilita la lectura RAM
			bsf porta,RAM_WE#; Se deshabilita la escritura RAM
			
			return;
;--------------------------------------------------------------------------------------------------
			;=================================
			;== Subrutina de Interrupciones ==
			;=================================
			
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
			
			btfsc banderas,system.esp;
			goto pri_led;
			
			btfss porta,CAT_LED;
			goto sec_led;
pri_led		bcf porta,CAT_LED; Prende el led.
			goto sal_rutint;
			
sec_led 	bsf porta,CAT_LED; Apaga el led.

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
			;=====================
			;== Programa principal ==
			;=====================

prog_prin 	call prog_ini;
			call LCD_ini;
			call tec_array;
			call Text_ini;
			

Loop_prin 	call Menu;
			
			goto Loop_prin;
;----------------------------------------------------------------------------------------------
Menu 		bsf banderas,system.esp;
			call Text_menu;

			call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;
			
			movlw 0x01;
			xorwf var_tecld,w;
			btfsc status,z;
			goto Opcion_1;
			
			movlw 0x02;
			xorwf var_tecld,w;
			btfsc status,z;
			goto Opcion_2;
			nop;		
			
			goto Menu;
;----------------------------------------------------------------------------------------------		
Opcion_1	bcf banderas,system.esp;
			call Text_read;
			call RETARDO_3s;
			clrf portd;
			clrf porte;
			call Text_ram;

DIR_INT		movlw 0x84;
			call COMANDO_LCD;

loop_op1	bcf banderas,data.correct;
			call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;

			movlw 0xFF;
			xorwf var_tecld,w;
			btfsc status,z;
			goto loop_op1;
			
			call Datos_admi;

			btfss banderas,data.correct;
			goto loop_op1;
			
			movf var_expl,w;
			call PRINT_LCD;
			movf var_tecld,w;
			movwf porte;
			
loop2_op1	call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;

			movlw 0xFF;
			xorwf var_tecld,w;
			btfsc status,z;
			goto loop2_op1;
			
			movf var_expl,w;
			call PRINT_LCD;
			swapf var_tecld,f;
			movf var_tecld,w;
			movwf portd;
			
loop3_op1	call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;

			movlw 0xFF;
			xorwf var_tecld,w;
			btfsc status,z;
			goto loop3_op1;
			
			movf var_expl,w;
			call PRINT_LCD;
			movf var_tecld,w;
			addwf portd,f;

			movlw 0xC5;
			call COMANDO_LCD;

			btfsc banderas,ban_data;
			return;

			bsf status,RP0; Ponte en el banco 1 de ram.
			movlw 0xFF;
			movwf trisc ^0x80;
			bcf status,RP0; Ponte en el banco 0 de ram.
			bcf status,RP1; Ponte en el banco 0 de ram.
			
			bCf porta,RAM_OE#;
			bSf porta,RAM_wE#;
			bCf porta,RAM_CE#;
			call RETARDO_1ms;
			movf portc,w;
			movwf data_port;
			bsf porta,RAM_wE#;
			bsf porta,RAM_OE#;

			bsf status,RP0; Ponte en el banco 1 de ram.
			movlw 0x00;
			movwf trisc ^0x80;
			bcf status,RP0; Ponte en el banco 0 de ram.
			bcf status,RP1; Ponte en el banco 0 de ram.
			
			movlw 0xF0;
			andwf data_port,w;
			movwf var_tecld;
			swapf var_tecld,F;
			
			call conv_ASCII;
			call PRINT_LCD;

			movlw 0x0F;
			andwf data_port,f;

			movf data_port,w;
			movlw var_tecld;
			call conv_ASCII;
			call PRINT_LCD;

			bsf banderas,system.esp;
			
espera.sys	call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;	
			
			movlw 0x0A;
			xorwf var_tecld,w;
			btfsc status,z;
			goto menu;
			
			movlw 0x0B;
			xorwf var_tecld,w;
			btfsc status,z;
			goto Opcion_1;
			
			goto espera.sys;
;----------------------------------------------------------------------------------------------		
Opcion_2	bcf banderas,system.esp;
			call Text_write;
			call RETARDO_3s;
			clrf portd;
			clrf porte;
			call Text_ram;

			bsf banderas,ban_data;
			call DIR_INT;
			bcf banderas,ban_data;

			movlw 0xC5;
			call COMANDO_LCD;

loop_op2	call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;

			movlw 0xFF;
			xorwf var_tecld,w;
			btfsc status,z;
			goto loop_op2;
			
			movf var_expl,w;
			call PRINT_LCD;
			swapf var_tecld,f;
			movf var_tecld,w;
			movwf var_aux;
			
loop2_op2	call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;

			movlw 0xFF;
			xorwf var_tecld,w;
			btfsc status,z;
			goto loop2_op2;
						
			movf var_expl,w;
			call PRINT_LCD;
			movf var_tecld,w;
			addwf var_aux,f;

			movf var_aux,w;
			movwf portc;

			bcf porta,RAM_WE#;
			bSf porta,RAM_OE#;
			call RETARDO_1ms;
			bsf porta,RAM_WE#;
			bsf porta,RAM_CE#;

			bsf banderas,system.esp;
			
espera.sys2	call expl_tec;
			call RETARDO_0.2s;
			call RETARDO_0.2s;	
			
			movlw 0x0A;
			xorwf var_tecld,w;
			btfsc status,z;
			goto Opcion_2;
			
			movlw 0x0B;
			xorwf var_tecld,w;
			btfsc status,z;
			goto menu;;
			
			goto espera.sys2;
;-----------------------------------------------------------------------------------------------------------------

Datos_admi	clrf select_tec;
			movlw 0x07;
			movwf select_tec;
			
looop_data	movf select_tec,w;
			xorwf var_tecld,w;
			btfsc status,z;
			goto data.check;

			nop;
			
			movlw 0x00;
			xorwf select_tec,w;
			btfsc status,z;
			goto data.chent;
			decf select_tec,f;
			goto looop_data;
			
data.chent	bcf banderas,data.correct;
			return;
data.check	bsf banderas,data.correct;
			return;
;----------------------------------------------------------------------------------------------		

#include "Teclado_Matricial_4x4.inc"
#include "Text_temp5.6.inc"
			
			end