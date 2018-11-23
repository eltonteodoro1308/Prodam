#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} TRM003()
Cadastro de Categorias de Cursos (SZ5)

@author Diego Santos
@since 21/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function TRM003()

Local cAlias  := "SZ5"
Local cTitulo := "Cadastro de Categorias de Cursos"
Local cVldExc := "U_DELTRM003()"
Local cVldAlt := ".T." 

If AliasInDic( "SZ5" )
	dbSelectArea( "SZ5" )
	SZ5->(dbSetOrder(1))	
	AxCadastro( cAlias, cTitulo, cVldExc, cVldAlt )
Else
	//MsgAlert( STR0003 )	   		//"Tabela de Cadastro de Categorias de Cursos (SZ5) não encontrada!"
	MsgAlert( "Tabela de Cadastro de Categorias de Cursos (SZ5) não encontrada!" )
EndIf

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} DELTRM003()
Valida a Exclusão de Categorias de Cursos (SZ5)

@author Diego Santos
@since 21/03/2016
@version P12.1.6
/*/
//-------------------------------------------------------------------

User Function DELTRM003

Local cQuery 	:= ""
Local cAliasQry := GetNextAlias()
Local lRet 		:= .T.
Local cMsg		:= ""

cMsg   := "Existem cursos relacionados a esta categoria." + Chr(13) + Chr(10)
cMsg   += "Por favor, exclua ou altere o campo CATEGORIA no cadastro de cursos, e tente novamente."

cQuery := "SELECT * FROM "+RetSqlName("RA1")+" RA1 "
cQuery += "WHERE "
cQuery += "RA1.RA1_FILIAL = '"+xFilial("RA1")+"' AND "
cQuery += "RA1.RA1_CATEG = '"+SZ5->Z5_CODIGO+"' AND "
cQuery += "RA1.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

If (cAliasQry)->(!Eof())
	lRet := .F.
	MsgAlert( cMsg, "Aviso" )
EndIf

Return lRet
