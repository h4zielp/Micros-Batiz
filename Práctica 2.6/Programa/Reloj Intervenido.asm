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
 
 #include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC";
 ;#include "C:\Program Files\Microchip\MPASM Suite\P16F877A.INC";

 
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

cuenta_deci_s 	equ 0x28;
cuenta_unid_s 	equ 0x29;

cuenta_deci_m 	equ 0x2A;
cuenta_unid_m 	equ 0x2B;

cuenta_deci_h 	equ 0x2C;
cuenta_unid_h 	equ 0x2D;

CodASCII_dec_s 	equ 0x2E;
CodASCII_uni_s 	equ 0x2F;

CodASCII_dec_m 	equ 0x30;
CodASCII_uni_m 	equ 0x31;

CodASCII_dec_h 	equ 0x32;
CodASCII_uni_h 	equ 0x33;

cont_mils 	   	equ 0x34;

Var_teclado		equ 0x35;
Var_tecopri		equ 0x36;

Var_aux			equ 0x37;
Var_dis_pos		equ 0x38;
Var_filas		equ 0x39;

resp_portB		equ 0x3A;
;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.131;

Deshabilitado 	equ 0xFF;
No_haytecla		equ 0xF0;
Des_teclado		equ 0x0F;

Tec_col_1 		equ 0xE0;
Tec_col_2		equ 0xD0;
Tec_col_3		equ 0xB0;
Tec_col_4		equ 0x70;

; banderas del registro banderas.
ban_int 		equ .0;
ban_24h			equ .1;
ban_A	 		equ .2;
ban_B	 		equ .3;
ban_carga 		equ .4;
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
Renglon_1 equ .0;
Renglon_2 equ .1;
Renglon_3 equ .2;
Renglon_4 equ .3;
Tecla_1 equ .4;
Tecla_2 equ .5;
Tecla_3 equ .6;
Tecla_4 equ .7;

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

			btfss intcon,t0if;
			goto sal_int;
			call rutina_int;
			call check_tec;
			bcf intcon,t0if;

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
			;=======================================
			;== Subrutina de Ini. de Reg. del Pic ==
			;=======================================
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
				
			clrf porta;
			clrf banderas;
			clrf cont_milis;
			
			movlw '0';
			movwf CodASCII_dec_s;
			movwf CodASCII_uni_s;
			movwf CodASCII_dec_m;
			movwf CodASCII_uni_m;
			movwf CodASCII_dec_h;
			movwf CodASCII_uni_h;

			clrf cuenta_deci_s;
			clrf cuenta_unid_s;
			clrf cuenta_deci_m;
			clrf cuenta_unid_m;
			clrf cuenta_deci_h;
			clrf cuenta_unid_h;
			
			movlw 0xa0;
			movwf intcon;
			movlw Tmb;
			movwf tmr0;
			
			movlw H'84';
			movwf Var_dis_pos;

			return;
;-------------------------------------------------------------------------------------------------
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

 			bsf banderas,ban_int;
 			
 			btfss porte,Led_Rojo;
			goto sec_led;
			bcf porte,Led_Rojo; Prende el led.
			goto sal_rutint;
			
sec_led 	bsf porte,Led_Rojo; Apaga el led.

sal_rutint 	return;
;--------------------------------------------------------------------------------------------------
			;=============================
			;== Subrutina de Interrupciones ==
			;=============================
check_tec	btfsc banderas,ban_A;
			goto ban2_B;
			movlw Renglon_1;
			movwf portb;
			btfss portb,Tecla_4;
			bsf banderas,ban_A;
			
ban2_B		movlw Deshabilitado;
			movwf portb;
			
			btfsc banderas,ban_B;
			goto sal_check;
			movlw Renglon_2;
			movwf portb;
			btfss portb,Tecla_4;
			bsf banderas,ban_B;

sal_check	return;
;---------------------------------------------------------------------------------------------
				;====================================
				;== Subrutina que arma el tiempo ==
				;====================================
conv_A_ASCII 	
				addwf pcl,f;
				retlw '0';
				retlw '1';
				retlw '2';
				retlw '3';
				retlw '4';
				retlw '5';
				retlw '6';
				retlw '7';
				retlw '8';
				retlw '9';
;-------------------------------------------------------------------------------------------------
Lista_Col_1		movf Var_filas,w;
				addwf pcl,f;
				nop;
				nop;
				nop;
				nop;
				nop;
				goto Tecla_7_1;		0x0B
				nop;
				goto Tecla_4_1;		0x0D
				goto Tecla_1_1;		0x0E

Tecla_7_1		movlw '7';
				movwf Var_tecopri;
				retlw .7;
				
Tecla_4_1		movlw '4';
				movwf Var_tecopri;
				retlw .4;

Tecla_1_1		movlw '1';
				movwf Var_tecopri;
				retlw .1;
;-------------------------------------------------------------------------------------------------
Lista_Col_2		movf Var_filas,w;
				addwf pcl,f;
				nop;
				goto Tecla_0_2;		0x07
				nop;
				nop;
				nop;
				goto Tecla_8_2;		0x0B
				nop;
				goto Tecla_5_2;		0x0D
				goto Tecla_2_2;		0x0E

Tecla_0_2		movlw '0';
				movwf Var_tecopri;
				retlw .0;

Tecla_8_2		movlw '8';
				movwf Var_tecopri;
				retlw .8;
				
Tecla_5_2		movlw '5';
				movwf Var_tecopri;
				retlw .5;

Tecla_2_2		movlw '2';
				movwf Var_tecopri;
				retlw .2;
;-------------------------------------------------------------------------------------------------
Lista_Col_3		movf Var_filas,w;
				addwf pcl,f;
				nop;
				nop;
				nop;
				nop;
				nop;
				goto Tecla_9_3;		0x0B
				nop;
				goto Tecla_6_3;		0x0D
				goto Tecla_3_3;		0x0E

Tecla_9_3		movlw '9';
				movwf Var_tecopri;
				retlw .9;
				
Tecla_6_3		movlw '6';
				movwf Var_tecopri;
				retlw .6;

Tecla_3_3		movlw '3';
				movwf Var_tecopri;
				retlw .3;
;-------------------------------------------------------------------------------------------------
			;========================
			;== Programa principal ==
			;========================

prog_prin 	call prog_ini;
			call LCD_ini;

Loop_prin 	org 0x010C;
			call esp_int;
			
			call barre_var_tmp;
			call muestra_time;
			call cta_tiempo;
			call arma_tiempo;
			
			goto Loop_prin;
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
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de HABILITACIÓN DE LCD (E) ==
			;=========================================
	
PRINT_LCD	bsf porta,LCD_R#s;
			goto CARGA;
COMANDO_LCD	bcf porta,LCD_R#s; Modo comando
CARGA		movwf portc;

			call RETARDO;
			bcf porta,LCD_E;
			call RETARDO;
			bsf porta,LCD_E;
				
			call RETARDO_40ms

			return;
;--------------------------------------------------------------------------------------------------			
			;==============================================
			;== Subrutina de espera de int. de 1 segundo ==
			;==============================================
			
esp_int 	nop;
			btfss banderas,ban_int;
			goto esp_int;
			bcf banderas,ban_int;
			
			return;
;--------------------------------------------------------------------------------------------------			
				;=======================================
				;== Subrutina que muestra el tiempo ==
				;=======================================
muestra_time	movlw H'84';
				call COMANDO_LCD;
				movf CodASCII_dec_h,w;
				call PRINT_LCD;	

				movlw H'85';
				call COMANDO_LCD;
				movf CodASCII_uni_h,w;
				call PRINT_LCD;
				
				movlw H'86';
				call COMANDO_LCD;
				movlw ':';
				call PRINT_LCD;
				
				movlw H'87';
				call COMANDO_LCD;
				movf CodASCII_dec_m,w;
				call PRINT_LCD;
				
				movlw H'88';
				call COMANDO_LCD;
				movf CodASCII_uni_m,w;
				call PRINT_LCD;
				
				movlw H'89';
				call COMANDO_LCD;
				movlw ':';
				call PRINT_LCD;
				
				movlw H'8A';
				call COMANDO_LCD;
				movf CodASCII_dec_s,w;
				call PRINT_LCD;
				
				movlw H'8B';
				call COMANDO_LCD;
				movf CodASCII_uni_s,w;
				call PRINT_LCD;
				
				return;
;---------------------------------------------------------------------------------------------
				;=======================================
				;== Subrutina que cuenta el tiempo ==
				;=======================================

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
				
				btfsc banderas,ban_24h;
				goto time_out;
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
				bsf	banderas,ban_24h;
				goto sal_ctatim;
				
time_out		movlw .4;
				subwf cuenta_unid_h,w;
				btfss status,Z;
				goto sal_ctatim;
				clrf cuenta_unid_h;
				clrf cuenta_deci_h;
				clrf cuenta_unid_m;
				clrf cuenta_deci_m;
				clrf cuenta_unid_s;
				clrf cuenta_deci_s;
				bcf banderas,ban_24h;

sal_ctatim		return;
;---------------------------------------------------------------------------------------------
				;====================================
				;== Subrutina que arma el tiempo ==
				;====================================
arma_tiempo		movf cuenta_unid_s,w;
				call conv_A_ASCII;
				movwf CodASCII_uni_s;

				movf cuenta_deci_s,w;
				call conv_A_ASCII;
				movwf CodASCII_dec_s;

				movf cuenta_unid_m,w;
				call conv_A_ASCII;
				movwf CodASCII_uni_m;

				movf cuenta_deci_m,w;
				call conv_A_ASCII;
				movwf CodASCII_dec_m;

				movf cuenta_unid_h,w;
				call conv_A_ASCII;
				movwf CodASCII_uni_h;

				movf cuenta_deci_h,w;
				call conv_A_ASCII;
				movwf CodASCII_dec_h;

				return;
;---------------------------------------------------------------------------------------------	
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO     clrf cont_milis;
esp_int1ms	movlw .1;
			subwf cont_milis,w;
			btfss status,Z;
			goto  esp_int1ms;
			return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_100 clrf cont_mils;
esp_in100ms	movlw .3;
			subwf cont_milis,w;
			btfss status,Z;
			goto  esp_in100ms;
			return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_500 clrf cont_mils;
esp_in500ms	movlw .150;
			subwf cont_milis,w;
			btfss status,Z;
			goto  esp_in500ms;
			return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_40ms    clrf cont_milis;
esp_int40ms		movlw .2;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_int1ms;
				return;
;---------------------------------------------------------------------------------------------				
			;==================================================
			;== Subrutina que barre las variables de tiempo ===
			;==================================================
barre_var_tmp	btfss banderas,ban_A;
				return;
				
tec_dec_hrs		call barre_teclado;
				movwf var_aux;
				btfsc banderas,ban_B;
				goto sal_int_dat;
				
				call test_24hrs;
				btfss banderas,ban_carga;
				goto tec_dec_hrs;
				
				bcf banderas,ban_carga;
				movf var_aux,w;
				movwf cuenta_deci_h;
				movlw H'84';
				call COMANDO_LCD;
				movf Var_tecopri,w;
				call PRINT_LCD;
				
				
tec_uni_hrs		call RETARDO_500;
				call barre_teclado;
				movwf var_aux;
				btfsc banderas,ban_B;
				goto sal_int_dat;
				
				call test_24hrs;
				btfss banderas,ban_carga;
				goto tec_uni_hrs;
				
				bcf banderas,ban_carga;
				movf var_aux,w;
				movwf cuenta_deci_h;
				movlw H'85';
				call COMANDO_LCD;
				movf Var_tecopri,w;
				call PRINT_LCD;
				
				
sal_int_dat		bcf banderas,ban_A;
				bcf banderas,ban_B;
				return;
;--------------------------------------------------------------------------------------------------
			;=======================================
			;== Subrutina que explora el teclado ===
			;=======================================
barre_teclado	movlw 0x0E;
				movwf portb;
				
loop_expl		btfsc banderas,ban_B;
				return;
				
				movf portb,w;
				movwf resp_portB;
				call RETARDO_100;
				movf resp_portB,w;
				movwf portb;
				
				movf portb,w;
				movwf Var_teclado;
				
				movlw 0x0F;	Máscara de Filas
				andwf Var_teclado,w;
				movwf Var_filas;
				movlw .6;
				subwf Var_filas,f;
				
				movlw 0xF0; Máscara de Columnas
				andwf Var_teclado,f;
				movlw No_haytecla;
				xorwf Var_teclado,w;
				btfsc status,z;
				goto sig_Ren;
				
				movlw Tec_col_1;
				subwf Var_teclado,w;
				btfsc status,z;
				goto Fue_Col1;
				
				movlw Tec_col_2;
				subwf Var_teclado,w;
				btfsc status,z;
				goto Fue_Col2;
				
				movlw Tec_col_3;
				subwf Var_teclado,w;
				btfsc status,z;
				goto Fue_Col3;
				
sig_Ren			movf portb,w;
				movwf Var_aux;
				movlw 0x0F;
				andwf Var_aux,f;
				nop;
				movlw 0x0F;
				xorwf Var_aux,w;
				nop;
				btfsc status,z;
				goto barre_teclado;
				
				rlf portb,f;
				movlw 0x0F;
				andwf portb,f;
				bsf status,c;	
				goto loop_expl;
;-----------------------------------------------------------
Fue_Col1		call Lista_Col_1;
				nop;
				return;

Fue_Col2		call Lista_Col_2;
				nop;
				return;
				
Fue_Col3		call Lista_Col_3;
				nop;
				return;
;-------------------------------------------------------------------------------------------------------------------------
			;================================================================
			;== Subrutina que verifica los datos validos para las horas ===
			;================================================================
test_24hrs		movlw .0;
				xorwf var_aux,w;
				btfsc status,z;
				goto dato_val;
				
				movlw .1;
				xorwf var_aux,w;
				btfsc status,z;
				goto dato_val;
				
				movlw .2;
				xorwf var_aux,w;
				btfss status,z;
				goto check_ban_24h;
				goto dato_val;
				
check_ban_24h	btfss banderas,ban_24h;
				goto dato_inva;
				
				movlw .3;
				xorwf var_aux,w;
				btfss status,z;
				goto dato_inva;
				goto dato_val;
				
dato_inva		bcf banderas,ban_carga;
				return;

dato_val		bsf banderas,ban_24h;
				bsf banderas,ban_carga;
				return;
;--------------------------------------------------------------------------------------------------
			end