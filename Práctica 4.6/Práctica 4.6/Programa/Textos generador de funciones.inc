			;=========================================
			;== Subrutina de HABILITACIÓN DE LCD (E) ==
			;=========================================
PRINT_LCD	bsf porta,LCD_R#s;
			goto CARGA;
COMANDO_LCD	bcf porta,LCD_R#s; Modo comando
CARGA		movwf portc;

			call RETARDO_1ms
			bcf porta,LCD_E;
			call RETARDO_1ms;
			bsf porta,LCD_E;
			call RETARDO_1ms;

			return;
;--------------------------------------------------------------------------------------------------	
text_ini	movlw 0x80;
			call COMANDO_LCD;
			movlw 'G';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 0X20;Espacio en blanco
			call PRINT_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw 'F';
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'S';
			call PRINT_LCD;
			return;

text_menu	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 'S';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'P';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw ':';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw '1';
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw '2';
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw '3';
			call PRINT_LCD
			return;
			
text_square	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 'S';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'T';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
            return;
text_senoi	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 'S';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'S';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
            return;
text_trian	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 'S';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'T';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'G';
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
            return;
;---------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================
RETARDO_1ms clrf cont_milis;
esp_int1ms	movlw .1;
			subwf cont_milis,w;
			btfss status,Z;
			goto  esp_int1ms;
			return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================
RETARDO_5s	    clrf cont_seg;
esp_5s			movlw .5;
				subwf cont_seg,w;
				btfss status,Z;
				goto  esp_5s;
				return;
;---------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_0.1s	clrf cont_milis;
esp_0.1s		movlw .100;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_int1ms;
				return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_0.08s	clrf cont_milis;
esp_0.08s		movlw .78;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_0.08s;
				return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_5ms		clrf cont_milis;
esp_5ms			movlw .5;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_5ms;
				return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_2ms		clrf cont_milis;
esp_2ms			movlw .2;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_2ms;
				return;
;--------------------------------------------------------------------------------------------------