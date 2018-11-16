#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDef.CH'

/*/{Protheus.doc} TRM009
Rotina de Cadastro de Requisitos do Cargo, defini��o do Browse de acesso a tabekla ZS0 - Requisitos do Cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
/*/
User Function TRM009()
	
	Local oFwMBrowse := FwMBrowse():New() // Atribui a vari�vel a inst�ncia do Browse
	
	oFwMBrowse:SetAlias( 'ZS0' ) // Tabela ZS0 - Requisitos do Cargo
	oFwMBrowse:SetDescription( 'Requisitos do Cargo' ) // Define Descri��o Browse
	
	oFwMBrowse:Activate() // Ativa e Exibe o Browse
	
Return

/*/{Protheus.doc} MENUDEF
Define o Menu de Rotina do Browser
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return array, Array com os itens do menu do Browse (aRotina)
/*/
Static Function MenuDef()
	
	Local aRotina := FWMVCMenu( 'TRM009' ) // Define o menu da rotina
	
Return aRotina

/*/{Protheus.doc} ModelDef
Defini��o do modelo de Dados
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return object, Objeto que representa o Model
/*/
Static Function ModelDef()
	
	// Definindo Vari�veis e iniciando as que s�o referente
	// as estruturas de tabelas utilizadas pelo Model
	Local oModel  := Nil
	Local oStrZS0 := FWFormStruct( 1, 'ZS0' )
	Local oStrZS1 := FWFormStruct( 1, 'ZS1' )
	Local oStrZS2 := FWFormStruct( 1, 'ZS2' )
	Local oStrZS3 := FWFormStruct( 1, 'ZS3' )
	Local oStrZS4 := FWFormStruct( 1, 'ZS4' )
	Local aAux    := {}
	
	// Criando a Inst�ncia do Objeto que represento o Model
	oModel := MPFormModel():New('MTRM009')
	
	// Definindo a Descri��o do Model
	oModel:SetDescription('Requisitos do Cargo')
	
	// Definindo os Sub-Models Field e Grid do Model
	oModel:addFields( 'FIELD_ZS0',            , oStrZS0                                                          )
	oModel:addGrid  ( 'GRID_ZS1' , 'FIELD_ZS0', oStrZS1,, { | oSubModel, nLinha | LinhaOK( oSubModel, nLinha ) } )
	oModel:addGrid  ( 'GRID_ZS2' , 'FIELD_ZS0', oStrZS2,, { | oSubModel, nLinha | LinhaOK( oSubModel, nLinha ) } )
	oModel:addGrid  ( 'GRID_ZS3' , 'FIELD_ZS0', oStrZS3,, { | oSubModel, nLinha | LinhaOK( oSubModel, nLinha ) } )
	oModel:addGrid  ( 'GRID_ZS4' , 'FIELD_ZS0', oStrZS4,, { | oSubModel, nLinha | LinhaOK( oSubModel, nLinha ) } )
	
	// Definindo a Rela��o dos Sub-Models Grid com o model Field 'FIELD_ZS0'
	oModel:SetRelation('GRID_ZS1', { { 'ZS1_FILIAL', 'ZS0_FILIAL' }, { 'ZS1_CARGO', 'ZS0_CARGO' } }, ZS1->( IndexKey( 1 ) ) )
	oModel:SetRelation('GRID_ZS2', { { 'ZS2_FILIAL', 'ZS0_FILIAL' }, { 'ZS2_CARGO', 'ZS0_CARGO' } }, ZS2->( IndexKey( 1 ) ) )
	oModel:SetRelation('GRID_ZS3', { { 'ZS3_FILIAL', 'ZS0_FILIAL' }, { 'ZS3_CARGO', 'ZS0_CARGO' } }, ZS3->( IndexKey( 1 ) ) )
	oModel:SetRelation('GRID_ZS4', { { 'ZS4_FILIAL', 'ZS0_FILIAL' }, { 'ZS4_CARGO', 'ZS0_CARGO' } }, ZS4->( IndexKey( 1 ) ) )
	
	// Definindo a Descri��o de cada sub_model Grid e Field
	oModel:getModel('FIELD_ZS0'):SetDescription( 'Cargo'                 )
	oModel:getModel('GRID_ZS1') :SetDescription( 'Forma��o do Cargo'     )
	oModel:getModel('GRID_ZS2') :SetDescription( 'Capacita��o do Cargo'  )
	oModel:getModel('GRID_ZS3') :SetDescription( 'Certifica��o do Cargo' )
	oModel:getModel('GRID_ZS4') :SetDescription( 'Conhecimento do Cargo' )
	
	// Defindo todos os Sub-Models Grid como Opcionais
	oModel:getModel( 'GRID_ZS1' ):SetOptional( .T. )
	oModel:getModel( 'GRID_ZS2' ):SetOptional( .T. )
	oModel:getModel( 'GRID_ZS3' ):SetOptional( .T. )
	oModel:getModel( 'GRID_ZS4' ):SetOptional( .T. )
	
	// Define para as View�s do tipo Grid os campos que n�o podem se repetir
	oModel:GetModel( 'GRID_ZS1' ):SetUniqueLine( { 'ZS1_CURSO'  } )
	oModel:GetModel( 'GRID_ZS2' ):SetUniqueLine( { 'ZS2_CURSO'  } )
	oModel:GetModel( 'GRID_ZS3' ):SetUniqueLine( { 'ZS3_CURSO'  } )
	oModel:GetModel( 'GRID_ZS4' ):SetUniqueLine( { 'ZS4_CONHEC' } )
	
	// Definindo que as View�s do tipo Grid ir�o trabalahar com aCols e aHeader
	oModel:getModel('GRID_ZS1'):SetUseOldGrid(.T.)
	oModel:getModel('GRID_ZS2'):SetUseOldGrid(.T.)
	oModel:getModel('GRID_ZS3'):SetUseOldGrid(.T.)
	oModel:getModel('GRID_ZS4'):SetUseOldGrid(.T.)
	
Return oModel

/*/{Protheus.doc} ViewDef
Defini��o do interface
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return object, Objeto que representa o View
/*/
Static Function ViewDef()
	
	// Definindo Vari�veis e iniciando as que s�o referente
	// as estruturas de tabelas utilizadas pela View
	Local oView   := Nil
	Local oModel  := ModelDef()
	Local oStrZS0 := FWFormStruct( 2, 'ZS0' )
	Local oStrZS1 := FWFormStruct( 2, 'ZS1' )
	Local oStrZS2 := FWFormStruct( 2, 'ZS2' )
	Local oStrZS3 := FWFormStruct( 2, 'ZS3' )
	Local oStrZS4 := FWFormStruct( 2, 'ZS4' )
	
	// Criando a Inst�ncia do Objeto que represento o View
	oView := FWFormView():New()
	
	// Definindo o Model utilizado pela View
	oView:SetModel(oModel)
	
	// Definindo os Sub-Models Field e Grid do View
	// Para tornar mais simples a leitura do Fonte
	// as Sub-View's foi definido o nome da View com
	// o mesmo nome do model que ela representa
	oView:AddField( 'FIELD_ZS0', oStrZS0, 'FIELD_ZS0' )// Cargo
	oView:AddGrid ( 'GRID_ZS1' , oStrZS1, 'GRID_ZS1'  )// Forma��o do Cargo
	oView:AddGrid ( 'GRID_ZS2' , oStrZS2, 'GRID_ZS2'  )// Capacita��o do Cargo
	oView:AddGrid ( 'GRID_ZS3' , oStrZS3, 'GRID_ZS3'  )// Certifica��o do Cargo
	oView:AddGrid ( 'GRID_ZS4' , oStrZS4, 'GRID_ZS4'  )// Conhecimento do Cargo
	
	// Dividindo a View Horizontalmente em uma Box superior com 15%
	// do espa�o total e uma Box inferior com com 85% do espa�o total
	oView:CreateHorizontalBox( 'BOX_HOR_SUPERIOR', 15 )
	oView:CreateHorizontalBox( 'BOX_HOR_INFERIOR', 85 )
	
	// Posicionando o Sub-Model na 'FORM_CARGO' Box Superior 'BOX_HOR_SUPERIOR'
	oView:SetOwnerView( 'FIELD_ZS0', 'BOX_HOR_SUPERIOR' )
	
	// Criando uma Folder na Box Inferior 'BOX_HOR_INFERIOR'
	oView:CreateFolder( 'FOLDER', 'BOX_HOR_INFERIOR')
	
	// Definindo as Sheet�s da Folder de nome 'FOLDER'
	oView:AddSheet( 'FOLDER', 'SHEET_FORMACAO'    , 'Forma��o'     )
	oView:AddSheet( 'FOLDER', 'SHEET_CAPACITACAO' , 'Capacita��o'  )
	oView:AddSheet( 'FOLDER', 'SHEET_CERTIFICACAO', 'Certifica��o' )
	oView:AddSheet( 'FOLDER', 'SHEET_CONHECIMENTO', 'Conhecimento' )
	
	// Criando Box�s Horizontais em cada Sheet da Folder de nome 'FOLDER'
	oView:CreateHorizontalBox( 'BOX_HOR_FORMACAO'    , 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_FORMACAO'     )
	oView:CreateHorizontalBox( 'BOX_HOR_CAPACITACAO' , 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_CAPACITACAO'  )
	oView:CreateHorizontalBox( 'BOX_HOR_CERTIFICACAO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_CERTIFICACAO' )
	oView:CreateHorizontalBox( 'BOX_HOR_CONHECIMENTO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_CONHECIMENTO' )
	
	// Posicionando as View�s do tipo Grid em cada Box do seu Folder Correspondente
	oView:SetOwnerView( 'GRID_ZS1', 'BOX_HOR_FORMACAO'     )
	oView:SetOwnerView( 'GRID_ZS2', 'BOX_HOR_CAPACITACAO'  )
	oView:SetOwnerView( 'GRID_ZS3', 'BOX_HOR_CERTIFICACAO' )
	oView:SetOwnerView( 'GRID_ZS4', 'BOX_HOR_CONHECIMENTO' )
	
Return oView

/*/{Protheus.doc} LinhaOk
Executa a valida��o da Linha dos Grid�s GRID_ZS1, GRID_ZS2, GRID_ZS3 e GRID_ZS4
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return logic, Retorna verdadeiro e falso para valida��o linha do grid
/*/
Static Function LinhaOK( oSubModel, nLinha )
	
	Local cAlias    := StrTokArr2( oSubModel:GetId(), '_', .T. )[2] // Pelo nome Id do Sub-Model verifica o nome da Tabela
	Local cAltern   := oSubModel:GetValue( cAlias + '_ALTERN', nLinha ) // Verifica o nome do campo de Grupo de Alternativas da Tabela
	Local cExigen   := oSubModel:GetValue( cAlias + '_EXIGEN', nLinha ) // Verifica o nome do campo de Exig�ncia da Tabela
	
	// Verifica se foi defindo para a Forma��o, Capacita��o, Certifica��o ou Conhecimento
	// um Grupo de Alternativas e o mesmo n�o foi definido com obrigat�rio e se positivo
	// invalida a linha e exibe alerta para o usu�rio
	If !Empty( cAltern ) .And. cExigen # '1'
		
		Help(,, 'Aten��o !!!',,;
			'Quando Item definido como "Desej�vel" n�o pode haver um Grupo de Alternativas Definido para este Item.', 1, 0,,,,,,;
			{ 'Definir Item como "Obrigat�rio" ou Exclu�-lo do Grupo de Alternativas' } )
		
		Return .F.
		
	End If
	
Return .T.

/*/{Protheus.doc} LeftZero
Fun��o utilizada no gatilho 001 dos campos ZS1_ALTERN, ZS2_ALTERN, ZS3_ALTERN e ZS4_ALTERN
para adicionar zeros � esquerda do valor do campo quando este n�o estiver em branco
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Param character, cCpo, Nome do campo do Gatilho
@Return character, Valor do campo com tratamento de zeros a esquerda
/*/
User Function LeftZero( cCpo )
	
	Local cRet := ''
	
	If ! Empty( FwFldGet( cCpo ) )
		
		cRet := PadL( AllTrim( FwFldGet( cCpo ) ), 5, '0' )
		
	End If
	
Return cRet

/*/{Protheus.doc} SZ5ZS
Fun��o utilizada na consulta padr�o SZ5ZS utilizada pelos campos ZS1_CATEG, ZS2_CATEG e ZS3_CATEG
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return logic, Indica que o Browse espec�fico da consulta padr�o pode ser montado com sucesso
/*/
User Function SZ5ZS()
	
	Local cReadvar := ReadVar()
	Local nRetorno := 0
	Local aPesq    := {"Z5_CODIGO","Z5_DESCRI"}
	Local lRet     := .T.
	Local cEstou   := ''
	
	If 'ZS1' $ cReadVar
		
		cEstou := '01'
		
	ElseIF 'ZS2' $ cReadVar
		
		cEstou := '02'
		
	ElseIF 'ZS3' $ cReadVar
		
		cEstou := '03'
		
	End If
	
	cQuery := " SELECT DISTINCT SZ5.Z5_FILIAL, SZ5.Z5_CODIGO, SZ5.Z5_DESCRI, SZ5.R_E_C_N_O_ SZ5RECNO "
	cQuery += " FROM "+RetSQLName("SZ5") + " SZ5 "
	cQuery += " LEFT JOIN "+RetSQLName("RA1") + " RA1 "
	cQuery += " ON "
	cQuery += " SZ5.Z5_FILIAL = RA1.RA1_FILIAL AND "
	cQuery += " SZ5.Z5_CODIGO = RA1.RA1_CATEG "
	cQuery += " WHERE "
	
	If cEstou == "01" //Forma��o Academica
		cQuery += " RA1.RA1_TIPOPP = '001' AND "
	ElseIf cEstou == "02" //Capacita��o
		cQuery += " RA1.RA1_TIPOPP <> '001' AND RA1.RA1_TIPOPP <> '002' AND "
	ElseIf cEstou == "03" //Certifica��o
		cQuery += " RA1.RA1_TIPOPP = '002' AND "
	EndIf
	
	cQuery += " SZ5.D_E_L_E_T_ = '' AND  RA1.D_E_L_E_T_ = '' AND SZ5.Z5_FILIAL = '"+xFilial("SZ5")+"'"
	
	
	If U_JurF3Qry( cQuery, 'SZ5ZS', 'SZ5RECNO', @nRetorno, , aPesq ) // User Function localizada no fonte TRM002.prw
		
		SZ5->( dbGoto( nRetorno ) )
		lRet := .T.
		
	Else
		
		lRet := .F.
		
	EndIf
	
Return lRet

/*/{Protheus.doc} ValidRA1
Valida��o de curso informado nos campos ZS1_CURS0, ZS2_CURS0 e ZS3_CURS0
Verifica a exit�ncia do c�digo do curso
Verifica se o Curso pertence a categoria selecionada definida no campo ZS1_CATEG, ZS2_CATEG e ZS3_CATEG respectivamente
Verifica se um curso de diferente de Forma��o est� sendo utilizado em na aba Forma��o
Verifica se um curso de diferente de Capacita��o est� sendo utilizado em na aba Capacita��o
Verifica se um curso de diferente de Certifica��o est� sendo utilizado em na aba Certifica��o
Verifica se h� pontu��o definida para o Curso de Forma��o
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return logic, Retorna se verdadeiro ou falso para se o curso � v�lido ou n�o
/*/
User Function ValidRA1()
	
	Local cTabName  := StrTokArr2( StrTokArr2( ReadVar(), '_', .T. )[ 1 ], '>', .T. )[ 2 ]
	Local cCategCpo := cTabName + '_CATEG'
	Local cCursoCpo := cTabName + '_CURSO'
	Local cTipoPp   := Posicione( 'RA1', 1, xFilial("RA1") + FwFldGet( cCursoCpo ), 'RA1_TIPOPP')
	Local lTipoPp   := cTipoPp == '001'
	Local lPonPd    := Posicione( 'RA1', 1, xFilial("RA1") + FwFldGet( cCursoCpo ), 'RA1_PONAPD') == 0
	Local cCateg    := Posicione( 'RA1', 1, xFilial("RA1") + FwFldGet( cCursoCpo ), 'RA1_CATEG')
	Local aArea     := GetArea()
	
	//Verifica a exit�ncia do c�digo do curso
	If ! ExistCpo( 'RA1', FwFldGet( cCursoCpo ) )
		
		Return .F.
		
	End If
	
	//Verifica se o Curso pertence a categoria selecionada
	If FwFldGet( cCategCpo ) != cCateg
		
		Help(,, 'Aten��o !!!',,;
			'Curso n�o pertence a categoria selecionada.', 1, 0,,,,,,;
			{ 'Selecione um curso para a categoria selecionada.' } )
		
		
		Return .F.
		
	End If
	
	// Verifica se um curso de diferente de Forma��o est� sendo utilizado em na aba Forma��o
	If cTabName = 'ZS1' .And. !( cTipoPp == '001' )
		
		Help(,, 'Aten��o !!!',,;
			'Curso n�o � uma Forma��o.', 1, 0,,,,,,;
			{ 'Selecione um Curso que � uma Forma��o.' } )
		
		Return .F.
		
	End If
	
	//Verifica se um curso de diferente de Capacita��o est� sendo utilizado em na aba Capacita��o
	If cTabName == 'ZS2' .And. !( cTipoPp # '001' .And. cTipoPp # '002' )
		
		Help(,, 'Aten��o !!!',,;
			'Curso n�o � uma Capacita��o.', 1, 0,,,,,,;
			{ 'Selecione um Curso que � uma Capacita��o.' } )
		
		Return .F.
		
	End If
	
	//Verifica se um curso de diferente de Certifica��o est� sendo utilizado em na aba Certifica��o
	If cTabName == 'ZS3' .And. !( cTipoPp == '002' )
		
		Help(,, 'Aten��o !!!',,;
			'Curso n�o � uma Certifica��o.', 1, 0,,,,,,;
			{ 'Selecione um Curso que � uma Certifica��o.' } )
		
		Return .F.
		
	End If
	
	
	// Verifica se h� pontu��o definida para o Curso de Forma��o
	If lTipoPp .And. lPonPd
		
		Help(,, 'Aten��o !!!',,;
			'Curso sem pontuacao.', 1, 0,,,,,,;
			{ 'Definir uma pontua��o para o curso.' } )
		
		Return .F.
		
	End If
	
	
	RestArea( aArea )
	
Return .T.

/*/{Protheus.doc} SZ7ZS4
Fun��o utilizada na consulta padr�o SZ7ZS4 utilizada pelo campo ZS4_CATEG
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return logic, Indica que o Browse espec�fico da consulta padr�o pode ser montado com sucesso
/*/
User Function SZ7ZS4()
	
	Local nRetorno := 0
	Local aPesq    := {"Z7_CODIGO","Z7_DESCRI"}
	Local lRet     := .T.
	
	cQuery := " SELECT SZ7.Z7_FILIAL, SZ7.Z7_CODIGO, SZ7.Z7_DESCRI, SZ7.R_E_C_N_O_ SZ7RECNO "
	cQuery += " FROM " + RetSqlName("SZ7") + " SZ7 "
	cQuery += " WHERE "
	cQuery += " SZ7.Z7_FILIAL 	= '"+xFilial("SZ7")+"' AND "
	cQuery += " SZ7.Z7_AREA 	= '"+FwFldGet('ZS4_AREA')+"' AND "
	cQuery += " SZ7.D_E_L_E_T_ 	= ''"
	
	If U_JurF3Qry( cQuery, 'SZ7ZS4', 'SZ7RECNO', @nRetorno, , aPesq ) // User Function localizada no fonte TRM002.prw
		
		SZ7->( dbGoto( nRetorno ) )
		lRet := .T.
		
	Else
		
		lRet := .F.
		
	EndIf
	
Return lRet

/*/{Protheus.doc} SZ8ZS4
Fun��o utilizada na consulta padr�o SZ8ZS4 utilizada pelo campo ZS4_CONHEC
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return logic, Indica que o Browse espec�fico da consulta padr�o pode ser montado com sucesso
/*/
User Function SZ8ZS4()
	
	Local nRetorno := 0
	Local aPesq	   := {"Z8_CODIGO","Z8_DESCRI"}
	Local lRet	   := .T.
	
	cQuery := " SELECT SZ8.Z8_FILIAL, SZ8.Z8_CODIGO, SZ8.Z8_DESCRI, SZ8.R_E_C_N_O_ SZ8RECNO "
	cQuery += " FROM " + RetSqlName("SZ8") + " SZ8 "
	cQuery += " WHERE "
	cQuery += " SZ8.Z8_FILIAL 	= '" + xFilial("SZ8")	+ "' AND "
	cQuery += " SZ8.Z8_AREA 	= '" + FwFldGet('ZS4_AREA') + "' AND "
	cQuery += " SZ8.Z8_CATEG 	= '" + FwFldGet('ZS4_CATEG') + "' AND "
	cQuery += " SZ8.D_E_L_E_T_ 	= ''"
	
	If U_JurF3Qry( cQuery, 'SZ8ZS4', 'SZ8RECNO', @nRetorno, , aPesq )// User Function localizada no fonte TRM002.prw
		
		SZ8->( dbGoto( nRetorno ) )
		lRet := .T.
		
	Else
		
		lRet := .F.
		
	EndIf
	
Return lRet