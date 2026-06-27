
				;=======================================
				;== Subrutina que muestra el tiempo ==
				;=======================================
muestra_time	
				movlw H'84';
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
				;====================================
				;== Subrutina que arma el tiempo ==
				;====================================
conv_A_ASCII	addwf pcl,f;
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