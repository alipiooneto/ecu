Comment	*

	 Autor: Eng. Alipio de Oliveira Neto

		versao 1.0 ( 24-11-94 )

	 Rotinas gerais para comunicao com monitor COM2
	*


CGROUP	GROUP	CODE_SEG
	ASSUME	CS:CGROUP


CODE_SEG	SEGMENT	PUBLIC


FUNTR		PROC	NEAR

	PUBLIC	FUNTR
;--------------------------------------;
;	Limpa toda tela		       ;
;--------------------------------------;

	PUBLIC  CLS_TELA

CLS_TELA	PROC	NEAR

		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		XOR  AL,AL		;Limpa tela inteira
		XOR  CX,CX		;Canto superior esquedo (0,0)
;		MOV  DH,24		;Ultima linha= 24
		MOV  DH,23		;Ultima linha= 24
		MOV  DL,79		;Coluna da direita = 79
;		MOV  BH,7		;Atributo tela normal 80 por 25
		MOV  BH,74h		;Atributo amarelo fundo vermelho
		MOV  AH,6		;Chama funcao 6
		INT  10h		;Limpa janela
		POP  DX
		POP  CX
		POP  BX
		POP  AX
		RET

CLS_TELA	ENDP


	PUBLIC	CLS_SAI

CLS_SAI		PROC	NEAR

		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		XOR  AL,AL		;Limpa tela inteira
		XOR  CX,CX		;Canto superior esquedo (0,0)
		MOV  DH,24		;Ultima linha= 24
		MOV  DL,79		;Coluna da direita = 79
		MOV  BH,7		;Atributo tela normal 80 por 25
		MOV  AH,6		;Chama funcao 6
		INT  10h		;Limpa janela
		POP  DX
		POP  CX
		POP  BX
		POP  AX
		RET

CLS_SAI		ENDP


;--------------------------------------;
;	Tela de Abertura	       ;
;				       ;
;--------------------------------------;

	PUBLIC	TEL_ABER

TEL_ABER 	PROC	NEAR

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0CDh		;Caracter a ser impresso
		MOV  DX,0000h
		MOV  CL,4Fh		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0BBh		;Caracter a ser impresso
		MOV  DX,004Fh		;DH =Linha   Dl = Coluna
		MOV  CL,01h		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,00h		;Linha vertival p/ baixo BL = 0
		MOV  BH,0BAh		;Caracter a ser impresso
		MOV  DX,014Fh		;DH =Linha   Dl = Coluna
		MOV  CL,17h		;Quantidade de linhas
		CALL LIN_V

		MOV  BL,00h		;Linha vertival p/ baixo BL = 0
		MOV  BH,0BCh		;Caracter a ser impresso
		MOV  DX,174Fh		;DH =Linha   Dl = Coluna
		MOV  CL,01h		;Quantidade de linhas
		CALL LIN_V

		MOV  BL,00h		;Linha horizontal esquerda BL = 0
		MOV  BH,0CDh		;Caracter a ser impresso
		MOV  DX,174Eh
		MOV  CL,4Fh		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,00h		;Linha horizontal esquerda BL = 0
		MOV  BH,0C8h		;Caracter a ser impresso
		MOV  DX,1700h
		MOV  CL,01h		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,01h		;Linha vertival p/ cima BL = 1
		MOV  BH,0BAh		;Caracter a ser impresso
		MOV  DX,1600h		;DH =Linha   Dl = Coluna
		MOV  CL,17h		;Quantidade de linhas
		CALL LIN_V

		MOV  BL,01h		;Linha vertival p/ cima BL = 1
		MOV  BH,0C9h		;Caracter a ser impresso
		MOV  DX,0000h		;DH =Linha   Dl = Coluna
		MOV  CL,01h		;Quantidade de linhas
		CALL LIN_V

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0CCh		;Caracter a ser impresso
		MOV  DX,0400h
		MOV  CL,01h		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0CDh		;Caracter a ser impresso
		MOV  DX,0401h
		MOV  CL,4Eh		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0B9h		;Caracter a ser impresso
		MOV  DX,044Fh
		MOV  CL,01h		;Quantidade de colunas
		CALL LIN_H

;--------------------------------------------------------

	;***  Quadro inferior

		MOV  BL,00h		;Linha horizontal esquerda BL = 0
		MOV  BH,0CDh		;Caracter a ser impresso
		MOV  DX,154Eh           ;Rodape
		MOV  CL,4Fh		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0B9h		;Caracter a ser impresso
		MOV  DX,154Fh
		MOV  CL,01h		;Quantidade de colunas
		CALL LIN_H

		MOV  BL,01h		;Linha horizontal direita BL = 1
		MOV  BH,0CCh		;Caracter a ser impresso
		MOV  DX,1500h
		MOV  CL,01h		;Quantidade de colunas
		CALL LIN_H

;--------------------------------------------------------

TEL_ABER	ENDP


;--------------------------------------;
;	Posiciona cursor	       ;
;	em  DH numero da linha	       ;
;	em  DL numero da coluna	       ;
;--------------------------------------;

	PUBLIC	POS_CUR

POS_CUR	 	PROC	NEAR

		PUSH DX		;Numero linha e coluna
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		POP  DX
		RET

POS_CUR		ENDP


;--------------------------------------;
;	Imprime horizontal             ;
;    BL = 0 esquerda  BL = 1 direita   ;
;	em  CL quantidade de colunas   ;
;	em  BH caracter a imprimir     ;
;--------------------------------------;

	PUBLIC	LIN_H

LIN_H		PROC	NEAR

HOR_1:
		PUSH DX		;Numero linha e coluna
		PUSH CX
		PUSH BX
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		POP  BX
		POP  CX
		POP  DX
		PUSH DX
		PUSH CX
		PUSH BX
		MOV  AH,2
		MOV  DL,BH
		INT  21h
		POP  BX
		POP  CX
		POP  DX
		CMP  BL,1h
		JZ   HOR_2
		DEC  DL
		JMP  HOR_3
HOR_2:		INC  DL
HOR_3:		DEC  CL
		JNZ  HOR_1
		RET

LIN_H		ENDP



;--------------------------------------;
;	Imprime vertical               ;
;    BL = 0 p/ baixo  BL = 1 p/ cima   ;
;	em  CL quantidade de linhass   ;
;	em  BH caracter a imprimir     ;
;--------------------------------------;

	PUBLIC	LIN_V

LIN_V		PROC	NEAR

VER_1:
		PUSH DX		;Numero linha e coluna
		PUSH CX
		PUSH BX
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		POP  BX
		POP  CX
		POP  DX
		PUSH DX
		PUSH CX
		PUSH BX
		MOV  AH,2
		MOV  DL,BH
		INT  21h
		POP  BX
		POP  CX
		POP  DX
		CMP  BL,0h
		JZ   VER_2
		DEC  DH
		JMP  VER_3
VER_2:		INC  DH
VER_3:		DEC  CL
		JNZ  VER_1
		RET

LIN_V		ENDP



;--------------------------------------;
;	Imprime mensagem	       ;
;	Em DX mensagem		       ;
;	Em BX posicao linha/coluna     ;
;--------------------------------------;

	PUBLIC	PR_MEN

PR_MEN	PROC	NEAR

		PUSH DX		;Mensagem
		MOV  DX,BX
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		POP  DX
		MOV  AH,9
		INT  21h
		RET

PR_MEN		ENDP


;--------------------------------------;
;	Le caracter e Imprime 	       ;
;	Volta caracter em AL	       ;
;	Em BX posicao linha/coluna     ;
;--------------------------------------;

	PUBLIC	LE_OPC

LE_OPC		PROC	NEAR

		PUSH BX		;Posicao cursor
		MOV  DX,BX
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		MOV  AH,08h	;Le caracter
		INT  21h
		PUSH AX
		CMP  AL,48h
		JNZ  LEPCE
		MOV  AL,20h
LEPCE:		MOV  DL,AL
		MOV  AH,02h
		INT  21h
		POP  AX
		POP  BX
		PUSH AX
		MOV  DX,BX
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		POP  AX
		RET

LE_OPC		ENDP

;--------------------------------------;
;	Video fechando p/ centro       ;
;  em  CL cur_ini / CH cur_fim         ;
;  em  BH linha   / BL qtde caract.    ;
;  em  DI men_ini / SI mem_fin         ;
;--------------------------------------;

	PUBLIC	MEN_CEN

MEN_CEN	 	PROC	NEAR

		PUSH AX
		MOV  SI,DI
		MOV  CH,CL
		MOV  BL,00h
M_CEN1:		MOV  AL,[SI+0]
		CMP  AL,'$'
		JZ   M_CEN1A
		INC  SI
		INC  CH
		INC  BL
		JMP  M_CEN1
M_CEN1A:	DEC  SI
		DEC  CH
M_CEN1B:	PUSH CX
		PUSH BX
		MOV  DH,BH
		MOV  DL,CL	;Numero linha e coluna
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		MOV  AL,[DI+0]	;Caracter p/ impimir
		MOV  DL,AL
		MOV  AH,02h
		INT  21h
		POP  BX
		POP  CX
		POP  AX
		PUSH AX
		PUSH CX
		PUSH BX
M_CEN1B0:	DEC  AX
		JNZ  M_CEN1B0
		POP  BX
		POP  CX
		INC  DI
		INC  CL
		DEC  BL
		JZ   M_CEN1C
		PUSH CX
		PUSH BX
		MOV  DH,BH
		MOV  DL,CH	;Numero linha e coluna
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		MOV  AL,[SI+0]	;Caracter p/ impimir
		MOV  DL,AL
		MOV  AH,02h
		INT  21h
		POP  BX
		POP  CX
		POP  AX
		PUSH AX
		PUSH CX
		PUSH BX
M_CEN1B1:	DEC  AX
		JNZ  M_CEN1B1
		POP  BX
		POP  CX
		DEC  SI
		DEC  CH
		DEC  BL
		JNZ  M_CEN1B
M_CEN1C:	POP  AX
		RET


MEN_CEN	 	ENDP


;--------------------------------------;
;	Mensagem impressa p/ direita   ;
;  em  DX linha e coluna	       ;
;  em  DI men_ini 		       ;
;--------------------------------------;

	PUBLIC	MEN_DIR

MEN_DIR	 	PROC	NEAR


M_DIR1:		MOV  AL,[DI+0]
		CMP  AL,'$'
		JZ   M_DIR1B
		PUSH DX		;Numero linha e coluna
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		MOV  DL,AL	;Caracter para imprimir
		MOV  AH,02h
		INT  21h
		MOV  BX,SI
M_DIR1A:	DEC  BX
		JNZ  M_DIR1A
		POP  DX
		INC  DI
		INC  DL
		JMP  M_DIR1
M_DIR1B:	RET


MEN_DIR	 	ENDP


;--------------------------------------;
;	Mensagem impressa p/ esquerda  ;
;  em  DX linha e coluna	       ;
;  em  DI men_ini 		       ;
;--------------------------------------;

	PUBLIC	MEN_ESQ

MEN_ESQ	 	PROC	NEAR


		MOV  CH,00h
M_ESQ1:		MOV  AL,[DI+0]
		CMP  AL,'$'
		JZ   M_ESQ1A
		INC  DI
		INC  CH		;Quantidade caracteres
		INC  DL		;Posicao Cursor
		JMP  M_ESQ1
M_ESQ1A:	DEC  DI
		DEC  DL
M_ESQ1B:	PUSH DX		;Numero linha e coluna
		MOV  AH,2	;Funcao
		MOV  BH,0	;Numero pagina de video
		INT  10h
		MOV  AL,[DI+0]  ;Caracter p/ imprimir
		MOV  DL,AL
		MOV  AH,02h
		INT  21h
		MOV  BX,SI
M_ESQ1C:	DEC  BX
		JNZ  M_ESQ1C
		POP  DX
		DEC  DI
		DEC  DL
		DEC  CH
		JNZ  M_ESQ1B
		RET

MEN_ESQ	 	ENDP


;--------------------------------------;
;	Le teclado		       ;
;	em  BX racunho teclado	       ;
;	em  DX nome arquivo + 00h      ;
;--------------------------------------;

	PUBLIC	LE_TEC

LE_TEC	 	PROC	NEAR

		PUSH DX		;Nome do arquivo
LER1:
		PUSH BX		;Rascunho do teclado
		MOV  DX,BX
		MOV  AH,0Ah
		INT  21h
		POP  BX
		MOV  CL,[BX+1]
		CMP  CL,00h
		JZ   LER1 
		MOV  SI,BX	;Rascunho do teclado
		INC  SI		;Quantidade maxima de caracteres
		INC  SI		;Caracteres digitados
		POP  DX		;Nome do arquivo
		MOV  DI,DX
LER1A:
		MOV  AL,[SI+0]
		MOV  [DI+0],AL
		INC  SI
		INC  DI
		DEC  CL
		JNZ  LER1A
		INC  DI
		MOV  AL,'$'
		MOV  [DI+0],AL
		RET

LE_TEC		ENDP


;--------------------------------------;
;	Le teclado		       ;
;	em  SI  racunho 	       ;
;	em  BL col. inf.  BH col. sup. ;
;	em  DI numer. N  Alfa A	       ;
;--------------------------------------;

;Le numerico ou alfa
;-------------------

	PUBLIC	LE_DIG

LE_DIG	 	PROC	NEAR

LE_D1:		MOV  AH,01h	;Caracter Disponivel
		INT  16h
		JZ   LE_D1	;Nenhum caracter
		MOV  AH,00h
		INT  16h
		CMP  AL,00h	;Funcoes especiais
		JNZ  LE_D2
		CMP  AH,48h	;Volta campo
		JNZ  LE_D1
		MOV  AL,AH
		RET
LE_D2:		CMP  AL,1Bh	;<ESC>
		JNZ  LE_D2A
		RET
LE_D2A:		CMP  AL,0Dh	;<RET>
		JNZ  LE_D3
		RET
LE_D3:		CMP  AL,08h	;<BS>
		JNZ  LE_D4
LE_D3A:		CALL LE_CPOS	;Posicao do cursor
		CMP  AL,BL	;Coluna Inferior
		JZ   LE_D1
		PUSH DX
		MOV  AH,02h	;Caracter Branco
		MOV  DL,' '
		INT  21h
		POP  DX
		MOV  AL,' '
		MOV  [SI+0],AL
		DEC  SI
		PUSH BX
		MOV  AH,02h
		MOV  BH,00h
		DEC  DL
		INT  10h
		POP  BX
		CALL LE_CPOS
		JMP  LE_D1
LE_D4:		MOV  AH,[DI+0]
		CMP  AH,'A'	;Verifica numerico ou Alfa
		JZ   LED2
		CMP  AL,30h
		JNC  LEDD
LEDD1:		MOV  AH,02h
		MOV  DL,07h
		INT  21h
		JMP  LE_D1
LEDD:		CMP  AL,3Ah
		JNC  LEDD1
LED2:		MOV  [SI+0],AL
		INC  SI
		MOV  AH,02h	;Mostar caracter
		MOV  DL,AL
		INT  21h
		CALL LE_CPOS	;Posicao do cursor
		CMP  AL,BL	;Coluna Inferior
		JNZ  LE_D4X
		JMP  LE_D1
LE_D4X:		CMP  AL,BH
		JNC  LE_D4Y
		JMP  LE_D1
LE_D4Y:		DEC  SI		;Coluna Superior
LE_D4A:		PUSH BX
		MOV  AH,02h
		MOV  BH,00h
		DEC  DL
		INT  10h
		POP  BX
		JMP  LE_D1

LE_CPOS:	PUSH BX		;Posicao do cursor
		MOV  AH,03h
		MOV  BH,00h
		INT  10h
		MOV  AL,DL
		POP  BX
		RET

LE_DIG		ENDP


;--------------------------------------;
; Tranforma HEX -> DEC volta em CX     ;
;				       ;
; Valor a ser transformado em  AH      ;
;--------------------------------------;

	PUBLIC  TRA_DEC

TRA_DEC		PROC	NEAR

		MOV  AL,AH
		AND  AL,0F0H
		SHR  AL,1
		SHR  AL,1
		SHR  AL,1
		SHR  AL,1
		CMP  AL,0Ah
		JNC  TRA_D1
		ADD  AL,30h
		JMP  TRA_D2
TRA_D1:
		ADD  AL,40h
		SBB  AL,09h
TRA_D2:
		MOV  CH,AL
		MOV  AL,AH
		AND  AL,0FH
		CMP  AL,0Ah
		JNC  TRA_D3
		ADD  AL,30h
		JMP  TRA_D4
TRA_D3:
		ADD  AL,40h
		SBB  AL,09h
TRA_D4:
		MOV  CL,AL
		RET

TRA_DEC		ENDP



;--------------------------------------;
; Tranforma HEX -> DEC volta em CX     ;
;				       ;
; Valor a ser transformado em  AH      ;
;--------------------------------------;

	PUBLIC  MOS_HEX

MOS_HEX		PROC	NEAR

		MOV  AL,AH
		AND  AL,0F0H
		SHR  AL,1
		SHR  AL,1
		SHR  AL,1
		SHR  AL,1
		ADD  AL,30h

		MOV  CH,AL
		MOV  AL,AH
		AND  AL,0FH
		ADD  AL,30h
		MOV  CL,AL
		RET

MOS_HEX		ENDP


;--------------------------------------;
; Contador de 4 digitos		       ;
;				       ;
; Valor deve vir em DX --> FCONT       ;
;--------------------------------------;

	PUBLIC  CONT_4

CONT_4		PROC	NEAR

		MOV  BX,DX		;Contador 5 Digitos
		MOV  AL,[BX+3]
		CMP  AL,30h
		JZ   CONT_4A
		DEC  AL
		MOV  [BX+3],AL
		RET
CONT_4A:	MOV  AL,[BX+2]
		CMP  AL,30h
		JZ   CONT_4B
		DEC  AL
		MOV  [BX+2],AL
		MOV  AL,39h
		MOV  [BX+3],AL
		RET
CONT_4B:	MOV  AL,[BX+1]
		CMP  AL,30h
		JZ   CONT_4C
		DEC  AL
		MOV  [BX+1],AL
		MOV  AL,39h
		MOV  [BX+3],AL
		MOV  [BX+2],AL
		RET
CONT_4C:	MOV  AL,[BX+0]
		CMP  AL,30h
		JNZ  CONT_4D
		MOV  AL,00h
		RET
CONT_4D:	DEC  AL
		MOV  [BX+0],AL
		MOV  AL,39h
		MOV  [BX+3],AL
		MOV  [BX+2],AL
		MOV  [BX+1],AL
		RET

CONT_4		ENDP


;--------------------------------------;
; Contador de 5 digitos	,tamanho arq.  ;
;				       ;
; Contador em DX --> FARQ	       ;
; Valor deve vir em CX                 ;
;--------------------------------------;

	PUBLIC  CONTF_5

CONTF_5		PROC	NEAR

		MOV  BX,DX		;Contador 5 Digitos
		MOV  AL,CL
		CMP  AL,00h
		JNZ  CONT_5B
		MOV  AL,CH
		CMP  AL,00h
		JNZ  CONT_5B
		RET
CONT_5A:	DEC  CX
		JNZ  CONT_5B
		RET
CONT_5B:
		MOV  AL,[BX+4]
		INC  AL
		MOV  [BX+4],AL
		CMP  AL,3Ah
		JNZ   CONT_5A

		MOV  AL,30h
		MOV  [BX+4],AL
		MOV  AL,[BX+3]
		INC  AL
		MOV  [BX+3],AL
		CMP  AL,3Ah
		JNZ   CONT_5A

		MOV  AL,30h
		MOV  [BX+4],AL
		MOV  [BX+3],AL
		MOV  AL,[BX+2]
		INC  AL
		MOV  [BX+2],AL
		CMP  AL,3Ah
		JNZ   CONT_5A

		MOV  AL,30h
		MOV  [BX+4],AL
		MOV  [BX+3],AL
		MOV  [BX+2],AL
		MOV  AL,[BX+1]
		INC  AL
		MOV  [BX+1],AL
		CMP  AL,3Ah
		JNZ   CONT_5A

		MOV  AL,30h
		MOV  [BX+4],AL
		MOV  [BX+3],AL
		MOV  [BX+2],AL
		MOV  [BX+1],AL
		MOV  AL,[BX+0]
		INC  AL
		MOV  [BX+0],AL
		JMP  CONT_5A

CONTF_5		ENDP


;--------------------------------------;
; Contador de 5 digitos	,tamanho arq.  ;
;	DECREMENTA		       ;
; Contador em DX --> FARQ	       ;
;--------------------------------------;

	PUBLIC  DONTF_5

DONTF_5		PROC	NEAR

		MOV  BX,DX		;Contador 5 Digitos
		MOV  AL,[BX+4]
		CMP  AL,30h
		JZ   DONT_4A
		DEC  AL
		MOV  [BX+4],AL
		RET
DONT_4A:	MOV  AL,[BX+3]
		CMP  AL,30h
		JZ   DONT_4B
		DEC  AL
		MOV  [BX+3],AL
		MOV  AL,39h
		MOV  [BX+4],AL
		RET

DONT_4B:	MOV  AL,[BX+2]
		CMP  AL,30h
		JZ   DONT_4C
		DEC  AL
		MOV  [BX+2],AL
		MOV  AL,39h
		MOV  [BX+4],AL
		MOV  [BX+3],AL
		RET


DONT_4C:	MOV  AL,[BX+1]
		CMP  AL,30h
		JZ   DONT_4D
		DEC  AL
		MOV  [BX+1],AL
		MOV  AL,39h
		MOV  [BX+4],AL
		MOV  [BX+3],AL
		MOV  [BX+2],AL
		RET


DONT_4D:	MOV  AL,[BX+0]
		CMP  AL,30h
		JZ   DONT_4E
		DEC  AL
		MOV  [BX+0],AL
		MOV  AL,39h
		MOV  [BX+4],AL
		MOV  [BX+3],AL
		MOV  [BX+2],AL
		MOV  [BX+1],AL
		RET

DONT_4E:	MOV  AL,00h
		RET


DONTF_5		ENDP


;--------------------------------------;
;				       ;
;          V I D E O                   ;
;				       ;
;--------------------------------------;

	PUBLIC  VID

VID		PROC	NEAR

	        PUSH CX
        	PUSH DX
	        PUSH BX
	        PUSH AX
	        PUSH AX
	        MOV  AH,02H
	        MOV  BH,00H
	        MOV  DX,174BH
	        INT  10H
	        POP  AX
	        MOV  AH,09H
	        MOV  BH,00H
	        MOV  BL,07H
	        MOV  CX,0001H
	        INT  10H
	        POP  AX
	        POP  BX
	        POP  DX
	        POP  CX
	        RET

VID     	ENDP


CODE_SEG	ENDS

		END 	FUNTR


