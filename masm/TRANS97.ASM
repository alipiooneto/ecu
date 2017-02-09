COMMENT *

	 Autor: Eng. Alipio de Oliveira Neto

	 Transmite arquivos .COM [ L80 ]

	 PC --> COM1 OU COM2 : 9600/ Parid Par / 8bytes / 1Stop

	 versao 2.0  -	11/01/95
	*


CGROUP	GROUP	CODE_SEG,DATA_SEG	;Agrupa dois segmentos
	ASSUME	CS:CGROUP,DS:CGROUP


CODE_SEG	SEGMENT PUBLIC
		ORG 100h

	PUBLIC	INST_A
	EXTRN	FUNTR:NEAR
	EXTRN	CLS_TELA:NEAR
	EXTRN	CLS_SAI:NEAR
	EXTRN	TEL_ABER:NEAR
	EXTRN	POS_CUR:NEAR
	EXTRN	PR_MEN:NEAR
	EXTRN	LE_OPC:NEAR
	EXTRN	LE_TEC:NEAR
	EXTRN	LE_DIG:NEAR
	EXTRN	MEN_CEN:NEAR
	EXTRN	MEN_DIR:NEAR
	EXTRN	MEN_ESQ:NEAR
	EXTRN	CONTF_5:NEAR
	EXTRN	DONTF_5:NEAR
	EXTRN	TRA_DEC:NEAR
	EXTRN	MOS_HEX:NEAR


;---------------------------------------;
;					;
; Usa:	Geralarq para limpar a tela	;
;					;
;---------------------------------------;


INST_A		PROC	NEAR

TRA:		CALL CLS_TELA		;Limpa janela

		CALL TEL_ABER		;Tela de Abertura

		LEA  DI,OLIV		;Mensagem
		MOV  AX,9FFFH		;Delay para caracteres
		MOV  BH,02h		;Linha
		MOV  CL,10h		;Coluna inicial
		CALL MEN_CEN		;Imprime mensagem

		LEA  DI,AQSER		;Serial 1 ou 2
		MOV  SI,5500H
		MOV  DX,0815h		;Posicao do cursor
		CALL MEN_ESQ		;Imprime mensagem

TRA0:		MOV  BX,0826h		;Posicao do cursor
		CALL LE_OPC
		CMP  AL,'1'
		JZ   TRA0A
		CMP  AL,'2'
		JNZ  TRA0

TRA0A:
		LEA  SI,SER12
		MOV  [SI+0],AL

;*************************************************

	;***   TENTA CONFIGURAR 8250  *****

BAA0:		MOV  AH,00h		;Inicializar porta
		MOV  DX,0000h		;COM # 1
		MOV  AL,[SI+0]
		CMP  AL,'1'
		JZ   BRA0E
		INC  DX
BRA0E:		MOV  AL,0E7h		;9600 / NO PAR / 8 BITS / 2 STOP
		INT  14h


	;*****	  Mostra Status   *****

		LEA  DI,VIDST		;Conteudo reg. Status
		MOV  SI,3500H
		MOV  DX,0A15h		;Posicao do cursor
		CALL MEN_ESQ		;Imprime mensagem
		MOV  DX,0A28h
		CALL POS_CUR


		MOV  DX,0000h		;Ler Status COM1 OU COM2
		MOV  AL,[SI+0]
		CMP  AL,'1'
		JZ   BTA0A
		INC  DX
BTA0A:		MOV  AH,03h
		INT  14h
		CMP  AH,60H
		JZ   BTXAA
		MOV  AH,02H
		INT  14H
		JMP  TRA	
BTXAA:
		CALL MOS_HEX		;Mostra Hexa
		MOV  AH,02h
		MOV  DL,CH
		INT  21h
		MOV  AH,02h
		MOV  DL,CL
		INT  21h


;*************************************************


TRA1A:		LEA  DI,AQNOM		;Nome Arquivo
		MOV  SI,5500H
		MOV  DX,0C15h		;Posicao do cursor
		CALL MEN_ESQ		;Imprime mensagem

		LEA  DI,FLAN		;Define Alfa/Numerico
		MOV  AL,'A'
		MOV  [DI+0],AL

		MOV  DX,0C26h
		CALL POS_CUR
		LEA  SI,TARQ2
		MOV  BL,26h
		MOV  BH,32h
		CALL LE_DIG
		CMP  AL,1Bh		;<ESC> Aborta Operacao
		JNZ  TRA1B
		JMP  ABO

;**********************************

	  ;****  Abre arquivo de leitura

TRA1B:
		MOV  AH,3DH		;Abre arquivo
		LEA  DX,TARQ2
		MOV  AL,00h		;Modo Leitura
		INT  21H
		JNC  TRA1C

		LEA  DI,ERARQ1		;Erro abertura do arquivo
		MOV  SI,3000H
		MOV  DX,1605h		;Posicao do cursor
		CALL MEN_DIR		;Imprime mensagem

		MOV  DX,162Eh
		JMP  SAI

TRA1C:
		MOV  N_HANL,AX

		MOV  AH,42h		;Move pointer
		MOV  BX,N_HANL		;Para saber tamanho arq.
		MOV  AL,02h		;Final do arquivo
		XOR  CX,CX		;Deslocamento alto
		XOR  DX,DX		;Deslocamento baixo
		INT  21h
		JNC  TRA1D


		LEA  DI,ERTRA1		;Erro tratamento do arquivo
		MOV  SI,3000H
		MOV  DX,1605h		;Posicao do cursor
		CALL MEN_DIR		;Imprime mensagem

		MOV  DX,162Eh
		JMP  SAI

TRA1D:
		PUSH AX 		;Tamanho do arquivo
		LEA  DX,FARQ
		MOV  CX,AX
		CALL CONTF_5
		LEA  DX,FARQ
		MOV  BX,0D05h
		CALL PR_MEN

		MOV  AH,42h		;Move pointer
		MOV  BX,N_HANL
		MOV  AL,00h		;Inicio do arquivo
		XOR  CX,CX		;Deslocamento alto
		XOR  DX,DX		;Deslocamento baixo
		INT  21h
		POP  AX

	  ;****  Efetua leitura arquivo coloca no SETOR0

		MOV  CX,AX		;Quantidade de bytes a ler
		MOV  AH,3FH		;Leitura de arquivo
		MOV  BX,N_HANL
		LEA  DX,SETOR0		;Area para colocar os dados
		INT  21H
		JNC  TRA1E

		LEA  DI,ERLER1		;Erro Leitura do arquivo
		MOV  SI,2500H
		MOV  DX,1310h		;Posicao do cursor
		CALL MEN_ESQ		;Imprime mensagem

		MOV  DX,1339h
		JMP  SAI


TRA1E:
		LEA  DI,SETOR0
		LEA  SI,SER12


		MOV  DX,0000h		;Ler Status COM1 OU COM2
		MOV  AL,[SI+0]
		CMP  AL,'1'
		JZ   XTA0A
		INC  DX
XTA0A:		MOV  AH,03h
		INT  14h
		CMP  AH,60H
		JZ   TRA2F
		MOV  AH,02H
		INT  14H
		JMP  TRA	

TRA2F:
		MOV  DX,0000h		;Ler Status transm. COM # 1
		MOV  AL,[SI+0]
		CMP  AL,'1'
		JZ   TRA20F
		INC  DX
TRA20F: 	MOV  AH,03h
		INT  14h
		CMP  AH,60H
		JZ   TRA3G	
		MOV  AH,01h		;Ler teclado
		INT  16h
		JZ   TRA2F		;Nenhuma tecla presionada
		JMP  ABO

TRA3G:		
;		MOV  DX,0000h		;Ler caracter COM # 1
;		MOV  AL,[SI+0]
;		CMP  AL,'1'
;		JZ   TRA30G
;		INC  DX
;TRA30G: 	MOV  AH,02h
;		INT  14h

TRA1F:
		MOV  DX,0000h		;Transmitir um byte
		MOV  AL,[SI+0]
		CMP  AL,'1'
		JZ   TRA0F
		INC  DX
TRA0F:		MOV  AL,[DI+0]
		INC  DI
		MOV  AH,01h
		INT  14h


TRA30X: 	LEA  DX,FARQ		;Contador
		CALL DONTF_5
		CMP  AL,00h
		JZ   TRAFIM

		LEA  DX,FARQ
		MOV  BX,0D10h
		CALL PR_MEN
		JMP  TRA2F


TRAFIM:
		MOV  AH,3EH		;Fecha arquivo
;		LEA  DX,N_HANL
		MOV  BX,N_HANL
		INT  21H
		JNC  TRAFI1
;		JC   TRAFI1
;		LEA  DI,OPEOK
		LEA  DI,OPOFFL		;Erro fechamento do arquivo
		JMP  TRAFI2

TRAFI1: 	LEA  DI,OPEOK
TRAFI2: 	MOV  SI,3000H
		MOV  DX,1605h		;Posicao do cursor
		CALL MEN_DIR		;Imprime mensagem

		JMP  SAI01


		MOV  DX,162Eh
		JMP  SAI


ABO:
		LEA  DI,TABOT
ABO1:		MOV  SI,3000H
		MOV  DX,1605h		 ;Posicao do cursor
		CALL MEN_DIR		 ;Imprime mensagem

		MOV  DX,162Eh


SAI:
		CALL POS_CUR
SAI01:		MOV  AH,08h
		INT  21h
		CMP  AL,0DH		;<RET>
		JNZ  SAI01

SAIR:		CALL CLS_SAI		;Limpa janela
		MOV  DX,0000h
		CALL POS_CUR

		INT  20h		;Retorna ao dos


INST_A		ENDP

CODE_SEG	ENDS




DATA_SEG	SEGMENT PUBLIC


OLIV	DB	'O & S  OLIVEIRA E SOGUMO LTDA-ME    fone: 959-2365$'
N_HANL	DW	?
ERARQ1	DB	'ERRO ABERTURA DO ARQUIVO DE ENTRADA    < RET >$'
ERLER1	DB	'ERRO NA LEITURA DO ARQUIVO DE ENTRADA  < RET >$'
ERTRA1	DB	'ERRO TRATAMENTO DO ARQUIVO ..........  < RET >$'
OPOFFL	DB	'ERRO FECHAMENTO ARQUIVO ENTRADA        < RET >$'
OPEOK	DB	'OPERACAO EFETUADA COM SUCESSO          < RET >$'
TABOT	DB	' .......  OPERACAO ABORTADA  ........  < RET >$'
ERRTR	DB	' .......  ERRO TRANSMISSAO   ........  < RET >$'
AQNOM	DB	'Nome do arquivo: $'
AQSER	DB	'Serial  1 ou 2  [ ]$'
VIDST	DB	'Status da serial.1:$'
VIDTR	DB	'Status depois TRA :$'
TABST	DB	'Estou parado em Status  $'
TARQ2	DB	'            ',00H,00H,24h
FLAN	DB	'A'
SER12	DB	'1'
FARQ	DB	'00000$'
SETOR0	DB	 4000h DUP (0)	 ;***  16 KB  16384


DATA_SEG	ENDS



		END	INST_A

