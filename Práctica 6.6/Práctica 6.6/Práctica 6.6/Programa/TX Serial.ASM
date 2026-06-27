; CECYT 9 JUAN DE DIOS BATIZ.
;
; PRACTICA 0';.
; MANEJO DE UN LED OSCILANDO A 1 Hz.
;
; EQUIPO: 4 	GRUPO: 6IM1.
;
; INTEGRANTES:
; Garcia Romero Ariadna Elizabeth
; Gutiérrez Miranda Perla Mayte
; Puente Castro Dilan Haziel
; Villa Terán Usiel
; FECHA DE ENTREGA DEL REPORTE.
;
; ESTE PROGRAMA GENERA UN CONTADOR DE MINUTOS Y SEGUNDOS EN 4 DISPLAYS DE CÁTODO COMÚN MEDIANTE LA
; TRANSMISIÓN DE DATOS DE FORMA SERIAL UTILIZANDO EL CIHC595.
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
banderas	equ 0x29;
seg_unid	equ 0x2A;
seg_dece	equ 0x2B;
min_unid	equ 0x2C;
min_dece	equ 0x2D;
reg_tx		equ 0x2E; Este registro será usado para mover el caracter el cual se quiere transmitir de
					; manera serial.
var_rota	equ 0x2F; Esta variable será usada para limitar el número de bits hasta el cual se realizará
					; la lectura y transmisión del "reg_tx" (Registro de transmisión).

;---------------------------------------------------------------------------------------------------
; Def. de constantes a utilizar.
Tmb	equ	.133;
						; Nota: Los siguientes caractéres deberían estar codificados en hexadecimal,
						; así los piden en el exámen.
num_0	equ	b'00111111';
num_1	equ	b'00000110';
num_2	equ	b'01011011';
num_3	equ	b'01001111';
num_4	equ	b'01100110';
num_5	equ	b'01101101';
num_6	equ	b'01111101';
num_7	equ	b'00000111';
num_8	equ	b'01111111';
num_9	equ	b'01101111';
;---------------------------------------------------------------------------------------------------
band_int	equ .0;
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

progb equ b'11111111'; // Programacion inicial del puerto B.

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
DATA_TX		equ .0;
SH_CP# 		equ .1;
ST_CP# 		equ .2;
OE# 		equ .3;
Sin_uso_RD4 equ .4;
Sin_uso_RD5 equ .5;
Sin_uso_RD6 equ .6;
Sin_uso_RD7 equ .7;

progD equ b'11110000'; // Programacion inicial del puerto D donde los bits RD0-RD3 serán empleados
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
			
			clrf portc;
			clrf portd;
			clrf porte;
			clrf portb;
			;					Estado inicial de las señales de control del hardware, recordar que
			bsf portd,SH_CP#;	son de activo bajo.
			bsf portd,ST_CP#;
			bcf portd,OE#;
			
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

			bsf banderas,band_int;

sal_rutint 	bcf intcon,t0if;
			
			return;
;--------------------------------------------------------------------------------------------------
Conv_7seg	addwf pcl,f;	Se añade al pcl el contenido de w, para que salte las siguientes columnas
					   ;	hasta donde se seleccione.
			retlw num_0;	Regresa de la subrutina actual cargando a w con el elemento 1 de la lista.
			retlw num_1;	.
			retlw num_2;	.
			retlw num_3;	.	
			retlw num_4;	.
			retlw num_5;	.	
			retlw num_6;	.
			retlw num_7;	.
			retlw num_8;	.
			retlw num_9;	Regresa de la subrutina actual cargando a w con el elemento 10 de la lista.
			nop;
			
			return;
;-------------------------------------------------------------------------------------------------
			;=====================
			;== Programa principal ==
			;=====================

prog_prin 	call prog_ini;
			org 0x0100;				Dirección empleada para no entrar en conflicto con la operación
								;	del pcl en el empleo de las listas.
Loop_prin 	call contador;
			call Print_7seg;
			call esp_1s;
			goto Loop_prin;
;-------------------------------------------------------------------------------------------------
esp_1s		bcf banderas,band_int; 	Limpia la bandera que espera a la interrupción de 1s.
loop_int	nop;
			btfss banderas,band_int;Testea que la bandera de interrupción se halla encendido, si no,
			goto loop_int;			salta al "loop_int"; sí si, limpia la bandera y regresa al punto
			bcf banderas,band_int;	donde fué llamada la subrutina.
			return;
;-------------------------------------------------------------------------------------------------
contador	incf seg_unid,f;
			movlw .10;
			xorwf seg_unid,w;
			btfss status,z;
			return;
			clrf seg_unid;
			
			incf seg_dece,f;
			movlw .6;
			xorwf seg_dece,w;
			btfss status,z;
			return;
			clrf seg_unid;
			clrf seg_dece;
			
			incf min_unid,f;
			movlw .10;
			xorwf min_unid,w;
			btfss status,z;
			return;
			clrf seg_unid;
			clrf seg_dece;
			clrf min_unid;
			
			incf min_dece,f;
			movlw .6;
			xorwf min_dece,w;
			btfss status,z;
			return;
			clrf seg_unid;
			clrf seg_dece;
			clrf min_unid;
			clrf min_dece;
			return;
;-------------------------------------------------------------------------------------------------
Print_7seg	movf seg_unid,w;	Se mueve el contenido del registro seg_unid a w.
			call Conv_7seg;		Se llama a la subrutina Conv_7seg.
			movwf reg_tx;		Mueve el resultado de la anterior subrutina, contenido en w, al
						;		registro de transmisión (reg_tx).
			call transmision;	
			
			movf seg_dece,w;
			call Conv_7seg;
			movwf reg_tx;
			call transmision;
			
			movf min_unid,w;
			call Conv_7seg;
			movwf reg_tx;
			call transmision;
			
			movf min_dece,w;
			call Conv_7seg;
			movwf reg_tx;
			call transmision;
			nop;
			return;
;-------------------------------------------------------------------------------------------------
transmision clrf var_rota;		Inicializa en 0 la variable de rotción o lectura.
			
loop_tx		movlw .8;			Testea si la variable de rotación ha incrementado hasta 8, si es así,
			xorwf var_rota,w;	va a la etiqueta end_tx, si no, hace un salto de linea.
			btfsc status,z;
			goto end_tx;
			
			rlf reg_tx,f;		Hace una rotación hacia la izquierda en el reg_tx.
			btfss status,c;		Testea el bit que halla saltado al carry para determinar si envía un 0 o 1
			goto send_0;		a la transmisión.
			goto send_1;
			
send_0		bcf portd,DATA_TX;
			goto carga;

send_1		bsf portd,DATA_TX;
			goto carga;
						
carga		bcf portd,SH_CP#;
			nop;
			bsf portd,SH_CP#;
			
			bcf portd,ST_CP#;
			nop;
			bsf portd,ST_CP#;

			incf var_rota,f;
			goto loop_tx;
end_tx		clrf var_rota;
			return;
;-------------------------------------------------------------------------------------------------
			end