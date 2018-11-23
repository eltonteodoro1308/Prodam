#INCLUDE "PROTHEUS.CH"      
#INCLUDE "DBTREE.CH"
#INCLUDE 'JURXFUN.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWBROWSE.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'DBSTRUCT.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TRM002    ³ Autor ³ Marcos Pereira	        		³ Data ³16/03/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Banco de Talentos                 	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM002                           	 	                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                  	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.            		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data       ³ BOPS         ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM002()

Local bFiltraBrw, cFiltraRh
Local AINDEXSRA := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := MenuDef() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := OemtoAnsi("Banco de Talentos")	
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o filtro utilizando a funcao FilBrowse                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFiltraRh := CHKRH(FunName(),"SRA","1")
cFiltraRh := "RA_SITFOLH<>'D'" + If(!Empty(cFiltraRh)," .and. "+cFiltraRh,"")
bFiltraBrw 	:= {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }
Eval(bFiltraBrw)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRA")
dbSetOrder(1)       
dbGoTop()

dbSelectArea("RA4")
dbSetOrder(1)       
	
mBrowse( 6, 1, 22, 75, "SRA",,,,,,fCriaCor() )

Return Nil
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ cDbtreeRot ³ Autor ³ Marcos Pereira	 	³ Data ³01/11/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra a Tree dos Processos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Alias                                              ³±±
±±³          ³ ExpN1 : Registro                                           ³±±
±±³          ³ ExpN2 : Opcao                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function cDbtreeRot(cAlias,nReg,nOpcx)
Local aKeys			:= GetKeys()
Local oDlgMain, oTree
Local aCursoF  		:= {}
Local aCursoC		:= {}
Local aCursoE		:= {}
Local aConhec		:= {}
Local aAtivida		:= {}
Local nOpca			:= 0
Local nOrder		:= 0
Local aFields		:= {}
Local aNoFields		:= {}
Local aSZ9NoFields	:= {}
Local aRBNNoFields	:= {}
Local i				:= 0
Local bObjHide                    
Local aSRAKeySeek	:= {}
Local aRA4KeySeek	:= {}
Local aButtons		:= {}
Local bSet15		:= { || NIL }
Local bSet24		:= { || NIL }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para Dimensionar Tela		                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}

Local aAdv1Size		:= {}
Local aInfo1AdvSize	:= {}
Local aObj1Size		:= {}
Local aObj1Coords	:= {}

Local aAdv2Size		:= {}
Local aInfo2AdvSize	:= {}
Local aObj2Size		:= {}
Local aObj2Coords	:= {}

Local aAdv3Size		:= {}
Local aInfo3AdvSize	:= {}
Local aObj3Size		:= {}
Local aObj3Coords	:= {}

Local aAdv4Size		:= {}
Local aInfo4AdvSize	:= {}
Local aObj4Size		:= {}
Local aObj4Coords	:= {}

Local aAdv5Size		:= {}
Local aInfo5AdvSize	:= {}
Local aObj5Size		:= {}
Local aObj5Coords	:= {}

Local nLoop
Local nLoops     
Local nOpcNewGd		:= IF( ( ( nOpcx == 2 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)
Local x
Local nAt 		:= 0
Local cCCMemo	:= ""
Local cAuxMemo	:= ""
Local nCCMemo	
Local aArea		:=	GetArea()
Local nX, nY

Private nOpcao	:= nOpcx 
Private cGet	:= ""

// Private da Getdados
Private aCols  	:= {}
Private aHeader	:= {}
Private Continua:= .F.
Private aObjects:= {}

// Private dos objetos da Enchoice
Private oEnchoice
Private cNumProc	:= ""
Private cFilPA5		:= ""
Private cDesc		:= ""
Private cAno		:= ""
Private cEstou		:= "01"
Private cIndo		:= ""
Private oSay1, oGetSRA, oAux
Private aMemos1		:= { {} }					//Variavel para tratamento dos memos Processo
Private lExistRBN	:=.T.

// Private Cursos - RA4 - Formacao
Private oGetCursoF, oGroupCF
Private aMemosCF  				:= {}		//Variavel para tratamento dos memos 
Private aMemosGrCF		  		:= {}
Private cFilRA4					:= ""

// Private Cursos - RA4 - Capacitacao
Private oGetCursoC, oGroupCC
Private aMemosCC				:= {}		//Variavel para tratamento dos memos 
Private aMemosGrCC				:= {}
Private cFilRA4					:= ""

// Private Cursos - RA4 - Certificação
Private oGetCursoE, oGroupCE
Private aMemosCE				:= {}		//Variavel para tratamento dos memos 
Private aMemosGrCE				:= {}
Private cFilRA4					:= ""

// Private - XXX - Conhecimentos
Private oGetConhec, oGroupCO
Private aMemosCO				:= {}		//Variavel para tratamento dos memos 
Private aMemosGrCO				:= {}
Private cFilRA4					:= ""

// Private - XXX - Atividades Funcionais
Private oGetAtFunc, oGroupAtFunc
Private aMemosAt				:= {}		//Variavel para tratamento dos memos 
Private aMemosGrAt				:= {}
Private cFilRBN					:= ""


// Private dos Botoes
Private oSButtonBC 
Private oSButtonB2
Private oSButtonEm

Private aTELA[0][0],aGETS[0]

bCampo := {|nCPO| Field(nCPO) }

cFilSRA			:= xFilial("SRA")
cFilSZ9			:= xFilial("SZ9")
cFilRBN			:= xFilial("RBN")
cFilRA4			:= xFilial("RA4")
cMat 			:= SRA->RA_MAT  
cNome			:= SRA->RA_NOME 

aSRAKeySeek		:= { cFilSRA , cMat }
aRA4KeySeek		:= { cFilRA4 , cMat }
aSZ9KeySeek		:= { cFilSZ9 , cMat }
aRBNKeySeek		:= { cFilRBN , cMat }

//Cria as variaveis de memoria da SRA
For i := 1 TO FCount()
	 M->&(EVAL(bCampo,i)) := FieldGet(i)
Next i

//Posiciona RA1 no final de arquivo para não manter descricao em memoria
RA1->(dbsetorder(1))
RA1->(dbseek("@@"))

//Posiciona SZ9 no final de arquivo para não manter descricao em memoria
SZ9->(dbsetorder(1))
SZ9->(dbseek("@@"))

//Posiciona SZ9 no final de arquivo para não manter descricao em memoria
RBN->(dbsetorder(1))
RBN->(dbseek("@@"))

// Montando os Arrays do Dbtree
// fMonta: retornos 1-aColsRec 2-Header 3-aCols

nOrder 		:= 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campos Pertences APENAS ao Portal Gestão do Capital Humano:  ³
//³ RA4_NIVEL, RA4_STATUS, RA4_DTALT, RA4_CODCOM, RA4_CONTEU.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aNoFields	:={"RA4_FILIAL","RA4_MAT","RA4_NOME","RA4_NIVEL","RA4_STATUS",;
				"RA4_DTALT","RA4_CODCOM","RA4_CONTEU"}
				
aSZ9NoFields	:= {"Z9_FILIAL","Z9_MAT"}
				
aRBNNoFields	:= {"RBN_FILIAL","RBN_MAT"}				
				
// 01- RA4 - Cursos Formacao
aCursoF  	:= fMonta("RA4", nReg, nOpcx, nOrder, aRA4KeySeek , aNoFields, "SRA", .F.,,,"01" )
nLoops 		:= Len( aCursoF[ 2 ] )
For nLoop := 1 To nLoops
	SetMemVar( aCursoF[ 2 , nLoop , 2 ] , NIL , .T. )
Next nLoop	

// 02- RA4 - Cursos Capacitacao
aCursoC  	:= fMonta("RA4", nReg, nOpcx, nOrder, aRA4KeySeek , aNoFields, "SRA", .F.,,,"02" )
nLoops 		:= Len( aCursoC[ 2 ] )
For nLoop := 1 To nLoops
	SetMemVar( aCursoC[ 2 , nLoop , 2 ] , NIL , .T. )
Next nLoop	

// 03- RA4 - Cursos Certificacao
aCursoE  	:= fMonta("RA4", nReg, nOpcx, nOrder, aRA4KeySeek , aNoFields, "SRA", .F.,,,"03" )
nLoops 		:= Len( aCursoE[ 2 ] )
For nLoop := 1 To nLoops
	SetMemVar( aCursoE[ 2 , nLoop , 2 ] , NIL , .T. )
Next nLoop	

// 04- XXX - Conhecimentos
aConhec  	:= fMonta("SZ9", nReg, nOpcx, nOrder, aSZ9KeySeek , aSZ9NoFields, "SRA", .F.,,,"04" )
nLoops 		:= Len( aConhec[ 2 ] )
For nLoop := 1 To nLoops
	SetMemVar( aConhec[ 2 , nLoop , 2 ] , NIL , .T. )
Next nLoop	

// 05- XXX - Atividades Funcionais
aAtivida  	:= fMonta("RBN", nReg, nOpcx, nOrder, aRBNKeySeek , aRBNNoFields, "SRA", .F.,,,"05" )
nLoops 		:= Len( aAtivida[ 2 ] )
For nLoop := 1 To nLoops
	SetMemVar( aAtivida[ 2 , nLoop , 2 ] , NIL , .T. )
Next nLoop	

cGet := cMat + " - " + cNome

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Monta as Dimensoes dos Objetos         					   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }					 
aAdd( aObjCoords , { 100 , 000 , .F. , .T. } )
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords,,.T. )    

aAdv1Size		:= aClone(aObjSize[2])
aInfo1AdvSize	:= { aAdv1Size[2] , aAdv1Size[1] , aAdv1Size[4] , aAdv1Size[3] , 5 , 0 }					 
aAdd( aObj1Coords , { 000 , 018 , .T. , .F. } )						//1-Cabecalho
aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )						//2-MsGetDados
aObj1Size		:= MsObjSize( aInfo1AdvSize , aObj1Coords)


aAdv2Size		:= aClone(aObj1Size[2])
aInfo2AdvSize	:= { aAdv2Size[2] , aAdv2Size[1] , aAdv2Size[4] , aAdv2Size[3] , 5 , 1 }					 
aAdd( aObj2Coords , { 000 , 000 , .T. , .T. } )						//1-Group1
aAdd( aObj2Coords , { 000 , 000 , .T. , .T. } )						//2-Group2
aObj2Size		:= MsObjSize( aInfo2AdvSize , aObj2Coords)

aAdv3Size		:= aClone(aObj2Size[1])
aInfo3AdvSize	:= { aAdv3Size[2] , aAdv3Size[1] , aAdv3Size[4] , aAdv3Size[3] , 5 , 5 }					 
aAdd( aObj3Coords , { 000 , 000 , .T. , .T. } )						//1-MsGet1
aObj3Size		:= MsObjSize( aInfo3AdvSize , aObj3Coords)

aAdv4Size		:= aClone(aObj2Size[2])
aInfo4AdvSize	:= { aAdv4Size[2] , aAdv4Size[1] , aAdv4Size[4] , aAdv4Size[3] , 5 , 5 }					 
aAdd( aObj4Coords , { 000 , 000 , .T. , .T. } )						//1-MsGet2
aObj4Size		:= MsObjSize( aInfo4AdvSize , aObj4Coords)

aAdv5Size		:= MsAdvSize()
aInfo5AdvSize	:= { aAdv5Size[1] , aAdv5Size[2] , aAdv5Size[3] , aAdv5Size[4] , 5 , 5 }					 
aAdd( aObj5Coords , { 100 , 000 , .F. , .T. } )
aAdd( aObj5Coords , { 000 , 000 , .T. , .T. } )
aObj5Size		:= MsObjSize( aInfo5AdvSize , aObj5Coords,,.T. )    


DEFINE MSDIALOG oDlgMain FROM	aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] TITLE OemToAnsi("xx Banco de Talentos xx")	OF oMainWnd  PIXEL	 
    
	@ aObj1Size[1,1]+5,aObj1Size[1,2]+5		Say oSay1 PROMPT OemToAnsi("Filial/Matricula") SIZE 40,7 PIXEL		
	@ aObj1Size[1,1]+5,aObj1Size[1,2]+55		Get oGetSRA VAR cGet SIZE 250,7 WHEN .F. PIXEL
	
	DEFINE DBTREE oTree FROM aObjSize[1,1],aObjSize[1,2] TO aObjSize[1,3],aObjSize[1,4] CARGO OF oDlgMain
			                     
		oTree:bValid 	:= {|| fVlTree(nOpcx) }
		oTree:lValidLost:= .F.
		oTree:lActivated:= .T.

		DBADDTREE oTree PROMPT "Formação" + space(10);				
							 RESOURCE "FOLDER5";
							 CARGO "01"
		DBENDTREE oTree					 							 

		DBADDTREE oTree PROMPT "Capacitação";				
							 RESOURCE "FOLDER5";
							 CARGO "02"
		DBENDTREE oTree					 							 

		DBADDTREE oTree PROMPT OemToAnsi("Certificação");				
							 RESOURCE "FOLDER5";
							 CARGO "03"
		DBENDTREE oTree					 							 

		
		DBADDTREE oTree PROMPT OemToAnsi("Conhecimentos");				
							 RESOURCE "FOLDER5";
							 CARGO "04"
		DBENDTREE oTree
		
		If lExistRBN
			DBADDTREE oTree PROMPT Alltrim(OemToAnsi("Ativ. Funcionais"));							//" Atividades Funcionais "
								RESOURCE "FOLDER5";
	  							CARGO "05"
			DBENDTREE oTree
		EndIf
						 							 

		//-----------------------
		// Dados Cadastrais
		//-----------------------
		Zero()
		aMemos		:=	aClone(aMemos1)
		oEnchoice	:= MsMGet():New(cAlias,nReg,nOpcx,NIL,NIL,NIL,NIL,aObjSize[2],NIL,NIL,NIL,NIL,NIL,NIL,NIL,.F.,.F.)
							               
		//-----------------------
		// Cursos Formacao
		//-----------------------
		aHeader					:= 	{}
		aCols					:= 	{}
		aMemosGrCF		  		:=	{}
		n						:= 1
		@ aObj2Size[1,1], aObj2Size[1,2] GROUP oGroupCF   TO aObj2Size[2,3], aObj2Size[2,4] LABEL OemtoAnsi(" Formação ")	OF oDlgMain PIXEL	
		oGetCursoF   	:= MSNewGetDados():New(	aObj3Size[1,1]+5,	;
										aObj3Size[1,2],	;
										aObj4Size[1,3],	;
										aObj4Size[1,4],	;
										nOpcNewGd,		;
										"U_CursoForOk",	;
										"AllwaysTrue",	;
										"",				;
										NIL,			;
										NIL,			;
										9999,			;
										NIL,			;
										NIL,			;
										NIL,			;
										@oDlgMain,		;
										aCursoF[2],	;
										aCursoF[3]	;
										)
		oGetCursoF:oBrowse:Default()                                    
		aAdd ( aMemosGrCF , { aMemosCF } )
		aAdd ( aObjects , { oGetCursoF , "RA4" , aCursoF[1] , aMemosGrCF } )
		
		//-----------------------
		// Cursos Capacitacao
		//-----------------------
		aHeader					:= 	{}
		aCols					:= 	{}
		aMemosGrCC				:=	{}
		n						:= 1
		@ aObj2Size[1,1], aObj2Size[1,2] GROUP oGroupCC TO aObj2Size[2,3], aObj2Size[2,4] LABEL OemtoAnsi(" Capacitação ")	OF oDlgMain PIXEL	
		oGetCursoC 	:= MSNewGetDados():New(	aObj3Size[1,1]+5,	;
										aObj3Size[1,2],	;
										aObj4Size[1,3],	;
										aObj4Size[1,4],	;
										nOpcNewGd,		;
										"U_CursoForOk",	;
										"AllwaysTrue",	;
										"",				;
										NIL,			;
										NIL,			;
										9999,			;
										NIL,			;
										NIL,			;
										NIL,			;
										@oDlgMain,		;
										aCursoC[2],	;
										aCursoC[3]	;
										)
		oGetCursoC:oBrowse:Default()                                    
		aAdd ( aMemosGrCC , { aMemosCC } )
		aAdd ( aObjects , { oGetCursoC , "RA4" , aCursoC[1] , aMemosGrCC } )
		
		//-----------------------
		// Cursos Certificacao
		//-----------------------
		aHeader					:= 	{}
		aCols					:= 	{}
		aMemosGrCE				:=	{}
		n						:= 1
		@ aObj2Size[1,1], aObj2Size[1,2] GROUP oGroupCE TO aObj2Size[2,3], aObj2Size[2,4] LABEL OemtoAnsi(" Certificação ")	OF oDlgMain PIXEL	
		oGetCursoE 	:= MSNewGetDados():New(	aObj3Size[1,1]+5,	;
										aObj3Size[1,2],	;
										aObj4Size[1,3],	;
										aObj4Size[1,4],	;
										nOpcNewGd,		;
										"U_CursoForOk",	;
										"AllwaysTrue",	;
										"",				;
										NIL,			;
										NIL,			;
										9999,			;
										NIL,			;
										NIL,			;
										NIL,			;
										@oDlgMain,		;
										aCursoE[2],	;
										aCursoE[3]	;
										)
		oGetCursoE:oBrowse:Default()										
		aAdd ( aMemosGrCE , { aMemosCE } )
		aAdd ( aObjects , { oGetCursoE , "RA4" , aCursoE[1] , aMemosGrCE } )

		//-----------------------
		// Conhecimentos
		//-----------------------
		aHeader					:= 	{}
		aCols					:= 	{}
		aMemosGrCO				:=	{}
		n						:= 1
		@ aObj2Size[1,1], aObj2Size[1,2] GROUP oGroupCO TO aObj2Size[2,3], aObj2Size[2,4] LABEL OemtoAnsi(" Conhecimentos ") OF oDlgMain PIXEL	
		oGetConhec 	:= MSNewGetDados():New(	aObj3Size[1,1]+5,	;
										aObj3Size[1,2],	;
										aObj4Size[1,3],	;
										aObj4Size[1,4],	;
										nOpcNewGd,		;
										"U_CursoForOk",	;
										"AllwaysTrue",	;
										"",				;
										NIL,			;
										NIL,			;
										9999,			;
										NIL,			;
										NIL,			;
										NIL,			;
										@oDlgMain,		;
										aConhec[2],	;
										aConhec[3]	;
										)
		oGetConhec:oBrowse:Default()								
		aAdd ( aMemosGrCO , { aMemosCO } )
		aAdd ( aObjects , { oGetConhec , "SZ9" , aConhec[1] , aMemosGrCO } )
		
		//-----------------------
		// Atividades Funcionais
		//-----------------------
		//Private oGetAtFunc, oGroupAtFunc
		//Private aMemosAt				:= {}		//Variavel para tratamento dos memos 
		//Private aMemosGrAt				:= {}
		//Private cFilRBN					:= ""
		
		aHeader					:= 	{}
		aCols					:= 	{}
		aMemosGrAt				:=	{}
		n						:= 1
		@ aObj2Size[1,1], aObj2Size[1,2] GROUP oGroupAtFunc TO aObj2Size[2,3], aObj2Size[2,4] LABEL OemtoAnsi(" Atividades Funcionais ") OF oDlgMain PIXEL	
		oGetAtFunc 	:= MSNewGetDados():New(	aObj3Size[1,1]+5,	;
										aObj3Size[1,2],	;
										aObj4Size[1,3],	;
										aObj4Size[1,4],	;
										nOpcNewGd,		;
										"U_CursoForOk",	;
										"AllwaysTrue",	;
										"",				;
										NIL,			;
										NIL,			;
										9999,			;
										NIL,			;
										NIL,			;
										NIL,			;
										@oDlgMain,		;
										aAtivida[2],	;
										aAtivida[3]	;
										)
		oGetAtFunc:oBrowse:Default()								
		aAdd ( aMemosGrAt , { aMemosCO } )
		aAdd ( aObjects , { oGetAtFunc , "RBN" , aAtivida[1] , aMemosGrAt } )		

//Limpa descricao de cursos de linhas que nao tem codigo de curso (novas linhas)
For nX := 1 to len(aObjects)
	
	/*
	For nY := 1 to len(aObjects[nX][1]:Acols)
		If empty(aObjects[nX][1]:Acols[nY][GdFieldPos("RA4_CURSO",aObjects[nX][1]:aHeader)])
			aObjects[nX][1]:Acols[nY][GdFieldPos("RA4_DESCCU",aObjects[nX][1]:aHeader)] := ""
		Endif
	Next nY
	*/
	/*	
	For nY := 1 to len(aObjects[nX][1]:Acols)
		If empty(aObjects[nX][1]:Acols[nY][GdFieldPos("RA4_CURSO",aObjects[nX][1]:aHeader)])
			aObjects[nX][1]:Acols[nY][GdFieldPos("RA4_DESCCA",aObjects[nX][1]:aHeader)] := ""
		Endif
	Next nY
	
	For nY := 1 to len(aObjects[nX][1]:Acols)
		If empty(aObjects[nX][1]:Acols[nY][GdFieldPos("RA4_CURSO",aObjects[nX][1]:aHeader)])
			aObjects[nX][1]:Acols[nY][GdFieldPos("RA4_CATEG",aObjects[nX][1]:aHeader)] := ""
		Endif
	Next nY
	*/
Next nX
		
/*
oSButtonBC := TBtnBmp2():New( 5, aObj2Size[1,1]+800, 40, 40, 'vernota' , 'Docs' , , ,{|| U_MsDocument(1) } , oDlgMain,'Documentos Relacionados' , , .T.) 
*/
		//----------------------------------------
 		// Esconde objetos
		//----------------------------------------
   		bObjHide := { ||;
							oEnchoice:Hide(),;
   							oGroupCC:Hide(),;
   							oGetCursoC:Hide(),;
   							oGetCursoC:oBrowse:Hide(),;
   							oGroupCE:Hide(),;
   							oGetCursoE:Hide(),;
   							oGetCursoE:oBrowse:Hide(),;
   							oGroupCO:Hide(),;
   							oGetConhec:Hide(),;
   							oGetConhec:oBrowse:Hide(),;
   							oGroupAtFunc:Hide(),;
   							oGetAtFunc:Hide(),;
   							oGetAtFunc:oBrowse:Hide(),;
   		            }
		Eval( bObjHide )

 ACTIVATE MSDIALOG oDlgMain ON INIT	(	oAux:= oEnchoice 			,	;
										EnchoiceBar	(	oDlgMain	,	;
														{	||nOpca:=1	, RestKeys(aKeys,.T.),	;
															If	(	U_cDbtTudOk(nOpcx)	,	;
																	oDlgMain:End()		,	;
																)	 						;
														}	,	{|| nOpca := 2, RestKeys(aKeys,.T.) ,oDlgMain:End()}, NIL , aButtons;
													)	,	;
										oTree:bChange:=	{	||cDbtPrincipal		(	oTree	,	;
																					oDlgMain	;	
																				)	;
														}	,	;
									)

If nOpca == 1
	If nOpcx # 2	// Se nao for visualiz.
		Begin Transaction
			fGrava ( nOpcx , aObjects )
			EvalTrigger()
		End Transaction
	EndIf
EndIf

Release Object oTree

dbSelectArea(cAlias)
dbGoto(nReg)
RestKeys(aKeys,.T.)

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fMonta   ³ Autor ³ Marcos Pereira		³ Data ³01/11/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta as getdados dos arquivos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias 	: Alias                                           ³±±
±±³          ³ nReg 	: Registro                                        ³±±
±±³          ³ nOpcx 	: Opcao                                           ³±±
±±³          ³ nOrder 	: Ordem do Arquivo                                ³±±
±±³          ³ aCond 	: Condicao                                        ³±±
±±³          ³ aNoFields: Campos nao utilizados                           ³±±
±±³          ³ cAliasPai: Alias da Tabela Pai                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³          ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fMonta(cAlias, nReg, nOpcx, nOrder, aCond, aNoFields, cAliasPai, lAllField, cKey, uQuery, cTipo)

Local a100Header		:= {}       
Local a100Cols			:= {}
Local a100VirtGd		:= {}
Local a100VisuGd		:= {}  
Local a100Recnos		:= {} 	//--Array que contem o Recno() dos registros da aCols
Local u100Query			:= {}
Local a100Keys			:= {}
Local n100Usado 		:= 0   
Local cKSeekFather		:= "" 
Local n100MaxLocks		:= 30  
Local lLock 			:= .F.
Local lExclu			:= .F.    
Local a100Retorno		:= {}
Local nCount			:= 0
Local nI                := 0
Local aColsX, aRecnoX, nY, nPos
Default lAllField		:= .F.
Default aNoFields		:= {}   
Default cKey			:= ""	// Chave para o filho
Default uQuery			:= NIL

If Len(aCond)>0
	For nCount := 1 to Len (aCond)
		cKSeekFather	:= cKSeekFather + aCond[nCount] 	// Chave da tabela Processos   
	Next nCount	
EndIf

// Monta o aCols  
(cAlias)->(DbSetOrder(nOrder))
a100Cols := GDMontaCols(	@a100Header		,;	//01 -> Array com os Campos do Cabecalho da GetDados
							@n100Usado		,;	//02 -> Numero de Campos em Uso
							@a100VirtGd		,;	//03 -> [@]Array com os Campos Virtuais
							@a100VisuGd		,;	//04 -> [@]Array com os Campos Visuais
							cAlias			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
							@aNoFields		,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
							@a100Recnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
							cAliasPai	   	,;	//08 -> Alias do Arquivo Pai
							cKSeekFather	,;	//09 -> Chave para o Posicionamento no Alias Filho
							NIL				,;	//10 -> Bloco para condicao de Loop While
							NIL				,;	//11 -> Bloco para Skip no Loop While
							NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
							NIL				,;	//13 -> Se cria variaveis Publicas
							NIL				,;	//14 -> Se Sera considerado o Inicializador Padrao
							NIL				,;	//15 -> Lado para o inicializador padrao
							lAllField		,;	//16 -> Opcional, Carregar Todos os Campos
							NIL				,;	//17 -> Opcional, Nao Carregar os Campos Virtuais
							uQuery			,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
							.F.				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
							.F.				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
							.f.				,;	//21 -> Carregar Coluna Fantasma
							NIL				,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
							NIL				,;	//23 -> Verifica se Deve verificar se o campo eh usado
							NIL				,;	//24 -> Verifica se Deve verificar o nivel do usuario
							NIL				,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
							@a100Keys  		,;	//26 -> [@]Array que contera as chaves conforme recnos
							@lLock			,;	//27 -> [@]Se devera efetuar o Lock dos Registros
							@lExclu			,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
							n100MaxLocks	,;	//29 -> Numero maximo de Locks a ser efetuado
							NIL				,;	//30
							NIL				,;	//31
							nOpcx			 ;	//32
                       )

//Tratamento para evitar erro de campo obrigatorio
For nI := 1 To Len(a100Header)
	If !Empty(a100Header[nI][16])  
		a100Header[nI][16] := ""	
	EndIf
Next nI

aColsX  := {}
aRecnoX := {}

If cAlias == "RA4"

	nPos := aScan( a100Header , { |x| x[2] == "RA4_CURSO" })
	
	For nY := 1 to len(a100Cols)
		If fVerTipo(cTipo, a100Cols[nY,nPos])
			aadd(aColsX , a100Cols[nY])
			aadd(aRecnoX, a100Cols[nY,len(a100Cols[nY])-1])
		EndIf
	Next nY
	
Else
	
	For nY := 1 to len(a100Cols)
		aadd(aColsX , a100Cols[nY])
		aadd(aRecnoX, a100Cols[nY, len(a100Cols[nY])-1])
	Next nY

EndIf

a100Retorno := { aRecnoX , a100Header, aColsX }

Return( aClone( a100Retorno ) )

                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CursoForOk     ³ Autor ³                        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a linha da getdados Lista de Documentos                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CursoForOk()

Local aExcecao	:= {}
Local aCols		:= {}
Local aHeader	:= {}
Local nx		:= 0   
Local nAt		:= 0  

If cEstou == "01"
	aCols 	:= aClone(oGetCursoF:aCols)
	aHeader := aClone(oGetCursoF:aHeader)
ElseIf cEstou == "02"
	aCols 	:= aClone(oGetCursoC:aCols)
	aHeader := aClone(oGetCursoC:aHeader)
ElseIf cEstou == "03"
	aCols 	:= aClone(oGetCursoE:aCols)
	aHeader := aClone(oGetCursoE:aHeader)
ElseIf cEstou == "04"
	aCols 	:= aClone(oGetConhec:aCols)
	aHeader := aClone(oGetConhec:aHeader)
ElseIf cEstou == "05"
	aCols 	:= aClone(oGetAtFunc:aCols)
	aHeader := aClone(oGetAtFunc:aHeader)	
EndIf

IF nOpcao # 2 .and. Len(aCols) > 0 
	
	For nAt := 1 to len(aCols)
	
		If !aCols[nAt,Len(aCols[nAt])]      // Se nao esta Deletado
		
			If fLinhaVazia ( aHeader , aCols , aExcecao, nAt )	//Se linha inteira esta em branco, exceto..
				Return .T.
			EndIf
			
			If cEstou == "04" //Conhecimentos
			
				cChaveAtu := 	aCols[nAt][GdFieldPos("Z9_AREA",aHeader)] 		+ ;
								aCols[nAt][GdFieldPos("Z9_CATEG",aHeader)] 		+ ;
								aCols[nAt][GdFieldPos("Z9_CONHEC",aHeader)]
									
				For nX := 1 To Len(aCols)
				
					If !aCols[nX][Len(aCols[nX])] .and. nAt # nX //Se nao deletado e nao for o registro posicionado
					
						cChaveFor := 	aCols[nX][GdFieldPos("Z9_AREA"  ,aHeader)] 	+ ;
										aCols[nX][GdFieldPos("Z9_CATEG" ,aHeader)] 	+ ;
										aCols[nX][GdFieldPos("Z9_CONHEC",aHeader)]
										 						
						If cChaveAtu == cChaveFor
							Aviso( "Atenção", "Conhecimento já cadastrado para o funcionário.", { "OK" } )		
							Return .F.
							Exit
						EndIf
													
					EndIf
					
					If Empty(aCols[nX][GdFieldPos("Z9_NIVEL",aHeader)])
						Aviso( "Atenção", "Preencha o nível.", { "OK" } )
						Return .F.
						Exit
					EndIf
											
				Next nX
			
			ElseIf cEstou == "05" //Ativ. Funcionais
			
				/*
				cChaveAtu := 	aCols[nAt][GdFieldPos("RA4_CALEND",aHeader)] 	+ ;
								aCols[nAt][GdFieldPos("RA4_CURSO",aHeader)] 	+ ;
								aCols[nAt][GdFieldPos("RA4_TURMA",aHeader)] 	+ ;
								aCols[nAt][GdFieldPos("RA4_SINONI",aHeader)] 	+ ;
								dtos(aCols[nAt][GdFieldPos("RA4_DATAIN",aHeader)])
				*/	
	
				For nX:=1 To Len(aCols)
					If !aCols[nX,Len(aCols[nX])] 		// Verifico deletado a linha
						If Empty( aCols[nX][GDFieldPos("RBN_DEPTO", aHeader)] )
							Aviso("Aviso", "A Area/Departamento que foi executada esta atividade deve ser informada.", {"Ok"})	//"A Area/Departamento que foi executada esta atividade deve ser informada."
							Return .F.
							Exit
						ElseIf Empty( aCols[nX][GDFieldPos("RBN_FUNCAO", aHeader)] )
							Aviso("Aviso", "A Funcao que o Funcionario ocupava nesta atividade deve ser informada.", {"Ok"})	//"A Funcao que o Funcionario ocupava nesta atividade deve ser informada."
							Return .F.
							Exit
						ElseIf Empty( aCols[nX][GDFieldPos("RBN_DTINI", aHeader)] )
							Aviso("Aviso", "A data de Inicio desta atividade deve ser informada.", {"Ok"})	//"A data de Inicio desta atividade deve ser informada."
							Return .F.
							Exit
						EndIf
					EndIf										
				Next nX
			
			Else
						
				cChaveAtu := 	aCols[nAt][GdFieldPos("RA4_CALEND",aHeader)] 	+ ;
								aCols[nAt][GdFieldPos("RA4_CURSO",aHeader)] 	+ ;
								aCols[nAt][GdFieldPos("RA4_TURMA",aHeader)] 	+ ;
								aCols[nAt][GdFieldPos("RA4_SINONI",aHeader)] 	+ ;
								dtos(aCols[nAt][GdFieldPos("RA4_DATAIN",aHeader)])
	
				For nx:=1 To Len(aCols)
					If !aCols[nx][Len(aCols[nx])] .and. nAt # nx //Se nao deletado e nao for o registro posicionado
						cChaveFor := 	aCols[nX][GdFieldPos("RA4_CALEND",aHeader)] 	+ ;
										aCols[nX][GdFieldPos("RA4_CURSO",aHeader)] 	+ ;
										aCols[nX][GdFieldPos("RA4_TURMA",aHeader)] 	+ ;
										aCols[nX][GdFieldPos("RA4_SINONI",aHeader)] 	+ ;
										DtoS(aCols[nX][GdFieldPos("RA4_DATAIN",aHeader)])
						If cChaveAtu == cChaveFor
							Aviso( "Atenção", "Curso já cadastrado para a mesma data.", { "OK" } )		
							Return .F.
							Exit
						EndIf	
					EndIf
						
				Next nX
				
			EndIf
			
		EndIf	

	Next nAt

EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fGrava  ³ Autor ³                		 ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava os registros referentes ao Processo	 	               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : OPcao                                               ³±±
±±³          ³ ExpN1 : Array dos Objetos da Get                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGrava ( nOpcx , aObjects )

Local aColsRec			:= {}
Local cCampo    		:= ""
Local xConteudo 		:= ""
Local nx 				:= 0
Local ny 				:= 0
Local nI				:= 0  
Local nz				:= 0
Local nd				:= 0
Local nCount			:= 1
Local cCodMM			:= ""
Local lGrava			:= .F.
Local lExcluido			:= .F.
Local lPerg				:= .F.
Local aMemosGrava		:= {}  
Local aCodMM			:= {}
Local nOpcMM			:= 0
Local cMsgNoYes			:= ""  
Local nk				:= 0 
Local aColTab			:= {}


For nCount := 1 to Len(aObjects)
	aColsRec	:= aClone(aObjects[nCount][3])
	aHeader		:= aClone(aObjects[nCount][1]:aHeader)
	aCols 		:= aClone(aObjects[nCount][1]:aCols)
	aMemosGrava	:= aClone(aObjects[nCount][4])
	cAliasObj	:= aObjects[nCount][2]
	lGrava		:= .F.	   
	aCodMM		:= {} 
	nOpcMM		:= 0      
	nz			:= 0

	dbSelectArea(cAliasObj)
	For nx :=1 to Len(aCols)
		lGrava	:=	.F.
		lNovaOco := .F.
		  
		If cAliasObj == "RA4"
			//--Verifica se Nao esta Deletado no aCols e se nao é registro em branco
			If !aCols[nx][Len(aCols[nx])] .And. !empty(aCols[nx][GdFieldPos("RA4_CURSO")])			
					//Se nao existe recno, inclui
					If empty(aCols[nx][GdFieldPos("RA4_REC_WT")])  
						RecLock(cAliasObj,.T.)
					//Se existe recno, posiciona pelo recno para alterar 	
					Else
						RA4->(dbgoto(aCols[nx][GdFieldPos("RA4_REC_WT")]))
						RecLock(cAliasObj,.F.)
					EndIf
					lGrava := .T.
					Replace RA4->RA4_FILIAL 	WITH SRA->RA_FILIAL
					Replace RA4->RA4_MAT	 	WITH SRA->RA_MAT			
			EndIf
		ElseIf cAliasObj == "SZ9" //Conhecimentos
			//--Verifica se Nao esta Deletado no aCols e se nao é registro em branco
			If !aCols[nx][Len(aCols[nx])] .And. !empty(aCols[nx][GdFieldPos("Z9_CONHEC")])			
					//Se nao existe recno, inclui
					If empty(aCols[nx][GdFieldPos("Z9_REC_WT")])  
						RecLock(cAliasObj,.T.)
					//Se existe recno, posiciona pelo recno para alterar 	
					Else
						RA4->(dbgoto(aCols[nx][GdFieldPos("Z9_REC_WT")]))
						RecLock(cAliasObj,.F.)
					EndIf
					lGrava := .T.
					Replace SZ9->Z9_FILIAL 	WITH SRA->RA_FILIAL
					Replace SZ9->Z9_MAT	 	WITH SRA->RA_MAT			
			EndIf		
		ElseIf cAliasObj == "RBN"
			If !aCols[nx][Len(aCols[nx])]
				//Se nao existe recno, inclui
				If empty(aCols[nx][GdFieldPos("RBN_REC_WT")])  
					RecLock(cAliasObj,.T.)
				//Se existe recno, posiciona pelo recno para alterar 	
				Else
					RBN->(dbgoto(aCols[nx][GdFieldPos("RBN_REC_WT")]))
					RecLock(cAliasObj,.F.)
				EndIf
				lGrava := .T.
				Replace RBN->RBN_FILIAL 	WITH SRA->RA_FILIAL
				Replace RBN->RBN_MAT	 	WITH SRA->RA_MAT			
			EndIf			
		EndIf

		If lGrava
		 
			For nY := 1 To Len(aHeader)
				If aHeader[ny][8] # "M" 
					cCampo    := Trim(aHeader[nY][2])
					xConteudo := aCols[nX][nY]
					Replace &cCampo With xConteudo
				EndIf	
				
				If cAliasObj == "RBN" .And. AllTrim(aHeader[nY][2]) == "RBN_MEMO1"				
					//Replace &aHeader[nY][2] With APDMSMM(RBN_ATIVID,,,aCols[nx][ny],1,,,"RBN","RBN_ATIVID")
					APDMSMM(RBN_ATIVID,,,aCols[nx][ny],1,,,"RBN","RBN_ATIVID")
				EndIf
				
				If aHeader[nY][8] == "M" 
					IF Len(aMemosGrava) > 0
						nz += 1
						If len(aMemosGrava[nZ][1]) > 0
							aAdd	( aCodMM , { FieldGet ( FieldPos ( aMemosGrava[nZ][1][1] ) ) , ;
									 		  	aCols[nX][nY]	  		,; 
												cAliasObj				,;
												aMemosGrava[nZ][1][1]	,;  
												aMemosGrava[nZ][1][3]	};
								    )                      
						EndIf
					EndIF
				EndIF
					
			Next ny
	        
			MsUnlock()   
			FkCommit() 
		EndIf
		
		//--Verifica se esta deletado
		If aCols[nX][Len(aCols[nX])] 
			nOpcMM := 2
		Else
			nOpcMM := 1
		EndIF

		// Providencia a Gravacao e/ou Exclusao do Memo.
		IF Len(aCodMM) > 0
			For ny := 1 to Len(aCodMM)
				MsMm(	aCodMM[nY][1]		,; //Codigo do memo 				
						NIL					,;
						NIL					,;
						aCodMM[nY][2]		,; //Conteudo do Memo
						nOpcMM				,; //Opcao de Gravacao ou Delecao do Memo
						NIL					,;
						NIL					,;
						aCodMM[nY][3]		,; //Alias da Tabela que contem o memo
						aCodMM[nY][4]		,; //Nome do campo codigo do memo
						aCodMM[nY][5]		 ; //Tabela de Memos
					 )			
			Next nY
			aCodMM	:=	{}
		EndIF  
		
		//--Verifica se esta deletado e se ja existia na base
		If Len(aColsRec) >= nX .And. aCols[nX][Len(aCols[nX])]
			IF ValType(aColsRec[nx]) # "A"
				dbGoto(aColsRec[nx])
			Else
				dbGoto(aColsRec[nx][1])
			EndIF
			RecLock(cAliasObj,.F.)
			
			If cAliasObj == "RBN"
				//Replace &aHeader[nY][2] With APDMSMM(RBN_ATIVID,,,aCols[nx][ny],1,,,"RBN","RBN_ATIVID")
				APDMSMM(RBN_ATIVID,,,aCols[nx][ny],2,,,"RBN","RBN_ATIVID")
			EndIf
			
			dbDelete()
			MsUnlock()
			FkCommit()    
		EndIf
		nz := 0
	Next nx
	
Next nCount

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ cDbtTudOk ³ Autor ³              	 	 ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao executada no Ok da enchoicebar                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cDbtTudOk                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function cDbtTudOk(nOpcx)
If nOpcx == 2
	Return .T.
EndIf	          
Return (fVlTree(nOpcx))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ cDbtPrincipal  ³ Autor ³                 ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao principal que controla mudanca de arquivo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cDbtPrincipal(oExpO1,oExpO2)	 	 					      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function cDbtPrincipal(oTree,oDlgMain)
cIndo:= oTree:GetCargo() 

If cEstou == "01"
	oGetCursoF:Hide()
	oGetCursoF:oBrowse:Hide()
	oGroupCF:Hide()
ElseIf cEstou == "02"
	oGetCursoC:Hide()
	oGetCursoC:oBrowse:Hide()
	oGroupCC:Hide()
ElseIf cEstou == "03"
	oGetCursoE:Hide()
	oGetCursoE:oBrowse:Hide()
	oGroupCE:Hide()
ElseIf cEstou == "04"
	oGetConhec:Hide()
	oGetConhec:oBrowse:Hide()
	oGroupCO:Hide()
ElseIf cEstou == "05"
	oGetAtFunc:Hide()
	oGetAtFunc:oBrowse:Hide()
	oGroupAtFunc:Hide()	
EndIf	

If cIndo == "01"
	oGetCursoF:Show()
	oGetCursoF:Refresh()
	oGetCursoF:oBrowse:Show()
	oGetCursoF:oBrowse:Refresh()
	oGroupCF:Show()
	oSay1:Show()
	oGetSRA:Show()	
	oGetSRA:cText(cGet)
	n		:= 1
	oAux	:= oGetCursoF
ElseIf cIndo == "02"
	oGetCursoC:Show()
	oGetCursoC:Refresh()
	oGetCursoC:oBrowse:Show()
	oGetCursoC:oBrowse:Refresh()
	oGroupCC:Show()
	oSay1:Show()
	oGetSRA:Show()	
	oGetSRA:cText(cGet)
	n		:= 1
	oAux	:= oGetCursoC
ElseIf cIndo == "03"
	oGetCursoE:Show()
	oGetCursoE:Refresh()
	oGetCursoE:oBrowse:Show()
	oGetCursoE:oBrowse:Refresh()
	oGroupCE:Show()
	oSay1:Show()
	oGetSRA:Show()	
	oGetSRA:cText(cGet)
	n		:= 1
	oAux	:= oGetCursoE
ElseIf cIndo == "04"
	oGetConhec:Show()
	oGetConhec:Refresh()
	oGetConhec:oBrowse:Show()
	oGetConhec:oBrowse:Refresh()
	oGroupCO:Show()
	oSay1:Show()
	oGetSRA:Show()	
	oGetSRA:cText(cGet)
	n		:= 1
	oAux	:= oGetConhec
ElseIf cIndo == "05"
	oGetAtFunc:Show()
	oGetAtFunc:Refresh()
	oGetAtFunc:oBrowse:Show()
	oGetAtFunc:oBrowse:Refresh()
	oGroupAtFunc:Show()
	oSay1:Show()
	oGetSRA:Show()	
	oGetSRA:cText(cGet)
	n		:= 1
	oAux	:= oGetAtFunc
EndIf

cEstou := cIndo
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fVlTree³ Autor ³    					     ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao do Tree                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVlTree(nOpcx)

Local lRet     	:=.T. 

If nOpcx # 2			// Diferente de visual 
	If cEstou == "01"
		lRet:= U_CursoForOk()
	ElseIf cEstou == "02"
		lRet:= U_CursoForOk()
	ElseIf cEstou == "03"
		lRet:= U_CursoForOk()
	ElseIf cEstou == "04"
		lRet:= U_CursoForOk()
	ElseIf cEstou == "05"
		lRet:= U_CursoForOk()
	EndIf
EndIf	

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fGetLinha	³ Autor ³                	³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a primeira linha esta toda sem preencher		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Alias											  ³±±
±±³			 ³ ExpN1 : Registro											  ³±±
±±³			 ³ ExpN2 : Opcao											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³       		 ³											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetLinha(aHeaderLinha,aColsLinha)
Local lTree := .T.
Local nx	:= 0
Local nTam	:= Len(aHeaderLinha)

For nx:=1 To nTam
	If 	aHeaderLinha[nx][4] != 1 ;  		// Desprezar tamanho = 1
		.And. aHeaderLinha[nx][14] != "V"	// Desprezar campos visuais
		If !Empty(aColsLinha[1][nx])
			lTree := .F.
			Exit
		EndIf
	EndIf
Next nx

Return lTree
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fLinhaVazia	³ Autor ³                       ³ Data ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a primeira linha esta toda sem preenchimento         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  	 	 	 	 								     		    ³±±
±±³			 ³                       			 		 		 	 		 	³±±
±±³			 ³                          	 		 		 		 		 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³        ³     	         	 		 		 		 		 	³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLinhaVazia ( aHeadVerif , aColsVerif , aExcecao, nAt )
Local lVazio := .T.
Local nx	 := 0
Local ne	 := 0  

Default	aExcecao	:=	{}

For nx := 1 To (Len(aHeadVerif) - 1)
	IF (!(Empty(aColsVerif[nAt][nx])) .And. (aHeadVerif[nx][14] != "V") .AND. !IsHeadRec(aHeadVerif[nx, 2]) .AND. !IsHeadAlias(aHeadVerif[nx, 2]) )
		IF Len(aExcecao) # 0 
			For ne	:=	1 to Len(aExcecao)
				If nx == aExcecao[ne]
			  		IF !Empty(aColsVerif[nAt][aExcecao[ne]])
						lVazio	:=	.T.  
						Exit             
					Else
						lVazio	:=	.F.
					EndIf  
				Else
					lVazio	:= .F.   	
				EndIF
			Next ne 
			IF !(lVazio)
		   		Exit
	        Endif
		Else
			lVazio	:= .F.
			Exit	
		EndIF
	EndIF
Next nx

Return lVazio



/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ MenuDef		³Autor³  Luiz Gustavo     ³ Data ³19/12/2006³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Isola opcoes de menu para que as opcoes da rotina possam    ³
³          ³ser lidas pelas bibliotecas Framework da Versao 9.12 .      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/   
Static Function MenuDef()

 Local aRotina :={ 		{ "Pesquisar" , "PesqBrw"		, 0, 1,,.F.}, 	;	
						{ "Visualizar", "U_cDbtreeRot"	, 0, 2}, 	;		
					 	{ ""		  , ""	  			, 0, 3},	; 
					 	{ "Manutenção", "U_cDbtreeRot"	, 0, 4},	; 
						{ "Impressão" , "U_cDbtreeRot"	, 0, 5},	;		
  						{ "Legenda"	  , 'gpLegend'      , 0, 6,,.F.}}							


Return aRotina
 

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fVerTipo		³Autor³                   ³ Data ³19/12/2006³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Verifica o tipo do curso                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/   
Static Function fVerTipo(cTipo,cCurso)
Local lRet := .f.
If RA1->(dbseek(xFilial("RA1",SRA->RA_FILIAL)+cCurso))
	If cTipo == '01' .and. RA1->RA1_TIPOPP == '001'  //Formacao Academica
		lRet := .t.
	ElseIf cTipo == '03' .and. RA1->RA1_TIPOPP == '002'	//Certificacao
		lRet := .t.
	ElseIf cTipo == '02' .and. !(RA1->RA1_TIPOPP $ '001/002') //Capacitacao
		lRet := .t.
	EndIf
EndIf
Return(lRet)


User Function fDescSZ5(cTab)

Local cRet 		:= ''
Local cCpo		:= ''
DEFAULT cTab 	:= ''

If cTab == 'RA4'
	cCpo := 'RA4->RA4_CURSO'
ElseIf cTab == 'RA1'
	cCpo := 'RA1->RA1_CURSO'
EndIf

If !empty(cCpo)
	cRet := FDESC("SZ5",XFILIAL("SZ5")+&(cCpo),"Z5_DESC")
EndIf

Return(cRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TRM002XB  ³ Autor ³ Equipe RH            ³ Data ³ 28/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Constroi F3 para tabela RA1 - Cursos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TRM002                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function TRM002XB( cTabela, cCpoRet )
Local aArea			:= GetArea()
Local aObject 		:= {}              
Local aSize 		:= {}  
Local aCordW 		:= {125,0,400,635} 
Local aSvRot 		:= Nil       
Local aCGD			:= {}
Local cCampo
Local cCaption
Local cPict
Local cValid
Local cF3
Local cWhen    
Local cBlkGet
Local cBlkWhen    
Local cBlkVld     
Local cSvField		:= &(ReadVar())
Local cMyCpo 		:= ""   
Local cLineOk 		:= "AllwaysTrue()"
Local cAllOk  		:= "AllwaysTrue()"
Local cCpoAux		:= "" 
Local cPesq    		:= Space(30)    
Local lDelGetD 		:= .F. 
Local lAllOk 
Local lExist   		:= .F.
Local nCpoRet 		:= 0
Local nOpca	   		:= 0 
Local nObject
Local nAuxWidth 	:= 0
Local nCount 		:= 0
Local nOpcx			:= 7 
Local nX
Local nY
Local nLargSay
Local nLargGet
Local nCntCmb 		:= 0
Local nMaxCmb 		:= 5	//# Nr.Maximo de opcoes no Combo
Local nPos 			:= At("+", cCpoRet )  
Local oDlg  
Local oSay
Local oGet 
Local oSaveGetdad 	:= Nil
Local oTop
Local oBottom
Local i
Local uConteudo 

Private aCombo  	:= {}
Private aMyCombo	:= {}
Private aSXBCols   	:= {}
Private aSXBHeader 	:= {}
Private aC 			:= {}  
Private aColsBkp 	:= {}
Private cCombo  	:= "" 
Private cFilRA1  	:= ""
Private cDescRA1 	:= ""   
Private cTitulo 	:= ""
Private lPesqComp 	:= .F. //Variavel que indica se a pesquisa esta sendo feita com mais de um campo
Private lCheck		
Private nUsado  	:= 0 
Private nMax 		:= 0   
Private oCombo
Private oPesq
Private oBtn1
Private oCheckBox  
// OBSERVACAO IMPORTANTE
// Ao serem incluidos novos alias, campo Filial
// devera ser incluido nessa variavel para montagem
// do F3 com filtro  
Private cCposFiltros	:= "RA1_CATEG*RA1_DESC"

	If cTabela == Nil.Or. cCpoRet == Nil
		MsgAlert(OemToAnsi("Nao e possivel continuar pois faltam parametros nesta funcao!"),OemToAnsi("Atencao"))	//"Atencao"###"Nao e possivel continuar pois faltam parametros nesta funcao!"
		Return(.F.)
	EndIf

	If nPos > 0
		lPesqComp := .T.
	EndIf

	cFilRA1  := xFilial("RA1")
	cDescRA1 := OemToAnsi("Cursos - por categoria")

	// Posiciona no RA1
	dbSelectArea("RA1")
   
	// Monta conteudo dos objetos
	U_TRM002MA(cTabela,xFilial("RA1")) 

	// Variaveis inicializadas no teste
	cTitulo		:= cTabela+" - "+cDescRA1
	nMax 		:= Len(aSXBCols)
	aColsBkp 	:= aClone(aSXBCols)
	
	// Variaveis inicializadas no teste
	AADD(aC,{"cMyCpo", {15,001},"",,,,.F.,})     

	// Variaveis inicializadas no teste
	nCount++
	__cLineOk := cLineOK
	__nOpcx	 := nOpcx
	If nCount > 1
		oSaveGetdad := oGetDados
		oSaveGetdad:oBrowse:lDisablePaint := .t.
	EndIf

	oGets := {}  
	
	If Type("aRotina") == "A"
		aSvRot := aClone(aRotina)
	EndIf
	aRotina := {}
	For nX := 1 to nOpcX
		AADD(aRotina,{"","",0,nOpcx})
	Next

	aCGD	:=Iif(Len(aCGD)==0,{34,5,128,315},aCGD)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) FROM aCordW[1],aCordW[2] TO aCordW[3],aCordW[4] PIXEL OF oMainWnd
        
		If Len(aC) > 0			
		
			For nX := 1 to Len(aSXBHeader)				
				// Monta o aCombo 
				AADD( aCombo, Alltrim(aSXBHeader[nX][1]) )
				aAdd( aMyCombo, {Alltrim(aSXBHeader[nX][1]),Alltrim(aSXBHeader[nX][2])} )		
			Next nX
   			
			@ 000,000 SCROLLBOX oTop
			Aadd(aSize,aCGD[1]+13)
			Aadd(aObject,oTop)
			nObject := 2
					
			@ 005,005 SAY OemToAnsi("Pesquisar por: ") SIZE 35,07 OF oTop PIXEL	//"Pesquisar por: "
			@ 005,045 MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 080,010 OF oTop PIXEL  			
			@ 005,145 MSGET oPesq VAR cPesq PICTURE "@!" VALID Iif(!Empty(cCombo),PesqDados(cPesq),fValPesq()) SIZE 80,10 OF oTop PIXEL 						
			@ 013,475 BTNBMP oBtn1 RESOURCE "btpesq" SIZE 025,025 OF oTop PIXEL ACTION ( PesqDados(cPesq) )			
			
			For i:=1 to Len(aC)
				cCampo:=aC[i,1]
				nX:=aC[i,2,1]-13
				nY:=aC[i,2,2]
				cCaption:=Iif(Empty(aC[i,3])," ",aC[i,3])
				cPict:=Iif(Empty(aC[i,4]),Nil,aC[i,4])
				cValid:=Iif(Empty(aC[i,5]),".T.",aC[i,5])
				cF3:=Iif(Empty(aC[i,6]),NIL,aC[i,6])
				cWhen    := Iif(aC[i,7]==NIL,".T.",Iif(aC[i,7],".T.",".F."))
				cWhen    := Iif(!(Str(nOpcx,1,0)$"346"),".F.",cWhen)
				cBlKSay  := "{|| OemToAnsi('"+cCaption+"')}"
				
				oSay     := TSay():New( nX+1, nY, &cBlkSay,oTop,,, .F., .F., .F., .T.,,,,, .F., .F., .F., .F., .F. )
				nLargSay := GetTextWidth(0,cCaption) / 1.8  // estava 2.2
				cCaption := oSay:cCaption
				
				cBlkGet  := "{ | u | If( PCount() == 0, "+cCampo+","+cCampo+":= u ) }"
				cBlKVld  := "{|| "+cValid+"}"
				cBlKWhen := "{|| "+cWhen+"}"
							
				oGet := TGet():New( nX, nY+nLargSay,&cBlKGet,oTop,,,cPict, &(cBlkVld),,,, .F.,, .T.,, .F., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,(cCampo))
				AADD(oGets,oGet)
			Next
		EndIf

		oGetDados := MsNewGetDados():New(aCGD[1],;			// nTop
										 aCGD[2],;   		// nLelft
										 aCGD[3],; 			// nBottom
			                             aCGD[4],;			// nRright
										 Nil,;	    		// controle do que podera ser realizado na GetDado - nstyle
										 "SXBMod2LOk()",;	// Funcao para validar a edicao da linha - ulinhaOK  (funcao no GPEA310)
										 "AllwaysTrue()",;	// Funcao para validar todas os registros da GetDados - uTudoOK
		  								 Nil,;				// cIniCPOS
										 Nil,;		        // aAlter
										 0,; 				// nfreeze
										 nMax,;  			// nMax
										 Nil,;		 		// cFieldOK
										 Nil,;				// usuperdel
										 .F.,;	        	// udelOK
										 @oDlg,;        	// objeto de dialogo - oWnd
										 @aSXBHeader,;		// Vetor com Colunas - AparHeader
										 @aSXBCols;			// Vetor com Header - AparCols
							)
		
		AADD(aObject,oGetDados:oBrowse)
		AADD(aSize,Nil)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,lAllOk:=__Mod2OK(cAllOk),Iif(lAllOk,oDlg:End(),nOpca:=0)},{||oDlg:End()},,),;
									AlignObject(oDlg,aObject,1,nObject,aSize),oGetDados:oBrowse:Refresh())

	nCount--
	If nCount > 0
		oGetDados := oSaveGetDad
		oGetDados:oBrowse:lDisablePaint := .f.
	EndIf
	If ValType(aSvRot) == "A"
		aRotina := aClone(aSvRot)
	EndIf

	If nOpca == 1 .And. Len(aSXBCols) > 0
		If !lPesqComp
			nCpoRet := GdFieldPos(cCpoRet, aSXBHeader)
			VAR_IXB  := aSXBCols[oGetDados:nAt,nCpoRet]
		Else         
			VAR_IXB := ""	
			While lPesqComp
				cCpoAux := Substr(cCpoRet, 1, nPos - 1)
				cCpoRet := Substr(cCpoRet, nPos +1)    
	
				nCpoRet := GdFieldPos(cCpoAux, aSXBHeader)
				VAR_IXB += aSXBCols[oGetDados:nAt,nCpoRet]
	
				nPos := At("+", cCpoRet )
				lPesqComp := If (nPos > 0, .T., .F.)
				
				If nPos == 0
					nCpoRet := GdFieldPos(cCpoRet, aSXBHeader)
					VAR_IXB += aSXBCols[oGetDados:nAt,nCpoRet]
				EndIf
			EndDo
		EndIf
	Else
		VAR_IXB := cSvField
		RestArea(aArea)
		Return .T.
	EndIf

RestArea( aArea )

Return(nOpca == 1)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ TRM002MA       ³ Autor ³ Equipe RH        ³ Data ³  22/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta aCols com campos para o F3 RA1.				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RSP210  									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
User Function TRM002MA(cTab,cFilRA1)   
Local aArea	  		:= GetArea()
Local nCont			:= 0    
Local nCnt
Local nQtdLin		:= 7000
Local uValor

    // Monta aHeader
	dbSelectArea("SX3")
	dbSetOrder(1) // X3_ARQUIVO + X3_ORIGEM	  
	If SX3->(dbSeek(cTab))
		While !Eof() .And. SX3->X3_ARQUIVO == cTab		
			If AllTrim(SX3->X3_CAMPO) $ "RA1_CATEG*RA1_CURSO*RA1_DESC"
				aAdd(aSXBHeader,{ 	SX3->X3_TITULO, ;	//# 01
									SX3->X3_CAMPO, ;	//# 02
									SX3->X3_PICTURE, ;	//# 03
									SX3->X3_TAMANHO, ;	//# 04
									SX3->X3_DECIMAL, ;	//# 05
									Nil, ;				//# 06
									Nil, ;				//# 07
									SX3->X3_TIPO, ;		//# 08
									Nil,  ;	     		//# 09
									SX3->X3_CONTEXT } )	//# 10 Real ou Virtual  
							
			EndIf
			dbSkip()
		EndDo 
	EndIf 
	
	// Monta aCols
	dbSelectArea( "RA1" )
	RA1->( dbSetOrder( 1 ) )	// RA1_FILIAL + RA1_CURSO 
	If RA1->(dbSeek(cFilRA1))
		While ! Eof() .And. RA1->RA1_FILIAL == ( cFilRA1  ) 
				AADD(aSXBCols,Array(Len(aSXBHeader)+1))
				For nCnt := 1 To Len(aSXBHeader)	
					cCampo := Alltrim(aSXBHeader[nCnt,02])		
						If aSXBHeader[nCnt,08] == "N"
							uValor := Val( RA1->&(cCampo) )
						ElseIf aSXBHeader[nCnt,08] == "D"
							uValor := Ctod( RA1->&(cCampo) )
						Else
							uValor := RA1->&(cCampo)
						EndIf
						aSXBCols[Len(aSXBCols)][nCnt] := uValor		  
				Next nCnt
				aSXBCols[Len(aSXBCols)][Len(aSXBHeader)+1] := .F.
				nCont += 1
				If nCont > nQtdLin
					Exit
				EndIf 
			dbSkip()
		EndDo  
	EndIf  

	RestArea( aArea )

Return   

//-------------------------------------------------------------------
/*/{Protheus.doc} SZ5RA4()
Consulta especifica de categoria de cursos (RA4_CATEG).

@author Diego Santos
@since 22/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function SZ5RA4()

Local nRetorno := 0
Local aPesq	   := {"Z5_CODIGO","Z5_DESCRI"}
Local lRet	   := .T.

If IsInCallStack("U_TRM002") //Se for chamado atraves da rotina de Cursos de Funcionário

	cQuery := " SELECT DISTINCT SZ5.Z5_FILIAL, SZ5.Z5_CODIGO, SZ5.Z5_DESCRI, SZ5.R_E_C_N_O_ SZ5RECNO "
	cQuery += " FROM "+RetSQLName("SZ5") + " SZ5 "
	cQuery += " LEFT JOIN "+RetSQLName("RA1") + " RA1 " 
	cQuery += " ON "
	cQuery += " SZ5.Z5_FILIAL = RA1.RA1_FILIAL AND "
	cQuery += " SZ5.Z5_CODIGO = RA1.RA1_CATEG "
	cQuery += " WHERE "

	If cEstou == "01" //Formação Academica
		cQuery += " RA1.RA1_TIPOPP = '001' AND "
	ElseIf cEstou == "02" //Capacitação
		cQuery += " RA1.RA1_TIPOPP <> '001' AND RA1.RA1_TIPOPP <> '002' AND "
	ElseIf cEstou == "03" //Certificação
		cQuery += " RA1.RA1_TIPOPP = '002' AND "
	EndIf
	
	cQuery += " SZ5.D_E_L_E_T_ = '' AND  RA1.D_E_L_E_T_ = '' AND SZ5.Z5_FILIAL = '"+xFilial("SZ5")+"'"
	
Else
	cQuery := " SELECT SZ5.Z5_FILIAL, SZ5.Z5_CODIGO, SZ5.Z5_DESCRI, SZ5.R_E_C_N_O_ SZ5RECNO "
	cQuery += " FROM "+RetSQLName("SZ5") + " SZ5 "
	cQuery += " WHERE "
	cQuery += " SZ5.D_E_L_E_T_ = '' AND SZ5.Z5_FILIAL = '"+xFilial("SZ5")+"'"
EndIf
	
If U_JurF3Qry( cQuery, 'SZ5RA4', 'SZ5RECNO', @nRetorno, , aPesq )
	SZ5->( dbGoto( nRetorno ) )
	lRet := .T.
Else
	lRet := .F.
EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} JurF3Qry
Função genérica para montagem de tela de consulta padrao baseado em query especifica
Uso Geral.

@param 	cQuery          Query a ser executada
@param 	cCodCon 	    Codigo da consulta
@param 	cCpoRecno 		Campo com o Recno()
@param 	nRetorno 		Campo onde sera retornado o recno() do registro selecionado
@param 	aCoord          Coordenadas da tela, se nao espeficicado serÃ¡ usado o tamanho padrão
@param 	aSearch         Array de campos que serao os indices utilizados para pesquisa
@sample

Funcion SA1CON()
Local nRetorno := 0

cQuery += "SELECT A1_COD, A1_LOJA, A1_NOME, SA1.R_E_C_N_O_ SA1RECNO "
cQuery += "  FROM " + RetSqlName( "SA1" ) + " SA1 "
cQuery += " WHERE A1_FILIAL = '" + xFilial( "SA1" ) + "'"
cQuery += "   AND A1_TIPO = 'J'"
cQuery += "   AND SA1.D_E_L_E_T_ = ' '"

If JurF3Qry( cQuery, 'SA1QRY', 'SA1RECNO', @nRetorno )
	SA1->( dbGoto( uRetorno ) )
	lRet := .T.
EndIf

// Deve ser criada uma consulta especifica no configurador para esta funcao,
// no exemplo, SA1CON()

Return lRet

@author Ernani Forastieri
@since 01/06/09
@version 1.0
/*/
//-------------------------------------------------------------------
User Function JurF3Qry( cQuery, cCodCon, cCpoRecno, uRetorno, aCoord, aSearch, cTela, lInclui, lAltera, lVisualiza, cTabela )
Local aArea       := GetArea()
Local aSeek	  	  := {}
Local aIndex      := {}
Local cIdBrowse   := ''
Local cIdRodape   := ''
Local cTrab       := GetNextAlias()
Local nI          := 0
Local cRestr			:= ''
Local oBrowse, oDlg, oBtnOk, oBtnCan, oTela, oPnlBrw, oPnlRoda, oBtnInc, oBtnAlt, oBtnVis
Local nButLeft    := 0

Private lRetF3      := .F.

ParamType 0 Var cQuery     As Character
ParamType 1 Var cCodCon    As Character
ParamType 2 Var cCpoRecno  As Character
ParamType 3 Var uRetorno   As Character, Date, Numeric
ParamType 4 Var aCoord     As Array Optional Default {178, 0, 543, 800} //padrï¿½o de coordenadas da consulta especï¿½fica
ParamType 5 Var aSearch    As Array Optional Default {}
ParamType 6 Var cTela	   As Character Optional Default ""
ParamType 7 Var lInclui    As Logical Optional Default .F.
ParamType 8 Var lAltera    As Logical Optional Default .F.
ParamType 9 Var lVisualiza As Logical Optional Default .F.
ParamType 10 Var cTabela   As Character Optional Default ""
  
If !EMPTY(cTabela)
	cRestr := JurQryRest(cTabela)
EndIf  
If !EMPTY(cRestr)
	cQuery += cRestr
EndIf

//-------------------------------------------------------------------
// Indica as chaves de Pesquisa
//-------------------------------------------------------------------
//[1] - Nome do Campo
//[2] - Titulo do Campo
//[3] - Tipo do Campo
//[4] - Tamanho do Campo
//[5] - Casas decimais
//-------------------------------------------------------------------
If !Empty (aSearch)
	For nI:= 1 to Len(aSearch)
		aAdd( aIndex, aSearch[nI] )
		aAdd( aSeek, { AvSX3(aSearch[nI],5), {{"",AvSX3(aSearch[nI],2),AvSX3(aSearch[nI],3),AvSX3(aSearch[nI],4),AvSX3(aSearch[nI],5),,}} } )
		
		If nI == 1
			cQuery += " ORDER BY "+aSearch[nI]
		EndIf
		
	Next
EndIf

Define MsDialog oDlg FROM aCoord[1], aCoord[2] To aCoord[3], aCoord[4] Title STR0112 Pixel Of oMainWnd //'Consulta Padrão'

oTela     := FWFormContainer():New( oDlg )
cIdBrowse := oTela:CreateHorizontalBox( 85 )
cIdRodape := oTela:CreateHorizontalBox( 15 )
oTela:Activate( oDlg, .F. )

oPnlBrw   := oTela:GeTPanel( cIdBrowse )
oPnlRoda  := oTela:GeTPanel( cIdRodape )

oBrowse := CriaF3Browse(oDlg, oPnlBrw, cQuery, @cTrab, @uRetorno, aSeek, aIndex, cCodCon, cCpoRecno)

@ oPnlRoda:nTop + 05, oPnlRoda:nLeft + 003 Button oBtnOk  Prompt STR0113 Size 25, 11 Of oPnlRoda Pixel Action ( lRetF3 := .T., uRetorno := ( cTrab )->( FieldGet( FieldPos( cCpoRecno ) ) ) , oDlg:End() ) //'Confirma'
@ oPnlRoda:nTop + 05, oPnlRoda:nLeft + 033 Button oBtnCan Prompt STR0114 Size 25, 11 Of oPnlRoda Pixel Action ( lRetF3 := .F., oDlg:End() ) //'Cancela'

nButLeft := 033

If lInclui
	nButLeft += 30
	@ oPnlRoda:nTop + 05, oPnlRoda:nLeft + nButLeft Button oBtnInc Prompt STR0115 Size 25, 12 Of oPnlRoda Pixel Action ( JurAcao(cTela, 3, oBrowse), ;
					 oBrowse:DeActivate(.T.), oBrowse := CriaF3Browse(oDlg, oPnlBrw, cQuery, @cTrab, @uRetorno, aSeek, aIndex, cCodCon, cCpoRecno) ) //'Incluir'
EndIf

If lAltera
	nButLeft += 30
	@ oPnlRoda:nTop + 05, oPnlRoda:nLeft + nButLeft Button oBtnAlt Prompt STR0116 Size 25, 12 Of oPnlRoda Pixel Action ( JurAcao(cTela, 4, oBrowse, (cTrab)->( FieldGet( FieldPos( cCpoRecno ) ) ), cTabela) ) //'Alterar'
EndIf

If lVisualiza
	nButLeft += 30
	@ oPnlRoda:nTop + 05, oPnlRoda:nLeft + nButLeft Button oBtnVis Prompt STR0117 Size 25, 12 Of oPnlRoda Pixel Action ( JurAcao(cTela, 1, oBrowse, (cTrab)->( FieldGet( FieldPos( cCpoRecno ) ) ), cTabela) ) //'Visualizar'
EndIf  
		
//-------------------------------------------------------------------
// Ativação do janela
//-------------------------------------------------------------------
Activate MsDialog oDlg Centered

RestArea( aArea )

Return lRetF3

Static Function CriaF3Browse(oDlg, oPnlBrw, cQuery, cTrab, uRetorno, aSeek, aIndex, cCodCon, cCpoRecno)
Local oBrowse, oColumn
Local nI, nAt
Local aCampos     := {}
Local aStru       := {}
Local aJurF3      := {}
Local cTitCpo     :=  ''
Local cPicCpo     :=  ''

  IF SELECT(cTrab) > 0
		(cTrab)->(DbCloseArea())
		cTrab := GetNextAlias()
	ElseIf File(cTrab+GetDbExtension())
		cTrab := GetNextAlias()
	EndIf

	nAt := aScan( aJurF3, { | aX | aX[1] == PadR( cCodCon, 10 ) } )
	If !Empty( cCodCon )
		
		If nAt == 0
			aAdd( aJurF3, { PadR( cCodCon, 10 ) , cQuery, {} } )
		Else
			cQuery  := aJurF3[nAt][2]
		EndIf
		
	EndIf

	//-------------------------------------------------------------------
	// Define o Browse
	//-------------------------------------------------------------------
	
	DEFINE FWBrowse oBrowse DATA QUERY ALIAS cTrab QUERY cQuery;
	DOUBLECLICK { || lRetF3 := .T., uRetorno := (cTrab)->( FieldGet( FieldPos( cCpoRecno ) ) ), oDlg:End() } ; 
	NO LOCATE FILTER SEEK ORDER aSeek INDEXQUERY aIndex Of oPnlBrw
	
	oBrowse:SetShowLimit(.T.)
	
	TcSetField( cTrab, cCpoRecno  , 'N', 12,0)
	TcSetField( cTrab, 'NT2_DATA' , 'D', TamSX3('NT2_DATA' )[1], 0 )
	//-------------------------------------------------------------------
	// Monta Estrutura de campos
	//-------------------------------------------------------------------
	If !Empty( cCodCon )
		
		If nAt == 0
			
			aStru := ( cTrab )->( dbStruct() )
			
			For nI := 1 To Len( aStru )
				
				//-------------------------------------------------------------------
				// Campos
				//-------------------------------------------------------------------
				// Estrutura do aFields
				//				[n][1] Campo
				//				[n][2] Título
				//				[n][3] Tipo                        	
				//				[n][4] Tamanho
				//				[n][5] Decimal
				//				[n][6] Picture
				//-------------------------------------------------------------------
				
				cTitCpo := aStru[nI][1]
				cPicCpo := ''
				
				If AvSX3( aStru[nI][1],, cTrab, .T. )
					cTitCpo := RetTitle( aStru[nI][1] )
					cPicCpo := AvSX3( aStru[nI][1], 6, cTrab )
					
					If cPicCpo $ '@!'
						cPicCpo := ''
					EndIf
				EndIf
				
				If !PadR( cCpoRecno, 15 ) == PadR( aStru[nI][1], 15 )
					aAdd( aCampos, { aStru[nI][1], cTitCpo,  aStru[nI][2], aStru[nI][3], aStru[nI][4], cPicCpo } )
				EndIf
				
			Next
			
			If !Empty( cCodCon )
				aJurF3[Len( aJurF3 )][3] := aCampos
			EndIf
			
		Else
			aCampos := aClone( aJurF3[nAt][3] )
		EndIf
		
	EndIf
	
	//-------------------------------------------------------------------
	// Adiciona as colunas do Browse
	//-------------------------------------------------------------------
	
	For nI := 1 To Len( aCampos )
		
		if "NT2_DATA" $ alltrim( aCampos[nI][1] )
			ADD COLUMN oColumn  DATA &( '{ || substr( &("' + aCampos[nI][1] + '"),7,2) + "/" + substr( &("' + aCampos[nI][1] + '"),5,2) + "/" + substr( &("' + aCampos[nI][1] + '"),1,4 ) }' ) Title aCampos[nI][2] PICTURE aCampos[nI][6] Of oBrowse
		else
			ADD COLUMN oColumn  DATA &( '{ ||' + aCampos[nI][1] + ' }' ) Title aCampos[nI][2]  PICTURE aCampos[nI][6] Of oBrowse
		endif
		
	Next
	
	//-------------------------------------------------------------------
	// Adiciona as colunas do Filtro
	//-------------------------------------------------------------------
	oBrowse:SetFieldFilter( aCampos )
	oBrowse:lFilter := .f.	
	
	//-------------------------------------------------------------------
	// Ativação do Browse
	//-------------------------------------------------------------------
	Activate FWBrowse oBrowse

Return oBrowse

//-------------------------------------------------------------------
/*/{Protheus.doc} XRA4()
Consulta especifica de cursos.

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function XRA4

Local lRet 		:= .T.
Local nPosCateg := aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CATEG" })

If IsInCallStack("U_TRM002")

	If cEstou == "01" //Formação Academica
		lRet := RA1->RA1_CATEG == aCols[n][nPosCateg] .And. RA1->RA1_TIPOPP == "001"
	ElseIf cEstou == "02" //Capacitação
		lRet := RA1->RA1_CATEG == aCols[n][nPosCateg] .And. RA1->RA1_TIPOPP != "001" .And. RA1->RA1_TIPOPP != "002" 
	ElseIf cEstou == "03" //Certificação
		lRet := RA1->RA1_CATEG == aCols[n][nPosCateg] .And. RA1->RA1_TIPOPP == "002"
	EndIf
	
Else
	lRet := RA1->RA1_CATEG == aCols[n][nPosCateg] 
EndIf	

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} RA4IPCAT()
Inicializador padrão do campo RA4_CATEG.

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//------------------------------------------------------------------

User Function RA4IPCAT

Local cRet 		:= ""

//Iif(!Inclui,AllTrim(Posicione("RA1",1,xFilial("RA1")+M->RA1_CURSO,"RA1_CATEG ")),"")
Local aRA1Area  := RA1->(GetArea())
Local lExistN	:= Type("n") <> "U"
Local nPosCurso := aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CURSO" })



If !Inclui//Se for um registro com valor
	If IsInCallStack("U_TRM002")
		If lExistN
			If n < Len(aCols) .Or. Empty(aCols[n][nPosCurso]) //Significa que trata-se de uma linha nova.
				cRet := ""
			Else
				cRet := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_CATEG")
			EndIf
		Else
			cRet := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_CATEG")
		EndIf
	Else
		cRet := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_CATEG")
	EndIf
Else
	cRet := ""
EndIf

RestArea(aRA1Area)

Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} RA4IPDESCA()
Inicializador padrão do campo RA4_DESCCA.

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//------------------------------------------------------------------

User Function RA4IPDESCA

Local cRet 		:= ""
Local cCateg	:= ""
Local nPosCurso := aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CURSO" })
Local lExistN	:= Type("n") <> "U"
Local aSZ5Area  := SZ5->(GetArea())

//Iif(!Inclui,AllTrim(Posicione("SZ5",1,xFilial("SZ5")+M->RA4_CATEG,"Z5_DESCRI")),"")]

If !Inclui//Se for um registro com valor
	If IsInCallStack("U_TRM002")
		If lExistN
			If n < Len(aCols) .Or. Empty(aCols[n][nPosCurso])//Significa que trata-se de uma linha nova.
				cRet   := ""
			Else	
				cCateg := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_CATEG")
				cRet   := Posicione("SZ5", 1, xFilial("SZ5")+cCateg, "Z5_DESCRI")
			EndIf
		Else
			cCateg := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_CATEG")
			cRet   := Posicione("SZ5", 1, xFilial("SZ5")+cCateg, "Z5_DESCRI")	
		EndIf
	Else
		cCateg := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_CATEG")
		cRet   := Posicione("SZ5", 1, xFilial("SZ5")+cCateg, "Z5_DESCRI")
	EndIf
Else
	cRet := ""
EndIf
	
RestArea(aSZ5Area)

Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} DESCARA4IP()
Inicializador padrão do campo RA4_DESCCU.

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//------------------------------------------------------------------

User Function DESCARA4IP

Local cRet 		:= ""
Local cCateg	:= ""
Local nPosCurso := aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CURSO" })
Local lExistN	:= Type("n") <> "U"
Local aSZ5Area  := SZ5->(GetArea())

//Iif(!Inclui,AllTrim(Posicione("SZ5",1,xFilial("SZ5")+M->RA4_CATEG,"Z5_DESCRI")),"")]
If !Inclui
	If IsInCallStack("U_TRM002")
		If lExistN
			If n < Len(aCols) .Or. Empty(aCols[n][nPosCurso])//Significa que trata-se de uma linha nova.
				cRet   := ""				
			Else
				cRet   := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_DESC")							
			EndIf
		Else
			cRet   := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_DESC")
		EndIf
	Else
		cRet   := Posicione("RA1", 1, xFilial("RA1")+RA4->RA4_CURSO, "RA1_DESC")
	EndIf
Else
	cRet   := ""
EndIf
	
RestArea(aSZ5Area)


Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} VLDRA1()
Valid campo RA4_CURSO.

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function VLDRA1()

Local lRet 			:= .T.
Local nPosCat 		:= aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CATEG" })
Local nPosCur		:= aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CURSO" })
Local nPosDCurso	:= aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_DESCCU" })

If IsInCallStack("U_TRM002")
	If cEstou == "01" //Formação Acadêmica aCols
		lRet := aCols[n][nPosCat] == Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_CATEG") .And.;
				Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_TIPOPP") == "001" 
	ElseIf cEstou == "02" //Capacitação
		lRet := aCols[n][nPosCat] == Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_CATEG") 	.And.;
				Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_TIPOPP") != "001" 			.And.;
				Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_TIPOPP") != "002"
	ElseIf cEstou == "03" //Certificação
		lRet := aCols[n][nPosCat] == Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_CATEG") 		.And.;
		Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_TIPOPP") == "002"
	EndIf
Else
	lRet := aCols[n][aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CATEG" })] == Posicione("RA1", 1, xFilial("RA1")+M->RA4_CURSO, "RA1_CATEG")
EndIf

If !lRet
	aCols[n][nPosDCurso] := Posicione("RA1", 1, xFilial("RA1")+aCols[n][nPosCur], "RA1_DESC")
EndIf
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} VLDSZ5()
Valid campo RA4_CATEG.

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function VLDSZ5()

Local lRet 		:= .T.
Local nPosCurso := aScan( aHeader , { |x| AllTrim(x[2]) == "RA4_CURSO" })
Local cTipoPP	:= ""

If IsInCallStack("U_TRM002")
	If cEstou == "01" //Formação Acadêmica
		cTipoPP  := Posicione("RA1", 1, xFilial("RA1")+"001"+M->RA4_CATEG, "RA1_TIPOPP", "RA1CAT")
		lRet 	 := cTipoPP == "001"  
	ElseIf cEstou == "02" //Capacitação
		cTipoPP  := GetTipoPP()
		lRet 	 := cTipoPP != "001" .And. cTipoPP != "002" .And. !Empty(cTipoPP)
		//Filtro diferente pois tenho q buscar por diferente de 001 e diferente de 002. 
	ElseIf cEstou == "03" //Certificação
		cTipoPP  := Posicione("RA1", 1, xFilial("RA1")+"002"+M->RA4_CATEG, "RA1_TIPOPP", "RA1CAT")
		lRet 	 := cTipoPP == "002"
	EndIf
EndIf
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GetTipoPP()
Verifica o campo RA1_TIPOPP na tabela de cursos (RA1).

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

Static Function GetTipoPP()

Local cTipoPP 	:= ""
Local cQuery  	:= ""
Local cAliasQry	:= GetNextAlias()

cQuery := "SELECT * FROM "+RetSqlName("RA1")+ " RA1 "
cQuery += "WHERE "
cQuery += "RA1.RA1_FILIAL = '"+xFilial("RA1")+"' AND "
cQuery += "RA1.RA1_CATEG  = '"+M->RA4_CATEG+"' AND "
cQuery += "RA1.RA1_TIPOPP  <> '001' AND "
cQuery += "RA1.RA1_TIPOPP  <> '002' AND "
cQuery += "RA1.D_E_L_E_T_ = ''"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)

If (cAliasQry)->(!Eof())
	cTipoPP := (cAliasQry)->RA1_TIPOPP
EndIf

Return cTipoPP


//-------------------------------------------------------------------
/*/{Protheus.doc} SZ7SZ9()
Consulta específica para categorias de conhecimentos (SZ7).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function SZ7SZ9()

Local nRetorno := 0
Local aPesq	   := {"Z7_CODIGO","Z7_DESCRI"}
Local lRet	   := .T.

cQuery := " SELECT SZ7.Z7_FILIAL, SZ7.Z7_CODIGO, SZ7.Z7_DESCRI, SZ7.R_E_C_N_O_ SZ7RECNO "
cQuery += " FROM " + RetSqlName("SZ7") + " SZ7 "
cQuery += " WHERE "
cQuery += " SZ7.Z7_FILIAL 	= '"+xFilial("SZ7")+"' AND "
cQuery += " SZ7.Z7_AREA 	= '"+M->Z9_AREA+"' AND "
cQuery += " SZ7.D_E_L_E_T_ 	= ''"
		
If U_JurF3Qry( cQuery, 'SZ7SZ9', 'SZ7RECNO', @nRetorno, , aPesq )
	SZ7->( dbGoto( nRetorno ) )
	lRet := .T.
Else
	lRet := .F.
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} SZ8SZ9()
Consulta específica para conhecimentos (SZ8).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function SZ8SZ9()

Local nRetorno := 0
Local aPesq	   := {"Z8_CODIGO","Z8_DESCRI"}
Local lRet	   := .T.

cQuery := " SELECT SZ8.Z8_FILIAL, SZ8.Z8_CODIGO, SZ8.Z8_DESCRI, SZ8.R_E_C_N_O_ SZ8RECNO "
cQuery += " FROM " + RetSqlName("SZ8") + " SZ8 "
cQuery += " WHERE "
cQuery += " SZ8.Z8_FILIAL 	= '" + xFilial("SZ8")	+ "' AND "
cQuery += " SZ8.Z8_AREA 	= '" + M->Z9_AREA  		+ "' AND "
cQuery += " SZ8.Z8_CATEG 	= '" + M->Z9_CATEG 		+ "' AND "
cQuery += " SZ8.D_E_L_E_T_ 	= ''"
		
If U_JurF3Qry( cQuery, 'SZ8SZ9', 'SZ8RECNO', @nRetorno, , aPesq )
	SZ8->( dbGoto( nRetorno ) )
	lRet := .T.
Else
	lRet := .F.
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} SZ9IPDAREA()
Inicializador padrão campo descrição área (SZ9).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function SZ9IPDAREA

Local cRet 		:= ""
Local cArea		:= ""
Local lExistN	:= Type("n") <> "U"
Local aSZ6Area  := SZ6->(GetArea())

//Iif(!Inclui,AllTrim(Posicione("SZ5",1,xFilial("SZ5")+M->RA4_CATEG,"Z5_DESCRI")),"")]
If !Inclui

	If lExistN
		If n < Len(aCols) //Significa que trata-se de uma linha nova.
			cRet   := ""				
		Else
			cRet   := Posicione("SZ6", 1, xFilial("SZ6")+SZ9->Z9_AREA, "Z6_DESCRI")							
		EndIf
	Else
		cRet   := Posicione("SZ6", 1, xFilial("SZ6")+SZ9->Z9_AREA, "Z6_DESCRI")
	EndIf
	
Else
	cRet   := ""
EndIf
	
RestArea(aSZ6Area)

Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} SZ9IPDCAT()
Inicializador padrão campo descrição categoria (SZ9).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function SZ9IPDCAT

Local cRet 		:= ""
Local cArea		:= ""
Local lExistN	:= Type("n") <> "U"
Local aSZ7Area  := SZ7->(GetArea())

//Iif(!Inclui,AllTrim(Posicione("SZ5",1,xFilial("SZ5")+M->RA4_CATEG,"Z5_DESCRI")),"")]
If !Inclui

	If lExistN
		If n < Len(aCols) //Significa que trata-se de uma linha nova.
			cRet   := ""				
		Else
			cRet   := Posicione("SZ7", 1, xFilial("SZ7")+SZ9->Z9_AREA+SZ9->Z9_CATEG, "Z7_DESCRI")							
		EndIf
	Else
		cRet   := Posicione("SZ7", 1, xFilial("SZ7")+SZ9->Z9_AREA+SZ9->Z9_CATEG, "Z7_DESCRI")
	EndIf
	
Else
	cRet   := ""
EndIf
	
RestArea(aSZ7Area)

Return cRet


//-------------------------------------------------------------------
/*/{Protheus.doc} SZ9IPDCON()
Inicializador padrão campo descrição conhecimento (SZ9).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function SZ9IPDCON

Local cRet 		:= ""
Local cArea		:= ""
Local lExistN	:= Type("n") <> "U"
Local aSZ8Area  := SZ8->(GetArea())

//Iif(!Inclui,AllTrim(Posicione("SZ5",1,xFilial("SZ5")+M->RA4_CATEG,"Z5_DESCRI")),"")]
If !Inclui

	If lExistN
		If n < Len(aCols) //Significa que trata-se de uma linha nova.
			cRet   := ""				
		Else
			//Z8_FILIAL+Z8_AREA+Z8_CATEG+Z8_CODIGO
			cRet   := Posicione("SZ8", 1, xFilial("SZ8")+SZ9->Z9_AREA+SZ9->Z9_CATEG+SZ9->Z9_CONHEC, "Z8_DESCRI")							
		EndIf
	Else
		cRet   := Posicione("SZ8", 1, xFilial("SZ8")+SZ9->Z9_AREA+SZ9->Z9_CATEG+SZ9->Z9_CONHEC, "Z8_DESCRI")
	EndIf
	
Else
	cRet   := ""
EndIf
	
RestArea(aSZ8Area)

Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} VLDSZ9A()
Valid campo Z9_AREA (SZ9).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------
User Function VLDSZ9A()

Local lRet 			:= .T.

Local lExistArea	:= .T.
Local lExistCat		:= .T.
Local lExistCon		:= .T.

Local nPosArea 		:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_AREA" 	})
Local nPosCateg		:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_CATEG" 	})
Local nPosConhec	:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_CONHEC" 	})

Local nPosDArea 	:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_DSCAREA" })

lExistArea := !Empty(Posicione("SZ6", 1, xFilial("SZ6")+M->Z9_AREA, "Z6_CODIGO"))
If lExistArea
	If !Empty(aCols[n][nPosCateg])
		lExistCat := !Empty(Posicione("SZ7", 1, xFilial("SZ7")+M->Z9_AREA+aCols[n][nPosCateg], "Z7_CODIGO"))
	EndIf	
	If lExistCat
		If !Empty(aCols[n][nPosConhec])
			lExistCon := !Empty(Posicione("SZ8", 1, xFilial("SZ8")+M->Z9_AREA+aCols[n][nPosCateg]+aCols[n][nPosConhec], "Z8_CODIGO"))
		EndIf
	EndIf		
EndIf

lRet := lExistArea .And. lExistCat .And. lExistCon

If !lRet
	aCols[n][nPosDArea] := Posicione("SZ6", 1, xFilial("SZ6")+aCols[n][nPosArea], "Z6_DESCRI")
Else
	aCols[n][nPosDArea] := Posicione("SZ6", 1, xFilial("SZ6")+M->Z9_AREA, "Z6_DESCRI")	
EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} VLDSZ9C()
Valid campo Z9_CATEG (SZ9).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------
User Function VLDSZ9C()

Local lRet 			:= .T.

Local lExistArea	:= .T.
Local lExistCat		:= .T.
Local lExistCon		:= .T.

Local nPosArea 		:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_AREA" 	})
Local nPosCateg		:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_CATEG" 	})
Local nPosConhec	:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_CONHEC" 	})

Local nPosDCateg 	:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_DSCATEG" })

lExistrArea := !Empty(Posicione("SZ6", 1, xFilial("SZ6")+aCols[n][nPosArea], "Z6_CODIGO"))
If lExistArea
	lExistCat := !Empty(Posicione("SZ7", 1, xFilial("SZ7")+aCols[n][nPosArea]+M->Z9_CATEG, "Z7_CODIGO"))	
	If lExistCat
		If !Empty(aCols[n][nPosConhec])
			lExistCon := !Empty(Posicione("SZ8", 1, xFilial("SZ8")+aCols[n][nPosArea]+M->Z9_CATEG+aCols[n][nPosConhec], "Z8_CODIGO"))
		EndIf
	EndIf		
EndIf

lRet := lExistArea .And. lExistCat .And. lExistCon

If !lRet
	aCols[n][nPosDCateg] := Posicione("SZ7", 1, xFilial("SZ7")+aCols[n][nPosArea]+aCols[n][nPosCateg], "Z7_DESCRI")
Else
	aCols[n][nPosDCateg] := Posicione("SZ7", 1, xFilial("SZ7")+aCols[n][nPosArea]+M->Z9_CATEG, "Z7_DESCRI")	
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} VLDSZ9K()
Valid campo Z9_CONHEC (SZ9).
Utilizado no TRM002. (Tree Conhecimentos)

@author Diego Santos
@since 23/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------
User Function VLDSZ9K()

Local lRet 			:= .T.

Local lExistArea	:= .T.
Local lExistCat		:= .T.
Local lExistCon		:= .T.

Local nPosArea 		:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_AREA" 	})
Local nPosCateg		:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_CATEG" 	})
Local nPosConhec	:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_CONHEC" 	})

Local nPosDConhec 	:= aScan( aHeader , { |x| AllTrim(x[2]) == "Z9_DSCONHE" })

lExistArea := !Empty(Posicione("SZ6", 1, xFilial("SZ6")+aCols[n][nPosArea], "Z6_CODIGO"))
If lExistArea
	lExistCat := !Empty(Posicione("SZ7", 1, xFilial("SZ7")+aCols[n][nPosArea]+aCols[n][nPosCateg], "Z7_CODIGO"))	
	If lExistCat
		lExistCon := !Empty(Posicione("SZ8", 1, xFilial("SZ8")+aCols[n][nPosArea]+aCols[n][nPosCateg]+M->Z9_CONHEC, "Z8_CODIGO"))
	EndIf		
EndIf

lRet := lExistArea .And. lExistCat .And. lExistCon

If !lRet
	aCols[n][nPosDConhec] := Posicione("SZ8", 1, xFilial("SZ8")+aCols[n][nPosArea]+aCols[n][nPosCateg]+aCols[n][nPosConhec], "Z8_DESCRI")
Else
	aCols[n][nPosDConhec] := Posicione("SZ8", 1, xFilial("SZ8")+aCols[n][nPosArea]+aCols[n][nPosCateg]+M->Z9_CONHEC, "Z8_DESCRI")	
EndIf

Return lRet
