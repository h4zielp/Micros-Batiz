			;INSTITUTO POLITECNICO NACIONAL.
			;CECYT 9 JUAN DE DIOS BATIZ.
;
	;PRACTICA: 3
	;Control de displays por micro controlador.
;
	;GRUPO: 5IM1. 				EQUIPO: 2
;
				;INTEGRANTES:
		;1.- MARTINEZ OSORIO MIGUEL ANGEL
		;2.- LOPEZ LOPEZ DAVID ISAI
		;3.- PUENTE CASTRO DILAN HAZIEL
		;4.- RAMIREZ VALENCIA ENRIQUE
;
; COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA: ESTE PROGRAMA PRESENTARÁ LA PORTADA DE LA PRÁCTICA
; MEDIANTE EL USO DE DISPLAYS DE 7 SEGMENTOS Y LA PROGRAMACIÓN DEL PIC16F877A
;---------------------------------------------------------------------------------------------

 list P=16F877A;
 #include "C:\Archivos de Programa\Microchip\MPASM Suite\P16F877A.INC"
 

;Bits de configuración.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;ALL
;---------------------------------------------------------------------------------------------
;
; fosc = 4 MHz.
; Ciclo de trabajo del PIC = (1/fosc)*4 = 1 µs.
;---------------------------------------------------------------------------------------------
;
			; Registros de propósito general Banco 0 de memoria RAM.
;
			; Registros propios de estructura del programa.
; Variables.
Contador1 equ 0x20; //
Contador2 equ 0x21; //
Contador3 equ 0x22; //
;---------------------------------------------------------------------------------------------
;
;Constantes de tiempo.
M equ .8;
N equ .255;
L equ .255;
;---------------------------------------------------------------------------------------------
;
;Constantes Alpha-numéricas
;
NULL	equ b'00000000';
A	equ	b'01110111';
bb	equ	b'01111100';
C_1	equ	b'00111001';
c_0	equ	b'01011000';
dd	equ	b'01011110';
E	equ	b'01111001';
FF	equ	b'01110001';
H	equ	b'01110110';
hh	equ	b'01110100';
i	equ	b'00010000';
J	equ	b'00011110';
LL	equ	b'00111000';
NNN	equ	b'00110111';
nn	equ	b'01010100';
ñ	equ	b'01010101';
o	equ	b'01011100';
PP	equ	b'01110011';
rr	equ	b'01010000';
t	equ	b'01111000';
U	equ	b'00111110';
uu	equ	b'00011100';
y	equ	b'01101110';
cero_0		equ	b'00111111';
uno_1		equ	b'00000110';
dos_2		equ	b'01011011';
tres_3		equ	b'01001111';
cuatro_4	equ	b'01100110';
cinco_5		equ	b'01101101';
seis_6		equ	b'01111101';
siete_7		equ	b'00000111';
ocho_8		equ	b'01111111';
nueve_9		equ	b'01101111';
;---------------------------------------------------------------------------------------------
;
			;Asignación de los bits de los puertos de I/O.

;Puerto A.	porta
Sin_UsoRA0 equ .0; // Sin Uso RA0.
Sin_UsoRA1 equ .1; // Sin Uso RA1.
Sin_UsoRA2 equ .2; // Sin Uso RA2.
Sin_UsoRA3 equ .3; // Sin Uso RA3.
Sin_UsoRA4 equ .4; // Sin Uso RA4.
Sin_UsoRA5 equ .5; // Sin Uso RA5..

proga equ b'111111'; // Programación inicial del puerto A como entradas.

;Puerto B.	portb
a_RB0 	equ .0; // Segmento a proveniente de RB0.
b_RB1 	equ .1; // Segmento b proveniente de RB1.
c_RB2 	equ .2; // Segmento c proveniente de RB2.
d_RB3 	equ .3; // Segmento d proveniente de RB3.
e_RB4 	equ .4; // Segmento e proveniente de RB4.
f_RB5 	equ .5; // Segmento f proveniente de RB5.
g_RB6 	equ .6; // Segmento g proveniente de RB6.
dp_RB7 	equ .7; // Segmento dp proveniente de RB7.

progb equ b'00000000'; // Programación inicial del puerto B como BUS de segmentos. Salidas.

;Puerto C.	portc
CLK_RE0_RC0 equ .0; // Salida CLK del Registro Externo 0 proveniente de RC0.
CLK_RE1_RC1 equ .1; // Salida CLK del Registro Externo 1 proveniente de RC1.
CLK_RE2_RC2 equ .2; // Salida CLK del Registro Externo 2 proveniente de RC2.
CLK_RE3_RC3 equ .3; // Salida CLK del Registro Externo 3 proveniente de RC3.
CLK_RE4_RC4 equ .4; // Salida CLK del Registro Externo 4 proveniente de RC4.
CLK_RE5_RC5 equ .5; // Salida CLK del Registro Externo 5 proveniente de RC5.
CLK_RE6_RC6 equ .6; // Salida CLK del Registro Externo 6 proveniente de RC6.
CLK_RE7_RC7 equ .7; // Salida CLK del Registro Externo 7 proveniente de RC7.

progc equ b'00000000'; // Programación inicial del puerto C como BUS de control. Salidas.

;Puerto D.	portd
Sin_UsoRD0 equ .0; // Sin Uso RD0.
Sin_UsoRD1 equ .1; // Sin Uso RD1.
Sin_UsoRD2 equ .2; // Sin Uso RD2.
Sin_UsoRD3 equ .3; // Sin Uso RD3.
Sin_UsoRD4 equ .4; // Sin Uso RD4.
Sin_UsoRD5 equ .5; // Sin Uso RD5.
Sin_UsoRD6 equ .6; // Sin Uso RD6.
Sin_UsoRD7 equ .7; // Sin Uso RD7.

progd equ b'11111111'; // Programación inicial del puerto D como entradas.

;Puerto E.	porte
Sin_UsoRE0 	equ .0; // Sin Uso RE0.
Sin_UsoRE1 	equ .1; // Sin Uso RE1.
Sin_UsoRE2 	equ .2; // Sin Uso RE2.

proge equ b'111'; // Programación inicial del puerto E.
;---------------------------------------------------------------------------------------------
			; ================
			; == Vector Reset ==
			; ================
			org 0x0000;
vec_reset	clrf pclath; Asegura la página cero de la memoria de prog.
			goto prog_prin;
;---------------------------------------------------------------------------------------------

			; ============================
			; == Vector de interrupción ==
			; ============================
			org 0x0004;
vec_int		Nop;

			Retfie;
;----------------------------------------------------------------------------------------------
			; ===========================
			; == Subrutina de inicio ==
			; ===========================
prog_ini	bsf status,rp0; selec. el bco. 1 de ram
			movlw 0x81;
			movwf option_reg ^0x80;
			movlw proga; w <-- b'111111'
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
			movwf adcon1 ^0x80;conf. el pto. a como salidas i/o.
			bcf status,rp0;

            
			return;

;---------------------------------------------------------------------------------------------

			; ===========================
			; == Programa principal =====
			; ===========================

prog_prin	call prog_ini;

loop_prin	bsf portc,CLK_RE0_RC0;-|
			bsf portc,CLK_RE1_RC1;-|
			bsf portc,CLK_RE2_RC2;-|
			bsf portc,CLK_RE3_RC3;-|--->Pone en 1 la salida de los bits del puerto c.
			bsf portc,CLK_RE4_RC4;-|
			bsf portc,CLK_RE5_RC5;-|
			bsf portc,CLK_RE6_RC6;-|
			bsf portc,CLK_RE7_RC7;-|


;Primera Palabra						1N5t1tUt

			movlw uno_1;				Genera la constante uno_1 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;1

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;N

			movlw cinco_5;				Genera la constante cinco_5 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;5

			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;t

			movlw uno_1;				Genera la constante uno_1 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;1

			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;t

			movlw U;					Genera la constante U y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;U

			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;t
			
			call retardo;
			
;Segunda Palabra						P0L1tECN

			movlw PP;					Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;P

			movlw cero_0;				Genera la constante cero_0 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;0

			movlw LL;					Genera la constante L y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;L

			movlw uno_1;				Genera la constante uno_1 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;1

			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;t

			movlw E;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;E

			movlw C_1;					Genera la constante C y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;C
			
			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;N			

			call retardo;

;Tercera Palabra						NAC10NAL

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;N

			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;A

			movlw C_1;					Genera la constante C y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;C

			movlw uno_1;				Genera la constante uno_1 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;1

			movlw cero_0;				Genera la constante cero_0 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;0

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;N

			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;A
			
			movlw LL;					Genera la constante L y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;L			

			call retardo;
			
;Cuarta Palabra							CECyt_9_

			movlw C_1;					Genera la constante C y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;C

			movlw E;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;E

			movlw C_1;					Genera la constante C y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;C

			movlw y;					Genera la constante y y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;y

			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;t

			movlw NULL;					Genera la constante NULL y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;NULL

			movlw nueve_9;				Genera la constante 9 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;9
			
			movlw NULL;					Genera la constante NULL y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;NULL			

			call retardo;


;Cinco Palabra							JUAN_dE_

			movlw J;					Genera la constante J y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;J

			movlw U;					Genera la constante U y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;U

			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;A

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;N

			movlw NULL;					Genera la constante NULL y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;NULL

			movlw dd;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;d

			movlw E;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;E
			
			movlw NULL;					Genera la constante NULL y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;NULL			

			call retardo;

;Sexta Palabra							d105_bAt

			movlw dd;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;d

			movlw uno_1;				Genera la constante uno_1 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;1

			movlw o;					Genera la constante o y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;o

			movlw cinco_5;				Genera la constante cinco_5 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;5

			movlw NULL;					Genera la constante NULL y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;NULL

			movlw bb;					Genera la constante b y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;b

			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;A
			
			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;t			

			call retardo;


;Septima Palabra						PrActicA

			movlw PP;					Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;P

			movlw rr;					Genera la constante r y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;r

			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;A

			movlw c_0;					Genera la constante c y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;c

			movlw t;					Genera la constante t y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;t

			movlw i;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;i

			movlw c_0;					Genera la constante c y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;c
			
			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;A			

			call retardo;


;Octava Palabra							3_NNAniP

			movlw tres_3;				Genera la constante 3 y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;3

			movlw NULL;					Genera la constante NULL y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;NULL

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;N

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;N

			movlw A;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;A

			movlw NNN;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;N

			movlw i;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;i
			
			movlw PP;					Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;P			
			call retardo;

;Novena Palabra							dE_di5P1

			movlw dd;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;d

			movlw E;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;E

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;NULL

			movlw dd;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;d

			movlw i;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;i

			movlw cinco_5;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;5

			movlw PP;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;P
			
			movlw uno_1;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;1			

			call retardo;


;Decima Palabra							Por_nnic

			movlw pp;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;p

			movlw o;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;o

			movlw rr;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;r

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;_

			movlw nn;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;n

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;n

			movlw i;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;i
			
			movlw c_0;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;c			

			call retardo;

			;Onceava Palabra			controla				

			movlw c_0;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;c

			movlw o;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;o

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;n

			movlw t;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;t

			movlw rr;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;r

			movlw o;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;o

			movlw 1;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;1
			
			movlw A;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;c			

			call retardo;

			;Doceava Palabra			contro1a				

			movlw c_0;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;c

			movlw o;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;o

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;n

			movlw t;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;t

			movlw rr;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;r

			movlw o;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;o

			movlw uno_1;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;1
			
			movlw A;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;c			

			call retardo;

			;Treceava Palabra			6rupo				

			movlw seis_6;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;6

			movlw rr;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;r

			movlw uu;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;u

			movlw pp;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;p

			movlw o;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;o

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Catorceava Palabra			5inn1				

			movlw cinco_5;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;5

			movlw i;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;i

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;n

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;n

			movlw uno_1;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;1

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Quinceava Palabra			Equipo_2				

			movlw E;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;E

			movlw nueve_9;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;9

			movlw uu;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;u

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;i

			movlw pp;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;p

			movlw o;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;o

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw dos_2;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;2			

			call retardo;


			;Dieciseisava Palabra		1ntegran				

			movlw uno_1;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;1

			movlw nn;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;n

			movlw t;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;t

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;e

			movlw seis_6;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;6

			movlw rr;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;r

			movlw A;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;a
			
			movlw nn;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;n			

			call retardo;


			;Diecisieteava Palabra		nnaRtinE				

			movlw nn;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;n

			movlw nn;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;n

			movlw A;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;a

			movlw rr;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;r

			movlw t;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;t

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;i

			movlw nn;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;n
			
			movlw E;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;e			

			call retardo;


			;Diesciochoava Palabra		o5oRio				

			movlw o;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;o

			movlw cinco_5;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;5

			movlw o;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;o

			movlw rr;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;R

			movlw i;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;i

			movlw o;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;o

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Diesinueveava Palabra		nni6ue1				

			movlw nn;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;n

			movlw nn;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;n

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;i

			movlw seis_6;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;6

			movlw uu;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;u

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;E

			movlw uno_1;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;1
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;
			;Treceava Palabra			An6e1				

			movlw A;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;A

			movlw nn;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;n

			movlw seis_6;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;6

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;E

			movlw uno_1;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;1

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veinteava Palabra			LoPE2				

			movlw LL;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;L

			movlw o;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;o

			movlw pp;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;p

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;E

			movlw dos_2;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;2

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veinteunava Palabra			1oPE2				

			movlw LL;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;L

			movlw o;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;o

			movlw pp;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;p

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;E

			movlw dos_2;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;2

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veintedosava Palabra			dAuid				

			movlw dd;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;d

			movlw A;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;A

			movlw uu;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;u

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;i

			movlw dd;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;d

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veintitresava Palabra			i5Ai				

			movlw i;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;i

			movlw cinco_5;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;5

			movlw A;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;A

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;i

			movlw NULL;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;_

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veintecuatroava Palabra			PuEntE				

			movlw pp;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;p

			movlw uu;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;u

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;E

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;n

			movlw t;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;t

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;E

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veinticincoava Palabra			CA5tRo				

			movlw C_1;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;C

			movlw A;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;A

			movlw cinco_5;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;5

			movlw t;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;t

			movlw rr;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;R

			movlw o;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;o

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veintiseisava Palabra			di1An				

			movlw dd;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;d

			movlw i;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;i

			movlw uno_1;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;1

			movlw A;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;A

			movlw nn;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;n

			movlw NULL;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;_

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veintisieteava Palabra			HA2iE1				

			movlw H;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;H

			movlw A;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;A

			movlw dos_2;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;2

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;i

			movlw E;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;E

			movlw uno_1;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;1

			movlw NULL;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;_
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;


			;Veintiochoava Palabra			RAnniRE2				

			movlw rr;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;R

			movlw A;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;A

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;n

			movlw nn;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;n

			movlw i;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;i

			movlw rr;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;r

			movlw E;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;E
			
			movlw dos_2;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;2			

			call retardo;


			;Veintenueveava Palabra			uA1EnciA				

			movlw uu;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;u

			movlw A;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;A

			movlw uno_1;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;1

			movlw E;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;E

			movlw nn;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;n

			movlw c_0;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;c

			movlw i;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;i
			
			movlw A;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;A			

			call retardo;


			;Treintava Palabra			EnRi9uE				

			movlw E;					Genera la constante d y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE0_RC0;		Pone en 0 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE0_RC0;		Pone en 1 la salida del bit 0 del puerto c (CLK_RE0_RC0).-|
			;E

			movlw nn;					Genera la constante E y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE1_RC1;		Pone en 0 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE1_RC1;		Pone en 1 la salida del bit 1 del puerto c (CLK_RE1_RC1).-|
			;n

			movlw rr;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE2_RC2;		Pone en 0 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE2_RC2;		Pone en 1 la salida del bit 2 del puerto c (CLK_RE2_RC2).-|
			;R

			movlw i;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE3_RC3;		Pone en 0 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE3_RC3;		Pone en 1 la salida del bit 3 del puerto c (CLK_RE3_RC3).-|
			;i

			movlw nueve_9;					Genera la constante A y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE4_RC4;		Pone en 0 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE4_RC4;		Pone en 1 la salida del bit 4 del puerto c (CLK_RE4_RC4).-|
			;9

			movlw uu;					Genera la constante N y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE5_RC5;		Pone en 0 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE5_RC5;		Pone en 1 la salida del bit 5 del puerto c (CLK_RE5_RC5).-|
			;u

			movlw E;					Genera la constante i y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE6_RC6;		Pone en 0 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE6_RC6;		Pone en 1 la salida del bit 6 del puerto c (CLK_RE6_RC6).-|
			;E
			
			movlw NULL;				Genera la constante P y la carga al registro de trabajo (w).
			movwf portb;				Carga el dato del registro w al puerto b.
			bcf portc,CLK_RE7_RC7;		Pone en 0 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
																								;--}-->	Genera un pulso bajo de 1us.		
			bsf portc,CLK_RE7_RC7;		Pone en 1 la salida del bit 7 del puerto c (CLK_RE7_RC7).-|
			;_			

			call retardo;
			goto loop_prin;
;---------------------------------------------------------------------------------------------
			; ===========================================
			; == Subrutina de retardo de medio segundo ==
			; ===========================================

retardo 	movlw M;
			movwf Contador3;
Loop3		movlw N;
			movwf Contador2;
Loop2		movlw L;
			movwf Contador1;
Loop1 		decfsz Contador1,f;
			goto Loop1;
			decfsz Contador2,f;
			goto Loop2;
			decfsz Contador3,f;
			goto Loop3;
			return;
;---------------------------------------------------------------------------------------------
		end