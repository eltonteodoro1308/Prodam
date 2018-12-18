#Include 'Protheus.ch'

/*/{Protheus.doc} FLXCXNAT
Gera Planilha Excel do Fluxo de Caixa Banc�rio por Natureza Anual ou Di�rio.
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
/*/
User Function FLXCXNAT()
	
	Local aParam      := {}
	Local aRet        := {}
	Local aMeses      := {}
	Local cMvPar      := 'MV_PAR08 := cGetFile( ,,, SubStr( MV_PAR08, 1, Rat( "\", MV_PAR08 ) - 1 ),,, .F. )'
	Local cValid      := 'Eval( { || If( ApMsgYesNo( "Utiliza o Mesmo Caminho ?" ), MV_PAR08 := MV_PAR08, ' + cMvPar + '), .T. } )'
	Local nSldInic    := 0
	Local cBancos     := GetBanco()
	Local aCabec      := {}
	Local aSldPrev    := {}
	Local aSldReal    := {}
	Local nX          := 0
	Local cAlias      := ''
	
	// Se vari�vel de banco vier vazia indica que nenhum banco foi selecionado
	// ou foi clicado em cancelar na janela de sele��o dos bancos assim a
	// rotina ser� encerrada sem executar nada
	If Empty( cBancos )
		
		Return
		
	End If
	
	// Popula Array com a lista de meses para
	// ser utilizado na tela de par�metro do Fluxo de Caixa
	aAdd( aMeses, '00=NENHUM' )
	
	For nX := 1 To 12
		
		aAdd( aMeses, StrZero( nX, 2 ) + '=' + Upper( MesExtenso( nX ) ) )
		
	Next nX
	
	// Popula array aRet com os par�metros para gerar o fluxo de caixa
	/* aRet[ 1 ] */aAdd( aParam, { 2, 'Tipo de Fluxo'           , '1' , { '1=DI�RIO', '2=ANUAL' }, 90, '.T.', .F.,                } )
	/* aRet[ 2 ] */aAdd( aParam, { 2, 'Considerar Realizado At�', '01', aMeses                   , 90, '.T.', .F., "MV_PAR01='2'" } )
	
	/* aRet[ 3 ] */aAdd( aParam, { 1, 'Data Base'              , dDataBase                          ,         , '.T.'  ,     , '.T.', 90, .F. } )
	/* aRet[ 4 ] */aAdd( aParam, { 1, 'Natureza De'            , Space( TamSx3( 'ED_CODIGO' )[ 1 ] ), '@!'    , '.T.'  ,'SED', '.T.', 90, .F. } )
	/* aRet[ 5 ] */aAdd( aParam, { 1, 'Natureza At�'           , Space( TamSx3( 'ED_CODIGO' )[ 1 ] ), '@!'    , '.T.'  ,'SED', '.T.', 90, .F. } )
	/* aRet[ 6 ] */aAdd( aParam, { 1, 'N�vel de Ingressos'     , 000                                , '@E 999', '.T.'  ,     , '.T.', 90, .F. } )
	/* aRet[ 7 ] */aAdd( aParam, { 1, 'N�vel de Desembolsos'   , 000                                , '@E 999', '.T.'  ,     , '.T.', 90, .F. } )
	/* aRet[ 8 ] */aAdd( aParam, { 1, 'Local e Nome do Arquivo', Space( 255 )                       , '@!'    , cValid ,     , '.T.', 90, .F. } )
	
	// Solicita preenchimento dos par�metros pelo usu�rio
	If ParamBox( aParam, 'Fluxo de Caixa por Natureza', @aRet,,,,,,, 'FLXCXNAT', .T., .T. )
		
		// Busca saldo inicial das contas banc�rias selecionadas
		
		MsgRun ( 'Carregando Saldos das Iniciais...', 'Aguarde',;
			{ || nSldInic := SldInic( cBancos, aRet[ 1 ], aRet[ 3 ] ) } )
		
		// Monta cabe�alho do fluxo de caixa conforme o tipo de fluxo de caixa di�rio ou anual
		MsgRun ( 'Montando Cabe�alho...', 'Aguarde',;
			{ || MontaCabec( aCabec, aRet[ 1 ], Val( aRet[ 2 ] ), aRet[ 3 ] ) } )
		
		// Busca saldos previsto/or�ados se fluxo for anual
		// se fluxo di�rio n�o executa
		If aRet[ 1 ] == '2'
			
			MsgRun ( 'Caregando Saldos Previstos...', 'Aguarde',;
				{ || GetSldPrev( aRet[ 3 ], aRet[ 4 ], aRet[ 5 ], aSldPrev, cBancos ) } )
			
		End If
		
		// Busca saldos realizados conforme fluxo di�rio ou anual
		// se for fluxo anual com nenhum m�s realizado n�o executa consulta
		If aRet[ 1 ] == '1' .Or. ( aRet[ 1 ] == '2' .And. aRet[ 2 ] # '00' )
			
			MsgRun ( 'Caregando Saldos Realizados...', 'Aguarde',;
				{ || GetSldReal( aRet[ 1 ], aRet[ 3 ], aRet[ 4 ], aRet[ 5 ], aSldReal, cBancos, Len( aCabec ) - 2 ) } )
			
		End If
		
		//Cria e Popula alias tempor�rio com dados dos saldos das naturezas
		MsgRun ( 'Montando Tabela Tempor�ria...', 'Aguarde',;
			{ || cAlias := MontaAlias( aSldPrev, aSldReal ) } )
		
		MV_PAR05 := If( aRet[ 1 ] == '1', 1, 3 )
		
		MsAguarde( { || U_Fluxo2Excel( { Val( aRet[ 2 ] ),cAlias, aCabec, aRet[ 6 ], aRet[ 7 ], aRet[ 8 ], nSldInic } ) }, 'Executando ...', 'Mensagem...',.F. )
		
	End If
	
Return

/*/{Protheus.doc} SldInic
Busca o saldo inicial banc�rio da data base, correspondente aos bancos que ir�o compor o fluxo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param cBancos, character, Lista de bancos em formato a ser utilizado na cl�usula IN da query que ir� buscar os saldo inicial do fluxo
@param cPeriodo, character, C�digo do per�odo definido para fluxo 1 - Di�rio, 2 - Anual
@param dDtBase, data, Data Base de Gera��o do Fluxo de Caixa
@return numeric, Saldo inicial banc�rio na data base, correspondente aos bancos que ir�o compor o fluxo
/*/
Static Function SldInic( cBancos, cPeriodo, dDtBase )
	
	Local nRet      := 0
	Local cQuery    := ''
	Local cAlias    := ''
	Local aArea     := GetArea()
	Local cDataAte  := Nil
	Local dDateAux  := Nil
	
	// Verifica se fluxo di�rio ou anual para definir a data de refer�ncia do saldo inicial
	// que ser� o �ltima dia do m�s anterior para Fluxo di�rio e
	// �ltimo dia do ano anterior para fluxo anual
	If cPeriodo == '1'
		
		dDateAux := DaySub( FirstDate( dDtBase ), 1 )
		
	ElseIf cPeriodo == '2'
		
		dDateAux := DaySub( FirstYDate( dDtBase ), 1 )
		
	EndIf
	
	// Converte data para string compat�vel para ser usuada na query
	cDataAte := DtoS( dDateAux )
	
	// Monta query de pesquisa do saldo inicial considerando os bancos selecionados e
	// a data limite de refer�ncia
	cQuery += " SELECT SUM( SE8.E8_SALATUA ) E8_SALATUA FROM " + RetSqlName( "SE8" ) + " SE8 "
	
	cQuery += " WHERE SE8.D_E_L_E_T_ = '' "
	cQuery += " AND   SE8.E8_FILIAL  = '" + xFilial( "SE8" ) + "' "
	cQuery += " AND   SE8.E8_BANCO + SE8.E8_AGENCIA + SE8.E8_CONTA + SE8.E8_DTSALAT IN ( "
	
	cQuery += " SELECT SE8SLD.E8_BANCO + SE8SLD.E8_AGENCIA + SE8SLD.E8_CONTA + MAX( SE8SLD.E8_DTSALAT ) E8_DTSALAT "
	
	cQuery += " FROM " + RetSqlName( "SE8" ) + " SE8SLD "
	
	cQuery += " WHERE SE8SLD.D_E_L_E_T_ = '' "
	cQuery += " AND   SE8SLD.E8_FILIAL = '" + xFilial( "SE8" ) + "' "
	cQuery += " AND   SE8SLD.E8_DTSALAT <= '" + cDataAte + "' "
	cQuery += " AND   SE8SLD.E8_BANCO + SE8SLD.E8_AGENCIA + SE8SLD.E8_CONTA IN " + cBancos + " "
	
	cQuery += " GROUP BY SE8SLD.E8_BANCO, SE8SLD.E8_AGENCIA, SE8SLD.E8_CONTA ) "
	
	// Executa a query
	cAlias := MPSysOpenQuery( cQuery )
	
	// Atribui a vari�vel de retorno o Saldo Inicial do Per�odo
	nRet := ( cAlias )->E8_SALATUA
	
	// Ajuste do saldo inicial
	// verifica par�metro para exibir 
	// tela solicitando ajuste do saldo inicial 
	If SuperGetMV( "PR_AJSLDIN", .T., .F. )
		
		nRet := AjSldInic( nRet, DtoC( StoD( cDataAte ) ) )
		
	End If
	
	// Fecha alias tempor�rio
	( cAlias )->( DbCloseArea( ) )
	
	// Restaura ambiente
	RestArea( aArea )
	MemoWrite( 'c:\temp\query.sld.inic.sql', cQuery )
Return nRet

/*/{Protheus.doc} GetBanco
Fun��o que exibe tela de marca��o dos bancos que ir�o compor o fluxo de caixa
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@return character, Lista de bancos em formato a ser utilizado na cl�usula IN de uma query
/*/
Static Function GetBanco()
	
	Local oOK     := LoadBitmap( GetResources(),'LBTIK')
	Local oNO     := LoadBitmap( GetResources(),'LBNO' )
	Local oDlg    := Nil
	Local oBrowse := Nil
	Local oBtnOk1 := Nil
	Local oBtnOk2 := Nil
	Local lCancela:= .F.
	Local aCabec  := { '', 'Banco', 'Ag�ncia', 'Conta', 'Nome' }
	Local aCabLen := { 20, 30, 30, 30, 50 }
	Local aBrowse := {}
	Local aBanco  := {}
	Local aAux    := {}
	Local cAux    := ''
	Local aArea   := GetArea()
	Local cRet    := ''
	Local nX      := 0
	Local nY      := 0
	Local uBancos := MemoRead( __cUserId + '.bco' )
	
	If ! Empty( uBancos )
	
		uBancos := StrTokArr2( uBancos, ',', .T. )
	
	End If
	
	// Popula array a ser utilizado no componente
	// de marca��o de com a lista de bancos cadastrados
	DbSelectArea( 'SA6' )
	SA6->( DbSetOrder( 1 ) )
	SA6->( DbGoTop() )
	
	Do While ! SA6->( Eof() )
		
		// Verifica se o Banco Pertence a Filial Corrente
		If xFilial( 'SA6' ) == SA6->A6_FILIAL
			
			// Popula array com dados do banco
			aAdd( aBanco, aScan( uBancos, SA6->( A6_COD + A6_AGENCIA + A6_NUMCON ) ) # 0 )
			aAdd( aBanco, SA6->A6_COD     )
			aAdd( aBanco, SA6->A6_AGENCIA )
			aAdd( aBanco, SA6->A6_NUMCON  )
			aAdd( aBanco, SA6->A6_NOME    )
			
			// Inclui linha do banco no array de lista de bancos
			aAdd( aBrowse, aClone( aBanco ) )
			
			// Esvazia array auxiliar
			aSize( aBanco, 0 )
			
		End If
		
		// Pr�xima Linha da Tabela
		SA6->( DbSkip() )
		
	End Do
	
	// Encerra a area da tabela de bancos
	SA6->( DbCloseArea() )
	
	// Retaura ambiente
	RestArea( aArea )
	
	// Monta janela de marca��o de banco a serem
	// considerados no Fluxo de Caixa
	DEFINE DIALOG oDlg TITLE 'Selecione os Bancos' FROM 180,180 TO 550,700 PIXEL
	
	// Cria o componete de marca��o
	oBrowse := TWBrowse():New( 01, 01, 260, 170,, aCabec, aCabLen, oDlg;
		,,,,,{||},,,,,,, .F.,, .T.,, .F.,,, )
	
	// Seta o array com a lista de bancos
	oBrowse:SetArray( aBrowse )
	
	// Define o bloco de c�dico a ser executado para
	// cada linha para popular o componente de marca��o
	oBrowse:bLine := { || {;
		If( aBrowse[ oBrowse:nAt , 01 ], oOK, oNO ),;
		aBrowse[ oBrowse:nAt, 02 ],;
		aBrowse[ oBrowse:nAt, 03 ],;
		aBrowse[ oBrowse:nAt, 04 ],;
		aBrowse[ oBrowse:nAt, 05 ] } }
	
	// Define o Bloco de C�digo a ser executado ao
	// clicar duas vezes na linha para marca��o da
	// mesma
	oBrowse:bLDblClick := { ||;
		aBrowse[ oBrowse:nAt, 1 ] := !aBrowse[ oBrowse:nAt, 1 ],;
		oBrowse:DrawSelect() }
	
	// Define Bloco de C�digo a ser executado ao
	// clicar no cabe�alho da coluna de marca��o
	// para inverter a sele��o
	oBrowse:bHeaderClick := { | oBrowse, nLinha | InvSelec( oBrowse, nLinha ) }
	
	// Define bot�o OK da tela de marca��o
	// que encerra a tela e segue com o programa
	// e o bot�o de cancelar que encerra a aplica�ao sem executar nada
	oBtnOk1 := SButton():New( 173, 200, 1, { || lCancela := .F., oDlg:End() }, oDlg, .T. )
	oBtnOk2 := SButton():New( 173, 230, 2, { || lCancela := .T., oDlg:End() }, oDlg, .T. )
	
	ACTIVATE DIALOG oDlg CENTERED
	
	// Verifica se foi clicado no bot�o cancela sai sem executar nenhuma a��o
	If ! lCancela
		
		// Popula array auxiliar com os bancos marcados
		For nX := 1 To Len( aBrowse )
			
			If aBrowse[ nX, 1 ]
				
				For nY := 2 To Len( aBrowse[ nX ] ) - 1
					
					cAux += aBrowse[ nX, nY ]
					
				Next nY
				
				aAdd( aAux, cAux )
				
				cAux := ''
				
			End If
			
		Next nX
		
		// Popula vari�vel de retorno com a lista de bancos marcados
		For nX := 1 To Len( aAux )
			
			cRet += aAux[ nX ]
			
			If nX # Len( aAux )
				
				cRet += ','
				
			End If
			
		Next nX
		
		MemoWrite( __cUserId + '.bco', cRet )
		
		// Verifica se nenhum banco foi selecionado e assim exibe alerta e encerra aplica��o
		If ! Empty( aAux )
			
			// Formata lista de bancos em formato a ser utilizado na cl�usula IN do SQL
			cRet := FormatIn( cRet, ',' )
			
		End If
		
	End If
	
Return cRet

/*/{Protheus.doc} InvSelec
Fun��o que faz a invers�o da sele��o ao clicar no cabe�alho da coluna de marca��o da linha
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param oBrowse, objeto, Objeto que representa o componente de marca��o dos bancos
@param nLinha, num�rico, Linha posicionada no componente de marca��o dos bancos
/*/
Static Function InvSelec( oBrowse, nLinha )
	
	Local nX := 0
	
	// Percorre array de marca��o invertente a sele��o
	For nX := 1 To Len( oBrowse:aArray )
		
		oBrowse:aArray[ nX, 1 ] := ! oBrowse:aArray[ nX, 1 ]
		
	Next nX
	
	// For�a a atualiza��o da tela de marca��o
	oBrowse:Refresh()
	
Return

/*/{Protheus.doc} MontaCabec
Fun�ao que que monta o cabe�alho das colunas do Fluxo de Caixa conforme o tipo de fluxo
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param aCabec, array, Array que ser� populado com as colunas do fluxo de caixa
@param cPeriodo, character, C�digo do per�odo definido para fluxo 1 - Di�rio, 2 - Anual
@param nMesReal, numeric, N�mero que representa o �ltimo m�s realizado
@param dDtBase, data, Data Base de Gera��o do Fluxo de Caixa
/*/
Static Function MontaCabec( aCabec, cPeriodo, nMesReal, dDtBase )
	
	Local cTpSld     := ''
	Local cDate      := ''
	Local nX         := 0
	
	// Adiciona a coluna das naturezas
	aAdd( aCabec, 'NATUREZAS' )
	
	// Se Fluxo di�rio popula o cabe�alho com as colunas dos dias do mes refer�ncia
	If cPeriodo == '1'
		
		For nX := 1 To Last_Day( dDtBase )
			
			// Monta string da data
			cDate := AnoMes( dDtBase )
			cDate += StrZero( nX, 2 )
			
			// Adiciona dia ao array
			aAdd( aCabec, DtoC( StoD( cDate ) ) )
			
		Next nX
		
		// Se Fluxo anual popula o array do cabe�alho com as colunas dos meses refer�ncia
		// considerando at� quando deve-se considerar o m�s realizado
	ElseIf cPeriodo == '2'
		
		For nX := 1 To 12
			
			// Verifica se o m�s deve ser considerado realizado
			If nX <= nMesReal
				
				cTpSld := 'REALIZADO'
				
			Else
				
				cTpSld := 'PREVISTO'
				
			End If
			
			// Adiciona m�s ao array
			aAdd( aCabec, Upper( MesExtenso( nX ) ) + ' - ' + cTpSld )
			
		Next nX
		
	EndIf
	
	aAdd( aCabec, 'TOTAL' )
	
Return

/*/{Protheus.doc} GetSldPrev
Busca os saldos or�ados/previstos das naturezas na per�odo da data base
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param dDtBase, data, Data Base de busca dos saldos or�ados/previstos das naturezas
@param cNatDe, character, Natureza inicial na busca dos saldos or�ados/previstos
@param cNatAte, character, Natureza final na busca dos saldos or�ados/previstos
@param aSldPrev, array, Array a ser populado com os saldos or�ados/previstos das naturezas
/*/
Static Function GetSldPrev( dDtBase, cNatDe, cNatAte, aSldPrev )
	
	Local aArea   := GetArea()
	Local cQuery  := ''
	Local cAno    := Year2Str( dDtBase )
	Local cMesCol := ''
	Local aAux    := {}
	Local aSld    := {}
	Local nX      := 0
	
	// Query de pesquisa
	cQuery += " SELECT "
	
	cQuery += " SE7.E7_ANO, "
	cQuery += " SE7.E7_NATUREZ, "
	cQuery += " SED.ED_DESCRIC, "
	cQuery += " SED.ED_XINGDES, "
	cQuery += " SE7.E7_VALJAN1, "
	cQuery += " SE7.E7_VALFEV1, "
	cQuery += " SE7.E7_VALMAR1, "
	cQuery += " SE7.E7_VALABR1, "
	cQuery += " SE7.E7_VALMAI1, "
	cQuery += " SE7.E7_VALJUN1, "
	cQuery += " SE7.E7_VALJUL1, "
	cQuery += " SE7.E7_VALAGO1, "
	cQuery += " SE7.E7_VALSET1, "
	cQuery += " SE7.E7_VALOUT1, "
	cQuery += " SE7.E7_VALNOV1, "
	cQuery += " SE7.E7_VALDEZ1  "
	
	cQuery += " FROM " + RetSqlName( "SE7" ) + " SE7 "
	
	cQuery += " LEFT JOIN " + RetSqlName( "SED" ) + " SED "
	cQuery += " ON  SE7.E7_FILIAL = SED.ED_FILIAL "
	cQuery += " AND SE7.E7_NATUREZ = SED.ED_CODIGO "
	
	cQuery += " WHERE SE7.D_E_L_E_T_ = '' "
	cQuery += " AND   SED.D_E_L_E_T_ = '' "
	cQuery += " AND   SE7.E7_FILIAL = '" + xFilial( "SE7" ) + "' "
	cQuery += " AND   SED.ED_FILIAL = '" + xFilial( "SED" ) + "' "
	cQuery += " AND   SE7.E7_ANO = '" + cAno + "' "
	cQuery += " AND   SE7.E7_NATUREZ BETWEEN '" + cNatDe + "' AND '" + cNatAte + "' "
	
	// Executa a query
	cAlias := MPSysOpenQuery( cQuery )
	
	// Posiciona no primeiro registro da Tabela
	( cAlias )->( DbGoTop() )
	
	// Percorre a tabela populando o array com os
	// saldos or�ados/previstos das naturezas
	Do While ! ( cAlias )->( Eof() )
		
		// Popula Array auxiliar com dados da linha posicionada
		aAdd( aAux, AllTrim( ( cAlias )->E7_NATUREZ ) )
		aAdd( aAux, AllTrim( ( cAlias )->ED_DESCRIC ) )
		aAdd( aAux, AllTrim( ( cAlias )->ED_XINGDES ) )
		
		// Popula array de saldos com os saldos dos meses
		For nX := 1 To 12
			
			// Monta o nome da coluna correspondente ao m�s
			cMesCol := 'E7_VAL'
			cMesCol += SubStr( Upper( MesExtenso( nX ) ), 1, 3 )
			cMesCol += '1'
			
			// Inclui saldo do m�s no array de saldos
			aAdd( aSld, ( cAlias )->&( cMesCol ) )
			
		Next nX
		
		// inclui array de saldos no array auxiliar
		aAdd( aAux, aClone( aSld ) )
		
		// Esvazia array de saldos
		aSize( aSld, 0 )
		
		// Inclui linha no array de saldos or�ados/previstos das naturezas
		aAdd( aSldPrev, aClone( aAux ) )
		
		//Esvazia vari�vel auxiliar
		aSize( aAux, 0 )
		
		// Pr�xima Linha da Tabela
		( cAlias )->( DbSkip() )
		
	End Do
	
	// Fecha alias tempor�rio
	( cAlias )->( DbCloseArea( ) )
	
	// Restaura ambiente
	RestArea( aArea )
	
Return

/*/{Protheus.doc} GetSldReal
Busca os saldos realizados das naturezas na per�odo da data base
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param cPeriodo, character, C�digo do per�odo definido para fluxo 1 - Di�rio, 2 - Anual
@param dDtBase, data, Data Base de Gera��o do Fluxo de Caixa
@param cNatDe, character, Natureza inicial na busca dos saldos realizados
@param cNatAte, character, Natureza final na busca dos saldos realizados
@param aSldReal, array, Array a ser populado com os saldos realizados das naturezas
@param cBancos, character, Lista de bancos em formato a ser utilizado na cl�usula IN da query que ir� buscar os saldo inicial do fluxo
@param nLen, numeric, Tamanhdo do array de saldos dependendo do n�mero de dias ou meses conforme o tipo de fluxo
/*/
Static Function GetSldReal( cPeriodo, dDtBase, cNatDe, cNatAte, aSldReal, cBancos, nLen )
	
	Local cQuery1    := ''
	Local cQuery2    := ''
	Local aArea      := GetArea()
	Local cTamDt     := ''
	Local cDataDe    := ''
	Local cDataAte   := ''
	Local aAlias     := {}
	Local oLine      := Nil
	Local nX         := 0
	Local nY         := 0
	Local nPos       := 0
	Local cMes       := Month2Str( dDtBase )
	Local cAno       := Year2Str( dDtBase )
	Local cSeek      := ''
	
	// Se Fluxo di�rio define que a data in�cio e fim do fluxo
	// ser�o a data inicial e final do m�s da data base e
	// na consulta ir� considerar ano-mes-dia pois a vari�vel
	// de tamanho da data ter� tamanho 8
	If cPeriodo == '1'
		
		cTamDt := '8'
		
		cDataDe  := DtoS( FirstDate( dDtBase ) )
		cDataAte := DtoS( LastDate( dDtBase ) )
		
		// Se Fluxo anual define que a data in�cio e fim do fluxo
		// ser�o a data inicial e final do ano da data base
		// na consulta ir� considerar ano-mes pois a vari�vel
		// de tamanho da data ter� tamanho 6
	ElseIf cPeriodo == '2'
		
		cTamDt := '6'
		
		cDataDe  := DtoS( FirstYDate( dDtBase ) )
		cDataAte := DtoS( LastYDate( dDtBase ) )
		
	End If
	
	
	// Query de busca na base os movimentos banc�rio que comp�em o movimento
	cQuery1 += " SELECT "
	
	cQuery1 += " SUBSTRING(SE5.E5_DTDISPO, 1, " + cTamDt + " ) E5_DTDISPO, "
	cQuery1 += " SE5.E5_NATUREZ, "
	cQuery1 += " SED.ED_DESCRIC, "
	cQuery1 += " SED.ED_XINGDES, "
	cQuery1 += " SE5.E5_RECPAG, "
	
	cQuery1 += " ( CASE "
	
	cQuery1 += " WHEN ( SED.ED_XINGDES = '1' AND "
	cQuery1 += " SE5.E5_RECPAG = 'R') OR "
	cQuery1 += " ( SED.ED_XINGDES = '2' AND "
	cQuery1 += " SE5.E5_RECPAG = 'P') THEN SE5.E5_VALOR "
	
	cQuery1 += " ELSE - SE5.E5_VALOR "
	
	cQuery1 += " END "
	
	cQuery1 += " ) E5_VALOR"
	
	cQuery1 += " FROM " + RetSqlName( "SE5" ) + " SE5 "
	
	cQuery1 += " LEFT JOIN " + RetSqlName( "SED" ) + " SED "
	cQuery1 += " ON SE5.E5_NATUREZ = SED.ED_CODIGO "
	
	cQuery1 += " WHERE SE5.E5_FILIAL = '" + xFilial('SE5') + "' "
	cQuery1 += " AND SED.D_E_L_E_T_ = '' "
	cQuery1 += " AND SE5.D_E_L_E_T_ = '' "
	cQuery1 += " AND SE5.E5_SITUACA <> 'C' "
	cQuery1 += " AND SE5.E5_NUMCHEQ <> '%*' "
	cQuery1 += " AND SE5.E5_TIPODOC NOT IN ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL') "
	cQuery1 += " AND ( ( SE5.E5_TIPODOC = 'VL' AND SE5.E5_TIPO ='CH' AND SE5.E5_RECPAG ='P' ) OR SE5.E5_TIPO <> 'CH') "
	
	// Seguindo mesma regra do relat�rio FINR620
	If SuperGetMV("MV_DTMOVRE",.T.,.F.)
		
		cQuery1 += " AND ( SE5.E5_VENCTO <= SE5.E5_DTDISPO Or"
		cQuery1 += " SE5.E5_ORIGEM ='FINA087A' Or SE5.E5_ORIGEM ='FINA070' Or"
		cQuery1 += " SE5.E5_ORIGEM ='FINA200' Or SE5.E5_ORIGEM ='FINA740' Or"
		cQuery1 += " SE5.E5_ORIGEM ='FINA100' Or SE5.E5_ORIGEM ='FINA430' Or"
		cQuery1 += " SE5.E5_ORIGEM ='FINA435' ) "
		
	Else
		
		cQuery1 += " AND ( SE5.E5_VENCTO <= SE5.E5_DTDISPO Or"
		cQuery1 += " SE5.E5_ORIGEM ='FINA087A' Or SE5.E5_ORIGEM ='FINA070' Or"
		cQuery1 += " SE5.E5_ORIGEM ='FINA200' Or SE5.E5_ORIGEM ='FINA740') "
		
	End If
	
	//cQuery1 += " AND SE5.E5_ORIGEM <> 'CNTA090' "
	
	cQuery1 += " AND SE5.E5_NATUREZ BETWEEN '" + cNatDe + "' AND '" + cNatAte + "' "
	
	cQuery1 += " AND SE5.E5_DTDISPO BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' "
	
	cQuery1 += " AND SE5.E5_BANCO + SE5.E5_AGENCIA + SE5.E5_CONTA IN " + cBancos + " "
	//TODO TIRAR ESTA LINHA
	MemoWrite( 'c:/temp/cQuery1.sql', cQuery1 )
	// Query que monta os saldos realizados do Fluxo
	cQuery2 += " SELECT "
	
	cQuery2 += " MOV_SE5.E5_DTDISPO, "
	cQuery2 += " MOV_SE5.E5_NATUREZ, "
	cQuery2 += " MOV_SE5.ED_DESCRIC, "
	cQuery2 += " SUM( MOV_SE5.E5_VALOR ) E5_VALOR "
	
	cQuery2 += " FROM (" + cQuery1 + ") MOV_SE5 "
	
	cQuery2 += " GROUP BY MOV_SE5.E5_DTDISPO, "
	cQuery2 += " MOV_SE5.E5_NATUREZ,  "
	cQuery2 += " MOV_SE5.ED_DESCRIC  "
	//TODO TIRAR ESTA LINHA
	MemoWrite( 'c:/temp/cQuery2.sql', cQuery2 )
	// Executa a query
	cAlias := MPSysOpenQuery( cQuery2 )
	
	// Posiciona na primeira linha da tabela
	( cAlias )->( DbGoTop() )
	
	// Percorre tabela populando array com as seus dados
	// tamb�m popula array com lista das naturezas
	Do While ! ( cAlias )->( Eof() )
		
		// Cria objeto da linha
		oLine := AliasLine():New()
		
		// Inclui valores aos dados correspondentes
		oLine:E5_DTDISPO    := AllTrim( ( cAlias )->E5_DTDISPO    )
		oLine:E5_NATUREZ := AllTrim( ( cAlias )->E5_NATUREZ )
		oLine:ED_DESCRIC := AllTrim( ( cAlias )->ED_DESCRIC )
		oLine:ED_XINGDES := Posicione( 'SED', 1, xFilial( 'SED' ) + AllTrim( ( cAlias )->E5_NATUREZ ), 'ED_XINGDES' )
		oLine:E5_VALOR   := ( cAlias )->E5_VALOR
		
		// Adiciona na lista do array que representa a pesquisa
		aAdd( aAlias, oLine )
		
		// Verifica se a natureza j� exite na lista de naturezas
		// se n�o exitir inclui
		If aScan( aSldReal, { | uItem | uItem[ 1 ] == AllTrim( ( cAlias )->E5_NATUREZ ) } ) == 0
			
			aAdd( aSldReal, ( cAlias )->(;
				{ AllTrim( E5_NATUREZ );
				, AllTrim( ED_DESCRIC );
				, Posicione( 'SED', 1, xFilial( 'SED' ) + AllTrim( ( cAlias )->E5_NATUREZ ), 'ED_XINGDES' );
				, Array( nLen ) } ) )
			
		End If
		
		// Pr�xima Linha
		( cAlias )->( DbSkip() )
		
	End Do
	
	// Percorre a lista de naturezas, busca seu valores conforme o per�odo do fluxo
	// dia a dia para di�rio e m�s a m�s para anual e popula o array de saldos
	For nX := 1 to Len( aSldReal )
		
		For nY := 1 To nLen
			
			If cPeriodo == '1'
				
				cSeek := cAno + cMes + StrZero( nY, 2 )
				
			ElseIf cPeriodo == '2'
				
				cSeek := cAno + StrZero( nY, 2 )
				
			End If
			
			nPos := aScan( aAlias, { | oLine |;
				oLine:E5_NATUREZ == aSldReal[ nX, 1 ] .And.;
				oLine:E5_DTDISPO == cSeek } )
			
			If nPos == 0
				
				aSldReal[ nX, 4, nY ] := 0
				
			Else
				
				aSldReal[ nX, 4, nY ] := aAlias[ nPos ]:E5_VALOR
				
			End If
			
		Next nY
		
	Next nX
	
	// Fecha alias tempor�rio
	( cAlias )->( DbCloseArea( ) )
	
	// Restaura ambiente
	RestArea( aArea )
	
Return

/*/{Protheus.doc} AliasLine
Classe que representa um linha na pesquisa de saldos realizados
@project MAN0000038865_EF_002
@type class Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
/*/
Class AliasLine
	
	Data E5_DTDISPO
	Data E5_NATUREZ
	Data ED_DESCRIC
	Data ED_XINGDES
	Data E5_VALOR
	
	Method New() Constructor
	
End Class

/*/{Protheus.doc} AliasLine:New
M�todo construtor da classe AliasLine
@project MAN0000038865_EF_002
@type Method Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param nil, nil,nil
/*/
Method New( ) Class AliasLine
	
	::E5_DTDISPO := ''
	::E5_NATUREZ := ''
	::ED_DESCRIC := ''
	::ED_XINGDES := ''
	::E5_VALOR   := ''
	
Return Self

/*/{Protheus.doc} MontaAlias
Gera tabela tempor�ria com o dados dos saldos realizados e previstos das naturezas
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param aSldPrev, array, Array populado com os saldos or�ados/previstos das naturezas
@param aSldReal, array, Array populado com os saldos realizados das naturezas
@return character, Nome do alias da tabela tempor�ria
/*/
Static Function MontaAlias( aSldPrev, aSldReal )
	
	Local nX         := 0
	Local nY         := 0
	Local cAlias     := GetNextAlias()
	Local oTempTable := FWTemporaryTable():New( cAlias )
	Local lRecLock   := .T.
	Local lRec       := .T.
	Local lVazia     := .T.
	
	oTempTable:SetFields( MontaEstr() )
	
	oTempTable:AddIndex( '01', { 'NAT' } )
	
	oTempTable:Create()
	
	// Popula alias com saldos previstos da natureza
	For nX := 1 To Len( aSldPrev )
		
		RecLock( cAlias, .T. )
		
		( cAlias )->NAT  := aSldPrev[ nX , 1 ] + ' - ' + NoAcento( aSldPrev[ nX , 2 ] )
		
		For nY := 1 To Len( aSldPrev[ nX, 4 ] )
			
			( cAlias )->&( 'ORC'  + StrZero( nY, 3 ) ) := aSldPrev[ nX, 4, nY ]
			
		Next nY
		
		( cAlias )->( MsUnlock() )
		
	Next nX
	
	// Caso esteja usando Fluxo Di�rio a tabela tempor�ria s�
	// � populada com o saldos realizado assim n�o cabe fazer DbSeek
	// para localizar a Natureza e sim inclu�-la direto pois a tabela
	// estar� vazia
	lVazia := ( cAlias )->( LastRec() ) = 0
	
	// Popula alias com saldos realizados da natureza
	For nX := 1 To Len( aSldReal )
		
		If ! lVazia
			
			lRecLock := aScan( aSldPrev, { |X| X[ 1 ] == aSldReal[ nX, 1 ] } ) == 0
			
			If ! lRecLock
				
				( cAlias )->( DbSeek( aSldReal[ nX, 1 ] ) )
				
			End If
			
		End If
		
		lRec := RecLock( cAlias, lRecLock )
		
		( cAlias )->NAT  := AllTrim( aSldReal[ nX , 1 ] ) + ' - ' + AllTrim( NoAcento( aSldReal[ nX , 2 ] ) )
		
		For nY := 1 To Len( aSldReal[ nX, 4 ] )
			
			( cAlias )->&( 'REAL'  + StrZero( nY, 3 ) ) := aSldReal[ nX, 4, nY ]
			
		Next nY
		
		( cAlias )->( MsUnlock() )
		
	Next nX
	
Return cAlias

/*/{Protheus.doc} MontaEstr
Monta array com a estrutura do alias da tabela tempor�ria
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@return array, Array com a estrutura do alias a ser criado
/*/
Static Function MontaEstr()
	
	Local aRet := {}
	Local nX   := 0
	
	aAdd( aRet, { 'NAT' , 'C', 50, 0 } )
	
	For nX := 1 To 31
		
		aAdd( aRet, { 'ORC'  + StrZero( nX, 3 ), 'N', 16, 2 } )
		aAdd( aRet, { 'REAL' + StrZero( nX, 3 ), 'N', 16, 2 } )
		
	Next nX
	
Return aRet

/*/{Protheus.doc} AjSldInic
Monta array com a estrutura do alias da tabela tempor�ria
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param nSaldo, numeric, Saldo inicial constante na tabela SE8
@param cReferencia, numeric, Dia de refer�ncia do saldo inicial lido na SE8
@return numeric, Saldo Inicial que consta no formul�rio
/*/
Static Function AjSldInic( nSaldo, cReferencia )
	
	Local nRet := nSaldo
	
	DEFINE MSDIALOG oDlg TITLE "SALDO BANC�RIO EM " + cReferencia FROM 000, 000  TO 100, 300 COLORS 0, 16777215 PIXEL
	
	TGet():New( 015, 015, { | u | If( PCount() == 0, nRet, nRet := u ) },oDlg, ;
		130, 010, "@E 9,999,999,999,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nRet",,,,.T.  )
	
	SButton():New( 035, 105, 1, { || oDlg:End() }, oDlg, .T. )
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return nRet