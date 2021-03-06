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

	aAdd( aRotina,  { 'Criticar Cargos x Funcion�rios', 'U_TRMX09', 0, 2, 0, NIL }  )

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
	oModel:getModel('GRID_ZS1'):SetUseOldGrid( .T. )
	oModel:getModel('GRID_ZS2'):SetUseOldGrid( .T. )
	oModel:getModel('GRID_ZS3'):SetUseOldGrid( .T. )
	oModel:getModel('GRID_ZS4'):SetUseOldGrid( .T. )

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

/*/{Protheus.doc} RA1ZS
Fun��o utilizada na consulta padr�o RA1ZS utilizada pelos campos ZS1_CURSO, ZS2_CURSO e ZS3_CURSO
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
@Return logic, Indica que o Browse espec�fico da consulta padr�o pode ser montado com sucesso
/*/
User Function RA1ZS()

	Local cTabName  := StrTokArr2( StrTokArr2( ReadVar(), '_', .T. )[ 1 ], '>', .T. )[ 2 ]
	Local cCategCpo := cTabName + '_CATEG'
	Local cReadvar := ReadVar()
	Local nRetorno := 0
	Local aPesq    := {"RA1_CURSO","RA1_DESC"}
	Local lRet     := .T.
	Local cEstou   := ''

	If 'ZS1' $ cReadVar

		cEstou := '01'

	ElseIF 'ZS2' $ cReadVar

		cEstou := '02'

	ElseIF 'ZS3' $ cReadVar

		cEstou := '03'

	End If

	cQuery := " SELECT RA1.RA1_CURSO, RA1.RA1_DESC, RA1.R_E_C_N_O_ RA1RECNO "
	cQuery += " FROM " + RetSQLName("RA1") + " RA1 "
	cQuery += " WHERE RA1.D_E_L_E_T_ = '' AND RA1.RA1_FILIAL = '" + xFilial("SZ5") + "' AND "

	If cEstou == "01" //Forma��o Academica
		cQuery += " RA1.RA1_TIPOPP = '001' AND "
	ElseIf cEstou == "02" //Capacita��o
		cQuery += " RA1.RA1_TIPOPP <> '001' AND RA1.RA1_TIPOPP <> '002' AND "
	ElseIf cEstou == "03" //Certifica��o
		cQuery += " RA1.RA1_TIPOPP = '002' AND "
	EndIf

	cQuery += " RA1.RA1_CATEG = '" + FwFldGet( cCategCpo ) + "'"

	If U_JurF3Qry( cQuery, 'RA1ZS', 'RA1RECNO', @nRetorno, , aPesq ) // User Function localizada no fonte TRM002.prw

		RA1->( dbGoto( nRetorno ) )
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

/*/{Protheus.doc} TRMX09
Rotina que emite o relat�rio de cr�tica das compet�ncias do cargo x funcion�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
/*/
User Function TRMX09()

	Local aParam    := {}
	Local aRet      := {}
	Local nTamMat   := GetSx3Cache( 'RA_MAT'  , 'X3_TAMANHO' )
	Local nTamCargo := GetSx3Cache( 'RA_CARGO', 'X3_TAMANHO' )
	Local cPicMat   := GetSx3Cache( 'RA_MAT'  , 'X3_PICTURE' )
	Local cPicCargo := GetSx3Cache( 'RA_CARGO', 'X3_PICTURE' )
	Local cMatDe    := Space( nTamMat )
	Local cCargoDe  := Space( nTamCargo )
	Local cMatAte   := Replicate( 'Z', nTamMat )
	Local cCargoAte := Replicate( 'Z', nTamCargo )
	Local bBlockAux := Nil

	aAdd( aParam, { 1, 'Matricula De'  , cMatDe   , cPicMat  , '.T.', 'SRA02', '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'Matricula At�' , cMatAte  , cPicMat  , '.T.', 'SRA02', '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'Cargo De'      , cCargoDe , cPicCargo, '.T.', 'SQ3'  , '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'Cargo At�'     , cCargoAte, cPicCargo, '.T.', 'SQ3'  , '.T.', 90, .F. } )

	If ! ParamBox( aParam, '', @aRet,,,,,,, 'TRMX09', .T., .T. )

		aRet := { cMatDe, cMatAte, cCargoDe, cCargoAte }

	End If

	// Imprime a critica de competencias dos cargo x competencias do funcion�rio
	bBlockAux  := { || Critica( aRet[ 1 ], aRet[ 2 ], aRet[ 3 ], aRet[ 4 ] ) }

	MsAguarde( bBlockAux, 'Criticando Funcion�rios ...', 'Aguarde...',.F. )


Return

/*/{Protheus.doc} Critica
Critica lista de funcion�rios conforme range de matriculas e cargos
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param character, cMatDe, Limite m�nimo do range de pesquisa de funcion�rios
@param character, cMatAte, Limite m�ximo do range de pesquisa de funcion�rios
@param character, cCargoDe, Limite m�nimo do range de pesquisa de cargos
@param character, cCargoAte, Limite m�ximo do range de pesquisa de cargos
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function Critica( cMatDe, cMatAte, cCargoDe, cCargoAte )

	Local cAlias        := GetNextAlias()
	Local aArea         := GetArea()
	Local oFuncionario  := Nil
	Local aFuncionarios := {}

	BeginSql alias cAlias

		SELECT DISTINCT

		SRA.RA_MAT,
		SRA.RA_NOME,
		SRA.RA_CARGO,
		SQ3.Q3_DESCSUM,
		SQ3.Q3_XESPECI

		FROM %table:SRA% SRA

		LEFT JOIN %table:SQ3% SQ3
		ON SRA.RA_CARGO = SQ3.Q3_CARGO

		WHERE SRA.RA_FILIAL = %xfilial:SRA%
		AND   SRA.%notDel%
		AND   SQ3.%notDel%
		//AND   SRA.RA_SITFOLH <> 'D'
		AND   SRA.RA_MAT   BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
		AND   SRA.RA_CARGO BETWEEN %exp:cCargoDe% AND %exp:cCargoAte%

		ORDER BY RA_MAT, RA_CARGO

	EndSql

	Do While (cAlias)->( ! Eof() )

		MsProcTxt( (cAlias)->( RA_MAT + ': ' + RA_NOME ) )
		ProcessMessage()

		aAdd( aFuncionarios, oFuncionario := Funcionario():New() )

		oFuncionario:cMat     := (cAlias)->RA_MAT
		oFuncionario:cNome    := (cAlias)->RA_NOME
		oFuncionario:cCargo   := (cAlias)->RA_CARGO
		oFuncionario:cDescSum := (cAlias)->Q3_DESCSUM
		oFuncionario:cXexpeci := (cAlias)->Q3_XESPECI

		(cAlias)->( DbSkip() )

	End Do

	(cAlias)->( DbCloseArea() )

	RestArea( aArea )

	// Popula os objetos que representam os funcion�rios com as forma��es, capacita��es, certifica��es e conhecimentos do cargo que ele exerce
	CarregaComp( @aFuncionarios, cCargoDe, cCargoAte  )

	// Verifica se o funcion�rio tem as competencias referentes ao cargo
	ChecaComp( @aFuncionarios )

	// Valida se o funcion�rio est� apto ou inapto ao cargo eu exerce
	ValidaAptdao( @aFuncionarios )

	// Gera relat�rio de cr�tica de competencias cargo X funcion�rio
	Imprimir( aFuncionarios )

Return

/*/{Protheus.doc} CarregaComp
Popula os objetos que representam os funcion�rios com as forma��es, capacita��es, certifica��es e conhecimentos do cargo que ele exerce
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param array, aFuncionarios, Array recebido por refer�ncia que ser� populado com os dados das competencias do cargo dos funcion�rios a serem criticados
@param character, cCargoDe, Limite m�nimo do range de pesquisa de cargos
@param character, cCargoAte, Limite m�ximo do range de pesquisa de cargos
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function CarregaComp( aFuncionarios, cCargoDe, cCargoAte  )

	Local cAlias       := GetNextAlias()
	Local aArea        := GetArea()
	Local oFuncionario := Nil
	Local nX           := 0

	// Faz busca no banco das fomra��es, capacita��es, certifica��es e conhecimentos dos cargos do range cCargoDe x cCargoAte
	BeginSql alias cAlias

		// Foma��o
		SELECT

		ZS1.ZS1_CARGO CARGO,
		ZS1.ZS1_ALTERN ALTERN,
		ZS1.ZS1_CURSO CURSO,
		RA1.RA1_DESC DESCR,
		ZS1.ZS1_EXIGEN EXIGEN,
		'ZS1' ORIGEM

		FROM %table:ZS1% ZS1

		LEFT JOIN %table:RA1% RA1
		ON ZS1.ZS1_CURSO = RA1.RA1_CURSO

		WHERE ZS1.ZS1_CARGO BETWEEN %exp:cCargoDe% AND %exp:cCargoAte%
		AND ZS1.%notDel%
		AND RA1.%notDel%

		UNION ALL

		// Capacita��o
		SELECT

		ZS2.ZS2_CARGO,
		ZS2.ZS2_ALTERN,
		ZS2.ZS2_CURSO,
		RA1.RA1_DESC,
		ZS2.ZS2_EXIGEN,
		'ZS2'

		FROM %table:ZS2% ZS2

		LEFT JOIN %table:RA1% RA1
		ON ZS2.ZS2_CURSO = RA1.RA1_CURSO

		WHERE ZS2.ZS2_CARGO BETWEEN %exp:cCargoDe% AND %exp:cCargoAte%
		AND ZS2.%notDel%
		AND RA1.%notDel%

		UNION ALL

		// Certifica��o
		SELECT

		ZS3.ZS3_CARGO,
		ZS3.ZS3_ALTERN,
		ZS3.ZS3_CURSO,
		RA1.RA1_DESC,
		ZS3.ZS3_EXIGEN,
		'ZS3'

		FROM %table:ZS3% ZS3

		LEFT JOIN %table:RA1% RA1
		ON ZS3.ZS3_CURSO = RA1.RA1_CURSO

		WHERE ZS3.ZS3_CARGO BETWEEN %exp:cCargoDe% AND %exp:cCargoAte%
		AND ZS3.%notDel%
		AND RA1.%notDel%

		UNION ALL

		// Conhecimento
		SELECT

		ZS4.ZS4_CARGO,
		ZS4.ZS4_ALTERN,
		ZS4.ZS4_CONHEC,
		SZ8.Z8_DESCRI,
		ZS4.ZS4_EXIGEN,
		'ZS4'

		FROM %table:ZS4% ZS4

		LEFT JOIN %table:SZ8% SZ8
		ON ZS4.ZS4_CONHEC = SZ8.Z8_CODIGO

		WHERE ZS4.ZS4_CARGO BETWEEN %exp:cCargoDe% AND %exp:cCargoAte%
		AND ZS4.%notDel%
		AND SZ8.%notDel%

		ORDER BY 6, 2, 1, 3

	EndSql

	// Percorre lista de funcion�rios e popula com dados das compet�ncias do cargo
	For nX := 1 To Len( aFuncionarios )

		oFuncionario := aFuncionarios[ nX ]

		SetaComp( oFuncionario, cAlias )

	Next nX

	(cAlias)->( DbCloseArea() )

	RestArea( aArea )

Return

/*/{Protheus.doc} SetaComp
Popula os objetos que representam os funcion�rios com as forma��es, capacita��es, certifica��es e conhecimentos do cargo que ele exerce
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@param array, cAlias, Nome da tabela tempor�ria com a consulta dos dados de compent�ncias dos cargos pesquisados
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function SetaComp( oFuncionario, cAlias )

	Local oCompetencia := Nil

	// Posiciona no in�cio da tabela
	(cAlias)->( DbGoTop() )

	// Percorre tabela e atribui ao cargo do funcion�rio
	// as compet�ncias do correspondentes
	Do While (cAlias)->( ! Eof() )

		// Se for o mesmo cargo do funcion�rio atibui a compet�ncia
		If AllTrim( oFuncionario:cCargo ) == AllTrim( (cAlias)->CARGO )

			oCompetencia := Competencia():New()

			oCompetencia:cGrupo       := (cAlias)->ALTERN
			oCompetencia:cCodigo      := (cAlias)->CURSO
			oCompetencia:cDescricao   := (cAlias)->DESCR
			oCompetencia:cObrigatorio := If( (cAlias)->EXIGEN = '1', 'SIM', 'N�O' )

			// Atribuindo Forma��o
			If (cAlias)->ORIGEM == 'ZS1'

				aAdd( oFuncionario:aFormacao, oCompetencia )

				// Atribuindo Capacita��o
			ElseIf (cAlias)->ORIGEM == 'ZS2'

				aAdd( oFuncionario:aCapacitacao, oCompetencia )

				// Atribuindo Certifica��o
			ElseIf (cAlias)->ORIGEM == 'ZS3'

				aAdd( oFuncionario:aCertificacao, oCompetencia )

				// Atribuindo Conhecimento
			ElseIf (cAlias)->ORIGEM == 'ZS4'

				aAdd( oFuncionario:aConhecimento, oCompetencia )

			End IF

		End If

		(cAlias)->( DbSkip() )

	End Do

Return

/*/{Protheus.doc} ChecaComp
Verifica se o funcion�rio tem as competencias referentes ao cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param array, aFuncionarios, Array recebido por refer�ncia que ser� criticado quanto a exit�ncia da Forma��o, Capacita��o, Certifica��o e Conhecimento do cargo para o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ChecaComp( aFuncionarios )

	Local aArea    := GetArea()
	Local aAreaRA4 := RA4->( GetArea() )
	Local aAreaSZ9 := SZ9->( GetArea() )
	Local nX       := 1

	DbSelectArea( 'RA4' )
	RA4->( DbSetOrder( 1 ) ) // RA4_FILIAL + RA4_MAT + RA4_CURSO

	DbSelectArea( 'SZ9' )
	SZ9->( DbSetOrder( 3 ) ) // Z9_FILIAL + Z9_MAT + Z9_CONHEC

	For nX := 1 To Len( aFuncionarios )

		ChecaForm( aFuncionarios[ nX ] )

		ChecaCapac( aFuncionarios[ nX ] )

		ChecaCert( aFuncionarios[ nX ] )

		ChecaConh( aFuncionarios[ nX ] )

	Next nX

	RestArea( aAreaRA4 )
	RestArea( aAreaSZ9 )
	RestArea( aArea    )

Return

/*/{Protheus.doc} ChecaForm
Checa se a o funcion�rio tem as Forma��es do seu cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ChecaForm( oFuncionario )

	Local nX       := 0
	Local cFil     := xFilial( 'RA4' )
	Local cMat     := ''
	Local cCodForm := ''
	Local cSeek    := ''

	For nX := 1 To Len( oFuncionario:aFormacao )

		cMat     := oFuncionario:cMat
		cCodForm := oFuncionario:aFormacao[ nX ]:cCodigo

		cSeek := cFil + cMat + cCodForm

		If RA4->( DbSeek( cSeek ) )

			oFuncionario:aFormacao[ nX ]:cPossui := 'SIM'

		Else

			oFuncionario:aFormacao[ nX ]:cPossui := 'N�O'

		End If

	Next nX

Return

/*/{Protheus.doc} ChecaCapac
Checa se a o funcion�rio tem as Capacita��es do seu cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ChecaCapac( oFuncionario )

	Local nX       := 0
	Local cFil     := xFilial( 'RA4' )
	Local cMat     := ''
	Local cCodForm := ''
	Local cSeek    := ''

	For nX := 1 To Len( oFuncionario:aCapacitacao )

		cMat     := oFuncionario:cMat
		cCodForm := oFuncionario:aCapacitacao[ nX ]:cCodigo

		cSeek := cFil + cMat + cCodForm

		If RA4->( DbSeek( cSeek ) )

			oFuncionario:aCapacitacao[ nX ]:cPossui := 'SIM'

		Else

			oFuncionario:aCapacitacao[ nX ]:cPossui := 'N�O'

		End If

	Next nX

Return

/*/{Protheus.doc} ChecaCert
Checa se a o funcion�rio tem as Certifica��es do seu cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ChecaCert( oFuncionario )

	Local nX       := 0
	Local cFil     := xFilial( 'RA4' )
	Local cMat     := ''
	Local cCodForm := ''
	Local cSeek    := ''

	For nX := 1 To Len( oFuncionario:aCertificacao )

		cMat     := oFuncionario:cMat
		cCodForm := oFuncionario:aCertificacao[ nX ]:cCodigo

		cSeek := cFil + cMat + cCodForm

		If RA4->( DbSeek( cSeek ) )

			oFuncionario:aCertificacao[ nX ]:cPossui := 'SIM'

		Else

			oFuncionario:aCertificacao[ nX ]:cPossui := 'N�O'

		End If

	Next nX

Return

/*/{Protheus.doc} ChecaConh
Checa se a o funcion�rio tem as Conhecimentos do seu cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ChecaConh( oFuncionario )

	Local nX       := 0
	Local cFil     := xFilial( 'SZ9' )
	Local cMat     := ''
	Local cCodForm := ''
	Local cSeek    := ''

	For nX := 1 To Len( oFuncionario:aConhecimento )

		cMat     := oFuncionario:cMat
		cCodForm := oFuncionario:aConhecimento[ nX ]:cCodigo

		cSeek := cFil + cMat + cCodForm

		If SZ9->( DbSeek( cSeek ) )

			oFuncionario:aConhecimento[ nX ]:cPossui := 'SIM'

		Else

			oFuncionario:aConhecimento[ nX ]:cPossui := 'N�O'

		End If

	Next nX

Return

/*/{Protheus.doc} ValidaAptdao
Valida se o funcion�rio est� apto ou inapto ao cargo que exerce
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param array, aFuncionarios, Array passado por refer�ncia com a lista de funcion�rios
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ValidaAptdao( aFuncionarios )

	Local nX := 0

	For nX := 1 To Len( aFuncionarios )

		aFuncionarios[ nX ]:cSituacao := 'APTO'

		If !( ValidaForm( aFuncionarios[nX] ) .And.;
		ValidaCapac( aFuncionarios[nX] ) .And.;
		ValidaCert( aFuncionarios[nX] ) .And.;
		ValidaConh( aFuncionarios[nX] ) )

			aFuncionarios[ nX ]:cSituacao := 'INAPTO'

		End If

	Next nX

Return

/*/{Protheus.doc} ValidaForm
Valida se o funcion�rio tem a forma��o necess�ria para o cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ValidaForm( oFuncionario )

	Local aGrupos := {}
	Local nX      := 0
	Local lRet    := .T.
	Local cGrupo  := ''

	// Verifica os grupos de alternativas existentes
	For nX := 1 To Len( oFuncionario:aFormacao )

		cGrupo := oFuncionario:aFormacao[ nX ]:cGrupo

		If ! Empty(cGrupo) .And. aScan( aGrupos, cGrupo ) == 0

			aAdd( aGrupos, cGrupo )

		End If

	Next nX

	// Valida as forma��es sem vinculo a grupos
	// Se alguma forma��o obrigat�ria estiver com cPossui == 'N�O'
	// Define como inapto para o cargo
	If aScan( oFuncionario:aFormacao, { | oFormacao | Empty( oFormacao:cGrupo ) .And.;
	oFormacao:cPossui == 'N�O' .And. oFormacao:cObrigatorio == 'SIM' }  ) # 0

		lRet := .F.

	End If

	// Se as forma��es n�o vinculadas a um grupo estiverem validas
	// Ent�o valida as aptid�es com vinculo a grupos
	// Se todas as forma��es do grupo de alternativas estiverem com cPossui == 'N�O'
	// Define como inapto para o cargo
	If lRet

		For nX := 1 To Len( aGrupos )

			If aScan( oFuncionario:aFormacao, { | oFormacao | AllTrim( oFormacao:cGrupo ) == AllTrim( aGrupos[ nX ] ) .And.;
			oFormacao:cPossui == 'SIM' }  ) == 0

				lRet := .F.

				Exit

			End If

		Next nX

	End If

Return lRet

/*/{Protheus.doc} ValidaCapac
Valida se o funcion�rio tem a capacita��o necess�ria para o cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ValidaCapac( oFuncionario )

	Local aGrupos := {}
	Local nX      := 0
	Local lRet    := .T.
	Local cGrupo  := ''

	// Verifica os grupos de alternativas existentes
	For nX := 1 To Len( oFuncionario:aCapacitacao )

		cGrupo := oFuncionario:aCapacitacao[ nX ]:cGrupo

		If ! Empty(cGrupo) .And. aScan( aGrupos, cGrupo ) == 0

			aAdd( aGrupos, cGrupo )

		End If

	Next nX

	// Valida as capacita��es sem vinculo a grupos
	// Se alguma capacita��o obrigat�ria estiver com cPossui == 'N�O'
	// Define como inapto para o cargo
	If aScan( oFuncionario:aCapacitacao, { | oCapacitacao | Empty( oCapacitacao:cGrupo ) .And.;
	oCapacitacao:cPossui == 'N�O' .And. oCapacitacao:cObrigatorio == 'SIM' }  ) # 0

		lRet := .F.

	End If

	// Se as capacita��es n�o vinculadas a um grupo estiverem validas
	// Ent�o valida as aptid�es com vinculo a grupos
	// Se todas as capacita��es do grupo de alternativas estiverem com cPossui == 'N�O'
	// Define como inapto para o cargo
	If lRet

		For nX := 1 To Len( aGrupos )

			If aScan( oFuncionario:aCapacitacao, { | oCapacitacao | AllTrim( oCapacitacao:cGrupo ) == AllTrim( aGrupos[ nX ] ) .And.;
			oCapacitacao:cPossui == 'SIM' }  ) == 0

				lRet := .F.

				Exit

			End If

		Next nX

	End If

Return lRet

/*/{Protheus.doc} ValidaCert
Valida se o funcion�rio tem a certifica��o necess�ria para o cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ValidaCert( oFuncionario )

	Local aGrupos := {}
	Local nX      := 0
	Local lRet    := .T.
	Local cGrupo  := ''

	// Verifica os grupos de alternativas existentes
	For nX := 1 To Len( oFuncionario:aCertificacao )

		cGrupo := oFuncionario:aCertificacao[ nX ]:cGrupo

		If ! Empty(cGrupo) .And. aScan( aGrupos, cGrupo ) == 0

			aAdd( aGrupos, cGrupo )

		End If

	Next nX

	// Valida as certifica��es sem vinculo a grupos
	// Se alguma certifica��o obrigat�ria estiver com cPossui == 'N�O'
	// Define como inapto para o cargo
	If aScan( oFuncionario:aCertificacao, { | oCertificacao | Empty( oCertificacao:cGrupo ) .And.;
	oCertificacao:cPossui == 'N�O' .And. oCertificacao:cObrigatorio == 'SIM' }  ) # 0

		lRet := .F.

	End If

	// Se as certifica��es n�o vinculadas a um grupo estiverem validas
	// Ent�o valida as aptid�es com vinculo a grupos
	// Se todas as certifica��es do grupo de alternativas estiverem com cPossui == 'N�O'
	// Define como inapto para o cargo
	If lRet

		For nX := 1 To Len( aGrupos )

			If aScan( oFuncionario:aCertificacao, { | oCertificacao | AllTrim( oCertificacao:cGrupo ) == AllTrim( aGrupos[ nX ] ) .And.;
			oCertificacao:cPossui == 'SIM' }  ) == 0

				lRet := .F.

				Exit

			End If

		Next nX

	End If

Return lRet

/*/{Protheus.doc} ValidaConh
Valida se o funcion�rio tem o conhecimento necess�rio para o cargo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ValidaConh( oFuncionario )

	Local aGrupos := {}
	Local nX      := 0
	Local lRet    := .T.
	Local cGrupo  := ''

	// Verifica os grupos de alternativas existentes
	For nX := 1 To Len( oFuncionario:aConhecimento )

		cGrupo := oFuncionario:aConhecimento[ nX ]:cGrupo

		If ! Empty(cGrupo) .And. aScan( aGrupos, cGrupo ) == 0

			aAdd( aGrupos, cGrupo )

		End If

	Next nX

	// Valida as certifica��es sem vinculo a grupos
	// Se alguma certifica��o obrigat�ria estiver com cPossui == 'N�O'
	// Define como inapto para o cargo
	If aScan( oFuncionario:aConhecimento, { | oConhecimento | Empty( oConhecimento:cGrupo ) .And.;
	oConhecimento:cPossui == 'N�O' .And. oConhecimento:cObrigatorio == 'SIM' }  ) # 0

		lRet := .F.

	End If

	// Se as certifica��es n�o vinculadas a um grupo estiverem validas
	// Ent�o valida as aptid�es com vinculo a grupos
	// Se todas as certifica��es do grupo de alternativas estiverem com cPossui == 'N�O'
	// Define como inapto para o cargo
	If lRet

		For nX := 1 To Len( aGrupos )

			If aScan( oFuncionario:aConhecimento, { | oConhecimento | AllTrim( oConhecimento:cGrupo ) == AllTrim( aGrupos[ nX ] ) .And.;
			oConhecimento:cPossui == 'SIM' }  ) == 0

				lRet := .F.

				Exit

			End If

		Next nX

	End If

Return lRet

/*/{Protheus.doc} Funcionario
Classe que representa os dados do funcion�rio para efetua a cr�tica de compet�ncias do cargo x funcion�rio
@project MAN0000038865_EF_002
@type class Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Class Funcionario

	Data cMat
	Data cNome
	Data cCargo
	Data cDescSum
	Data cXexpeci
	Data cSituacao
	Data aFormacao
	Data aCapacitacao
	Data aCertificacao
	Data aConhecimento

	Method New() Constructor

End Class

/*/{Protheus.doc} New
M�todo construtor da classe funcionario, inicializa os atributos com valores padr�o conforme tipo definido na nota��o h�ngara
@project MAN0000038865_EF_002
@type method Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Method New() Class Funcionario

	InitObject( @Self )

Return Self

/*/{Protheus.doc} Funcionario

@project MAN0000038865_EF_002
@type class Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Class Competencia

	Data cGrupo
	Data cCodigo
	Data cDescricao
	Data cObrigatorio
	Data cPossui

	Method New() Constructor

End Class

/*/{Protheus.doc} New
M�todo construtor da classe Competencia que ir� receber as compet�ncia do cargo do funcin�rio, inicializa os atributos com valores padr�o conforme tipo definido na nota��o h�ngara
@project MAN0000038865_EF_002
@type method Rotina Espec�fica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Method New() Class Competencia

	InitObject( @Self )

Return Self

/*/{Protheus.doc} InitObject
Fun�ao que inicializa os atributos de um objeto com valores padr�o conforme tipo definido na nota��o h�ngara
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oObj, Objeto que ter� os atributos iniciados recebido por refer�ncia
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function InitObject( oObj )

	Local aAtributos := ClassDataArr( oObj, .F. )
	Local nX         := 0

	For nX := 1 To Len( aAtributos )

		If SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'A'

			Eval( &( '{||oObj:' + aAtributos[ nX, 1 ] + ' := {} }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) $ 'CM'

			Eval( &( '{||oObj:' + aAtributos[ nX, 1 ] + ' := "" }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'D'

			Eval( &( '{||oObj:' + aAtributos[ nX, 1 ] + ' := CtoD( "" ) }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'L'

			Eval( &( '{||oObj:' + aAtributos[ nX, 1 ] + ' := .F. }' ) )

		ElseIf SubStr( aAtributos[ nX, 1 ], 1, 1 ) == 'N'

			Eval( &( '{||oObj:' + aAtributos[ nX, 1 ] + ' := 0 }' ) )

		Else

			Eval( &( '{||oObj:' + aAtributos[ nX, 1 ] + ' := Nil }' ) )

		End If

	Next nX

Return


/*/{Protheus.doc} Imprimir
Fun��o que imprime o relat�rio com a cr�tica de compet�ncias cargo x funcion�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param Array, aFuncionarios, Array com os Objetos que representam os funcion�rios
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function Imprimir( aFuncionarios )

	local oReport := ReportDef( aFuncionarios )

	oReport:printDialog()

Return

/*/{Protheus.doc} ReportDef
Monta o objeto que representa o relat�rio a ser gerado
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param Array, aFuncionarios, Array com os Objetos que representam os funcion�rios
@version P12
@author TOTVS
@since 14/11/2018
@return object, Objeto que representa o relat�rio a ser gerado
/*/
Static Function ReportDef( aFuncionarios )

	Local oReport    := Nil
	Local oSection1  := Nil
	Local oSection2  := Nil
	Local oSection3  := Nil
	Local oSection4  := Nil
	Local oSection5  := Nil
	Local cTitulo    := 'Cr�tica de Compet�ncia do cargo x Compet�ncias do Funcion�rio.'
	Loca cDescricao  := 'Imprime a cr�tica da Compet�ncia do cargo x Compet�ncias do Funcion�rio e define se o funcion�rio � apto ou n�o ao exerc�o do cargo'
	Local bAcao      := { |oReport| PrintReport( oReport, aFuncionarios ) }


	oReport := TReport():New( 'TRMX09', cTitulo,, bAcao, cDescricao )


	// Section do dados do funcion�rio
	oSection1 := TRSection():New( oReport, 'Section1' )

	TRCell():New( oSection1, 'MATRICULA'         , , 'Matr�cula'         , /*Picture*/, GetSx3Cache( 'RA_MAT'    , 'X3_TAMANHO' )  )
	TRCell():New( oSection1, 'NOME'              , , 'Nome'              , /*Picture*/, GetSx3Cache( 'RA_NOME'   , 'X3_TAMANHO' )  )
	TRCell():New( oSection1, 'CARGO'             , , 'Cargo'             , /*Picture*/, GetSx3Cache( 'RA_CARGO'  , 'X3_TAMANHO' )  )
	TRCell():New( oSection1, 'DESCRICAO_SUMARIA' , , 'Descri��o Sum�ria' , /*Picture*/, GetSx3Cache( 'Q3_DESCSUM', 'X3_TAMANHO' )  )
	TRCell():New( oSection1, 'EXPECIFICACAO'     , , 'Expecifica��o'     , /*Picture*/, GetSx3Cache( 'Q3_XESPECI', 'X3_TAMANHO' )  )
	TRCell():New( oSection1, 'SITUACAO'          , , 'Situa��o'          , /*Picture*/, /*Tamanho*/                                )

	// section das forma��es
	oSection2 := TRSection():New( oReport, 'Section2' )

	TRCell():New( oSection2, 'GRUPO'       , , 'Grupo'       , /*Picture*/, GetSx3Cache( 'ZS1_ALTERN', 'X3_TAMANHO' ) )
	TRCell():New( oSection2, 'CODIGO'      , , 'C�digo'      , /*Picture*/, GetSx3Cache( 'ZS1_CURSO', 'X3_TAMANHO'  ) )
	TRCell():New( oSection2, 'DESCRICAO'   , , 'Descri��o'   , /*Picture*/, GetSx3Cache( 'ZS1_DESCCU', 'X3_TAMANHO' ) )
	TRCell():New( oSection2, 'OBRIGATORIO' , , 'Obrigat�rio' , /*Picture*/,  /*Tamanho*/                              )
	TRCell():New( oSection2, 'POSSUI'      , , 'Possui'      , /*Picture*/,  /*Tamanho*/                              )

	// section das capacita��es
	oSection3 := TRSection():New( oReport, 'Section3' )

	TRCell():New( oSection3, 'GRUPO'       , , 'Grupo'       , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection3, 'CODIGO'      , , 'C�digo'      , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection3, 'DESCRICAO'   , , 'Descri��o'   , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection3, 'OBRIGATORIO' , , 'Obrigat�rio' , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection3, 'POSSUI'      , , 'Possui'      , /*Picture*/, /*Tamanho*/  )

	// section das certifica��es
	oSection4 := TRSection():New( oReport, 'Section4' )

	TRCell():New( oSection4, 'GRUPO'       , , 'Grupo'       , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection4, 'CODIGO'      , , 'C�digo'      , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection4, 'DESCRICAO'   , , 'Descri��o'   , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection4, 'OBRIGATORIO' , , 'Obrigat�rio' , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection4, 'POSSUI'      , , 'Possui'      , /*Picture*/, /*Tamanho*/  )


	// section dos sconhecimentos
	oSection5 := TRSection():New( oReport, 'Section5' )

	TRCell():New( oSection5, 'GRUPO'       , , 'Grupo'       , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection5, 'CODIGO'      , , 'C�digo'      , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection5, 'DESCRICAO'   , , 'Descri��o'   , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection5, 'OBRIGATORIO' , , 'Obrigat�rio' , /*Picture*/, /*Tamanho*/  )
	TRCell():New( oSection5, 'POSSUI'      , , 'Possui'      , /*Picture*/, /*Tamanho*/  )


Return oReport

/*/{Protheus.doc} PrintReport
Fun��o a ser executada na impress�od o relat�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oReport,Objeto que representa o relat�rio a ser gerado
@param Array, aFuncionarios, Array com os Objetos que representam os funcion�rios
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function PrintReport( oReport, aFuncionarios )

	Local oSection1 := oReport:Section( 1 )
	Local oSection2 := oReport:Section( 2 )
	Local oSection3 := oReport:Section( 3 )
	Local oSection4 := oReport:Section( 4 )
	Local oSection5 := oReport:Section( 5 )
	Local nX        := 0

	// Percorre o array com os funcion�rio e imprime a critica de cada um

	For nX := 1 To Len( aFuncionarios )

		// Section Dados do funcion�rio
		oSection1:Init()

		oSection1:Cell( 'MATRICULA'        ):SetValue( aFuncionarios[ nX ]:cMat      )
		oSection1:Cell( 'NOME'             ):SetValue( aFuncionarios[ nX ]:cNome     )
		oSection1:Cell( 'CARGO'            ):SetValue( aFuncionarios[ nX ]:cCargo    )
		oSection1:Cell( 'DESCRICAO_SUMARIA'):SetValue( aFuncionarios[ nX ]:cDescSum  )
		oSection1:Cell( 'EXPECIFICACAO'    ):SetValue( aFuncionarios[ nX ]:cXexpeci  )
		oSection1:Cell( 'SITUACAO'         ):SetValue( aFuncionarios[ nX ]:cSituacao )

		oSection1:PrintLine()

		oSection1:Finish()

		// Section Forma��o do Cargo

		If ! Empty( aFuncionarios[ nX ]:aFormacao )

			oReport:PrintText( '' )
			oReport:PrintText( 'Forma��o do Cargo' )
			oReport:PrintText( '-----------------------' )

			PrintForm( oSection2, aFuncionarios[ nX ] )

		End If

		// Section Capacita��o do Cargo

		If ! Empty( aFuncionarios[ nX ]:aCapacitacao )

			oReport:PrintText( '' )
			oReport:PrintText( 'Capacita��o do Cargo' )
			oReport:PrintText( '--------------------------' )

			PrintCapac( oSection3, aFuncionarios[ nX ] )

		End If

		// Section Certifica��o do Cargo

		If ! Empty( aFuncionarios[ nX ]:aCertificacao )

			oReport:PrintText( '' )
			oReport:PrintText( 'Certifica��o do Cargo' )
			oReport:PrintText( '---------------------------' )

		PrintCert( oSection4, aFuncionarios[ nX ] )

		End If

		// Section Conhecimento do funcion�rio

		If ! Empty( aFuncionarios[ nX ]:aConhecimento )

			oReport:PrintText( '' )
			oReport:PrintText( 'Conhecimento do Cargo' )
			oReport:PrintText( '---------------------------' )

			PrintConh( oSection5, aFuncionarios[ nX ] )

		End If

	Next nX

Return

/*/{Protheus.doc} PrintForm
Fun��o que imprime a se��o de forma��o do funcion�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oSection, Objeto que representa a section do
relat�rio que imprime as forma��es do funcion�rio
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function PrintForm( oSection, oFuncionario )

	Local nY := 0

	For nY := 1 To Len( oFuncionario:aFormacao )

		oSection:Init()

		oSection:Cell( 'GRUPO'       ):SetValue( oFuncionario:aFormacao[ nY ]:cGrupo       )
		oSection:Cell( 'CODIGO'      ):SetValue( oFuncionario:aFormacao[ nY ]:cCodigo      )
		oSection:Cell( 'DESCRICAO'   ):SetValue( oFuncionario:aFormacao[ nY ]:cDescricao   )
		oSection:Cell( 'OBRIGATORIO' ):SetValue( oFuncionario:aFormacao[ nY ]:cObrigatorio )
		oSection:Cell( 'POSSUI'      ):SetValue( oFuncionario:aFormacao[ nY ]:cPossui      )

		oSection:PrintLine()

	Next nY

	oSection:Finish()

Return

/*/{Protheus.doc} PrintCapac
Fun��o que imprime a se��o de capacita��o do funcion�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oSection, Objeto que representa a section do
relat�rio que imprime as capacita��o do funcion�rio
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function PrintCapac( oSection, oFuncionario )

	Local nY := 0

	For nY := 1 To Len( oFuncionario:aCapacitacao )

		oSection:Init()

		oSection:Cell( 'GRUPO'       ):SetValue( oFuncionario:aCapacitacao[ nY ]:cGrupo       )
		oSection:Cell( 'CODIGO'      ):SetValue( oFuncionario:aCapacitacao[ nY ]:cCodigo      )
		oSection:Cell( 'DESCRICAO'   ):SetValue( oFuncionario:aCapacitacao[ nY ]:cDescricao   )
		oSection:Cell( 'OBRIGATORIO' ):SetValue( oFuncionario:aCapacitacao[ nY ]:cObrigatorio )
		oSection:Cell( 'POSSUI'      ):SetValue( oFuncionario:aCapacitacao[ nY ]:cPossui      )

		oSection:PrintLine()

	Next nY

	oSection:Finish()

Return

/*/{Protheus.doc} PrintCert
Fun��o que imprime a se��o de certifica��o do funcion�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oSection, Objeto que representa a section do
relat�rio que imprime as certifica��o do funcion�rio
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function PrintCert( oSection, oFuncionario )

	Local nY := 0

	For nY := 1 To Len( oFuncionario:aCertificacao )

		oSection:Init()

		oSection:Cell( 'GRUPO'       ):SetValue( oFuncionario:aCertificacao[ nY ]:cGrupo       )
		oSection:Cell( 'CODIGO'      ):SetValue( oFuncionario:aCertificacao[ nY ]:cCodigo      )
		oSection:Cell( 'DESCRICAO'   ):SetValue( oFuncionario:aCertificacao[ nY ]:cDescricao   )
		oSection:Cell( 'OBRIGATORIO' ):SetValue( oFuncionario:aCertificacao[ nY ]:cObrigatorio )
		oSection:Cell( 'POSSUI'      ):SetValue( oFuncionario:aCertificacao[ nY ]:cPossui      )

		oSection:PrintLine()

	Next nY

	oSection:Finish()

Return

/*/{Protheus.doc} PrintConh
Fun��o que imprime a se��o de conhecimento do funcion�rio
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@param object, oSection, Objeto que representa a section do
relat�rio que imprime as conhecimento do funcion�rio
@param object, oFuncionario, Objeto que representa o funcion�rio
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function PrintConh( oSection, oFuncionario )

	Local nY := 0

	For nY := 1 To Len( oFuncionario:aConhecimento )

		oSection:Init()

		oSection:Cell( 'GRUPO'       ):SetValue( oFuncionario:aConhecimento[ nY ]:cGrupo       )
		oSection:Cell( 'CODIGO'      ):SetValue( oFuncionario:aConhecimento[ nY ]:cCodigo      )
		oSection:Cell( 'DESCRICAO'   ):SetValue( oFuncionario:aConhecimento[ nY ]:cDescricao   )
		oSection:Cell( 'OBRIGATORIO' ):SetValue( oFuncionario:aConhecimento[ nY ]:cObrigatorio )
		oSection:Cell( 'POSSUI'      ):SetValue( oFuncionario:aConhecimento[ nY ]:cPossui      )

		oSection:PrintLine()

	Next nY

	oSection:Finish()

Return