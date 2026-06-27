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
var_conteo		equ 0x26;
var_control		equ 0x27;
cont_milis 		equ 0x28;
cont_mils		equ 0x29;
var_global_cont	equ 0x2A;
var_control2	equ 0x2B;
;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.133;
Tms	equ .5;

ACT_COL_0 equ 0x01;
ACT_COL_1 equ 0x02;
ACT_COL_2 equ 0x04;
ACT_COL_3 equ 0x08;
ACT_COL_4 equ 0x10;
des_colum equ 0x00;
;						0 1 2 3 4
COL_0_Ñ	equ	0XC1;	0	  *	* * 
COL_1_Ñ	equ 0XFA;	1	* 		*
COL_2_Ñ	equ	0XF6;	2	* *		*
COL_3_Ñ	equ	0XEE;	3	*   *	*
COL_4_Ñ	equ	0XC1;	4	*     *	*
;					5	*    	*
;					6
;					7
;
;						0 1 2 3 4
COL_0_p	equ	0XFF;	0	       
COL_1_p	equ 0XF7;	1	      * 
COL_2_p	equ	0XEB;	2	    *	
COL_3_p	equ	0XDD;	3	  *   
COL_4_p	equ	0XFF;	4	    *   
;					5   	  *
;					6
;					7

;						0 1 2 3 4
COL_0_?	equ	0XFD;	0	       
COL_1_?	equ 0XFE;	1	       
COL_2_?	equ	0XA6;	2	    	
COL_3_?	equ	0XFA;	3	     
COL_4_?	equ	0XFD;	4	       
;					5   	   
;					6
;					7

;						0 1 2 3 4
COL_0_r	equ	0XC0;	0	*   * *   
COL_1_r	equ 0XFD;	1	* *     *  
COL_2_r	equ	0XFE;	2	*    	
COL_3_r	equ	0XFE;	3	*     
COL_4_r	equ	0XFD;	4	*       
;					5   *	   
;					6
;					7

;						0 1 2 3 4
COL_0_9	equ	0XFF;	0	    * *   
COL_1_9	equ 0XE9;	1	  *     *  
COL_2_9	equ	0XD6;	2	  *   	*
COL_3_9	equ	0XD6;	3	    * * *
COL_4_9	equ	0XE1;	4	  *     * 
;					5     	* * 
;					6
;					7	

;							0 1 2 3 4
COL_0_Mu1	equ	0XEF;	0   
COL_1_Mu1	equ 0X95;	1  
COL_2_Mu1	equ	0XE2;	2
COL_3_Mu1	equ	0X95;	3
COL_4_Mu1	equ	0XEF;	4
;						5
;						6
;						7

;							0 1 2 3 4
COL_0_Mu2	equ	0XBB;	0   
COL_1_Mu2	equ 0XD5;	1  
COL_2_Mu2	equ	0XE2;	2
COL_3_Mu2	equ	0XD5;	3
COL_4_Mu2	equ	0XBB;	4
;						5
;						6
;						7

;							0 1 2 3 4
COL_0_Mu3	equ	0XF7;	0
					;	1	   
COL_1_Mu3	equ 0X97;	2  		*
COL_2_Mu3	equ	0XEB;	3	* *   * *
COL_3_Mu3	equ	0X97;	4		*
COL_4_Mu3	equ	0XF7;	5     *   *
;						6	  *   *
;						7
	
;---------------------------------------------------------------------------------------------------

; Def. de Ptos. I/0.

; Puerto A.
Sin_UsoRA0 equ .0;
Sin_UsoRA1 equ .1;
Sin_UsoRA2 equ .2;
Sin_UsoRA3 equ .3;
Sin_UsoRA4 equ .4;
Sin_UsoRA5 equ .5;

progA equ b'111111';Def. la config. de los bits del pto. a.

;Puerto B.
COL_0 equ .0;
COL_1 equ .1;
COL_2 equ .2;
COL_3 equ .3;
COL_4 equ .4;
COL_5 equ .5;
COL_6 equ .6;
COL_7 equ .7;

progb equ b'00000000'; // Programación inicial del puerto B.

;Puerto C.
Sin_UsoRD0 equ .0;
Sin_UsoRD1 equ .1;
Sin_UsoRD2 equ .2;
Sin_UsoRD3 equ .3;
Sin_UsoRD4 equ .4;
Sin_UsoRD5 equ .5;
Sin_UsoRD6 equ .6;
Sin_UsoRD7 equ .7;

progC equ b'11111111';Def.

;Puerto D.
FIL_0 equ .0;
FIL_1 equ .1;
FIL_2 equ .2;
FIL_3 equ .3;
FIL_4 equ .4;
FIL_5 equ .5;
FIL_6 equ .6;
FIL_7 equ .7;

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
				
			clrf portb;
			clrf cont_milis;
			clrf cont_mils;
			
			movlw 0xFF;
			movwf portD;
			
			movlw 0xa0;
			movwf intcon;
			movlw Tmb;
			movwf tmr0;
			
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
			incf var_control2,f;
			goto sig_int;

sig_int 	clrf presc_1;
			incf presc_2,f;
			movlw .10;
			xorwf presc_2,w;
			btfss status,z;
			goto sal_rutint;
			clrf presc_1;
			clrf presc_2;
			
			incf var_control,f;
			
			btfss porte,Led_Rojo;
			goto sec_led;
			bcf porte,Led_Rojo; Prende el led.
			goto sal_rutint;
			
sec_led 	bsf porte,Led_Rojo; Apaga el led.

sal_rutint 	bcf intcon,t0if;
			
			return;
;--------------------------------------------------------------------------------------------------
Lista_ACT_col	movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw ACT_COL_0;
				retlw ACT_COL_1;
				retlw ACT_COL_2;
				retlw ACT_COL_3;
				retlw ACT_COL_4;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_Ñ			movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_Ñ;
				retlw COL_1_Ñ;
				retlw COL_2_Ñ;
				retlw COL_3_Ñ;
				retlw COL_4_Ñ;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_p			movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_p;
				retlw COL_1_p;
				retlw COL_2_p;
				retlw COL_3_p;
				retlw COL_4_p;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_?			movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_?;
				retlw COL_1_?;
				retlw COL_2_?;
				retlw COL_3_?;
				retlw COL_4_?;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_r			movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_r;
				retlw COL_1_r;
				retlw COL_2_r;
				retlw COL_3_r;
				retlw COL_4_r;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_9			movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_9;
				retlw COL_1_9;
				retlw COL_2_9;
				retlw COL_3_9;
				retlw COL_4_9;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_Mu1		movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_Mu1;
				retlw COL_1_Mu1;
				retlw COL_2_Mu1;
				retlw COL_3_Mu1;
				retlw COL_4_Mu1;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_Mu2		movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_Mu2;
				retlw COL_1_Mu2;
				retlw COL_2_Mu2;
				retlw COL_3_Mu2;
				retlw COL_4_Mu2;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
Lista_Mu3		movf Var_conteo,w;
				addwf pcl,f;
				nop;
				retlw COL_0_Mu3;
				retlw COL_1_Mu3;
				retlw COL_2_Mu3;
				retlw COL_3_Mu3;
				retlw COL_4_Mu3;
				nop;
				return;
;--------------------------------------------------------------------------------------------------
			;=====================
			;== Programa principal ==
			;=====================

prog_prin 	call prog_ini;
			
Loop_prin 	org 0x0100;

			call eñe;
			call menorque;
			call interrogaci;
			call erre;
			call nueve;
			
			call Muñeco_1;
			call Muñeco_2;
			call Muñeco_1;
			call Muñeco_2;
			call Muñeco_1;
			call Muñeco_2;
			call Muñeco_1;
			call Muñeco_2;
			call Muñeco_1;
			call Muñeco_2;
			
			call Muñeco_1;
			call Muñeco_3;
			call Muñeco_1;
			call Muñeco_3;
			call Muñeco_1;
			call Muñeco_3;
			call Muñeco_1;
			call Muñeco_3;
			call Muñeco_1;
			call Muñeco_3;
			call Muñeco_1;
			call Muñeco_3;			

			goto Loop_prin;
			
;---------------------------------------------------------------------------------------------------------
eñe			clrf var_control;
			clrf Var_conteo;
			
esp_Ñ		movlw Tms;
			subwf var_control,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_Ñ;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta1;
			clrf Var_conteo;
			
esp_vuelta1	call RETARDO;
			goto esp_Ñ;
;_______________________________________________________________________________________
menorque	clrf var_control;
			clrf Var_conteo;
esp_menorq	movlw Tms;
			subwf var_control,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_p;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta2;
			clrf Var_conteo;
			
esp_vuelta2	call RETARDO;
			goto esp_menorq;
;_______________________________________________________________________________________
interrogaci	clrf var_control;
			clrf Var_conteo;
esp_interro	movlw Tms;
			subwf var_control,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_?;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta3;
			clrf Var_conteo;
			
esp_vuelta3	call RETARDO;
			goto esp_interro;
;_______________________________________________________________________________________
erre		clrf var_control;
			clrf Var_conteo;
esp_erre	movlw Tms;
			subwf var_control,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_r;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta4;
			clrf Var_conteo;
			
esp_vuelta4	call RETARDO;
			goto esp_erre;
;_______________________________________________________________________________________
nueve		clrf var_control;
			clrf Var_conteo;
esp_nueve	movlw Tms;
			subwf var_control,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_9;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta5;
			clrf Var_conteo;
			
esp_vuelta5	call RETARDO;
			goto esp_nueve;
;_______________________________________________________________________________________			
Muñeco_1	clrf var_control2;
			clrf Var_conteo;
esp_Mu1		movlw .5;
			subwf var_control2,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_Mu1;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta6;
			clrf Var_conteo;
			
esp_vuelta6	call RETARDO;
			goto esp_Mu1;
;_______________________________________________________________________________________
Muñeco_2	clrf var_control2;
			clrf Var_conteo;
esp_Mu2		movlw .5;
			subwf var_control2,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_Mu2;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta7;
			clrf Var_conteo;
			
esp_vuelta7	call RETARDO;
			goto esp_Mu2;
;_______________________________________________________________________________________
Muñeco_3	clrf var_control2;
			clrf Var_conteo;
esp_Mu3		movlw .5;
			subwf var_control2,w;
			btfsc status,Z;
			return;
			
			incf Var_conteo,f;
			
			call Lista_ACT_col;
			movwf portB;
			
			call Lista_Mu3;
			movwf portD;
			
			movlw .5;
			subwf Var_conteo,w;
			btfss status,z;
			goto esp_vuelta8;
			clrf Var_conteo;
			
esp_vuelta8	call RETARDO;
			goto esp_Mu3;
;_______________________________________________________________________________________
			

;---------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO     clrf cont_milis;
esp_int1ms	movlw .3;
			subwf cont_milis,w;
			btfss status,Z;
			goto  esp_int1ms;
			return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_300ms   clrf cont_mils;
esp_int300ms	movlw .5;
				subwf cont_mils,w;
				btfss status,Z;
				goto  esp_int300ms;
				return;
;--------------------------------------------------------------------------------------------------
			end