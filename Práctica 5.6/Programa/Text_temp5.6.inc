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
			;call RETARDO_1ms;

			return;
;--------------------------------------------------------------------------------------------------	
Text_ini	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 'M';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'J';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw 'M';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'M';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD
			movlw 'A';
			call PRINT_LCD;
			movlw 'M';
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			call RETARDO_8s;
			return;
;---------------------------------------------------------------------------------------------}
Text_menu	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
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
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw '1';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw '2';
			call PRINT_LCD;
			movlw 'W';
			call PRINT_LCD
			movlw 'R';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD
			movlw 'T';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD
			
			return;
;---------------------------------------------------------------------------------------------}
Text_read	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 0x20;
			call PRINT_LCD;
			movlw 0x20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw '1';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'L';
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'T';
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD
			movlw 'A';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			call RETARDO_3s;
			return;
;---------------------------------------------------------------------------------------------
Text_write	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 0x20;
			call PRINT_LCD;
			movlw 0x20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw 'N';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw '2';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 'E';
			call PRINT_LCD;
			movlw 'S';
			call PRINT_LCD;
			movlw 'C';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'T';
			call PRINT_LCD;
			movlw 'U';
			call PRINT_LCD
			movlw 'R';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			call RETARDO_3s;
			return;
;---------------------------------------------------------------------------------------------}
Text_ram	movlw 0x01;
			call COMANDO_LCD;
			movlw 0x80;
			call COMANDO_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'I';
			call PRINT_LCD;
			movlw 'R';
			call PRINT_LCD;
			movlw ':';
			call PRINT_LCD;
			movlw 'X';			0x85
			call PRINT_LCD;
			movlw 'X';
			call PRINT_LCD;
			movlw 'X';
			call PRINT_LCD;
			movlw 'H';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD;
			
			movlw 0xC0;
			call COMANDO_LCD;
			movlw 'D';
			call PRINT_LCD;
			movlw 'A';
			call PRINT_LCD;
			movlw 'T';
			call PRINT_LCD;
			movlw 'O';
			call PRINT_LCD;
			movlw ':';
			call PRINT_LCD;
			movlw 'X';
			call PRINT_LCD;
			movlw 'X';
			call PRINT_LCD;
			movlw 'H';
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			movlw 0X20;
			call PRINT_LCD;
			movlw 0X20;
			call PRINT_LCD
			call RETARDO_3s;
			return;
;_-----------------------------------------------------------------------------------------------
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
RETARDO_3s	clrf cont_seg;
esp_3s		movlw .3;
			subwf cont_seg,w;
			btfss status,Z;
			goto  esp_3s;
			return;
;---------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================
RETARDO_8s	clrf cont_seg;
esp_8s		movlw .8;
			subwf cont_seg,w;
			btfss status,Z;
			goto  esp_8s;
			return;
;---------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_0.1s	clrf cont_milis;
esp_0.1s		movlw .100;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_0.1s;
				return;
;--------------------------------------------------------------------------------------------------

			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_0.2s	clrf cont_milis;
esp_0.2s		movlw .200;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_0.2s;
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
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_16ms	clrf cont_milis;
esp_16ms		movlw .16;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_16ms;
				return;
;--------------------------------------------------------------------------------------------------
			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_4ms		clrf cont_milis;
esp_4ms			movlw .4;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_4ms;
				return;
;--------------------------------------------------------------------------------------------------

			;=========================================
			;== Subrutina de RETARDO_2ms MILISEGUNDOS ==
			;=========================================

RETARDO_0.08s	clrf cont_milis;
esp_0.08s		movlw .8;
				subwf cont_milis,w;
				btfss status,Z;
				goto  esp_0.08s;
				return;
;--------------------------------------------------------------------------------------------------