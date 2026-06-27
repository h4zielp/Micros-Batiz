;INSTITUTO POLITECNICO NACIONAL
;CECYT 9 "Juan de Dios Bátiz"
;
;PRACTICA 1
;TIMER 0 "MANEJO DE UNA PANTALLA LCD" (RELOJ DE TIEMPO REAL)
;
;PROFESOR:
;OLIVARES
;
;GRUPO: 6IM1	EQUIPO: 6
;
;INTEGRANTES:
;1.-DELGADO CRUZ TONATIUH JAREB
;2.-ESPINOSA PORRAS JAIME HAMID
;3.-GUTIERREZ DELGADO EMILIANO
;4.-SANCHEZ ESCOBAR DIANA ITZEL
;
;COMENTARIO DE LO QUE EL PROGRAMA EJECUTARA:
;El programa llevara a cabo la cuenta de un reloj en tiempo real en formato militar, donde utilizando el timer 0 se controlara
;la visualizacion del tiempo esto a traves de una interfazar una LCD de 16 char x 1 linea al microcontrolador "PIC16F877A"
;
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
 list p=16f877A;  
 ;#include "c:\program files (x86)\microchip\mpasm suite\p16f877a.inc";  
 #include "C:\Program Files (x86)\Microchip\MPASM Suite\P16F877A.INC";

; Bits de configuración.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF;ALL
;---------------------------------------------------------------------------------------------
;
; fosc = 4 MHz.
; Ciclo de trabajo del PIC = (1/fosc)*4 = 1 µs.
; t int = (256-tmr0)*(P)*((1/3579545)*4) = 1ms  ;//Tiempo de interrupcion.
; tmr0 = 131, P = 8
; frec int = 1/t int = 1KHz
;-------------------------------------------------------------------------------------------
;
; Registros de propósito general Banco 0 de memoria RAM.
;
; Registros propios de estructura del programa

resp_w		  equ 0x20;
resp_status	  equ 0x21;
res_pclath	  equ 0x22;
res_fsr	 	  equ 0x23;
presc_1	 	  equ 0x24;
presc_2		  equ 0x25;
banderas	  equ 0x26;
cont_milis	  equ 0x27;
dec_seg		  equ 0x28;
uni_seg		  equ 0x29;
dec_seg_ascii equ 0x2A;
uni_seg_ascii equ 0x2B;
dec_min       equ 0x2C;
uni_min       equ 0x2D;
dec_min_ascii equ 0x2E;
uni_min_ascii equ 0x2F;
dec_hrs       equ 0x30;
uni_hrs       equ 0x31;
dec_hrs_ascii equ 0x32;
uni_hrs_ascii equ 0x33;
;---------------------------------------------------------------------------------------------
;
;Def. de constantes a utilizar.
;
dig1_LCD	  equ 0x80;
dig5_LCD	  equ 0x84;
dig8_LCD	  equ 0x87;
dig11_LCD	  equ 0x8A;

conv_ascii	  equ 0X30;

; Banderas del registro banderas.
ban_int		  equ 	   .0; //
sin_bd1		  equ	   .1;
sin_bd2		  equ	   .2;
sin_bd3		  equ      .3;
sin_bd4		  equ      .4;
sin_bd5		  equ	   .5;
sin_bd6		  equ	   .6;
sin_bd7		  equ      .7;
;---------------------------------------------------------------------------------------------
; 
;Asignación de los bits de los puertos de I/O.
;Puerto A.
RS_LCD	      equ          .0; // Señal de control Comando o dato de la LCD.
Enable_LCD    equ          .1; // Señal de ingreso de informacion a la LCD.
Sin_UsoRA2    equ          .2; // Sin Uso RA2.
Sin_UsoRA3    equ          .3; // Sin Uso RA3.
Sin_UsoRA4    equ          .4; // Sin Uso RA4.
Sin_UsoRA5    equ          .5; // Sin Uso RA5.
  
proga         equ   b'111100'; // Programación inicial del puerto A.

 ;Puerto B.
Sin_UsoRB0    equ          .0; // Sin_UsoRB0.
Sin_UsoRB1    equ          .1; // Sin_UsoRB1.
Sin_UsoRB2    equ          .2; // Sin_UsoRB2.
Sin_UsoRB3    equ          .3; // Sin_UsoRB3.
Sin_UsoRB4    equ          .4; // Sin_UsoRB4.
Sin_UsoRB5    equ          .5; // Sin_UsoRB5.
Sin_UsoRB6    equ          .6; // Sin_UsoRB6.
Sin_UsoRB7    equ          .7; // Sin_UsoRB7.

progb         equ b'11111111'; // Programación inicial del puerto B.

 ; Puerto C.
D0_LCD	      equ          .0; // Bit D0 de la LCD.
D1_LCD	      equ          .1; // Bit D1 de la LCD.
D2_LCD	      equ          .2; // Bit D2 de la LCD.
D3_LCD	      equ          .3; // Bit D3 de la LCD.
D4_LCD	      equ          .4; // Bit D4 de la LCD.
D5_LCD	      equ          .5; // Bit D5 de la LCD.
D6_LCD	      equ          .6; // Bit D6 de la LCD.
D7_LCD	      equ          .7; // Bit D7 de la LCD.

progc         equ b'00000000'; // Programación inicial del puerto C como entrada.

;Puerto D.
Sin_UsoRD0    equ          .0; // Sin Uso RD0.
Sin_UsoRD1    equ          .1; // Sin Uso RD1.
Sin_UsoRD2    equ          .2; // Sin Uso RD2.
Sin_UsoRD3    equ          .3; // Sin Uso RD3.
Sin_UsoRD4    equ          .4; // Sin Uso RD4.
Sin_UsoRD5    equ          .5; // Sin Uso RD5.
Sin_UsoRD6    equ          .6; // Sin Uso RD6.
Sin_UsoRD7    equ          .7; // Sin Uso RD7.

progd         equ b'11111111'; // Programación inicial del puerto D como entradas.
 
;Puerto E.
Sin_UsoRE0    equ          .0; // Sin Uso RE0.
Sin_UsoRE1    equ          .1; // Sin Uso RE1.
Led_Op        equ          .2; // Led Sistema en operación.

proge         equ      b'011'; // Programación inicial del puerto E.

;---------------------------------------------------------------------------------------------
 
                             ; ==================
                             ; == Vector Reset ==
                             ; ==================
                    org 0x0000;
vec_reset           clrf pclath; Se asegura la página cero de la memoria de programa  
                    goto prog_prin;
;---------------------------------------------------------------------------------------------

                       ; ==============================
                       ; ==  Vector de interrupción  ==
                       ; ==============================
                        org 0x0004;                  
vec_int                 movwf resp_w;resp. el estado del reg. w.
						movf  status,w;
						movwf resp_status;resp. banderas de la alu.
						clrf  status;
						movf  pclath,w;
						movwf res_pclath;
						clrf  pclath;
						movf  fsr,w;
						movwf res_fsr;

						btfsc intcon,tmr0if;
						call  rutina_int;

sal_int					movlw .131;
						movwf tmr0;

						movf  res_fsr,w;
						movwf fsr;
						movf  res_pclath,w;
						movwf pclath;
						movf  resp_status,w;
						movwf status;
						movf  resp_w,w;

						retfie;
             
;---------------------------------------------------------------------------------------------
						
						;=================================
						;== Subrutina de Interrupciones ==
						;=================================
rutina_int				incf  cont_milis,f;
							 		   ;                      100       10
						incf  presc_1,f;   t int = t intb * presc_1 * presc_2

						movlw .100;
						subwf presc_1,w;
						btfss status,z;
						goto  sal_rutint;
						clrf  presc_1;

						incf  presc_2,f;
						movlw .10;
						subwf presc_2,w;
						btfss status,z;
						goto  sal_rutint;
						clrf  presc_1;
						clrf  presc_2;

						bsf   banderas,ban_int;

sal_rutint				bcf	  intcon,t0if;
						return;
;---------------------------------------------------------------------------------------------
                 
                        ; ===========================
                        ; ==  Subrutina de inicio  ==
                        ; ===========================
prog_ini                bsf status,rp0; Ponte en el banco 1 de ram.
                        movlw 0x82;                       
                        movwf option_reg ^0x80;
                        movlw proga;             w <-- b'111111'    
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
                        bcf status,rp0;    Ponte en el banco 0 de ram

                        movlw 0xA0;
                        movwf intcon;

						movlw .131;
                        movwf tmr0;
                       
						clrf  banderas;

						clrf  portc;
						movlw 0x03;
						movwf porta;

						return;
;---------------------------------------------------------------------------------------------

			;==========================
			;== Programa principal ==
			;==========================
prog_prin	call prog_ini;

			call ini_lcd;
			call ini_cta_LCD;

Loop_prin	call esp_int;
			call cuenta_bin;
			call conv_bin_ascii;
			call muestra_cta;

			goto Loop_prin;

;---------------------------------------------------------------------------------------------

					;================================================
					;== Subrutina de espera de int. de 0.5 segundo ==
					;================================================
ini_cta_LCD			bcf   porta,RS_LCD;
					movlw dig5_LCD;
					movwf portc;
					call  pulso_enable;
					bsf   porta,RS_LCD;

					movlw '0';
					movwf portc;
					call  pulso_enable;
					call  pulso_enable;

					movlw ':';
					movwf portc;
					call  pulso_enable;

					movlw '0';
					movwf portc;
					call  pulso_enable;
					call  pulso_enable;

					movlw ':';
					movwf portc;
					call  pulso_enable;

					movlw '0';
					movwf portc;
					call  pulso_enable;
					call  pulso_enable;

					return;

;---------------------------------------------------------------------------------------------

				;================================================
				;== Subrutina de espera de int. de 0.5 segundo ==
				;================================================
esp_int			nop;
				btfss banderas,ban_int;
				goto  esp_int;
				bcf   banderas,ban_int;

				return;

;---------------------------------------------------------------------------------------------

				;===================================
				;== Subrutina de cuenta de tiempo ==
				;===================================
cuenta_bin		incf  uni_seg,f;
				movlw .10;
				subwf uni_seg,w;
				btfss status,Z;
				goto  salte_cuenta;
				clrf  uni_seg;

				incf  dec_seg,f;
				movlw .6;
				subwf dec_seg,w;
				btfss status,Z;
				goto  salte_cuenta;
				clrf  uni_seg;
				clrf  dec_seg;

				incf  uni_min,f;
				movlw .10;
				subwf uni_min,w;
				btfss status,Z;
				goto  salte_cuenta;
				clrf  uni_seg;
				clrf  dec_seg;
				clrf  uni_min;

				incf  dec_min,f;
				movlw .6;
				subwf dec_min,w;
				btfss status,Z;
				goto  salte_cuenta;
				clrf  uni_seg;
				clrf  dec_seg;
				clrf  uni_min;
				clrf  dec_min;

				incf  uni_hrs,f;
				movlw .10;
				subwf uni_hrs,w;
				btfss status,Z;
				goto  salte_cuenta;
				clrf  uni_seg;
				clrf  dec_seg;
				clrf  uni_min;
				clrf  dec_min;
				clrf  uni_hrs;

				incf  dec_hrs,f;
				movlw .3;
				subwf dec_hrs,w;
				btfss status,Z;
				goto  salte_cuenta;
				clrf  uni_seg;
				clrf  dec_seg;
				clrf  uni_min;
				clrf  dec_min;
				clrf  uni_hrs;
				clrf  dec_hrs;

salte_cuenta	return;
;---------------------------------------------------------------------------------------------

				;====================================
				;== Subrutina de armado del tiempo ==
				;====================================
conv_bin_ascii	movf  uni_seg,w;
				addlw conv_ascii;
				movwf uni_seg_ascii;

				movf  dec_seg,w;
				addlw conv_ascii;
				movwf dec_seg_ascii;

				movf  uni_min,w;
				addlw conv_ascii;
				movwf uni_min_ascii;

				movf  dec_min,w;
				addlw conv_ascii;
				movwf dec_min_ascii;

				movf  uni_hrs,w;
				addlw conv_ascii;
				movwf uni_hrs_ascii;

				movf  dec_hrs,w;
				addlw conv_ascii;
				movwf dec_hrs_ascii;

				return;
;---------------------------------------------------------------------------------------------

				;===========================================
				;== Subrutina muestra el tiempo en la LCD ==
				;===========================================
muestra_cta		bcf   porta,RS_LCD;
				movlw dig5_LCD;
				movwf portc;
				call  pulso_enable;
				bsf   porta,RS_LCD;

				movf  dec_hrs_ascii,w;
				movwf portc;
				call  pulso_enable;

				movf  uni_hrs_ascii,w;
				movwf portc;
				call  pulso_enable;

				movlw ':';
				movwf portc;
				call  pulso_enable;

				movf  dec_min_ascii,w;
				movwf portc;
				call  pulso_enable;

				movf  uni_min_ascii,w;
				movwf portc;
				call  pulso_enable;

				movlw ':';
				movwf portc;
				call  pulso_enable;

				movf  dec_seg_ascii,w;
				movwf portc;
				call  pulso_enable;

				movf  uni_seg_ascii,w;
				movwf portc;
				call  pulso_enable;

				return;
;---------------------------------------------------------------------------------------------

				;===========================================
				;== Subrutina de inicializacion de la LCD ==
				;===========================================
ini_lcd			bcf   porta,RS_LCD; coloca la lcd en el formato comandos

				movlw 0x38;
				movwf portc;
				call  pulso_enable;
				movlw 0x0C;
				movwf portc;
				call  pulso_enable;
				movlw 0x01;
				movwf portc;
				call  pulso_enable;
				movlw 0x06;
				movwf portc;
				call  pulso_enable;
				movlw dig1_LCD;
				movwf portc;
				call  pulso_enable;

				bsf   porta,RS_LCD;

				return;
;---------------------------------------------------------------------------------------------

				;===========================================
				;== Subrutina de retardo de medio segundo ==
				;===========================================
pulso_enable    bcf   porta,Enable_LCD;
				call  retardo_1ms;
				bsf   porta,Enable_LCD;

				call  ret_40ms;
				
				return;
;---------------------------------------------------------------------------------------------

				;===========================================
				;== Subrutina de retardo de 1 milisegundo ==
				;===========================================
retardo_1ms		clrf  cont_milis;
esp_int1ms		movlw .1;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_int1ms;

				return;
;---------------------------------------------------------------------------------------------

				;=============================================
				;== Subrutina de retardo de 40 milisegundos ==
				;=============================================
ret_40ms		clrf  cont_milis;
esp_int40ms		movlw .40;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_int40ms;

				return;

;---------------------------------------------------------------------------------------------
;================================== Y ya terminamos FIN ======================================
;---------------------------------------------------------------------------------------------

                      end