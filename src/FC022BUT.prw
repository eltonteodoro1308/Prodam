#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} FC022BUT
Adiciona opção em Ações Relacionadas da rotina de Fluxo de Caixa por Natureza - FINC022
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@return array, Retorna um array com a(s) nova(s) opção(ões) que será(ão) adicionada(s) ao botão Ações relacionadas
/*/
User Function FC022BUT()

	Local aParam       := aClone( PARAMIXB )
	Local aUsButtons   := {}
	Local bFluxo2Excel := { || Fluxo2Excel( aParam ) }
	Local bMsAguarde   := { || MsAguarde( bFluxo2Excel, 'Executando ...', 'Mensagem...',.F. ) }

	aUsButtons := { { "", bMsAguarde, "Gera em excel os fluxos de caixa diário e anual para o Portal da Transparência", "Portal Transparência" } }

Return aUsButtons

/*/{Protheus.doc} Fluxo2Excel
Gera Planilha Excel com base na tabela temporária descrita no PARAMIXB[2]
A planilha se baseia quando o Período é Diário ou Mensal, em outro período não gera.
Também gera somente quando o modelo for Sintético.
Quando o Período for Diário a data inicial e final deve compreender o primeiro e último dia do Mês
Quando o Período for Mensal a data inicial e final deve compreender o primeiro e último dia do Ano
@project MAN0000038865_EF_002
@type function Rotina Específica
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

	// Verifica a quantidade níveis do Fluxo
	If ! ParamBox({{1,'Quantidade de Níveis',Len(aMasc),'@','.T.',,'.T.',50,.F.}},'',@aRet,,,,,,,'Fluxo2Excel',.T.,.T.)

		aRet := {999}

	End If

	//lExecuta := lExecuta .And. lFluxSint // Verifica se Considera Fluxo Sintético
	lExecuta := lExecuta .And. cValToChar( MV_PAR05 ) $ '13' // Verifica se Mostra Períodos em Dias ou Meses

	If MV_PAR05 == 1

		// Se Período em Dias Verifica se a Data Inicial é o Primeiro dia do Mês e
		// se a Data Final é o Último dia do mês

		lExecuta := lExecuta .And. FirstDate( MV_PAR03 ) == MV_PAR03
		lExecuta := lExecuta .And. LastDate ( MV_PAR04 ) == MV_PAR04

	ElseIf MV_PAR05 == 3

		// Se Período em Meses Verifica se a Data Inicial é o Primeiro dia do Ano e
		// se a Data Final é o Último dia do Ano

		lExecuta := lExecuta .And. Day  ( MV_PAR03 ) == 01
		lExecuta := lExecuta .And. Month( MV_PAR03 ) == 01
		lExecuta := lExecuta .And. Day  ( MV_PAR04 ) == 31
		lExecuta := lExecuta .And. Month( MV_PAR04 ) == 12

	End If

	If ! lExecuta // Se Alguma condição não for atendida exibe mensagem para o usuário e encerra a função

		AutoGrLog( 'Permitido Executar Apenas para:' )
		AutoGrLog( '' )
		AutoGrLog( '- Fluxo sintético.' )
		AutoGrLog( '' )
		AutoGrLog( '- Período em Dias ou Meses.')
		AutoGrLog( '' )
		AutoGrLog( '- Se período em dias a data inicial deve ser o primeiro dia do mês e a data final o último dia do mês.' )
		AutoGrLog( '' )
		AutoGrLog( '- Se período em meses a data inicial deve ser o primeiro dia do ano e a data final o último dia do ano.' )

		MostraErro()

		Return

	End If

	MsProcTxt( 'Montando Cabeçalho.' )

	// Populando o Array com os nomes das colunas da planilha a ser gerada
	// Se o período for Diário considera a coluna de Naturesas e as colunas de saldo realizado de cada dia do mês
	// Se o período for Mensal considera a coluna de Naturezas, as colunas de saldo Realizado do meses anteriores ao Mês corrente (dDataBase) e
	// as colunas de saldo Orçado do mês corrente e dos meses posteriores a este.
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

	// Somente se o período for Mensal inclui coluna de Total
	If MV_PAR05 = 3

		aAdd( aCabec, 'TOTAL' )

	End If

	// Populando os array correspondentes as linhas de Saldo de Ingressos,
	// Entradas, Saldo de Desembolso, Linha de Saída, Saldo Líquido, Saldo Inicial, Saldo Final
	(cAlias)->( DbGoTop() )

	Do While ! (cAlias)->( Eof() )

		// Se a linha não corresponder ao saldo de uma natureza, substitui o nome da mesma confome abaixo
		cNat := AllTrim( Upper( NoAcento( (cAlias)->NAT ) ) )

		MsProcTxt( 'Montando Linhas: ' + cNat )
		ProcessMessage()

		// Verifica se a linha é uma natureza se tiver um hífen separando o código do nome da natureza
		If Len( StrTokArr2(cNat,'-', .T.) ) > 1

			// Se Natureza estiver em nível superior ao definido pelo usuário pula para próxima

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

			aAdd( aColunas, 'LÍQUIDO' )

		ElSeIf 'SALDO FINAL' $ cNat

			aAdd( aColunas, 'SALDO FINAL' )

		Else

			aAdd( aColunas, cNat )

		End If


		// Popula os arrays com saldos da naturezas de entrada e saída

		// Fluxo Diário
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

		// Popula os array´s com os totais do perído
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

	// Executa função para gerar planilha do Excel com base nos dados dos arrays correspondentes a cada linha
	ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido, aSldInicial, aSldFinal )

Return

/*/{Protheus.doc} MesNum
Função que localiza no nome da coluna o mês correspondente e retorna o número deste mês
@project MAN0000038865_EF_002
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 30/10/2018
@param cColName, characters, Nome da Coluna
@return return, Número correspondente ao mês localizado no nome da coluna
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
@type function Rotina EspecÃ­fica
@version P12
@author TOTVS
@since 30/10/2018
@param aCabec, array, Nomes da Colunas
@param aIngresso, array, Saldos totais de Ingressos da Naturezas
@param aLinEntrada, array, Saldos de Entradas na Natureza
@param aDesembolso, array, Saldos totais de Desembolso da Naturezas
@param aLinSaida, array, Saldos de Saídas na Natureza
@param aSldLiquido, array, Saldos totais Líquido da Naturezas
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

	ApMsgInfo( 'O arquivo ' + cArquivo + ' foi gerado com sucesso.', 'Atenção !!!' )

	//oMsExcel:WorkBooks:Open( cArquivo )
	//oMsExcel:SetVisible( .T. )
	//oMsExcel:Destroy()

Return