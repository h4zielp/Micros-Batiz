			;INSTITUTO POLITECNICO NACIONAL.
			;CECYT 9 JUAN DE DIOS BATIZ.
;
	;PRACTICA: 4
	;Control de displays por TDM
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
 ;#include "C:\Archivos de Programa\Microchip\MPASM Suite\P16F877A.INC"
 #include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC";

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
Contador4 equ 0x23; //
;---------------------------------------------------------------------------------------------
;
;Constantes de tiempo.
M equ .45;
N equ .255;

L equ .3;
K equ .126;
;---------------------------------------------------------------------------------------------
;
;Constantes Alpha-numéricas
;
NULL	equ b'00000000';
car_A	equ	b'01110111';
car_b	equ	b'01111100';
car_C	equ	b'00111001';
car_cc	equ	b'01011000';
car_d	equ	b'01011110';
car_E	equ	b'01111001';
car_F	equ	b'01110001';
car_H	equ	b'01110110';
car_hh	equ	b'01110100';
car_i	equ	b'00010000';
car_J	equ	b'00011110';
car_L	equ	b'00111000';
car_N	equ	b'00110111';
car_nn	equ	b'01010100';
car_ñ	equ	b'01010101';
car_o	equ	b'01011100';
car_P	equ	b'01110011';
car_r	equ	b'01010000';
car_t	equ	b'01111000';
car_U	equ	b'00111110';
car_uu	equ	b'00011100';
car_y	equ	b'01101110';
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
;---------------------------------------------------------------------------------------------
;
			;Asignación de los bits de los puertos de I/O.

;Puerto A.	porta
Sin_UsoRA0 equ .0; // Sin Uso RA0.
Sin_UsoRA1 equ .1; // Sin Uso RA1.
Sin_UsoRA2 equ .2; // Sin Uso RA2.
Sin_UsoRA3 equ .3; // Sin Uso RA3.
Sin_UsoRA4 equ .4; // Sin Uso RA4.
Sin_UsoRA5 equ .5; // Sin Uso RA5.

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
Sin_UsoRC0 equ .0; // Sin Uso RC0.
Sin_UsoRC1 equ .1; // Sin Uso RC1.
Sin_UsoRC2 equ .2; // Sin Uso RC2.
Sin_UsoRC3 equ .3; // Sin Uso RC3.
Sin_UsoRC4 equ .4; // Sin Uso RC4.
Sin_UsoRC5 equ .5; // Sin Uso RC5.
Sin_UsoRC6 equ .6; // Sin Uso RC6.
Sin_UsoRC7 equ .7; // Sin Uso RC7.

progc equ b'11111111'; // Programación inicial del puerto C como entradas.

;Puerto D.	portd
DIS0 equ .0; // Salida CLK del Registro Externo 0 proveniente de RC0.
DIS1 equ .1; // Salida CLK del Registro Externo 1 proveniente de RC1.
DIS2 equ .2; // Salida CLK del Registro Externo 2 proveniente de RC2.
DIS3 equ .3; // Salida CLK del Registro Externo 3 proveniente de RC3.
DIS4 equ .4; // Salida CLK del Registro Externo 4 proveniente de RC4.
DIS5 equ .5; // Salida CLK del Registro Externo 5 proveniente de RC5.
DIS6 equ .6; // Salida CLK del Registro Externo 6 proveniente de RC6.
DIS7 equ .7; // Salida CLK del Registro Externo 7 proveniente de RC7.

progd equ b'0000000'; // Programación inicial del puerto D como entradas.

;Puerto E.	porte
Sin_UsoRE0 	equ .0; // Sin Uso RE0.
Sin_UsoRE1 	equ .1; // Sin Uso RE1.
Sin_UsoRE2 	equ .2; // Sin Uso RE2.

proge equ b'111'; // Programación inicial del puerto E.
;---------------------------------------------------------------------------------------------
			; ==================
			; == Vector Reset ==
			; ==================
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
			
			call lLimpieza_pg0;
			
			return;

;---------------------------------------------------------------------------------------------

			; ==========================
			; === Programa principal ===
			; ==========================
			
prog_prin	call prog_ini;
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm1		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw NULL;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw NULL;
			call lP0_DIS6;

			movlw num_1;
			call lP0_DIS7;		
			
Loop1		decfsz Contador2,f;
			goto Loop1;
			decfsz Contador1,f;
			goto Ftgrm1;
			
			call lLimpieza_pg0;

;---------- Ftgm2 --------- _ _ _ _ _ 1 N

		 	movlw M;
			movwf Contador1;
Ftgrm2		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw NULL;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw num_1;
			call lP0_DIS6;

			movlw car_N;
			call lP0_DIS7;		
			
Loop2		decfsz Contador2,f;
			goto Loop2;
			decfsz Contador1,f;
			goto Ftgrm2;
			
			call lLimpieza_pg0;

;---------- Ftgm3 --------- _ _ _ _ _ 1 N 5

		 	movlw M;
			movwf Contador1;
Ftgrm3		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw NULL;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw num_1;
			call lP0_DIS5;

			movlw car_N;
			call lP0_DIS6;

			movlw num_5;
			call lP0_DIS7;		
			
Loop3		decfsz Contador2,f;
			goto Loop3;
			decfsz Contador1,f;
			goto Ftgrm3;
			
			call lLimpieza_pg0;

;---------- Ftgm4 --------- _ _ _ 1 N 5 t

		 	movlw M;
			movwf Contador1;
Ftgrm4		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw NULL;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw num_1;
			call lP0_DIS4;

			movlw car_N;
			call lP0_DIS5;

			movlw num_5;
			call lP0_DIS6;

			movlw car_t;
			call lP0_DIS7;		
			
Loop4		decfsz Contador2,f;
			goto Loop4;
			decfsz Contador1,f;
			goto Ftgrm4;
			
			call lLimpieza_pg0;

;---------- Ftgm5 --------- _ _ _ 1 N 5 t 1

		 	movlw M;
			movwf Contador1;
Ftgrm5		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw NULL;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw num_1;
			call lP0_DIS3;

			movlw car_N;
			call lP0_DIS4;

			movlw num_5;
			call lP0_DIS5;

			movlw car_t;
			call lP0_DIS6;

			movlw num_1;
			call lP0_DIS7;	
			
Loop5		decfsz Contador2,f;
			goto Loop5;
			decfsz Contador1,f;
			goto Ftgrm5;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm6		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw NULL;
			call lP0_DIS1;

			movlw num_1;
			call lP0_DIS2;

			movlw car_N;
			call lP0_DIS3;

			movlw num_5;
			call lP0_DIS4;

			movlw car_t;
			call lP0_DIS5;

			movlw num_1;
			call lP0_DIS6;

			movlw car_t;
			call lP0_DIS7;		
			
Loop6		decfsz Contador2,f;
			goto Loop6;
			decfsz Contador1,f;
			goto Ftgrm6;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm7		movlw N;
			movwf Contador2;
			
			movlw NULL;
			call lP0_DIS0;
			
			movlw num_1;
			call lP0_DIS1;

			movlw car_N;
			call lP0_DIS2;

			movlw num_5;
			call lP0_DIS3;

			movlw car_t;
			call lP0_DIS4;

			movlw num_1;
			call lP0_DIS5;

			movlw car_t;
			call lP0_DIS6;

			movlw car_U;
			call lP0_DIS7;		
			
Loop7		decfsz Contador2,f;
			goto Loop7;
			decfsz Contador1,f;
			goto Ftgrm7;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm8		movlw N;
			movwf Contador2;
			
			movlw num_1;
			call lP0_DIS0;
			
			movlw car_N;
			call lP0_DIS1;

			movlw num_5;
			call lP0_DIS2;

			movlw car_t;
			call lP0_DIS3;

			movlw num_1;
			call lP0_DIS4;

			movlw car_t;
			call lP0_DIS5;

			movlw car_U;
			call lP0_DIS6;

			movlw car_t;
			call lP0_DIS7;		
			
Loop8		decfsz Contador2,f;
			goto Loop8;
			decfsz Contador1,f;
			goto Ftgrm8;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm9		movlw N;
			movwf Contador2;
			
			movlw car_N;
			call lP0_DIS0;

			movlw num_5;
			call lP0_DIS1;

			movlw car_t;
			call lP0_DIS2;

			movlw num_1;
			call lP0_DIS3;

			movlw car_t;
			call lP0_DIS4;

			movlw car_U;
			call lP0_DIS5;

			movlw car_t;
			call lP0_DIS6;

			movlw num_0;
			call lP0_DIS7;	
			
Loop9		decfsz Contador2,f;
			goto Loop9;
			decfsz Contador1,f;
			goto Ftgrm9;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm10		movlw N;
			movwf Contador2;
			
			movlw num_5;
			call lP0_DIS0;

			movlw car_t;
			call lP0_DIS1;

			movlw num_1;
			call lP0_DIS2;

			movlw car_t;
			call lP0_DIS3;

			movlw car_U;
			call lP0_DIS4;

			movlw car_t;
			call lP0_DIS5;

			movlw num_0;
			call lP0_DIS6;

			movlw NULL;
			call lP0_DIS7;	
			
Loop10		decfsz Contador2,f;
			goto Loop10;
			decfsz Contador1,f;
			goto Ftgrm10;
			
			call lLimpieza_pg0;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm11		movlw N;
			movwf Contador2;
			
			movlw car_t;
			call lP0_DIS0;

			movlw num_1;
			call lP0_DIS1;

			movlw car_t;
			call lP0_DIS2;

			movlw car_U;
			call lP0_DIS3;

			movlw car_t;
			call lP0_DIS4;

			movlw num_0;
			call lP0_DIS5;

			movlw NULL;
			call lP0_DIS6;

			movlw car_P;
			call lP0_DIS7;
			
Loop11		decfsz Contador2,f;
			goto Loop11;
			decfsz Contador1,f;
			goto Ftgrm11;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm12		movlw N;
			movwf Contador2;
			
			movlw num_1;
			call lP0_DIS0;

			movlw car_t;
			call lP0_DIS1;

			movlw car_U;
			call lP0_DIS2;

			movlw car_t;
			call lP0_DIS3;

			movlw num_0;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw car_P;
			call lP0_DIS6;

			movlw num_0;
			call lP0_DIS7;
			
Loop12		decfsz Contador2,f;
			goto Loop12;
			decfsz Contador1,f;
			goto Ftgrm12;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm13		movlw N;
			movwf Contador2;
			
			movlw car_t;
			call lP0_DIS0;

			movlw car_U;
			call lP0_DIS1;

			movlw car_t;
			call lP0_DIS2;

			movlw num_0;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw car_P;
			call lP0_DIS5;

			movlw num_0;
			call lP0_DIS6;

			movlw car_L;
			call lP0_DIS7;
			
Loop13		decfsz Contador2,f;
			goto Loop13;
			decfsz Contador1,f;
			goto Ftgrm13;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm14		movlw N;
			movwf Contador2;
			
			movlw car_U;
			call lP0_DIS0;

			movlw car_t;
			call lP0_DIS1;

			movlw num_0;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw car_P;
			call lP0_DIS4;

			movlw num_0;
			call lP0_DIS5;

			movlw car_L;
			call lP0_DIS6;

			movlw num_1;
			call lP0_DIS7;
			
Loop14		decfsz Contador2,f;
			goto Loop14;
			decfsz Contador1,f;
			goto Ftgrm14;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm15		movlw N;
			movwf Contador2;
			
			movlw car_t;
			call lP0_DIS0;

			movlw num_0;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw car_P;
			call lP0_DIS3;

			movlw num_0;
			call lP0_DIS4;

			movlw car_L;
			call lP0_DIS5;

			movlw num_1;
			call lP0_DIS6;

			movlw car_t;
			call lP0_DIS7;
			
Loop15		decfsz Contador2,f;
			goto Loop15;
			decfsz Contador1,f;
			goto Ftgrm15;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm16		movlw N;
			movwf Contador2;

			movlw num_0;
			call lP0_DIS0;

			movlw NULL;
			call lP0_DIS1;

			movlw car_P;
			call lP0_DIS2;

			movlw num_0;
			call lP0_DIS3;

			movlw car_L;
			call lP0_DIS4;

			movlw num_1;
			call lP0_DIS5;

			movlw car_t;
			call lP0_DIS6;

			movlw car_E;
			call lP0_DIS7;
			
Loop16		decfsz Contador2,f;
			goto Loop16;
			decfsz Contador1,f;
			goto Ftgrm16;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm17		movlw N;
			movwf Contador2;

			movlw NULL;
			call lP0_DIS0;

			movlw car_P;
			call lP0_DIS1;

			movlw num_0;
			call lP0_DIS2;

			movlw car_L;
			call lP0_DIS3;

			movlw num_1;
			call lP0_DIS4;

			movlw car_t;
			call lP0_DIS5;

			movlw car_E;
			call lP0_DIS6;
			
			movlw car_C;
			call lP0_DIS7;

Loop17		decfsz Contador2,f;
			goto Loop17;
			decfsz Contador1,f;
			goto Ftgrm17;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm18		movlw N;
			movwf Contador2;

			movlw car_P;
			call lP0_DIS0;

			movlw num_0;
			call lP0_DIS1;

			movlw car_L;
			call lP0_DIS2;

			movlw num_1;
			call lP0_DIS3;

			movlw car_t;
			call lP0_DIS4;

			movlw car_E;
			call lP0_DIS5;
			
			movlw car_C;
			call lP0_DIS6;

			movlw car_N;
			call lP0_DIS7;

Loop18		decfsz Contador2,f;
			goto Loop18;
			decfsz Contador1,f;
			goto Ftgrm18;
			
			call lLimpieza_pg0;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm19		movlw N;
			movwf Contador2;

			movlw num_0;
			call lP0_DIS0;

			movlw car_L;
			call lP0_DIS1;

			movlw num_1;
			call lP0_DIS2;

			movlw car_t;
			call lP0_DIS3;

			movlw car_E;
			call lP0_DIS4;
			
			movlw car_C;
			call lP0_DIS5;

			movlw car_N;
			call lP0_DIS6;

			movlw num_1;
			call lP0_DIS7;

Loop19		decfsz Contador2,f;
			goto Loop19;
			decfsz Contador1,f;
			goto Ftgrm19;
			
			call lLimpieza_pg0;
			
;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm20		movlw N;
			movwf Contador2;

			movlw car_L;
			call lP0_DIS0;

			movlw num_1;
			call lP0_DIS1;

			movlw car_t;
			call lP0_DIS2;

			movlw car_E;
			call lP0_DIS3;
			
			movlw car_C;
			call lP0_DIS4;

			movlw car_N;
			call lP0_DIS5;

			movlw num_1;
			call lP0_DIS6;
			
			movlw car_C;
			call lP0_DIS7;

Loop20		decfsz Contador2,f;
			goto Loop20;
			decfsz Contador1,f;
			goto Ftgrm20;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm21		movlw N;
			movwf Contador2;

			movlw num_1;
			call lP0_DIS0;

			movlw car_t;
			call lP0_DIS1;

			movlw car_E;
			call lP0_DIS2;
			
			movlw car_C;
			call lP0_DIS3;

			movlw car_N;
			call lP0_DIS4;

			movlw num_1;
			call lP0_DIS5;
			
			movlw car_C;
			call lP0_DIS6;

			movlw num_0;
			call lP0_DIS7;

Loop21		decfsz Contador2,f;
			goto Loop21;
			decfsz Contador1,f;
			goto Ftgrm21;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm22		movlw N;
			movwf Contador2;

			movlw car_t;
			call lP0_DIS0;

			movlw car_E;
			call lP0_DIS1;
			
			movlw car_C;
			call lP0_DIS2;

			movlw car_N;
			call lP0_DIS3;

			movlw num_1;
			call lP0_DIS4;
			
			movlw car_C;
			call lP0_DIS5;

			movlw num_0;
			call lP0_DIS6;

			movlw NULL;
			call lP0_DIS7;

Loop22		decfsz Contador2,f;
			goto Loop22;
			decfsz Contador1,f;
			goto Ftgrm22;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm23		movlw N;
			movwf Contador2;

			movlw car_E;
			call lP0_DIS0;
			
			movlw car_C;
			call lP0_DIS1;

			movlw car_N;
			call lP0_DIS2;

			movlw num_1;
			call lP0_DIS3;
			
			movlw car_C;
			call lP0_DIS4;

			movlw num_0;
			call lP0_DIS5;

			movlw NULL;
			call lP0_DIS6;

			movlw car_N;
			call lP0_DIS7;

Loop23		decfsz Contador2,f;
			goto Loop23;
			decfsz Contador1,f;
			goto Ftgrm23;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm24		movlw N;
			movwf Contador2;
		
			movlw car_C;
			call lP0_DIS0;

			movlw car_N;
			call lP0_DIS1;

			movlw num_1;
			call lP0_DIS2;
			
			movlw car_C;
			call lP0_DIS3;

			movlw num_0;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw car_N;
			call lP0_DIS6;

			movlw car_A;
			call lP0_DIS7;

Loop24		decfsz Contador2,f;
			goto Loop24;
			decfsz Contador1,f;
			goto Ftgrm24;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm25		movlw N;
			movwf Contador2;

			movlw car_N;
			call lP0_DIS0;

			movlw num_1;
			call lP0_DIS1;
			
			movlw car_C;
			call lP0_DIS2;

			movlw num_0;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw car_N;
			call lP0_DIS5;

			movlw car_A;
			call lP0_DIS6;

			movlw car_C;
			call lP0_DIS7;

Loop25		decfsz Contador2,f;
			goto Loop25;
			decfsz Contador1,f;
			goto Ftgrm25;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm26		movlw N;
			movwf Contador2;

			movlw num_1;
			call lP0_DIS0;
			
			movlw car_C;
			call lP0_DIS1;

			movlw num_0;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw car_N;
			call lP0_DIS4;

			movlw car_A;
			call lP0_DIS5;

			movlw car_C;
			call lP0_DIS6;

			movlw num_1;
			call lP0_DIS7;

Loop26		decfsz Contador2,f;
			goto Loop26;
			decfsz Contador1,f;
			goto Ftgrm26;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm27		movlw N;
			movwf Contador2;
	
			movlw car_C;
			call lP0_DIS0;

			movlw num_0;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw car_N;
			call lP0_DIS3;

			movlw car_A;
			call lP0_DIS4;

			movlw car_C;
			call lP0_DIS5;

			movlw num_1;
			call lP0_DIS6;

			movlw num_0;
			call lP0_DIS7;

Loop27		decfsz Contador2,f;
			goto Loop27;
			decfsz Contador1,f;
			goto Ftgrm27;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm28		movlw N;
			movwf Contador2;
	
			movlw num_0;
			call lP0_DIS0;

			movlw NULL;
			call lP0_DIS1;

			movlw car_N;
			call lP0_DIS2;

			movlw car_A;
			call lP0_DIS3;

			movlw car_C;
			call lP0_DIS4;

			movlw num_1;
			call lP0_DIS5;

			movlw num_0;
			call lP0_DIS6;

			movlw car_N;
			call lP0_DIS7;

Loop28		decfsz Contador2,f;
			goto Loop28;
			decfsz Contador1,f;
			goto Ftgrm28;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm29		movlw N;
			movwf Contador2;

			movlw NULL;
			call lP0_DIS0;

			movlw car_N;
			call lP0_DIS1;

			movlw car_A;
			call lP0_DIS2;

			movlw car_C;
			call lP0_DIS3;

			movlw num_1;
			call lP0_DIS4;

			movlw num_0;
			call lP0_DIS5;

			movlw car_N;
			call lP0_DIS6;

			movlw car_A;
			call lP0_DIS7;

Loop29		decfsz Contador2,f;
			goto Loop29;
			decfsz Contador1,f;
			goto Ftgrm29;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm30		movlw N;
			movwf Contador2;

			movlw car_N;
			call lP0_DIS0;

			movlw car_A;
			call lP0_DIS1;

			movlw car_C;
			call lP0_DIS2;

			movlw num_1;
			call lP0_DIS3;

			movlw num_0;
			call lP0_DIS4;

			movlw car_N;
			call lP0_DIS5;

			movlw car_A;
			call lP0_DIS6;

			movlw car_L;
			call lP0_DIS7;

Loop30		decfsz Contador2,f;
			goto Loop30;
			decfsz Contador1,f;
			goto Ftgrm30;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm31		movlw N;
			movwf Contador2;

			movlw car_A;
			call lP0_DIS0;

			movlw car_C;
			call lP0_DIS1;

			movlw num_1;
			call lP0_DIS2;

			movlw num_0;
			call lP0_DIS3;

			movlw car_N;
			call lP0_DIS4;

			movlw car_A;
			call lP0_DIS5;

			movlw car_L;
			call lP0_DIS6;

			movlw NULL;
			call lP0_DIS7;

Loop31		decfsz Contador2,f;
			goto Loop31;
			decfsz Contador1,f;
			goto Ftgrm31;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm32		movlw N;
			movwf Contador2;

			movlw car_C;
			call lP0_DIS0;

			movlw num_1;
			call lP0_DIS1;

			movlw num_0;
			call lP0_DIS2;

			movlw car_N;
			call lP0_DIS3;

			movlw car_A;
			call lP0_DIS4;

			movlw car_L;
			call lP0_DIS5;

			movlw NULL;
			call lP0_DIS6;

			movlw car_C;
			call lP0_DIS7;

Loop32		decfsz Contador2,f;
			goto Loop32;
			decfsz Contador1,f;
			goto Ftgrm32;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm33		movlw N;
			movwf Contador2;

			movlw num_1;
			call lP0_DIS0;

			movlw num_0;
			call lP0_DIS1;

			movlw car_N;
			call lP0_DIS2;

			movlw car_A;
			call lP0_DIS3;

			movlw car_L;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw car_C;
			call lP0_DIS6;

			movlw car_E;
			call lP0_DIS7;

Loop33		decfsz Contador2,f;
			goto Loop33;
			decfsz Contador1,f;
			goto Ftgrm33;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm34		movlw N;
			movwf Contador2;

			movlw num_0;
			call lP0_DIS0;

			movlw car_N;
			call lP0_DIS1;

			movlw car_A;
			call lP0_DIS2;

			movlw car_L;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw car_C;
			call lP0_DIS5;

			movlw car_E;
			call lP0_DIS6;

			movlw car_C;
			call lP0_DIS7;

Loop34		decfsz Contador2,f;
			goto Loop34;
			decfsz Contador1,f;
			goto Ftgrm34;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm35		movlw N;
			movwf Contador2;

			movlw car_N;
			call lP0_DIS0;

			movlw car_A;
			call lP0_DIS1;

			movlw car_L;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw car_C;
			call lP0_DIS4;

			movlw car_E;
			call lP0_DIS5;

			movlw car_C;
			call lP0_DIS6;

			movlw car_Y;
			call lP0_DIS7;

Loop35		decfsz Contador2,f;
			goto Loop35;
			decfsz Contador1,f;
			goto Ftgrm35;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm36		movlw N;
			movwf Contador2;

			movlw car_A;
			call lP0_DIS0;

			movlw car_L;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw car_C;
			call lP0_DIS3;

			movlw car_E;
			call lP0_DIS4;

			movlw car_C;
			call lP0_DIS5;

			movlw car_Y;
			call lP0_DIS6;

			movlw car_t;
			call lP0_DIS7;

Loop36		decfsz Contador2,f;
			goto Loop36;
			decfsz Contador1,f;
			goto Ftgrm36;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm37		movlw N;
			movwf Contador2;

			movlw car_L;
			call lP0_DIS0;

			movlw NULL;
			call lP0_DIS1;

			movlw car_C;
			call lP0_DIS2;

			movlw car_E;
			call lP0_DIS3;

			movlw car_C;
			call lP0_DIS4;

			movlw car_Y;
			call lP0_DIS5;

			movlw car_t;
			call lP0_DIS6;

			movlw NULL;
			call lP0_DIS7;

Loop37		decfsz Contador2,f;
			goto Loop37;
			decfsz Contador1,f;
			goto Ftgrm37;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm38		movlw N;
			movwf Contador2;

			movlw NULL;
			call lP0_DIS0;

			movlw car_C;
			call lP0_DIS1;

			movlw car_E;
			call lP0_DIS2;

			movlw car_C;
			call lP0_DIS3;

			movlw car_Y;
			call lP0_DIS4;

			movlw car_t;
			call lP0_DIS5;

			movlw NULL;
			call lP0_DIS6;

			movlw num_9;
			call lP0_DIS7;

Loop38		decfsz Contador2,f;
			goto Loop38;
			decfsz Contador1,f;
			goto Ftgrm38;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm39		movlw N;
			movwf Contador2;

			movlw car_C;
			call lP0_DIS0;

			movlw car_E;
			call lP0_DIS1;

			movlw car_C;
			call lP0_DIS2;

			movlw car_Y;
			call lP0_DIS3;

			movlw car_t;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw num_9;
			call lP0_DIS6;

			movlw NULL;
			call lP0_DIS7;

Loop39		decfsz Contador2,f;
			goto Loop39;
			decfsz Contador1,f;
			goto Ftgrm39;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm40		movlw N;
			movwf Contador2;

			movlw car_E;
			call lP0_DIS0;

			movlw car_C;
			call lP0_DIS1;

			movlw car_Y;
			call lP0_DIS2;

			movlw car_t;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw num_9;
			call lP0_DIS5;

			movlw NULL;
			call lP0_DIS6;

			movlw car_J;
			call lP0_DIS7;

Loop40		decfsz Contador2,f;
			goto Loop40;
			decfsz Contador1,f;
			goto Ftgrm40;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm41		movlw N;
			movwf Contador2;

			movlw car_C;
			call lP0_DIS0;

			movlw car_Y;
			call lP0_DIS1;

			movlw car_t;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw num_9;
			call lP0_DIS4;

			movlw NULL;
			call lP0_DIS5;

			movlw car_J;
			call lP0_DIS6;

			movlw car_U;
			call lP0_DIS7;

Loop41		decfsz Contador2,f;
			goto Loop41;
			decfsz Contador1,f;
			goto Ftgrm41;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm42		movlw N;
			movwf Contador2;

			movlw car_Y;
			call lP0_DIS0;

			movlw car_t;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw num_9;
			call lP0_DIS3;

			movlw NULL;
			call lP0_DIS4;

			movlw car_J;
			call lP0_DIS5;

			movlw car_U;
			call lP0_DIS6;

			movlw car_A;
			call lP0_DIS7;

Loop42		decfsz Contador2,f;
			goto Loop42;
			decfsz Contador1,f;
			goto Ftgrm42;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm43		movlw N;
			movwf Contador2;

			movlw car_t;
			call lP0_DIS0;

			movlw NULL;
			call lP0_DIS1;

			movlw num_9;
			call lP0_DIS2;

			movlw NULL;
			call lP0_DIS3;

			movlw car_J;
			call lP0_DIS4;

			movlw car_U;
			call lP0_DIS5;

			movlw car_A;
			call lP0_DIS6;

			movlw car_N;
			call lP0_DIS7;

Loop43		decfsz Contador2,f;
			goto Loop43;
			decfsz Contador1,f;
			goto Ftgrm43;
			
			call lLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm44		movlw N;
			movwf Contador2;

			movlw NULL;
			call lP0_DIS0;

			movlw num_9;
			call lP0_DIS1;

			movlw NULL;
			call lP0_DIS2;

			movlw car_J;
			call lP0_DIS3;

			movlw car_U;
			call lP0_DIS4;

			movlw car_A;
			call lP0_DIS5;

			movlw car_N;
			call lP0_DIS6;

			movlw NULL;
			call lP0_DIS7;

Loop44		decfsz Contador2,f;
			goto Loop44;
			decfsz Contador1,f;
			goto Ftgrm44;
			
			call lLimpieza_pg0;

			goto pg1;

;--------------------------------------------------------------------------------------------

			;=======================
			;== Limpia displays ====
			;=======================
			
lLimpieza_pg0	bsf	portd,DIS0;
				bsf	portd,DIS1;
				bsf	portd,DIS2;
				bsf	portd,DIS3;
				bsf	portd,DIS4;
				bsf	portd,DIS5;
				bsf	portd,DIS6;
				bsf	portd,DIS7;
			
				bcf portb,a_RB0;
				bcf portb,b_RB1;
				bcf portb,c_RB2;
				bcf portb,d_RB3;
				bcf portb,e_RB4;
				bcf portb,f_RB5;
				bcf portb,g_RB6;
				bcf portb,dp_RB7;
			
				return;
			
;---------------------------------------------------------------------------------------------
			; ====================
			; === Retardo Menor ==
			; ====================
lRmn_pg1	movlw L;
			movwf Contador3;
LoopR11		movlw K;
			movwf Contador4;
			
LoopRB01	decfsz Contador4,f;
			goto LoopRB01;
			decfsz Contador3,f;
			goto LoopR11;

			return;
;---------------------------------------------------------------------------------------------
			;========================
			;=== Pulsos de cambio ===
			;========================
lP0_DIS0	movwf portb;
			bcf portd,DIS0;
			call lRmn_pg1;
			bsf portd,DIS0;
			return;

lP0_DIS1	movwf portb;
			bcf portd,DIS1;
			call lRmn_pg1;
			bsf portd,DIS1;
			return;

lP0_DIS2	movwf portb;
			bcf portd,DIS2;
			call lRmn_pg1;
			bsf portd,DIS2;
			return;

lP0_DIS3	movwf portb;
			bcf portd,DIS3;
			call lRmn_pg1;
			bsf portd,DIS3;
			return;

lP0_DIS4	movwf portb;
			bcf portd,DIS4;
			call lRmn_pg1;
			bsf portd,DIS4;
			return;

lP0_DIS5	movwf portb;
			bcf portd,DIS5;
			call lRmn_pg1;
			bsf portd,DIS5;
			return;

lP0_DIS6	movwf portb;
			bcf portd,DIS6;
			call lRmn_pg1;
			bsf portd,DIS6;
			return;

lP0_DIS7	movwf portb;
			bcf portd,DIS7;
			call lRmn_pg1;
			bsf portd,DIS7;
			return;

;---------------------------------------------------------------------------------------------

pg1			bcf pclath,.4;
			bsf pclath,.3;
			org 0x800;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm45		movlw N;
			movwf Contador2;

			movlw num_9;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_J;
			call P0_DIS2;

			movlw car_U;
			call P0_DIS3;

			movlw car_A;
			call P0_DIS4;

			movlw car_N;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_d;
			call P0_DIS7;

Loop45		decfsz Contador2,f;
			goto Loop45;
			decfsz Contador1,f;
			goto Ftgrm45;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm46		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_J;
			call P0_DIS1;

			movlw car_U;
			call P0_DIS2;

			movlw car_A;
			call P0_DIS3;

			movlw car_N;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_d;
			call P0_DIS6;

			movlw car_E;
			call P0_DIS7;

Loop46		decfsz Contador2,f;
			goto Loop46;
			decfsz Contador1,f;
			goto Ftgrm46;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm47		movlw N;
			movwf Contador2;

			movlw car_J;
			call P0_DIS0;

			movlw car_U;
			call P0_DIS1;

			movlw car_A;
			call P0_DIS2;

			movlw car_N;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_d;
			call P0_DIS5;

			movlw car_E;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop47		decfsz Contador2,f;
			goto Loop47;
			decfsz Contador1,f;
			goto Ftgrm47;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm48		movlw N;
			movwf Contador2;

			movlw car_U;
			call P0_DIS0;

			movlw car_A;
			call P0_DIS1;

			movlw car_N;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_d;
			call P0_DIS4;

			movlw car_E;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_d;
			call P0_DIS7;

Loop48		decfsz Contador2,f;
			goto Loop48;
			decfsz Contador1,f;
			goto Ftgrm48;
			
			call Limpieza_pg0;

		
;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm49		movlw N;
			movwf Contador2;

			movlw car_A;
			call P0_DIS0;

			movlw car_N;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_d;
			call P0_DIS3;

			movlw car_E;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_d;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop49		decfsz Contador2,f;
			goto Loop49;
			decfsz Contador1,f;
			goto Ftgrm49;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm50		movlw N;
			movwf Contador2;

			movlw car_N;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_d;
			call P0_DIS2;

			movlw car_E;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_d;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw car_o;
			call P0_DIS7;

Loop50		decfsz Contador2,f;
			goto Loop50;
			decfsz Contador1,f;
			goto Ftgrm50;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm51		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_d;
			call P0_DIS1;

			movlw car_E;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_d;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw car_o;
			call P0_DIS6;

			movlw num_5;
			call P0_DIS7;

Loop51		decfsz Contador2,f;
			goto Loop51;
			decfsz Contador1,f;
			goto Ftgrm51;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm52		movlw N;
			movwf Contador2;

			movlw car_d;
			call P0_DIS0;

			movlw car_E;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_d;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw car_o;
			call P0_DIS5;

			movlw num_5;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop52		decfsz Contador2,f;
			goto Loop52;
			decfsz Contador1,f;
			goto Ftgrm52;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm53		movlw N;
			movwf Contador2;

			movlw car_E;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_d;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw num_5;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_b;
			call P0_DIS7;

Loop53		decfsz Contador2,f;
			goto Loop53;
			decfsz Contador1,f;
			goto Ftgrm53;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm54		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_d;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw car_o;
			call P0_DIS3;

			movlw num_5;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_b;
			call P0_DIS6;

			movlw car_A;
			call P0_DIS7;

Loop54		decfsz Contador2,f;
			goto Loop54;
			decfsz Contador1,f;
			goto Ftgrm54;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm55		movlw N;
			movwf Contador2;

			movlw car_d;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw car_o;
			call P0_DIS2;

			movlw num_5;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_b;
			call P0_DIS5;

			movlw car_A;
			call P0_DIS6;

			movlw car_t;
			call P0_DIS7;

Loop55		decfsz Contador2,f;
			goto Loop55;
			decfsz Contador1,f;
			goto Ftgrm55;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm56		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw car_o;
			call P0_DIS1;

			movlw num_5;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_b;
			call P0_DIS4;

			movlw car_A;
			call P0_DIS5;

			movlw car_t;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop56		decfsz Contador2,f;
			goto Loop56;
			decfsz Contador1,f;
			goto Ftgrm56;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm57		movlw N;
			movwf Contador2;

			movlw car_o;
			call P0_DIS0;

			movlw num_5;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_b;
			call P0_DIS3;

			movlw car_A;
			call P0_DIS4;

			movlw car_t;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw num_2;
			call P0_DIS7;

Loop57		decfsz Contador2,f;
			goto Loop57;
			decfsz Contador1,f;
			goto Ftgrm57;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm58		movlw N;
			movwf Contador2;

			movlw num_5;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_b;
			call P0_DIS2;

			movlw car_A;
			call P0_DIS3;

			movlw car_t;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw num_2;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop58		decfsz Contador2,f;
			goto Loop58;
			decfsz Contador1,f;
			goto Ftgrm58;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm59		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_b;
			call P0_DIS1;

			movlw car_A;
			call P0_DIS2;

			movlw car_t;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw num_2;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_P;
			call P0_DIS7;

Loop59		decfsz Contador2,f;
			goto Loop59;
			decfsz Contador1,f;
			goto Ftgrm59;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm60		movlw N;
			movwf Contador2;

			movlw car_b;
			call P0_DIS0;

			movlw car_A;
			call P0_DIS1;

			movlw car_t;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw num_2;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_P;
			call P0_DIS6;

			movlw car_r;
			call P0_DIS7;

Loop60		decfsz Contador2,f;
			goto Loop60;
			decfsz Contador1,f;
			goto Ftgrm60;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm61		movlw N;
			movwf Contador2;

			movlw car_A;
			call P0_DIS0;

			movlw car_t;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw num_2;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_P;
			call P0_DIS5;

			movlw car_r;
			call P0_DIS6;

			movlw car_A;
			call P0_DIS7;

Loop61		decfsz Contador2,f;
			goto Loop61;
			decfsz Contador1,f;
			goto Ftgrm61;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm62		movlw N;
			movwf Contador2;

			movlw car_t;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw num_2;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_P;
			call P0_DIS4;

			movlw car_r;
			call P0_DIS5;

			movlw car_A;
			call P0_DIS6;

			movlw car_cc;
			call P0_DIS7;

Loop62		decfsz Contador2,f;
			goto Loop62;
			decfsz Contador1,f;
			goto Ftgrm62;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm63		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw num_2;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_P;
			call P0_DIS3;

			movlw car_r;
			call P0_DIS4;

			movlw car_A;
			call P0_DIS5;

			movlw car_cc;
			call P0_DIS6;

			movlw car_t;
			call P0_DIS7;

Loop63		decfsz Contador2,f;
			goto Loop63;
			decfsz Contador1,f;
			goto Ftgrm63;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm64		movlw N;
			movwf Contador2;

			movlw num_2;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_P;
			call P0_DIS2;

			movlw car_r;
			call P0_DIS3;

			movlw car_A;
			call P0_DIS4;

			movlw car_cc;
			call P0_DIS5;

			movlw car_t;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop64		decfsz Contador2,f;
			goto Loop64;
			decfsz Contador1,f;
			goto Ftgrm64;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm65		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_P;
			call P0_DIS1;

			movlw car_r;
			call P0_DIS2;

			movlw car_A;
			call P0_DIS3;

			movlw car_cc;
			call P0_DIS4;

			movlw car_t;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw car_C;
			call P0_DIS7;

Loop65		decfsz Contador2,f;
			goto Loop65;
			decfsz Contador1,f;
			goto Ftgrm65;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm66		movlw N;
			movwf Contador2;

			movlw car_P;
			call P0_DIS0;

			movlw car_r;
			call P0_DIS1;

			movlw car_A;
			call P0_DIS2;

			movlw car_cc;
			call P0_DIS3;

			movlw car_t;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw car_C;
			call P0_DIS6;

			movlw car_A;
			call P0_DIS7;

Loop66		decfsz Contador2,f;
			goto Loop66;
			decfsz Contador1,f;
			goto Ftgrm66;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm67		movlw N;
			movwf Contador2;

			movlw car_r;
			call P0_DIS0;

			movlw car_A;
			call P0_DIS1;

			movlw car_cc;
			call P0_DIS2;

			movlw car_t;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw car_C;
			call P0_DIS5;

			movlw car_A;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop67		decfsz Contador2,f;
			goto Loop67;
			decfsz Contador1,f;
			goto Ftgrm67;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm68		movlw N;
			movwf Contador2;

			movlw car_A;
			call P0_DIS0;

			movlw car_cc;
			call P0_DIS1;

			movlw car_t;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw car_C;
			call P0_DIS4;

			movlw car_A;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw num_4;
			call P0_DIS7;

Loop68		decfsz Contador2,f;
			goto Loop68;
			decfsz Contador1,f;
			goto Ftgrm68;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm69		movlw N;
			movwf Contador2;

			movlw car_cc;
			call P0_DIS0;

			movlw car_t;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw car_C;
			call P0_DIS3;

			movlw car_A;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw num_4
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop69		decfsz Contador2,f;
			goto Loop69;
			decfsz Contador1,f;
			goto Ftgrm69;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm70		movlw N;
			movwf Contador2;

			movlw car_t;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw car_c;
			call P0_DIS2;

			movlw car_A;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw num_4;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_c;
			call P0_DIS7;

Loop70		decfsz Contador2,f;
			goto Loop70;
			decfsz Contador1,f;
			goto Ftgrm70;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm71		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw car_cc;
			call P0_DIS1;

			movlw car_A;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw num_4;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_c;
			call P0_DIS6;

			movlw car_o;
			call P0_DIS7;

Loop71		decfsz Contador2,f;
			goto Loop71;
			decfsz Contador1,f;
			goto Ftgrm71;
			
			call Limpieza_pg0;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm72		movlw N;
			movwf Contador2;

			movlw car_cc;
			call P0_DIS0;

			movlw car_A;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw num_4;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_cc;
			call P0_DIS5;

			movlw car_o;
			call P0_DIS6;

			movlw car_nn;
			call P0_DIS7;

Loop72		decfsz Contador2,f;
			goto Loop72;
			decfsz Contador1,f;
			goto Ftgrm72;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm73		movlw N;
			movwf Contador2;

			movlw car_A;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw num_4;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_cc;
			call P0_DIS4;

			movlw car_o;
			call P0_DIS5;

			movlw car_nn;
			call P0_DIS6;

			movlw car_t;
			call P0_DIS7;

Loop73		decfsz Contador2,f;
			goto Loop73;
			decfsz Contador1,f;
			goto Ftgrm73;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm74		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw num_4;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_cc;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw car_nn;
			call P0_DIS5;

			movlw car_t;
			call P0_DIS6;

			movlw car_r;
			call P0_DIS7;

Loop74		decfsz Contador2,f;
			goto Loop74;
			decfsz Contador1,f;
			goto Ftgrm74;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm75		movlw N;
			movwf Contador2;

			movlw num_4;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_cc;
			call P0_DIS2;

			movlw car_o;
			call P0_DIS3;

			movlw car_nn;
			call P0_DIS4;

			movlw car_t;
			call P0_DIS5;

			movlw car_r;
			call P0_DIS6;

			movlw car_o;
			call P0_DIS7;

Loop75		decfsz Contador2,f;
			goto Loop75;
			decfsz Contador1,f;
			goto Ftgrm75;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm76		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_cc;
			call P0_DIS1;

			movlw car_o;
			call P0_DIS2;

			movlw car_nn;
			call P0_DIS3;

			movlw car_t;
			call P0_DIS4;

			movlw car_r;
			call P0_DIS5;

			movlw car_o;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop76		decfsz Contador2,f;
			goto Loop76;
			decfsz Contador1,f;
			goto Ftgrm76;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm77		movlw N;
			movwf Contador2;

			movlw car_cc;
			call P0_DIS0;

			movlw car_o;
			call P0_DIS1;

			movlw car_nn;
			call P0_DIS2;

			movlw car_t;
			call P0_DIS3;

			movlw car_r;
			call P0_DIS4;

			movlw car_o;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop77		decfsz Contador2,f;
			goto Loop77;
			decfsz Contador1,f;
			goto Ftgrm77;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm78		movlw N;
			movwf Contador2;

			movlw car_o;
			call P0_DIS0;

			movlw car_nn;
			call P0_DIS1;

			movlw car_t;
			call P0_DIS2;

			movlw car_r;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_d;
			call P0_DIS7;

Loop78		decfsz Contador2,f;
			goto Loop78;
			decfsz Contador1,f;
			goto Ftgrm78;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm79		movlw N;
			movwf Contador2;

			movlw car_nn;
			call P0_DIS0;

			movlw car_t;
			call P0_DIS1;

			movlw car_r;
			call P0_DIS2;

			movlw car_o;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_d;
			call P0_DIS6;

			movlw car_E;
			call P0_DIS7;

Loop79		decfsz Contador2,f;
			goto Loop79;
			decfsz Contador1,f;
			goto Ftgrm79;
			
			call Limpieza_pg0;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm80		movlw N;
			movwf Contador2;

			movlw car_t;
			call P0_DIS0;

			movlw car_r;
			call P0_DIS1;

			movlw car_o;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_d;
			call P0_DIS5;

			movlw car_E;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop80		decfsz Contador2,f;
			goto Loop80;
			decfsz Contador1,f;
			goto Ftgrm80;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm81		movlw N;
			movwf Contador2;

			movlw car_r;
			call P0_DIS0;

			movlw car_o;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_d;
			call P0_DIS4;

			movlw car_E;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_d;
			call P0_DIS7;

Loop81		decfsz Contador2,f;
			goto Loop81;
			decfsz Contador1,f;
			goto Ftgrm81;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm82		movlw N;
			movwf Contador2;

			movlw car_o;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_d;
			call P0_DIS3;

			movlw car_E;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_d;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop82		decfsz Contador2,f;
			goto Loop82;
			decfsz Contador1,f;
			goto Ftgrm82;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm82.1	movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_d;
			call P0_DIS2;

			movlw car_E;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_d;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw num_5;
			call P0_DIS7;

Loop82.1	decfsz Contador2,f;
			goto Loop82.1;
			decfsz Contador1,f;
			goto Ftgrm82.1;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm83		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_d;
			call P0_DIS1;

			movlw car_E;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_d;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw num_5;
			call P0_DIS6;

			movlw car_p;
			call P0_DIS7;

Loop83		decfsz Contador2,f;
			goto Loop83;
			decfsz Contador1,f;
			goto Ftgrm83;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm84		movlw N;
			movwf Contador2;

			movlw car_d;
			call P0_DIS0;

			movlw car_E;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_d;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw num_5;
			call P0_DIS5;

			movlw car_p;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop84		decfsz Contador2,f;
			goto Loop84;
			decfsz Contador1,f;
			goto Ftgrm84;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm85		movlw N;
			movwf Contador2;

			movlw car_E;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_d;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw num_5;
			call P0_DIS4;

			movlw car_p;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw car_A;
			call P0_DIS7;

Loop85		decfsz Contador2,f;
			goto Loop85;
			decfsz Contador1,f;
			goto Ftgrm85;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm86		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_d;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw num_5;
			call P0_DIS3;

			movlw car_p;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw car_A;
			call P0_DIS6;

			movlw car_y;
			call P0_DIS7;

Loop86		decfsz Contador2,f;
			goto Loop86;
			decfsz Contador1,f;
			goto Ftgrm86;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm87		movlw N;
			movwf Contador2;

			movlw car_d;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw num_5;
			call P0_DIS2;

			movlw car_p;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw car_A;
			call P0_DIS5;

			movlw car_y;
			call P0_DIS6;

			movlw num_5;
			call P0_DIS7;

Loop87		decfsz Contador2,f;
			goto Loop87;
			decfsz Contador1,f;
			goto Ftgrm87;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm88		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw num_5;
			call P0_DIS1;

			movlw car_p;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw car_A;
			call P0_DIS4;

			movlw car_y;
			call P0_DIS5;

			movlw num_5;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop88		decfsz Contador2,f;
			goto Loop88;
			decfsz Contador1,f;
			goto Ftgrm88;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm89		movlw N;
			movwf Contador2;

			movlw num_5;
			call P0_DIS0;

			movlw car_p;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw car_A;
			call P0_DIS3;

			movlw car_y;
			call P0_DIS4;

			movlw num_5;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_p;
			call P0_DIS7;

Loop89		decfsz Contador2,f;
			goto Loop89;
			decfsz Contador1,f;
			goto Ftgrm89;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm90		movlw N;
			movwf Contador2;

			movlw car_p;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw car_A;
			call P0_DIS2;

			movlw car_y;
			call P0_DIS3;

			movlw num_5;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_p;
			call P0_DIS6;

			movlw car_o;
			call P0_DIS7;

Loop90		decfsz Contador2,f;
			goto Loop90;
			decfsz Contador1,f;
			goto Ftgrm90;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm91		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw car_A;
			call P0_DIS1;

			movlw car_y;
			call P0_DIS2;

			movlw num_5;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_p;
			call P0_DIS5;

			movlw car_o;
			call P0_DIS6;

			movlw car_r;
			call P0_DIS7;

Loop91		decfsz Contador2,f;
			goto Loop91;
			decfsz Contador1,f;
			goto Ftgrm91;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm92		movlw N;
			movwf Contador2;

			movlw car_A;
			call P0_DIS0;

			movlw car_y;
			call P0_DIS1;

			movlw num_5;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_p;
			call P0_DIS4;

			movlw car_o;
			call P0_DIS5;

			movlw car_r;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop92		decfsz Contador2,f;
			goto Loop92;
			decfsz Contador1,f;
			goto Ftgrm92;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm93		movlw N;
			movwf Contador2;

			movlw car_y;
			call P0_DIS0;

			movlw num_5;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_p;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw car_r;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_t;
			call P0_DIS7;

Loop93		decfsz Contador2,f;
			goto Loop93;
			decfsz Contador1,f;
			goto Ftgrm93;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm94		movlw N;
			movwf Contador2;

			movlw num_5;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_p;
			call P0_DIS2;

			movlw car_o;
			call P0_DIS3;

			movlw car_r;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_t;
			call P0_DIS6;

			movlw car_d;
			call P0_DIS7;

Loop94		decfsz Contador2,f;
			goto Loop94;
			decfsz Contador1,f;
			goto Ftgrm94;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm95		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_p;
			call P0_DIS1;

			movlw car_o;
			call P0_DIS2;

			movlw car_r;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_t;
			call P0_DIS5;

			movlw car_d;
			call P0_DIS6;

			movlw car_n;
			call P0_DIS7;

Loop95		decfsz Contador2,f;
			goto Loop95;
			decfsz Contador1,f;
			goto Ftgrm95;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm96		movlw N;
			movwf Contador2;

			movlw car_p;
			call P0_DIS0;

			movlw car_o;
			call P0_DIS1;

			movlw car_r;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_t;
			call P0_DIS4;

			movlw car_d;
			call P0_DIS5;

			movlw car_n;
			call P0_DIS6;

			movlw car_n;
			call P0_DIS7;

Loop96		decfsz Contador2,f;
			goto Loop96;
			decfsz Contador1,f;
			goto Ftgrm96;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm97		movlw N;
			movwf Contador2;

			movlw car_o;
			call P0_DIS0;

			movlw car_r;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_t;
			call P0_DIS3;

			movlw car_d;
			call P0_DIS4;

			movlw car_n;
			call P0_DIS5;

			movlw car_n;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop97		decfsz Contador2,f;
			goto Loop97;
			decfsz Contador1,f;
			goto Ftgrm97;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm98		movlw N;
			movwf Contador2;

			movlw car_r;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_t;
			call P0_DIS2;

			movlw car_d;
			call P0_DIS3;

			movlw car_n;
			call P0_DIS4;

			movlw car_n;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw num_6;
			call P0_DIS7;

Loop98		decfsz Contador2,f;
			goto Loop98;
			decfsz Contador1,f;
			goto Ftgrm98;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm99		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_t;
			call P0_DIS1;

			movlw car_d;
			call P0_DIS2;

			movlw car_n;
			call P0_DIS3;

			movlw car_n;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw num_6;
			call P0_DIS6;

			movlw car_r;
			call P0_DIS7;

Loop99		decfsz Contador2,f;
			goto Loop99;
			decfsz Contador1,f;
			goto Ftgrm99;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm100		movlw N;
			movwf Contador2;

			movlw car_t;
			call P0_DIS0;

			movlw car_d;
			call P0_DIS1;

			movlw car_n;
			call P0_DIS2;

			movlw car_n;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw num_6;
			call P0_DIS5;

			movlw car_r;
			call P0_DIS6;

			movlw car_uu;
			call P0_DIS7;

Loop100		decfsz Contador2,f;
			goto Loop100;
			decfsz Contador1,f;
			goto Ftgrm100;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm101		movlw N;
			movwf Contador2;

			movlw car_d;
			call P0_DIS0;

			movlw car_n;
			call P0_DIS1;

			movlw car_n;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw num_6;
			call P0_DIS4;

			movlw car_r;
			call P0_DIS5;

			movlw car_uu;
			call P0_DIS6;

			movlw car_p;
			call P0_DIS7;

Loop101		decfsz Contador2,f;
			goto Loop101;
			decfsz Contador1,f;
			goto Ftgrm101;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm102		movlw N;
			movwf Contador2;

			movlw car_n;
			call P0_DIS0;

			movlw car_n;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw num_6;
			call P0_DIS3;

			movlw car_r;
			call P0_DIS4;

			movlw car_uu;
			call P0_DIS5;

			movlw car_p;
			call P0_DIS6;

			movlw car_o;
			call P0_DIS7;

Loop102		decfsz Contador2,f;
			goto Loop102;
			decfsz Contador1,f;
			goto Ftgrm102;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm103		movlw N;
			movwf Contador2;

			movlw car_n;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw num_6;
			call P0_DIS2;

			movlw car_r;
			call P0_DIS3;

			movlw car_uu;
			call P0_DIS4;

			movlw car_p;
			call P0_DIS5;

			movlw car_o;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop103		decfsz Contador2,f;
			goto Loop103;
			decfsz Contador1,f;
			goto Ftgrm103;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm104		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw num_6;
			call P0_DIS1;

			movlw car_r;
			call P0_DIS2;

			movlw car_uu;
			call P0_DIS3;

			movlw car_p;
			call P0_DIS4;

			movlw car_o;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw num_5;
			call P0_DIS7;

Loop104		decfsz Contador2,f;
			goto Loop104;
			decfsz Contador1,f;
			goto Ftgrm104;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm105		movlw N;
			movwf Contador2;

			movlw num_6;
			call P0_DIS0;

			movlw car_r;
			call P0_DIS1;

			movlw car_uu;
			call P0_DIS2;

			movlw car_p;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw num_5;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop105		decfsz Contador2,f;
			goto Loop105;
			decfsz Contador1,f;
			goto Ftgrm105;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm106		movlw N;
			movwf Contador2;

			movlw car_r;
			call P0_DIS0;

			movlw car_uu;
			call P0_DIS1;

			movlw car_p;
			call P0_DIS2;

			movlw car_o;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw num_5;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw car_n;
			call P0_DIS7;

Loop106		decfsz Contador2,f;
			goto Loop106;
			decfsz Contador1,f;
			goto Ftgrm106;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm107		movlw N;
			movwf Contador2;

			movlw car_uu;
			call P0_DIS0;

			movlw car_p;
			call P0_DIS1;

			movlw car_o;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw num_5;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw car_n;
			call P0_DIS6;

			movlw car_n;
			call P0_DIS7;

Loop107		decfsz Contador2,f;
			goto Loop107;
			decfsz Contador1,f;
			goto Ftgrm107;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm108		movlw N;
			movwf Contador2;

			movlw car_p;
			call P0_DIS0;

			movlw car_o;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw num_5;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw car_n;
			call P0_DIS5;

			movlw car_n;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop108		decfsz Contador2,f;
			goto Loop108;
			decfsz Contador1,f;
			goto Ftgrm108;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm109		movlw N;
			movwf Contador2;

			movlw car_o;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw num_5;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw car_n;
			call P0_DIS4;

			movlw car_n;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop109		decfsz Contador2,f;
			goto Loop109;
			decfsz Contador1,f;
			goto Ftgrm109;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm110		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw num_5;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw car_n;
			call P0_DIS3;

			movlw car_n;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw car_E;
			call P0_DIS7;

Loop110		decfsz Contador2,f;
			goto Loop110;
			decfsz Contador1,f;
			goto Ftgrm110;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm111		movlw N;
			movwf Contador2;

			movlw num_5;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw car_n;
			call P0_DIS2;

			movlw car_n;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw car_E;
			call P0_DIS6;

			movlw num_9;
			call P0_DIS7;

Loop111		decfsz Contador2,f;
			goto Loop111;
			decfsz Contador1,f;
			goto Ftgrm111;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm112		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw car_n;
			call P0_DIS1;

			movlw car_n;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw car_E;
			call P0_DIS5;

			movlw num_9;
			call P0_DIS6;

			movlw car_uu;
			call P0_DIS7;

Loop112		decfsz Contador2,f;
			goto Loop112;
			decfsz Contador1,f;
			goto Ftgrm112;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm113		movlw N;
			movwf Contador2;

			movlw car_n;
			call P0_DIS0;

			movlw car_n;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw NULL;
			call P0_DIS3;

			movlw car_E;
			call P0_DIS4;

			movlw num_9;
			call P0_DIS5;

			movlw car_uu;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop113		decfsz Contador2,f;
			goto Loop113;
			decfsz Contador1,f;
			goto Ftgrm113;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm114		movlw N;
			movwf Contador2;

			movlw car_n;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw NULL;
			call P0_DIS2;

			movlw car_E;
			call P0_DIS3;

			movlw num_9;
			call P0_DIS4;

			movlw car_uu;
			call P0_DIS5;

			movlw num_1;
			call P0_DIS6;

			movlw car_p;
			call P0_DIS7;

Loop114		decfsz Contador2,f;
			goto Loop114;
			decfsz Contador1,f;
			goto Ftgrm114;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm115		movlw N;
			movwf Contador2;

			movlw num_1;
			call P0_DIS0;

			movlw NULL;
			call P0_DIS1;

			movlw car_E;
			call P0_DIS2;

			movlw num_9;
			call P0_DIS3;

			movlw car_uu;
			call P0_DIS4;

			movlw num_1;
			call P0_DIS5;

			movlw car_p;
			call P0_DIS6;

			movlw car_o;
			call P0_DIS7;

Loop115		decfsz Contador2,f;
			goto Loop115;
			decfsz Contador1,f;
			goto Ftgrm115;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm116		movlw N;
			movwf Contador2;

			movlw NULL;
			call P0_DIS0;

			movlw car_E;
			call P0_DIS1;

			movlw num_9;
			call P0_DIS2;

			movlw car_uu;
			call P0_DIS3;

			movlw num_1;
			call P0_DIS4;

			movlw car_p;
			call P0_DIS5;

			movlw car_o;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop116		decfsz Contador2,f;
			goto Loop116;
			decfsz Contador1,f;
			goto Ftgrm116;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm117		movlw N;
			movwf Contador2;

			movlw car_E;
			call P0_DIS0;

			movlw num_9;
			call P0_DIS1;

			movlw car_uu;
			call P0_DIS2;

			movlw num_1;
			call P0_DIS3;

			movlw car_p;
			call P0_DIS4;

			movlw car_o;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw num_2;
			call P0_DIS7;

Loop117		decfsz Contador2,f;
			goto Loop117;
			decfsz Contador1,f;
			goto Ftgrm117;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm118		movlw N;
			movwf Contador2;

			movlw num_9;
			call P0_DIS0;

			movlw car_uu;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw car_p;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw num_2;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop118		decfsz Contador2,f;
			goto Loop118;
			decfsz Contador1,f;
			goto Ftgrm118;
			
			call Limpieza_pg0;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm118.1		movlw N;
			movwf Contador2;

			movlw num_9;
			call P0_DIS0;

			movlw car_uu;
			call P0_DIS1;

			movlw num_1;
			call P0_DIS2;

			movlw car_p;
			call P0_DIS3;

			movlw car_o;
			call P0_DIS4;

			movlw NULL;
			call P0_DIS5;

			movlw num_2;
			call P0_DIS6;

			movlw NULL;
			call P0_DIS7;

Loop118.1		decfsz Contador2,f;
			goto Loop118.1;
			decfsz Contador1,f;
			goto Ftgrm118.1;
			
			call Limpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm119		movlw N;
			movwf Contador2;

			movlw car_uu;
			call P0_DIS0;

			movlw num_1;
			call P0_DIS1;

			movlw car_p;
			call P0_DIS2;

			movlw car_o;
			call P0_DIS3;

			movlw NULL;
			call P0_DIS4;

			movlw num_2;
			call P0_DIS5;

			movlw NULL;
			call P0_DIS6;

			movlw num_1;
			call P0_DIS7;

Loop119		decfsz Contador2,f;
			goto Loop119;
			decfsz Contador1,f;
			goto Ftgrm119;
			
			call Limpieza_pg0;


			goto pg2;			

			;=======================
			;== Limpia displays ====
			;=======================
			
Limpieza_pg0	bsf	portd,DIS0;
				bsf	portd,DIS1;
				bsf	portd,DIS2;
				bsf	portd,DIS3;
				bsf	portd,DIS4;
				bsf	portd,DIS5;
				bsf	portd,DIS6;
				bsf	portd,DIS7;
			
				bcf portb,a_RB0;
				bcf portb,b_RB1;
				bcf portb,c_RB2;
				bcf portb,d_RB3;
				bcf portb,e_RB4;
				bcf portb,f_RB5;
				bcf portb,g_RB6;
				bcf portb,dp_RB7;
			
				return;
			
;---------------------------------------------------------------------------------------------
			; ====================
			; === Retardo Menor ==
			; ====================
Rmn_pg0		movlw L;
			movwf Contador3;
LoopR1		movlw K;
			movwf Contador4;
			
LoopRB0		decfsz Contador4,f;
			goto LoopRB0;
			decfsz Contador3,f;
			goto LoopR1;

			return;
;---------------------------------------------------------------------------------------------
			;========================
			;=== Pulsos de cambio ===
			;========================
P0_DIS0		movwf portb;
			bcf portd,DIS0;
			call Rmn_pg0;
			bsf portd,DIS0;
			return;

P0_DIS1		movwf portb;
			bcf portd,DIS1;
			call Rmn_pg0;
			bsf portd,DIS1;
			return;

P0_DIS2		movwf portb;
			bcf portd,DIS2;
			call Rmn_pg0;
			bsf portd,DIS2;
			return;

P0_DIS3		movwf portb;
			bcf portd,DIS3;
			call Rmn_pg0;
			bsf portd,DIS3;
			return;

P0_DIS4		movwf portb;
			bcf portd,DIS4;
			call Rmn_pg0;
			bsf portd,DIS4;
			return;

P0_DIS5		movwf portb;
			bcf portd,DIS5;
			call Rmn_pg0;
			bsf portd,DIS5;
			return;

P0_DIS6		movwf portb;
			bcf portd,DIS6;
			call Rmn_pg0;
			bsf portd,DIS6;
			return;

P0_DIS7		movwf portb;
			bcf portd,DIS7;
			call Rmn_pg0;
			bsf portd,DIS7;
			return;

pg2			bsf pclath,.4;
			bcf pclath,.3;
			org 0x1000;


;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm120		movlw N;
			movwf Contador2;

			movlw num_1;
			call mP0_DIS0;

			movlw car_p;
			call mP0_DIS1;

			movlw car_o;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;

			movlw num_2;
			call mP0_DIS4;

			movlw NULL;
			call mP0_DIS5;

			movlw num_1;
			call mP0_DIS6;

			movlw car_nn;
			call mP0_DIS7;

Loop120		decfsz Contador2,f;
			goto Loop120;
			decfsz Contador1,f;
			goto Ftgrm120;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm121		movlw N;
			movwf Contador2;

			movlw car_p;
			call mP0_DIS0;

			movlw car_o;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;

			movlw num_2;
			call mP0_DIS3;

			movlw NULL;
			call mP0_DIS4;

			movlw num_1;
			call mP0_DIS5;

			movlw car_nn;
			call mP0_DIS6;

			movlw car_t;
			call mP0_DIS7;

Loop121		decfsz Contador2,f;
			goto Loop121;
			decfsz Contador1,f;
			goto Ftgrm121;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm122		movlw N;
			movwf Contador2;

			movlw car_o;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;

			movlw num_2;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;

			movlw num_1;
			call mP0_DIS4;

			movlw car_nn;
			call mP0_DIS5;

			movlw car_t;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop122		decfsz Contador2,f;
			goto Loop122;
			decfsz Contador1,f;
			goto Ftgrm122;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm123		movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;

			movlw num_2;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;

			movlw num_1;
			call mP0_DIS3;

			movlw car_nn;
			call mP0_DIS4;

			movlw car_t;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw num_6;
			call mP0_DIS7;

Loop123		decfsz Contador2,f;
			goto Loop123;
			decfsz Contador1,f;
			goto Ftgrm123;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm124		movlw N;
			movwf Contador2;

			movlw num_2;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;

			movlw num_1;
			call mP0_DIS2;

			movlw car_nn;
			call mP0_DIS3;

			movlw car_t;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw num_6;
			call mP0_DIS6;

			movlw car_r;
			call mP0_DIS7;

Loop124		decfsz Contador2,f;
			goto Loop124;
			decfsz Contador1,f;
			goto Ftgrm124;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm125		movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;

			movlw num_1;
			call mP0_DIS1;

			movlw car_nn;
			call mP0_DIS2;

			movlw car_t;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw num_6;
			call mP0_DIS5;

			movlw car_r;
			call mP0_DIS6;

			movlw car_A;
			call mP0_DIS7;

Loop125		decfsz Contador2,f;
			goto Loop125;
			decfsz Contador1,f;
			goto Ftgrm125;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm126		movlw N;
			movwf Contador2;

			movlw num_1;
			call mP0_DIS0;

			movlw car_nn;
			call mP0_DIS1;

			movlw car_t;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw num_6;
			call mP0_DIS4;

			movlw car_r;
			call mP0_DIS5;

			movlw car_A;
			call mP0_DIS6;

			movlw car_nn;
			call mP0_DIS7;

Loop126		decfsz Contador2,f;
			goto Loop126;
			decfsz Contador1,f;
			goto Ftgrm126;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm127		movlw N;
			movwf Contador2;

			movlw car_nn;
			call mP0_DIS0;

			movlw car_t;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw num_6;
			call mP0_DIS3;

			movlw car_r;
			call mP0_DIS4;

			movlw car_A;
			call mP0_DIS5;

			movlw car_n;
			call mP0_DIS6;

			movlw car_t;
			call mP0_DIS7;

Loop127		decfsz Contador2,f;
			goto Loop127;
			decfsz Contador1,f;
			goto Ftgrm127;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm128		movlw N;
			movwf Contador2;

			movlw car_t;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw num_6;
			call mP0_DIS2;

			movlw car_r;
			call mP0_DIS3;

			movlw car_A;
			call mP0_DIS4;

			movlw car_n;
			call mP0_DIS5;

			movlw car_t;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop128		decfsz Contador2,f;
			goto Loop128;
			decfsz Contador1,f;
			goto Ftgrm128;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm129		movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw num_6;
			call mP0_DIS1;

			movlw car_r;
			call mP0_DIS2;

			movlw car_A;
			call mP0_DIS3;

			movlw car_n;
			call mP0_DIS4;

			movlw car_t;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw num_5;
			call mP0_DIS7;

Loop129		decfsz Contador2,f;
			goto Loop129;
			decfsz Contador1,f;
			goto Ftgrm129;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm130		movlw N;
			movwf Contador2;

			movlw num_6;
			call mP0_DIS0;

			movlw car_r;
			call mP0_DIS1;

			movlw car_A;
			call mP0_DIS2;

			movlw car_n;
			call mP0_DIS3;

			movlw car_t;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw num_5;
			call mP0_DIS6;

			movlw NULL;
			call mP0_DIS7;

Loop130		decfsz Contador2,f;
			goto Loop130;
			decfsz Contador1,f;
			goto Ftgrm130;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm131		movlw N;
			movwf Contador2;

			movlw car_r;
			call mP0_DIS0;

			movlw car_A;
			call mP0_DIS1;

			movlw car_nn;
			call mP0_DIS2;

			movlw car_t;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw num_5;
			call mP0_DIS5;

			movlw NULL;
			call mP0_DIS6;

			movlw car_n;
			call mP0_DIS7;

Loop131		decfsz Contador2,f;
			goto Loop131;
			decfsz Contador1,f;
			goto Ftgrm131;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm132		movlw N;
			movwf Contador2;

			movlw car_A;
			call mP0_DIS0;

			movlw car_nn;
			call mP0_DIS1;

			movlw car_t;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw num_5;
			call mP0_DIS4;

			movlw NULL;
			call mP0_DIS5;

			movlw car_n;
			call mP0_DIS6;

			movlw car_n;
			call mP0_DIS7;

Loop132		decfsz Contador2,f;
			goto Loop132;
			decfsz Contador1,f;
			goto Ftgrm132;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm133		movlw N;
			movwf Contador2;

			movlw car_nn;
			call mP0_DIS0;

			movlw car_t;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw num_5;
			call mP0_DIS3;

			movlw NULL;
			call mP0_DIS4;

			movlw car_n;
			call mP0_DIS5;

			movlw car_n;
			call mP0_DIS6;

			movlw car_A;
			call mP0_DIS7;

Loop133		decfsz Contador2,f;
			goto Loop133;
			decfsz Contador1,f;
			goto Ftgrm133;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm134		movlw N;
			movwf Contador2;

			movlw car_t;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw num_5;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;

			movlw car_n;
			call mP0_DIS4;

			movlw car_n;
			call mP0_DIS5;

			movlw car_A;
			call mP0_DIS6;

			movlw car_r;
			call mP0_DIS7;

Loop134		decfsz Contador2,f;
			goto Loop134;
			decfsz Contador1,f;
			goto Ftgrm134;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm135		movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw num_5;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;

			movlw car_n;
			call mP0_DIS3;

			movlw car_n;
			call mP0_DIS4;

			movlw car_A;
			call mP0_DIS5;

			movlw car_r;
			call mP0_DIS6;

			movlw car_t;
			call mP0_DIS7;

Loop135		decfsz Contador2,f;
			goto Loop135;
			decfsz Contador1,f;
			goto Ftgrm135;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm136		movlw N;
			movwf Contador2;

			movlw num_5;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;

			movlw car_n;
			call mP0_DIS2;

			movlw car_n;
			call mP0_DIS3;

			movlw car_A;
			call mP0_DIS4;

			movlw car_r;
			call mP0_DIS5;

			movlw car_t;
			call mP0_DIS6;

			movlw num_1;
			call mP0_DIS7;

Loop136		decfsz Contador2,f;
			goto Loop136;
			decfsz Contador1,f;
			goto Ftgrm136;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm137		movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;

			movlw car_n;
			call mP0_DIS1;

			movlw car_n;
			call mP0_DIS2;

			movlw car_A;
			call mP0_DIS3;

			movlw car_r;
			call mP0_DIS4;

			movlw car_t;
			call mP0_DIS5;

			movlw num_1;
			call mP0_DIS6;

			movlw car_n;
			call mP0_DIS7;

Loop137		decfsz Contador2,f;
			goto Loop137;
			decfsz Contador1,f;
			goto Ftgrm137;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm138		movlw N;
			movwf Contador2;

			movlw car_n;
			call mP0_DIS0;

			movlw car_n;
			call mP0_DIS1;

			movlw car_A;
			call mP0_DIS2;

			movlw car_r;
			call mP0_DIS3;

			movlw car_t;
			call mP0_DIS4;

			movlw num_1;
			call mP0_DIS5;

			movlw car_n;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop138		decfsz Contador2,f;
			goto Loop138;
			decfsz Contador1,f;
			goto Ftgrm138;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm139		movlw N;
			movwf Contador2;

			movlw car_n;
			call mP0_DIS0;

			movlw car_A;
			call mP0_DIS1;

			movlw car_r;
			call mP0_DIS2;

			movlw car_t;
			call mP0_DIS3;

			movlw num_1;
			call mP0_DIS4;

			movlw car_n;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw num_2;
			call mP0_DIS7;

Loop139		decfsz Contador2,f;
			goto Loop139;
			decfsz Contador1,f;
			goto Ftgrm139;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm140		movlw N;
			movwf Contador2;

			movlw car_A;
			call mP0_DIS0;

			movlw car_r;
			call mP0_DIS1;

			movlw car_t;
			call mP0_DIS2;

			movlw num_1;
			call mP0_DIS3;

			movlw car_n;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw num_2;
			call mP0_DIS6;

			movlw NULL;
			call mP0_DIS7;

Loop140		decfsz Contador2,f;
			goto Loop140;
			decfsz Contador1,f;
			goto Ftgrm140;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm141		movlw N;
			movwf Contador2;

			movlw car_r;
			call mP0_DIS0;

			movlw car_t;
			call mP0_DIS1;

			movlw num_1;
			call mP0_DIS2;

			movlw car_n;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw num_2;
			call mP0_DIS5;

			movlw NULL;
			call mP0_DIS6;

			movlw car_L;
			call mP0_DIS7;

Loop141		decfsz Contador2,f;
			goto Loop141;
			decfsz Contador1,f;
			goto Ftgrm141;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm142		movlw N;
			movwf Contador2;

			movlw car_t;
			call mP0_DIS0;

			movlw num_1;
			call mP0_DIS1;

			movlw car_n;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw num_2;
			call mP0_DIS4;

			movlw NULL;
			call mP0_DIS5;

			movlw car_L;
			call mP0_DIS6;

			movlw car_o;
			call mP0_DIS7;

Loop142		decfsz Contador2,f;
			goto Loop142;
			decfsz Contador1,f;
			goto Ftgrm142;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm143		movlw N;
			movwf Contador2;

			movlw num_1;
			call mP0_DIS0;

			movlw car_n;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw num_2;
			call mP0_DIS3;

			movlw NULL;
			call mP0_DIS4;

			movlw car_L;
			call mP0_DIS5;

			movlw car_o;
			call mP0_DIS6;

			movlw car_p;
			call mP0_DIS7;

Loop143		decfsz Contador2,f;
			goto Loop143;
			decfsz Contador1,f;
			goto Ftgrm143;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm144		movlw N;
			movwf Contador2;

			movlw car_n;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw num_2;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;

			movlw car_L;
			call mP0_DIS4;

			movlw car_o;
			call mP0_DIS5;

			movlw car_p;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop144 	decfsz Contador2,f;
			goto Loop144;
			decfsz Contador1,f;
			goto Ftgrm144;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm145		movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw num_2;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;

			movlw car_L;
			call mP0_DIS3;

			movlw car_o;
			call mP0_DIS4;

			movlw car_p;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw num_2;
			call mP0_DIS7;

Loop145		decfsz Contador2,f;
			goto Loop145;
			decfsz Contador1,f;
			goto Ftgrm145;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm146		movlw N;
			movwf Contador2;

			movlw num_2;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;

			movlw car_L;
			call mP0_DIS2;

			movlw car_o;
			call mP0_DIS3;

			movlw car_p;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw num_2;
			call mP0_DIS6;

			movlw NULL;
			call mP0_DIS7;

Loop146		decfsz Contador2,f;
			goto Loop146;
			decfsz Contador1,f;
			goto Ftgrm146;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm147		movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;

			movlw car_L;
			call mP0_DIS1;

			movlw car_o;
			call mP0_DIS2;

			movlw car_p;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw num_2;
			call mP0_DIS5;

			movlw NULL;
			call mP0_DIS6;

			movlw car_p;
			call mP0_DIS7;

Loop147		decfsz Contador2,f;
			goto Loop147;
			decfsz Contador1,f;
			goto Ftgrm147;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm148		movlw N;
			movwf Contador2;

			movlw car_L;
			call mP0_DIS0;

			movlw car_o;
			call mP0_DIS1;

			movlw car_p;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw num_2;
			call mP0_DIS4;

			movlw NULL;
			call mP0_DIS5;

			movlw car_P;
			call mP0_DIS6;

			movlw car_uu;
			call mP0_DIS7;

Loop148		decfsz Contador2,f;
			goto Loop148;
			decfsz Contador1,f;
			goto Ftgrm148;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm149		movlw N;
			movwf Contador2;

			movlw car_o;
			call mP0_DIS0;

			movlw car_p;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw num_2;
			call mP0_DIS3;

			movlw NULL;
			call mP0_DIS4;

			movlw car_p;
			call mP0_DIS5;

			movlw car_uu;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop149		decfsz Contador2,f;
			goto Loop149;
			decfsz Contador1,f;
			goto Ftgrm149;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm150		movlw N;
			movwf Contador2;

			movlw car_p;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw num_2;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;

			movlw car_p;
			call mP0_DIS4;

			movlw car_uu;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw car_nn;
			call mP0_DIS7;

Loop150		decfsz Contador2,f;
			goto Loop150;
			decfsz Contador1,f;
			goto Ftgrm150;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm151		movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw num_2;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;

			movlw car_p;
			call mP0_DIS3;

			movlw car_uu;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw car_nn;
			call mP0_DIS6;

			movlw car_t;
			call mP0_DIS7;

Loop151		decfsz Contador2,f;
			goto Loop151;
			decfsz Contador1,f;
			goto Ftgrm151;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm152		movlw N;
			movwf Contador2;

			movlw num_2;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;

			movlw car_p;
			call mP0_DIS2;

			movlw car_uu;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw car_nn;
			call mP0_DIS5;

			movlw car_t;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop152		decfsz Contador2,f;
			goto Loop152;
			decfsz Contador1,f;
			goto Ftgrm152;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm153		movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;

			movlw car_p;
			call mP0_DIS1;

			movlw car_uu;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw car_nn;
			call mP0_DIS4;

			movlw car_t;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw NULL;
			call mP0_DIS7;

Loop153		decfsz Contador2,f;
			goto Loop153;
			decfsz Contador1,f;
			goto Ftgrm153;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm154		movlw N;
			movwf Contador2;

			movlw car_p;
			call mP0_DIS0;

			movlw car_uu;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw car_nn;
			call mP0_DIS3;

			movlw car_t;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw NULL;
			call mP0_DIS6;

			movlw car_R;
			call mP0_DIS7;

Loop154		decfsz Contador2,f;
			goto Loop154;
			decfsz Contador1,f;
			goto Ftgrm154;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm155	movlw N;
			movwf Contador2;

			movlw car_uu;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw car_nn;
			call mP0_DIS2;

			movlw car_t;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw NULL;
			call mP0_DIS5;

			movlw car_r;
			call mP0_DIS6;

			movlw car_A;
			call mP0_DIS7;

Loop155		decfsz Contador2,f;
			goto Loop155;
			decfsz Contador1,f;
			goto Ftgrm155;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm156	movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw car_nn;
			call mP0_DIS1;

			movlw car_t;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw NULL;
			call mP0_DIS4;

			movlw car_r;
			call mP0_DIS5;

			movlw car_A;
			call mP0_DIS6;

			movlw car_nn;
			call mP0_DIS7;

Loop156		decfsz Contador2,f;
			goto Loop156;
			decfsz Contador1,f;
			goto Ftgrm156;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm157	movlw N;
			movwf Contador2;

			movlw car_nn;
			call mP0_DIS0;

			movlw car_t;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;

			movlw car_r;
			call mP0_DIS4;

			movlw car_A;
			call mP0_DIS5;

			movlw car_nn;
			call mP0_DIS6;

			movlw car_nn;
			call mP0_DIS7;

Loop157		decfsz Contador2,f;
			goto Loop157;
			decfsz Contador1,f;
			goto Ftgrm157;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm158		movlw N;
			movwf Contador2;

			movlw car_t;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;

			movlw car_r;
			call mP0_DIS3;

			movlw car_A;
			call mP0_DIS4;

			movlw car_nn;
			call mP0_DIS5;

			movlw car_nn;
			call mP0_DIS6;

			movlw num_1;
			call mP0_DIS7;

Loop158		decfsz Contador2,f;
			goto Loop158;
			decfsz Contador1,f;
			goto Ftgrm158;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm159		movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;

			movlw car_r;
			call mP0_DIS2;

			movlw car_A;
			call mP0_DIS3;

			movlw car_nn;
			call mP0_DIS4;

			movlw car_nn;
			call mP0_DIS5;

			movlw num_1;
			call mP0_DIS6;

			movlw car_R;
			call mP0_DIS7;

Loop159		decfsz Contador2,f;
			goto Loop159;
			decfsz Contador1,f;
			goto Ftgrm159;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm160		movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;

			movlw car_r;
			call mP0_DIS1;

			movlw car_A;
			call mP0_DIS2;

			movlw car_nn;
			call mP0_DIS3;

			movlw car_nn;
			call mP0_DIS4;

			movlw num_1;
			call mP0_DIS5;

			movlw car_r;
			call mP0_DIS6;

			movlw car_E;
			call mP0_DIS7;

Loop160		decfsz Contador2,f;
			goto Loop160;
			decfsz Contador1,f;
			goto Ftgrm160;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm161		movlw N;
			movwf Contador2;

			movlw car_r;
			call mP0_DIS0;

			movlw car_A;
			call mP0_DIS1;

			movlw car_nn;
			call mP0_DIS2;

			movlw car_nn;
			call mP0_DIS3;

			movlw num_1;
			call mP0_DIS4;

			movlw car_r;
			call mP0_DIS5;

			movlw car_E;
			call mP0_DIS6;

			movlw num_2;
			call mP0_DIS7;

Loop161		decfsz Contador2,f;
			goto Loop161;
			decfsz Contador1,f;
			goto Ftgrm161;
			
			call mLimpieza_pg0;

;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm162		movlw N;
			movwf Contador2;

			movlw car_A;
			call mP0_DIS0;

			movlw car_nn;
			call mP0_DIS1;

			movlw car_nn;
			call mP0_DIS2;

			movlw num_1;
			call mP0_DIS3;

			movlw car_r;
			call mP0_DIS4;

			movlw car_E;
			call mP0_DIS5;

			movlw num_2;
			call mP0_DIS6;

			movlw NULL;
			call mP0_DIS7;

Loop162		decfsz Contador2,f;
			goto Loop162;
			decfsz Contador1,f;
			goto Ftgrm162;
			
			call mLimpieza_pg0;
			
			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm163	movlw N;
			movwf Contador2;

			movlw car_nn;
			call mP0_DIS0;

			movlw car_nn;
			call mP0_DIS1;

			movlw num_1;
			call mP0_DIS2;

			movlw car_r;
			call mP0_DIS3;

			movlw car_E;
			call mP0_DIS4;

			movlw num_2;
			call mP0_DIS5;

			movlw NULL;
			call mP0_DIS6;
			
			movlw num_1;
			call mP0_DIS7;

Loop163		decfsz Contador2,f;
			goto Loop163;
			decfsz Contador1,f;
			goto Ftgrm163;
			
			call mLimpieza_pg0;
			
			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm164	movlw N;
			movwf Contador2;

			movlw car_nn;
			call mP0_DIS0;

			movlw num_1;
			call mP0_DIS1;

			movlw car_r;
			call mP0_DIS2;

			movlw car_E;
			call mP0_DIS3;

			movlw num_2;
			call mP0_DIS4;

			movlw NULL;
			call mP0_DIS5;
			
			movlw num_1;
			call mP0_DIS6;
			
			movlw car_N;
			call mP0_DIS7;

Loop164		decfsz Contador2,f;
			goto Loop164;
			decfsz Contador1,f;
			goto Ftgrm164;
			
			call mLimpieza_pg0;
			
			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm165	movlw N;
			movwf Contador2;

			movlw num_1;
			call mP0_DIS0;

			movlw car_r;
			call mP0_DIS1;

			movlw car_E;
			call mP0_DIS2;

			movlw num_2;
			call mP0_DIS3;

			movlw NULL;
			call mP0_DIS4;
			
			movlw num_1;
			call mP0_DIS5;
			
			movlw car_N;
			call mP0_DIS6;
			
			movlw num_2;
			call mP0_DIS7;

Loop165		decfsz Contador2,f;
			goto Loop165;
			decfsz Contador1,f;
			goto Ftgrm165;
			
			call mLimpieza_pg0;
			
			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm166	movlw N;
			movwf Contador2;

			movlw car_r;
			call mP0_DIS0;

			movlw car_E;
			call mP0_DIS1;

			movlw num_2;
			call mP0_DIS2;

			movlw NULL;
			call mP0_DIS3;
			
			movlw num_1;
			call mP0_DIS4;
			
			movlw car_N;
			call mP0_DIS5;
			
			movlw num_2;
			call mP0_DIS6;
			
			movlw car_t;
			call mP0_DIS7;

Loop166		decfsz Contador2,f;
			goto Loop166;
			decfsz Contador1,f;
			goto Ftgrm166;
			
			call mLimpieza_pg0;
			
			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm167	movlw N;
			movwf Contador2;

			movlw car_E;
			call mP0_DIS0;

			movlw num_2;
			call mP0_DIS1;

			movlw NULL;
			call mP0_DIS2;
			
			movlw num_1;
			call mP0_DIS3;
			
			movlw car_N;
			call mP0_DIS4;
			
			movlw num_2;
			call mP0_DIS5;
			
			movlw car_t;
			call mP0_DIS6;
			
			movlw num_1;
			call mP0_DIS7;

Loop167		decfsz Contador2,f;
			goto Loop167;
			decfsz Contador1,f;
			goto Ftgrm167;
			
			call mLimpieza_pg0;
			
			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm168	movlw N;
			movwf Contador2;

			movlw num_2;
			call mP0_DIS0;

			movlw NULL;
			call mP0_DIS1;
			
			movlw num_1;
			call mP0_DIS2;
			
			movlw car_N;
			call mP0_DIS3;
			
			movlw num_2;
			call mP0_DIS4;
			
			movlw car_t;
			call mP0_DIS5;
			
			movlw num_1;
			call mP0_DIS6;
			
			movlw car_t;
			call mP0_DIS7;

Loop168		decfsz Contador2,f;
			goto Loop168;
			decfsz Contador1,f;
			goto Ftgrm168;
			
			call mLimpieza_pg0;


			;---------- Ftgm1 --------- _ _ _ _ _ _ 1

		 	movlw M;
			movwf Contador1;
Ftgrm169	movlw N;
			movwf Contador2;

			movlw NULL;
			call mP0_DIS0;
			
			movlw num_1;
			call mP0_DIS1;
			
			movlw car_N;
			call mP0_DIS2;
			
			movlw num_2;
			call mP0_DIS3;
			
			movlw car_t;
			call mP0_DIS4;
			
			movlw num_1;
			call mP0_DIS5;
			
			movlw car_t;
			call mP0_DIS6;
			
			movlw car_U;
			call mP0_DIS7;

Loop169		decfsz Contador2,f;
			goto Loop169;
			decfsz Contador1,f;
			goto Ftgrm169;
			
			call mLimpieza_pg0;
			
;-------------------------------------------------------------------------------------------

			goto regreso;
;--------------------------------------------------------------------------------------------

			;=======================
			;== Limpia displays ====
			;=======================
			
mLimpieza_pg0	bsf	portd,DIS0;
				bsf	portd,DIS1;
				bsf	portd,DIS2;
				bsf	portd,DIS3;
				bsf	portd,DIS4;
				bsf	portd,DIS5;
				bsf	portd,DIS6;
				bsf	portd,DIS7;
			
				bcf portb,a_RB0;
				bcf portb,b_RB1;
				bcf portb,c_RB2;
				bcf portb,d_RB3;
				bcf portb,e_RB4;
				bcf portb,f_RB5;
				bcf portb,g_RB6;
				bcf portb,dp_RB7;
			
				return;
			
;---------------------------------------------------------------------------------------------
			; ====================
			; === Retardo Menor ==
			; ====================
mRmn_pg0		movlw L;
			movwf Contador3;
mLoopR1		movlw K;
			movwf Contador4;
			
mLoopRB0		decfsz Contador4,f;
			goto mLoopRB0;
			decfsz Contador3,f;
			goto mLoopR1;

			return;
;---------------------------------------------------------------------------------------------
			;========================
			;=== Pulsos de cambio ===
			;========================
mP0_DIS0		movwf portb;
			bcf portd,DIS0;
			call mRmn_pg0;
			bsf portd,DIS0;
			return;

mP0_DIS1		movwf portb;
			bcf portd,DIS1;
			call mRmn_pg0;
			bsf portd,DIS1;
			return;

mP0_DIS2		movwf portb;
			bcf portd,DIS2;
			call mRmn_pg0;
			bsf portd,DIS2;
			return;

mP0_DIS3		movwf portb;
			bcf portd,DIS3;
			call mRmn_pg0;
			bsf portd,DIS3;
			return;

mP0_DIS4		movwf portb;
			bcf portd,DIS4;
			call mRmn_pg0;
			bsf portd,DIS4;
			return;

mP0_DIS5		movwf portb;
			bcf portd,DIS5;
			call mRmn_pg0;
			bsf portd,DIS5;
			return;

mP0_DIS6		movwf portb;
			bcf portd,DIS6;
			call mRmn_pg0;
			bsf portd,DIS6;
			return;

mP0_DIS7		movwf portb;
			bcf portd,DIS7;
			call mRmn_pg0;
			bsf portd,DIS7;
			return;

;---------------------------------------------------------------------------------------------	

regreso bcf pclath,.4;
		bcf pclath,.3;
		goto Ftgrm8;
				

		end