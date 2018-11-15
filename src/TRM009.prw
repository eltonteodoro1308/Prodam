#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDef.CH'

/*/{Protheus.doc} TRM009
Rotina de Cadastro de Requisitos e Competências do Cargo
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 14/11/2018
/*/
User Function TRM009()
	
	Local oFwMBrowse := FwMBrowse():New()
	
	oFwMBrowse:SetAlias( 'ZS0' )
	oFwMBrowse:SetDescription( 'Requisitos do Cargo' )
	
	oFwMBrowse:Activate()
	
Return

/*/{Protheus.doc} MENUDEF
Define o Menu de Rotina do Browser
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function MenuDef()
	
	Local aRotina := FWMVCMenu( 'TRM009' )
	
Return aRotina

/*/{Protheus.doc} ModelDef
Definição do modelo de Dados
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ModelDef()
	Local oModel
	
	
	Local oStr1:= FWFormStruct(1,'ZS0')
	
	Local oStr2:= FWFormStruct(1,'ZS1')
	
	Local oStr3:= FWFormStruct(1,'ZS2')
	
	Local oStr4:= FWFormStruct(1,'ZS3')
	
	Local oStr5:= FWFormStruct(1,'ZS4')
	oModel := MPFormModel():New('MTRM009')
	oModel:SetDescription('Competências do Cargo')
	oModel:addFields('FIELD_ZS0',,oStr1)
	oModel:addGrid('GRID_ZS1','FIELD_ZS0',oStr2)
	oModel:SetRelation('GRID_ZS1', { { 'ZS1_FILIAL', 'ZS0_FILIAL' }, { 'ZS1_CARGO', 'ZS0_CARGO' } }, ZS1->(IndexKey(1)) )
	
	
	oModel:addGrid('GRID_ZS2','FIELD_ZS0',oStr3)
	oModel:SetRelation('GRID_ZS2', { { 'ZS2_FILIAL', 'ZS0_FILIAL' }, { 'ZS2_CARGO', 'ZS0_CARGO' } }, ZS2->(IndexKey(1)) )
	
	
	oModel:addGrid('GRID_ZS3','FIELD_ZS0',oStr4)
	oModel:SetRelation('GRID_ZS3', { { 'ZS3_FILIAL', 'ZS0_FILIAL' }, { 'ZS3_CARGO', 'ZS0_CARGO' } }, ZS3->(IndexKey(1)) )
	
	
	oModel:addGrid('GRID_ZS4','FIELD_ZS0',oStr5)
	oModel:SetRelation('GRID_ZS4', { { 'ZS4_FILIAL', 'ZS0_FILIAL' }, { 'ZS4_CARGO', 'ZS0_CARGO' } }, ZS4->(IndexKey(1)) )
	
	
	oModel:getModel('FIELD_ZS0'):SetDescription('Cargo')
	oModel:getModel('GRID_ZS1'):SetDescription('Formação do Cargo')
	oModel:getModel('GRID_ZS2'):SetDescription('Capacitação do Cargo')
	oModel:getModel('GRID_ZS2'):SetOptional(.T.)
	oModel:getModel('GRID_ZS1'):SetOptional(.T.)
	oModel:getModel('GRID_ZS3'):SetDescription('Certificação do Cargo')
	oModel:getModel('GRID_ZS4'):SetDescription('Conhecimento do Cargo')
	oModel:getModel('GRID_ZS4'):SetOptional(.T.)
	oModel:getModel('GRID_ZS3'):SetOptional(.T.)
	
Return oModel

/*/{Protheus.doc} ViewDef
Definição do interface
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 14/11/2018
/*/
Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	
	Local oStr1:= FWFormStruct(2, 'ZS0')
	
	Local oStr2:= Nil
	
	Local oStr3:= FWFormStruct(2, 'ZS1')
	
	Local oStr4:= FWFormStruct(2, 'ZS2')
	
	Local oStr5:= FWFormStruct(2, 'ZS3')
	
	Local oStr6:= FWFormStruct(2, 'ZS4')
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('FORM_CARGO' , oStr1,'FIELD_ZS0' )
	oView:AddGrid('FORM_FORMACAO' , oStr3,'GRID_ZS1')
	oView:AddGrid('FORM_CAPACITACAO' , oStr4,'GRID_ZS2')
	oView:AddGrid('FORM_CERTIFICACAO' , oStr5,'GRID_ZS3')
	oView:AddGrid('FORM_CONHECIMENTO' , oStr6,'GRID_ZS4')
	
	oView:CreateHorizontalBox( 'BOX_HOR_TOPO', 15)
	oView:CreateHorizontalBox( 'BOX_HOR_FOLDER', 85)
	oView:CreateFolder( 'FOLDER', 'BOX_HOR_FOLDER')
	oView:AddSheet('FOLDER','SHEET_FORMACAO','Formação')
	oView:AddSheet('FOLDER','SHEET_CAPACITACAO','Capacitação')
	oView:AddSheet('FOLDER','SHEET_CERTIFICACAO','Certificação')
	oView:AddSheet('FOLDER','SHEET_CONHECIMENTO','Conhecimento')
	oView:CreateHorizontalBox( 'BOX_HOR_CONHECIMENTO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_CONHECIMENTO')
	oView:SetOwnerView('FORM_CONHECIMENTO','BOX_HOR_CONHECIMENTO')
	oView:CreateHorizontalBox( 'BOX_HOR_CERTIFICACAO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_CERTIFICACAO')
	oView:SetOwnerView('FORM_CERTIFICACAO','BOX_HOR_CERTIFICACAO')
	oView:CreateHorizontalBox( 'BOX_HOR_CAPACITACAO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_CAPACITACAO')
	oView:SetOwnerView('FORM_CAPACITACAO','BOX_HOR_CAPACITACAO')
	oView:CreateHorizontalBox( 'BOX_HOR_FORMACAO', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_FORMACAO')
	oView:SetOwnerView('FORM_FORMACAO','BOX_HOR_FORMACAO')
	
	oView:SetOwnerView('FORM_CARGO','BOX_HOR_TOPO')
	
Return oView

User Function SZ5ZS()
	
	Local cReadvar := ReadVar()
	
	If 'ZS1' $ cReadVar
		
		cEstou := '01'
		
	ElseIF 'ZS2' $ cReadVar
		
		cEstou := '02'
		
	ElseIF 'ZS3' $ cReadVar
		
		cEstou := '03'
		
	End If
	
	U_SZ5RA4()
	
Return
