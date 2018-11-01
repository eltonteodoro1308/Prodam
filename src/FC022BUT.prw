#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} FC022BUT
Adiciona op��o em A��es Relacionadas da rotina de Fluxo de Caixa por Natureza - FINC022
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@return array, Retorna um array com a(s) nova(s) op��o(�es) que ser�(�o) adicionada(s) ao bot�o A��es relacionadas
/*/
User Function FC022BUT()

	Local aParam       := aClone( PARAMIXB )
	Local aUsButtons   := {}
	Local bFluxo2Excel := { || Fluxo2Excel( aParam ) }
	Local bMsAguarde   := { || MsAguarde( bFluxo2Excel, 'Executando ...', 'Mensagem...',.F. ) }

	aUsButtons := { { "", bMsAguarde, "Gera em excel os fluxos de caixa di�rio e anual para o Portal da Transpar�ncia", "Portal Transpar�ncia" } }

Return aUsButtons

/*/{Protheus.doc} Fluxo2Excel
Gera Planilha Excel com base na tabela tempor�ria descrita no PARAMIXB[2]
A planilha se baseia quando o Per�odo � Di�rio ou Mensal, em outro per�odo n�o gera.
Tamb�m gera somente quando o modelo for Sint�tico.
Quando o Per�odo for Di�rio a data inicial e final deve compreender o primeiro e �ltimo dia do M�s
Quando o Per�odo for Mensal a data inicial e final deve compreender o primeiro e �ltimo dia do Ano
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
/*/
Static Function Fluxo2Excel( aParam )

	Local cAlias      := aParam[ 2 ]
	Local aArea       := GetArea()
	Local aAreaAlias  := (cAlias)->(GetArea())
	Local aCabec      := {}
	Local cCabec      := ''
	Local nMesBase    := Month( dDataBase )
	Local nMesCol     := 0
	Local aLinEntrada := {}
	Local aLinSaida   := {}
	Local aIngresso   := {}
	Local aDesembolso := {}
	Local aSldLiquido := {}
	Local aSldInicial := {}
	Local aSldFinal   := {}
	Local aColunas    := {}
	Local cNat        := ''
	Local cNatAux     := ''
	Local nX          := 0
	Local lExecuta    := .T.
	Local aRet        := {}

	// Verifica a quantidade n�veis do Fluxo
	If ! ParamBox({{1,'Quantidade de N�veis',Len(aMasc),'@','.T.',,'.T.',50,.F.}},'',@aRet,,,,,,,'Fluxo2Excel',.T.,.T.)

		aRet := {999}

	End If

	//lExecuta := lExecuta .And. lFluxSint // Verifica se Considera Fluxo Sint�tico
	lExecuta := lExecuta .And. cValToChar( MV_PAR05 ) $ '13' // Verifica se Mostra Per�odos em Dias ou Meses

	If MV_PAR05 == 1

		// Se Per�odo em Dias Verifica se a Data Inicial � o Primeiro dia do M�s e
		// se a Data Final � o �ltimo dia do m�s

		lExecuta := lExecuta .And. FirstDate( MV_PAR03 ) == MV_PAR03
		lExecuta := lExecuta .And. LastDate ( MV_PAR04 ) == MV_PAR04

	ElseIf MV_PAR05 == 3

		// Se Per�odo em Meses Verifica se a Data Inicial � o Primeiro dia do Ano e
		// se a Data Final � o �ltimo dia do Ano

		lExecuta := lExecuta .And. Day  ( MV_PAR03 ) == 01
		lExecuta := lExecuta .And. Month( MV_PAR03 ) == 01
		lExecuta := lExecuta .And. Day  ( MV_PAR04 ) == 31
		lExecuta := lExecuta .And. Month( MV_PAR04 ) == 12

	End If

	If ! lExecuta // Se Alguma condi��o n�o for atendida exibe mensagem para o usu�rio e encerra a fun��o

		AutoGrLog( 'Permitido Executar Apenas para:' )
		AutoGrLog( '' )
		AutoGrLog( '- Fluxo sint�tico.' )
		AutoGrLog( '' )
		AutoGrLog( '- Per�odo em Dias ou Meses.')
		AutoGrLog( '' )
		AutoGrLog( '- Se per�odo em dias a data inicial deve ser o primeiro dia do m�s e a data final o �ltimo dia do m�s.' )
		AutoGrLog( '' )
		AutoGrLog( '- Se per�odo em meses a data inicial deve ser o primeiro dia do ano e a data final o �ltimo dia do ano.' )

		MostraErro()

		Return

	End If

	MsProcTxt( 'Montando Cabe�alho.' )

	// Populando o Array com os nomes das colunas da planilha a ser gerada
	// Se o per�odo for Di�rio considera a coluna de Naturesas e as colunas de saldo realizado de cada dia do m�s
	// Se o per�odo for Mensal considera a coluna de Naturezas, as colunas de saldo Realizado do meses anteriores ao M�s corrente (dDataBase) e
	// as colunas de saldo Or�ado do m�s corrente e dos meses posteriores a este.
	For nX := 1 To Len( oFluxo:aColumns )

		cCabec  := AllTrim( Upper( NoAcento( oFluxo:aColumns[ nX ]:cTitle ) ) )
		nMesCol := MesNum( cCabec )

		If 'NATUREZA' $ cCabec

			aAdd( aCabec, cCabec )

		ElseIf MV_PAR05 = 1 .And. 'REALIZADO' $ cCabec .And. ! 'TOTAL' $ cCabec .And. ! '01/' + StrZero( Month( MV_PAR03 ) + 1, 2 ) $ cCabec

			cCabec := StrTran( cCabec, 'REALIZADO', '' )
			cCabec := AllTrim( StrTokArr2(cCabec,'/', .T.)[1] )

			aAdd( aCabec, cCabec )

		ElseIf MV_PAR05 = 3 .And. 'REALIZADO' $ cCabec .And. ! 'TOTAL' $ cCabec .And. nMesBase > nMesCol .And. ! cValToChar( Year( MV_PAR03 ) + 1 ) $ cCabec

			cCabec := AllTrim( StrTran( cCabec, '/' + cValToChar( Year( MV_PAR03 ) ), '' ) )

			aAdd( aCabec, StrTokArr2(cCabec,' ', .T.)[2] + ' - ' + StrTokArr2(cCabec,' ', .T.)[1] )

		ElseIf MV_PAR05 = 3 .And. 'ORCADO' $ cCabec .And. ! 'TOTAL' $ cCabec .And. nMesBase <= nMesCol .And. ! cValToChar( Year( MV_PAR03 ) + 1 ) $ cCabec

			cCabec := AllTrim( StrTran( cCabec, '/' + cValToChar( Year( MV_PAR03 ) ), '' ) )

			aAdd( aCabec, StrTran( StrTokArr2(cCabec,' ', .T.)[2] + ' - ' + StrTokArr2(cCabec,' ', .T.)[1], 'ORCADO', 'PLANEJADO' ) )

		End If

	Next nX

	// Somente se o per�odo for Mensal inclui coluna de Total
	If MV_PAR05 = 3

		aAdd( aCabec, 'TOTAL' )

	End If

	// Populando os array correspondentes as linhas de Saldo de Ingressos,
	// Entradas, Saldo de Desembolso, Linha de Sa�da, Saldo L�quido, Saldo Inicial, Saldo Final
	(cAlias)->( DbGoTop() )

	Do While ! (cAlias)->( Eof() )

		// Se a linha n�o corresponder ao saldo de uma natureza, substitui o nome da mesma confome abaixo
		cNat := AllTrim( Upper( NoAcento( (cAlias)->NAT ) ) )

		MsProcTxt( 'Montando Linhas: ' + cNat )
		ProcessMessage()

		// Verifica se a linha � uma natureza se tiver um h�fen separando o c�digo do nome da natureza
		If Len( StrTokArr2(cNat,'-', .T.) ) > 1

			// Se Natureza estiver em n�vel superior ao definido pelo usu�rio pula para pr�xima

			cNatAux := AllTrim( StrTokArr2(cNat,'-', .T.)[1] )

			If Len( StrTokArr2(cNat,'.', .T.)[1] ) > aRet[1]

				(cAlias)->( DbSkip() )

				LOOP

			End If

			cNat := AllTrim( StrTokArr2(cNat,'-', .T.)[1] ) + ' - ' + AllTrim( StrTokArr2(cNat,'-', .T.)[2] )

		End If

		If 'SALDOS INICIAIS' $ cNat

			aAdd( aColunas, 'SALDO INICIAL' )

		ElSeIf 'TOTAIS DE ENTRADAS' $ cNat

			aAdd( aColunas, 'INGRESSOS' )

		ElSeIf 'TOTAIS DE SAIDAS' $ cNat

			aAdd( aColunas, 'DESEMBOLSOS' )

		ElSeIf 'SALDO OPERACIONAL' $ cNat

			aAdd( aColunas, 'L�QUIDO' )

		ElSeIf 'SALDO FINAL' $ cNat

			aAdd( aColunas, 'SALDO FINAL' )

		Else

			aAdd( aColunas, cNat )

		End If


		// Popula os arrays com saldos da naturezas de entrada e sa�da

		// Fluxo Di�rio
		If MV_PAR05 = 1

			For nX := 1 To Day( LastDate ( MV_PAR04 ) )

				aAdd( aColunas, (cAlias)->&('REAL0' + StrZero( nX, 2 ) ) )

			Next nX

			// Fluxo Anual
		ElseIf MV_PAR05 = 3

			For nX := 1 To 12

				If nMesBase >= nX

					aAdd( aColunas, (cAlias)->&('REAL0' + StrZero( nX, 2 ) ) )

				Else

					aAdd( aColunas, (cAlias)->&('ORC0' + StrZero( nX, 2 ) ) )

				End If

			Next nX

			aAdd( aColunas, (cAlias)->( ORCTOT + REALTOT ) )

		End If

		// Popula os array�s com os totais do per�do
		If 'SALDOS INICIAIS' $ cNat

			aAdd( aSldInicial, aClone( aColunas ) )

		ElSeIf 'TOTAIS DE ENTRADAS' $ cNat

			aAdd( aIngresso, aClone( aColunas ) )

		ElSeIf 'TOTAIS DE SAIDAS' $ cNat

			aAdd( aDesembolso, aClone( aColunas ) )

		ElSeIf 'SALDO OPERACIONAL' $ cNat

			aAdd( aSldLiquido, aClone( aColunas ) )

		ElSeIf 'SALDO FINAL' $ cNat

			aAdd( aSldFinal, aClone( aColunas ) )

		Else

			If Empty( aIngresso )

				aAdd( aLinEntrada, aClone( aColunas ) )

			Else

				aAdd( aLinSaida, aClone( aColunas ) )

			End IF

		End If

		aSize( aColunas, 0 )

		(cAlias)->( DbSkip() )

	End Do

	RestArea( aAreaAlias )
	RestArea( aArea )

	// Executa fun��o para gerar planilha do Excel com base nos dados dos arrays correspondentes a cada linha
	ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido, aSldInicial, aSldFinal )

Return

/*/{Protheus.doc} MesNum
Fun��o que localiza no nome da coluna o m�s correspondente e retorna o n�mero deste m�s
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param cColName, characters, Nome da Coluna
@return return, N�mero correspondente ao m�s localizado no nome da coluna
/*/
Static Function MesNum( cColName )

	Local aMeses := {}
	Local nX     := 0
	Local nRet   := 0

	aAdd( aMeses, 'JANEIRO'   )
	aAdd( aMeses, 'FEVEREIRO' )
	aAdd( aMeses, 'MARCO'     )
	aAdd( aMeses, 'ABRIL'     )
	aAdd( aMeses, 'MAIO'      )
	aAdd( aMeses, 'JUNHO'     )
	aAdd( aMeses, 'JULHO'     )
	aAdd( aMeses, 'AGOSTO'    )
	aAdd( aMeses, 'SETEMBRO'  )
	aAdd( aMeses, 'OUTUBRO'  )
	aAdd( aMeses, 'NOVEMBRO'  )
	aAdd( aMeses, 'DEZEMBRO'  )

	For nX := 1 To Len( aMeses )

		If aMeses[ nX ] $ cColName

			nRet := nX

			Exit

		End If

	Next nX

Return nRet

/*/{Protheus.doc} ToExcel
Gera planilha do Excel com base nos dados coletados do Alias exibido no Fluxo de Caixa
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param aCabec, array, Nomes da Colunas
@param aIngresso, array, Saldos totais de Ingressos da Naturezas
@param aLinEntrada, array, Saldos de Entradas na Natureza
@param aDesembolso, array, Saldos totais de Desembolso da Naturezas
@param aLinSaida, array, Saldos de Sa�das na Natureza
@param aSldLiquido, array, Saldos totais L�quido da Naturezas
@param aSldInicial, array, Saldos totais de Iniciais da Naturezas
@param aSldFinal, array, Saldos totais de Finais da Naturezas
/*/
Static Function ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido, aSldInicial, aSldFinal )

	Local cArquivo   := cGetFile(,,,,,,.F.) + '.xml' //GetTempPath() + 'Fluxo2Excel.xml'
	Local oFwMsExcel := FwMsExcelEx():New()
	Local oMsExcel   := MsExcel():New()
	Local nX         := 0
	Local nAlign     := 0
	Local nFormat    := 0
	Local cDiario    := 'DIARIO ' + Upper( MesExtenso( Month( MV_PAR03 ) ) ) + '/' + cValToChar( Year( MV_PAR03 ) )
	Local cAnual     := 'ANUAL ' + cValToChar( Year( MV_PAR03 ) )
	Local cWorkSheet := If( MV_PAR05 = 1, cDiario, cAnual )
	Local cTable     := 'FLUXO DE CAIXA POR NATUREZA ' + cWorkSheet
	Local aCelStyle  := {}
	Local cNatAux    := ''

	For nX := 1 To Len( aCabec )

		aAdd( aCelStyle, nX )

	Next nX

	oFwMsExcel:SetFont( 'Calibri' )
	oFwMsExcel:SetFrGeneralColor( '#000000' )
	oFwMsExcel:SetBgGeneralColor( '#FFFFFF' )
	oFwMsExcel:SetFontSize(10)

	oFwMsExcel:AddworkSheet( cWorkSheet )
	oFwMsExcel:AddTable ( cWorkSheet, cTable  )

	For nX := 1 to Len( aCabec )

		If nX == 1

			nAlign  := 1
			nFormat := 1

		Else

			nAlign  := 3
			nFormat := 2

		End If

		oFWMSExcel:AddColumn( cWorkSheet, cTable, aCabec[ nX ], nAlign, nFormat, .F. )

	Next nX

	oFWMSExcel:SetCelSizeFont(8)

	oFWMSExcel:SetCelBold(.T.)
	oFWMSExcel:SetCelBgColor( '#DAEEF3' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aIngresso[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aIngresso[1,1] )

	oFWMSExcel:SetCelBgColor( '#FFFFFF' )
	For nX := 1 To Len( aLinEntrada )

		oFWMSExcel:SetCelBold(.F.)

		cNatAux := AllTrim( StrTokArr2( aLinEntrada[nX,1], '-', .T. )[1] )

		If Len( StrTokArr2( cNatAux, '.', .T. ) ) == 1

			oFWMSExcel:SetCelBold(.T.)

		End If

		oFWMSExcel:AddRow( cWorkSheet, cTable, aLinEntrada[nX], aCelStyle )
		MsProcTxt( 'Montando Planilha: ' + aLinEntrada[nX,1] )
		ProcessMessage()

	Next nX

	oFWMSExcel:SetCelBold(.T.)
	oFWMSExcel:SetCelBgColor(  '#DAEEF3' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aDesembolso[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aDesembolso[1,1] )

	oFWMSExcel:SetCelBgColor( '#FFFFFF' )
	For nX := 1 To Len( aLinSaida )

		oFWMSExcel:SetCelBold(.F.)

		cNatAux := AllTrim( StrTokArr2( aLinSaida[nX,1], '-', .T. )[1] )

		If Len( StrTokArr2( cNatAux, '.', .T. ) ) == 1

			oFWMSExcel:SetCelBold(.T.)

		End If

		oFWMSExcel:AddRow( cWorkSheet, cTable, aLinSaida[nX], aCelStyle )
		MsProcTxt( 'Montando Planilha: ' + aLinSaida[nX,1] )
		ProcessMessage()

	Next nX

	oFWMSExcel:SetCelBold(.T.)

	oFWMSExcel:SetCelBgColor( '#DAEEF3' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aSldLiquido[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aSldLiquido[1,1] )

	oFWMSExcel:SetCelBgColor( '#FFFFFF' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aSldInicial[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aSldInicial[1,1] )

	oFWMSExcel:SetCelBgColor( '#FFFFCC' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aSldFinal[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aSldFinal[1,1] )

	oFWMSExcel:Activate()
	oFWMSExcel:GetXMLFile( cArquivo )

	ApMsgInfo( 'O arquivo ' + cArquivo + ' foi gerado com sucesso.', 'Aten��o !!!' )

	//oMsExcel:WorkBooks:Open( cArquivo )
	//oMsExcel:SetVisible( .T. )
	//oMsExcel:Destroy()

Return