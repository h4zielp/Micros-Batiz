select_tec		equ 0x47;	
var_tecld		equ 0x48;	Regresa con la tecla en formato H
var_expl		equ 0x49;	Regresa con la tecla en formato ASCIIs


tec_array		clrf select_tec;
				
				movlw 0x30;
				movwf FSR;
				
				movlw 0x01;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x02;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x03;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x0A;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x04;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x05;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x06;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x0B;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x07;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x08;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x09;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x0C;
				movwf INDF;
				
				incf FSR,f;
				movlw 0xFF;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x00;
				movwf INDF;
				
				incf FSR,f;
				movlw 0xFF;
				movwf INDF;
				
				incf FSR,f;
				movlw 0x0D;
				movwf INDF;
				return;
;---------------------------------------------------------------------------------------------

			;=======================================
			;== Subrutina que explora el teclado ===
			;=======================================
expl_tec		clrf var_expl;
				clrf var_tecld;
				clrf select_tec;
				
				call RETARDO_1ms;				

				movlw 0x0E;
				movwf var_expl;
				
loop_expl		movf var_expl,w;
				movwf portb;
				
				nop;
				
				movf portb,w;
				movwf var_tecld;
				
				movlw 0xF0;
				andwf var_tecld,f;	Recorta el nibble de las Filas
				swapf var_tecld,f;	Pasa el nibble alto al bajo
				
				nop;
				nop;
				
				movlw 0x0F;
				xorwf var_tecld,w;	Corrobora que haya una tecla 
				btfsc status,z;		oprimida.
				goto sig_Fil;
				
				nop;
				goto selec.tec;
				
sig_Fil			clrf var_tecld;		Limpia la variable para otra exploraci n.
				bsf status,c;		Condiciona el carry para una rotaci n.
				
				rlf var_expl,f;		Hace una rotaci n hacia la derecha (descendente).
				movlw 0x0F;			Recorta el nibble alto de la variable de exploraci n
				andwf var_expl,f;	para no interferir con los valores introducidos.
				
				nop;
				nop;
				
				movlw 0x0F;			Revisa que la varible de exploraci n no sobrepase
				xorwf var_expl,w;	l mite: var_expl{0x0E,0X0D,0X0B,0X07}.
				btfsc status,z;
				goto expl_tec;
				
				goto loop_expl;
				
;---------------------------------------------------------------------------------------------				
				
selec.tec		call asing.fil;
				movwf select_tec;
				call asing.tec;
				
				addwf select_tec,f;
				
				movf FSR,w;
				movwf res_fsr;
				clrf FSR;
				
				movf select_tec,w;
				movwf FSR;
				movf INDF,w;
				movwf var_tecld;
				nop;
				
				clrf FSR;
				movf res_fsr,w;
				movwf FSR;
				clrf res_fsr;
				
				call conv_ASCII;
				movwf var_expl;
				return;
;---------------------------------------------------------------------------------------------

asing.fil		movlw 0x0E;
				xorwf var_expl,w;
				btfsc status,z;
				retlw 0x30;
				
				movlw 0x0D;
				xorwf var_expl,w;
				btfsc status,z;
				retlw 0x34;
				
				movlw 0x0B;
				xorwf var_expl,w;
				btfsc status,z;
				retlw 0x38;
				
				movlw 0x07;
				xorwf var_expl,w;
				btfsc status,z;
				retlw 0x3C;
				
asing.tec		movlw 0x0E;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw .0;
				
				movlw 0x0D;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw .1;
				
				movlw 0x0B;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw .2;
				
				movlw 0x07;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw .3;
				
				nop;
				nop;
				goto expl_tec;
				
				return;
				
conv_ASCII		movlw 0x0A;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw 'A';
				
				movlw 0x0B;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw 'B';
				
				movlw 0x0C;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw 'C';
				
				movlw 0x0D;
				xorwf var_tecld,w;
				btfsc status,z;
				retlw 'D';
				
				movlw '0';
				addwf var_tecld,w;
				return;