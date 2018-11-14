#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function TRM003()

	Local oFwMBrowse := FwMBrowse():New()
	
	oFwMBrowse:SetAlias( 'SQ3' )
	oFwMBrowse:SetDescription( 'Requisitos do Cargo' )
	
	oFwMBrowse:Activate()	


Return

Static Function MenuDef()

	Local aRotina := {}
	
	aAdd( aRotina, { 'Manutenção', 'VIEWDEF.TRM003', 0, 4, 0, NIL } )	
	 

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author x248892

@since 13/11/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SQ3')
Local oStr2:= FWFormStruct(1,'RA4')
Local oStr3:= FWFormStruct(1,'RA4')
Local oStr4:= FWFormStruct(1,'RA4')
Local oStr5:= FWFormStruct(1,'SZ9')

oStr2:SetProperty( '*', MODEL_FIELD_INIT, {||} )
oStr3:SetProperty( '*', MODEL_FIELD_INIT, {||} )
oStr4:SetProperty( '*', MODEL_FIELD_INIT, {||} )

oStr2:SetProperty( '*', MODEL_FIELD_WHEN, {||} )
oStr3:SetProperty( '*', MODEL_FIELD_WHEN, {||} )
oStr4:SetProperty( '*', MODEL_FIELD_WHEN, {||} )

oModel := MPFormModel():New('MTRM003')
oModel:SetDescription('Requisitos do Cargo')

oModel:addFields('FIELD_SQ3',,oStr1)

oModel:addGrid('GRID_RA4_FORM' ,'FIELD_SQ3',oStr2)
oModel:addGrid('GRID_RA4_CAPAC','FIELD_SQ3',oStr3)
oModel:addGrid('GRID_RA4_CERT' ,'FIELD_SQ3',oStr4)
oModel:addGrid('GRID_SZ9'      ,'FIELD_SQ3',oStr5)

oModel:getModel('FIELD_SQ3'):SetDescription('Cargos')
oModel:getModel('GRID_RA4_FORM'):SetDescription('Formacao')
oModel:getModel('GRID_RA4_CAPAC'):SetDescription('Capacitacao')
oModel:getModel('GRID_RA4_CERT'):SetDescription('Certificacao')
oModel:getModel('GRID_SZ9'):SetDescription('Conhecimentos')


Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author x248892

@since 13/11/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SQ3')
 
Local oStr2:= Nil
 
Local oStr3:= FWFormStruct(2, 'RA4')
 
Local oStr4:= FWFormStruct(2, 'RA4')
 
Local oStr5:= FWFormStruct(2, 'SZ9')
 
Local oStr6:= FWFormStruct(2, 'RA4')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('BOXH01_FORM01_FIELD_SQ3' , oStr1,'FIELD_SQ3' )
oView:AddGrid('FORM5' , oStr3,'GRID_RA4_FORM')
oView:AddGrid('FORM7' , oStr4,'GRID_RA4_CAPAC')
oView:AddGrid('FORM9' , oStr5,'GRID_SZ9')
oView:AddGrid('FORM11' , oStr6,'GRID_RA4_CERT')    

oView:CreateHorizontalBox( 'BOXH01', 50)
oView:CreateHorizontalBox( 'BOXV01', 50)
oView:CreateFolder( 'FOLDER', 'BOXV01')
oView:AddSheet('FOLDER','Formacao','Formação')
oView:AddSheet('FOLDER','Capacitacao','Capacitação')
oView:AddSheet('FOLDER','Certificacao','Certificação')
oView:AddSheet('FOLDER','Conhecimentos','Conhecimentos')

oStr6:RemoveField( 'RA4_NOME' )

oStr6:RemoveField( 'RA4_MAT' )
oView:CreateHorizontalBox( 'BOXFORM11', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'Certificacao')
oView:SetOwnerView('FORM11','BOXFORM11')
oView:CreateHorizontalBox( 'BOXFORM9', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'Conhecimentos')
oView:SetOwnerView('FORM9','BOXFORM9')

oStr4:RemoveField( 'RA4_NOME' )

oStr4:RemoveField( 'RA4_MAT' )
oView:CreateHorizontalBox( 'BOXFORM7', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'Capacitacao')
oView:SetOwnerView('FORM7','BOXFORM7')

oStr3:RemoveField( 'RA4_NOME' )

oStr3:RemoveField( 'RA4_MAT' )
oView:CreateHorizontalBox( 'BOXFORM5', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'Formacao')
oView:SetOwnerView('FORM5','BOXFORM5')



oView:SetOwnerView('BOXH01_FORM01_FIELD_SQ3','BOXH01')






Return oView