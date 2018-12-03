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
	
	aUsButtons := { { '', bMsAguarde, '', 'Portal Transparência' } }
	
Return aUsButtons

/*/{Protheus.doc} Fluxo2Exceladmin
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
	Local nSldInic    := 0
	Local nLen        := 0
	Local aColunas    := {}
	Local oNatureza   := Nil
	Local aNaturezas  := {}
	Local aAux        := {}
	Local cCondNat    := ''
	Local cCodNat     := ''
	Local cDescNat    := ''
	Local aSaldos     := Nil
	Local nX          := 0
	Local nY          := 0
	Local lExecuta    := .T.

	//TODO
	/*
	- Documentar corretamente o fonte
	- Verificar variáveis que não foram utilizadas
	- Comentar partes relevantes do fonte
	*/
	
	lExecuta := lExecuta .And. lFluxSint // Verifica se Fluxo é Sintético
	lExecuta := lExecuta .And. MV_PAR13 == 2 // Verifica se exibe Naturezas Sintéticas
	lExecuta := cValToChar( MV_PAR05 ) $ '13' // Verifica se Mostra Períodos em Dias ou Meses
	
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
		AutoGrLog( '- Fluxo definido como Sintético' )
		AutoGrLog( '' )
		AutoGrLog( '- Definir para não exibir as naturezas sintéticas' )
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
			cCabec := AllTrim( cCabec ) + '/' + cValToChar( Year( MV_PAR03 ) )
			
			aAdd( aCabec, cCabec )
			
		ElseIf MV_PAR05 = 3 .And. 'REALIZADO' $ cCabec .And. ! 'TOTAL' $ cCabec .And. nMesBase > nMesCol .And. ! cValToChar( Year( MV_PAR03 ) + 1 ) $ cCabec
			
			cCabec := AllTrim( StrTran( cCabec, '/' + cValToChar( Year( MV_PAR03 ) ), '' ) )
			
			aAdd( aCabec, StrTokArr2(cCabec,' ', .T.)[2] + ' - ' + StrTokArr2(cCabec,' ', .T.)[1] )
			
		ElseIf MV_PAR05 = 3 .And. 'ORCADO' $ cCabec .And. ! 'TOTAL' $ cCabec .And. nMesBase <= nMesCol .And. ! cValToChar( Year( MV_PAR03 ) + 1 ) $ cCabec
			
			cCabec := AllTrim( StrTran( cCabec, '/' + cValToChar( Year( MV_PAR03 ) ), '' ) )
			
			aAdd( aCabec, StrTran( StrTokArr2(cCabec,' ', .T.)[2] + ' - ' + StrTokArr2(cCabec,' ', .T.)[1], 'ORCADO', 'PREVISTO' ) )
			
		End If
		
	Next nX
	
	aAdd( aCabec, 'TOTAL' )
	
	nLen := Len( aCabec )
	
	// Popula Array com a lista de Naturezas que irão compor o Fluxo
	(cAlias)->( DbGoTop() )
	
	nSldInic := (cAlias)->REAL001
	
	Do While ! (cAlias)->( Eof() )
		
		MsProcTxt( AllTrim( Upper( NoAcento( (cAlias)->NAT ) ) ) )
		
		cCondNat := Posicione( 'SED', 1, xFilial( 'SED' ) + AllTrim( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 1 ] ), 'ED_COND' )
		cCodNat   := AllTrim( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 1 ] )
		
		// Verificar se a natureza não é uma redutora para adicionar a lista
		If ( ( (cAlias)->CART == 'R' .And. cCondNat == 'R' ) .Or.;
				( (cAlias)->CART == 'P' .And. cCondNat == 'D' ) ) .And.;
				! IsRedutora( cCodNat )
			
			cDescNat  := AllTrim( NoAcento( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 2 ] ) )
			
			oNatureza := FC022NAT():New( nLen )
			
			oNatureza:cCodigo   := cCodNat
			oNatureza:cNatureza := cDescNat
			oNatureza:cCondicao := Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo,'ED_COND' )
			oNatureza:cTipo     := IF( Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo,'ED_TIPO' )=='1','S','A')
			oNatureza:cRedutora := AllTrim( Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo,'ED_NATMT' ) )//TODO usando campo ED_NATMT mas criar ED_XNATRED
			oNatureza:cSeq      := (cAlias)->SEQ
			oNatureza:cCart     := (cAlias)->CART
			
			aAdd( aNaturezas, oNatureza )
			
		End If
		
		(cAlias)->( DbSkip() )
		
	End Do
	
	// Percorre lista de naturezas e monta os saldos
	For nX := 1 To Len( aNaturezas )
		
		GetSaldos( aNaturezas[ nX ],cAlias, nMesBase )
		
	Next nX
	
	// Descarta as naturezas que estão zeradas em todos os dias ou meses
	For nX := 1 To Len( aNaturezas )
		
		If ! IsZerada( aNaturezas[ nX ]:aSaldos )
			
			aAdd( aAux, aNaturezas[ nX ] )
			
		End If
		
	Next
	
	aSize( aNaturezas, 0 )
	
	aNaturezas := aClone( aAux )
	
	aSize( aAux, 0 )
	
	/*
	Monta array´s dos Saldos dos:
	
	- Ingressos
	- Desembolsos
	- Líquido
	- Inicial
	- Final
	
	*/
	
	aIngresso   := { Array( nLen ) }
	aDesembolso := { Array( nLen ) }
	aSldLiquido := { Array( nLen ) }
	aSldInicial := { Array( nLen ) }
	aSldFinal   := { Array( nLen ) }
	
	// Monta Array´s iniciando valores
	For nX := 1 To nLen
		
		If nX == 1
			
			aIngresso  [ 1, nX ] := 'INGRESSOS'
			aDesembolso[ 1, nX ] := 'DESEMBOLSOS'
			aSldLiquido[ 1, nX ] := 'LÍQUIDO'
			aSldInicial[ 1, nX ] := 'SALDO INICIAL'
			aSldFinal  [ 1, nX ] := 'SALDO FINAL'
			
		Else
			
			aIngresso  [ 1, nX ] := 0
			aDesembolso[ 1, nX ] := 0
			aSldLiquido[ 1, nX ] := 0
			aSldInicial[ 1, nX ] := 0
			aSldFinal  [ 1, nX ] := 0
			
		End If
		
	Next nX
	
	// Popula array de ingresso e de desembolso
	For nX := 1 To Len( aNaturezas )
		
		If aNaturezas[ nX ]:cCondicao == 'R'
			
			For nY := 2 To Len( aIngresso[ 1 ] )
				
				aIngresso[ 1, nY ] += aNaturezas[ nX ]:aSaldos[ nY - 1 ]
				
			Next nY
			
		ElseIf aNaturezas[ nX ]:cCondicao == 'D'
			
			For nY := 2 To Len( aDesembolso[ 1 ] )
				
				aDesembolso[ 1, nY ] += aNaturezas[ nX ]:aSaldos[ nY - 1 ]
				
			Next nY
			
		End If
		
	Next nX
	
	// Popula 	array de Saldo Líquido
	For nX := 2 To Len( aSldLiquido[ 1 ] )
		
		aSldLiquido[ 1, nX ] += aIngresso[ 1, nX ]
		
	Next nX
	
	For nX := 2 To Len( aSldLiquido[ 1 ] )
		
		aSldLiquido[ 1, nX ] -= aDesembolso[ 1, nX ]
		
	Next nX
	
	// Popula Array Saldos Inicial e Final
	For nX := 2 To nLen - 1 //If( MV_PAR05 = 3, nLen - 1, nLen )
		
		If nX == 2
			
			aSldInicial[ 1, nX] := nSldInic
			
		Else
			
			aSldInicial[ 1, nX] := aSldFinal  [ 1, nX - 1 ]
			
		End If
		
		aSldFinal  [ 1, nX] := aSldInicial[ 1, nX] + aSldLiquido[ 1, nX ]
		
	Next nX
	
	// Popula a posição total do saldo inicial com o próprio saldo inicial
	aSldInicial[ 1, Len( aSldInicial[ 1 ] ) ] := nSldInic
	
	// Popula a posição total do saldo Final com o proprio saldo final do último dia/mês do período
	aSldFinal[ 1, Len( aSldFinal[ 1 ] ) ]   := aSldFinal[ 1, Len( aSldFinal[ 1 ] ) - 1 ]
	
	// Popula aNaturezas com as contas sintéticas
	For nX := 1 To Len( aNaturezas )
		
		AddSintet( @aAux, aNaturezas[ nX ], nLen )
		
	Next nX
	
	For nX := 1 To Len( aAux )
		
		aAdd( aNaturezas, aAux[ nX ] )
		
	Next nX
	
	aSize( aAux, 0 )
	
	// Populando array com saldos das naturezas de ingresso e desembolso
	For nX := 1 To Len( aNaturezas )
		
		aAdd( aAux, aNaturezas[ nX ]:cCodigo + ' - ' + aNaturezas[ nX ]:cNatureza)
		
		For nY := 1 To Len( aNaturezas[ nX ]:aSaldos )
			
			aAdd( aAux, aNaturezas[ nX ]:aSaldos[ nY ] )
			
		Next nY
		
		If aNaturezas[ nX ]:cCondicao == 'R'
			
			aAdd( aLinEntrada, aClone( aAux ) )
			
		ElseIf aNaturezas[ nX ]:cCondicao == 'D'
			
			aAdd( aLinSaida, aClone( aAux ) )
			
		End If
		
		aSize( aAux, 0 )
		
	Next nX
	
	//Ordena o código das naturezas de ingressos e desembolsos
	aSort( aLinEntrada,,, { | X, Y | Transforma( X[1] ) < Transforma( Y[1] ) } )
	aSort( aLinSaida ,,,  { | X, Y | Transforma( X[1] ) < Transforma( Y[1] ) } )
	
	RestArea( aAreaAlias )
	RestArea( aArea )
	
	// Executa função para gerar planilha do Excel com base nos dados dos arrays correspondentes a cada linha
	ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido, aSldInicial, aSldFinal )
	
Return

/*/{Protheus.doc} MesNum
Função que localiza no nome da coluna o mês correspondente e retorna o número deste mês
@project MAN0000038865_EF_002
@type function Rotina Específica
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
@type function Rotina Específica
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
	
	Local cArquivo   := ''
	Local oFwMsExcel := FwMsExcelEx():New()
	Local nX         := 0
	Local nAlign     := 0
	Local nFormat    := 0
	Local cDiario    := 'DIARIO ' + Upper( MesExtenso( Month( MV_PAR03 ) ) ) + '/' + cValToChar( Year( MV_PAR03 ) )
	Local cAnual     := 'ANUAL ' + cValToChar( Year( MV_PAR03 ) )
	Local cWorkSheet := If( MV_PAR05 = 1, cDiario, cAnual )
	Local cTable     := 'FLUXO DE CAIXA POR NATUREZA ' + cWorkSheet
	Local aCelStyle  := {}
	Local cNatAux    := ''
	Local aArea      := SED->( GetArea() )
	Local aRet       := {}
	Local aParam     := {}
	Local cMvPar     := 'MV_PAR01 := cGetFile( ,,, SubStr( MV_PAR01, 1, Rat( "\", MV_PAR01 ) - 1 ),,, .F. )'
	Local cValid     := 'Eval( { || If( ApMsgYesNo( "Utiliza o Mesmo Caminho ?" ), MV_PAR01 := MV_PAR01, ' + cMvPar + '), .T. } )'
	Local aBkParam   := Array( 60 )
	
	For nX := 1 To Len( aBkParam )
		
		aBkParam[nX] := &( 'MV_PAR' + StrZero( nX, 2 ) )
		
	Next nX
	
	aAdd( aParam, { 1, 'Local e Nome do Arquivo'  , Space(255), '@!'    , cValid ,, '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'Nível de Ingressos'       , 000       , '@E 999', '.T.'  ,, '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'Nível de Desembolsos'     , 000       , '@E 999', '.T.'  ,, '.T.', 90, .F. } )
	
	// Verifica a quantidade níveis do Fluxo para ingressos e desembolsos
	If ! ParamBox( aParam, '', @aRet,,,,,,, 'Fluxo2Excel', .T., .T. )
		
		aRet := { GetTempPath() + GetNextAlias() + '.xml', 999, 999 }
		
	End If
	
	For nX := 1 To Len( aBkParam )
		
		&( 'MV_PAR' + StrZero( nX, 2 ) ) := aBkParam[nX]
		
	Next nX
	
	
	cArquivo := aRet[1]
	
	If Upper( AllTrim( Atail( StrTokArr2( cArquivo, '.', .T. ) ) ) ) <> 'XML'
		
		cArquivo += '.xml'
		
	End If
	
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
		
		If Len( StrTokArr2(cNatAux,'.', .T.) ) <= aRet[2]
			
			If Len( StrTokArr2( cNatAux, '.', .T. ) ) == 1
				
				oFWMSExcel:SetCelBold(.T.)
				
			End If
			
			oFWMSExcel:AddRow( cWorkSheet, cTable, aLinEntrada[nX], aCelStyle )
			
		End If
		
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
		
		If Len( StrTokArr2(cNatAux,'.', .T.) ) <= aRet[3]
			
			If Len( StrTokArr2( cNatAux, '.', .T. ) ) == 1
				
				oFWMSExcel:SetCelBold(.T.)
				
			End If
			
			oFWMSExcel:AddRow( cWorkSheet, cTable, aLinSaida[nX], aCelStyle )
			
		End If
		
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
	
	SED->( RestArea( aArea ) )
	
Return

/*/{Protheus.doc} Transforma
Transforma o código da natureza aplicando PadL( cVal, 3, '0' ) a cada nível, permitindo facilitar a ordenção do código das naturezas
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param cItem, character, Código da Natureza
@return character, Código da Natureza ajustado para facilitar a ordenção
/*/
Static Function Transforma( cItem )
	
	Local cRet  := ''
	Local aItem := {}
	Local nX    := 0
	
	cItem := AllTrim( StrTokArr2( cItem, '-', .T. )[1] )
	
	aItem := StrTokArr2( AllTrim( cItem ), '.', .T. )
	
	For nX := 1 To Len( aItem )
		
		cRet += PadL( AllTrim( aItem[nX] ), 3, '0' )
		
	Next nX
	
Return cRet

Class FC022NAT
	
	Data cCodigo
	Data cNatureza
	Data cCondicao // Receita // Despesa
	Data cTipo // Sintetico // Analitico
	Data cRedutora
	Data cSeq // 0 // 1 // 2 // 900 // 999
	Data cCart // P // R // Z
	Data aSaldos
	
	Method New( ) Constructor
	
End Class

Method New( nLen ) Class FC022NAT
	
	Local nX := 0
	
	::cCodigo   := ''
	::cNatureza := ''
	::cCondicao := ''
	::cTipo     := ''
	::cRedutora := ''
	::cSeq      := ''
	::cCart     := ''
	::aSaldos   := Array( nLen - 1 )
	
	For nX := 1 To Len( ::aSaldos )
		
		::aSaldos[ nX ] := 0
		
	Next nX
	
Return Self


Static Function IsRedutora( cCodNat )
	
	Local cQuery := ''
	Local aArea  := GetArea()
	Local lRet   := .F.
	Local cAlias := ''
	
	cQuery += "SELECT COUNT( * ) COUNT FROM " + RetSQLName ( 'SED' ) + " "
	cQuery += "WHERE D_E_L_E_T_ = '' AND ED_NATMT = '" + cCodNat + "'" //TODO usando campo ED_NATMT mas criar ED_XNATRED
	
	cAlias := MPSysOpenQuery( cQuery )
	
	lRet := (cAlias)->COUNT > 0
	
	
Return lRet

Static Function GetSaldos( oNatureza, cAlias, nMesBase )
	
	Local cCodNat := ''
	
	(cAlias)->( DbGoTop() )
	
	Do While ! (cAlias)->( Eof() )
		
		cCodNat := AllTrim( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 1 ] )
		
		// Natureza conforme a sua condição
		If ( oNatureza:cCodigo == cCodNat .Or. oNatureza:cRedutora == cCodNat) .And.(;
				( (cAlias)->CART == 'R' .And. oNatureza:cCondicao == 'R' ) .Or.;
				( (cAlias)->CART == 'P' .And. oNatureza:cCondicao == 'D' ) )
			
			AddSaldo( oNatureza, cAlias, nMesBase, 1 )
			
		End If
		
		// Natureza contrária a sua condição
		If ( oNatureza:cCodigo == cCodNat .Or. oNatureza:cRedutora == cCodNat) .And.(;
				( (cAlias)->CART == 'R' .And. oNatureza:cCondicao == 'D' ) .Or.;
				( (cAlias)->CART == 'P' .And. oNatureza:cCondicao == 'R' ) )
			
			AddSaldo( oNatureza, cAlias, nMesBase, -1 )
			
		End If
		
		(cAlias)->( DbSkip() )
		
	End Do
	
Return


Static Function AddSaldo( oNatureza, cAlias, nMesBase, nSinal )
	
	Local nX     := 0
	Local nTotal := 0
	Local nSaldo := 0
	Local aTpSld := { 'REAL0', 'ORC0' }
	Local nTpSld := 1
	
	For nX := 1 To Len( oNatureza:aSaldos )
		
		If MV_PAR05 = 1 // Fluxo Diário
			
			nTpSld := 1
			
		ElseIf MV_PAR05 = 3 // Fluxo Mensal
			
			If nMesBase >= nX //Verifica tipo de saldo conforme mês
				
				nTpSld := 1
				
			Else
				
				nTpSld := 2
				
			End If
			
		End If
		
		If nX < Len( oNatureza:aSaldos )
			
			// Atribui saldo ao array conforme mês e tipo de saldo e acumula o saldo total da natureza
			nSaldo := (cAlias)->&( aTpSld[ nTpSld ] + StrZero( nX, 2 ) ) * nSinal
			
			nTotal += nSaldo
			
			oNatureza:aSaldos[ nX ] := nSaldo
			
		End If
		
		If nX == Len( oNatureza:aSaldos )
			
			// Trata inclusão de coluna de total
			oNatureza:aSaldos[ nX ] := nTotal
			
		End If
		
		// Popula array de saldos com valores realizados
		
		// Se for fluxo do tipo Anual popula array de saldos com  valores realizados
		// para meses anteriores ao corrente e orçado/previsto para o mês corrente e os
		// subsequentes
		
		//		If MV_PAR05 = 1 // Fluxo Diário
		//
		//			nSaldo := oNatureza:aSaldos[ nX ] := (cAlias)->&('REAL0' + StrZero( nX, 2 ) ) * nSinal
		//
		//			nTotal += nSaldo
		//
		//			oNatureza:aSaldos[ nX ] := nSaldo
		//
		//		ElseIf MV_PAR05 = 3 // Fluxo Mensal
		//
		//			If nMesBase >= nX //Verifica tipo de saldo conforme mês
		//
		//				nTpSld := 1
		//
		//			Else
		//
		//				nTpSld := 2
		//
		//			End If
		//
		//			// Atribui saldo ao array conforme mês e tipo de saldo e acumula o saldo total da natureza
		//			nSaldo := (cAlias)->&( aTpSld[ nTpSld ] + StrZero( nX, 2 ) ) * nSinal
		//
		//			nTotal += nSaldo
		//
		//			oNatureza:aSaldos[ nX ] := nSaldo
		//
		//			// Trata inclusão de coluna de total
		//			If nX == Len( oNatureza:aSaldos )
		//
		//				oNatureza:aSaldos[ nX ] := nTotal
		//
		//			End If
		//
		//		End If
		
	Next nX
	
Return

/*/{Protheus.doc} IsZerada
Verifica se o array de uma linha da planilha a ser gerada tem todas as colunas de valores zerada
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param aColunas, array, Array com os valores das colunas da linha a ser verificada
@Return logic, Retorno lógico indicando se as colunas de valores estão zeradas
/*/
Static Function IsZerada( aColunas )
	
	Local lRet := .T.
	Local nX   := 0
	
	For nX := 1 To Len( aColunas )
		
		If aColunas[ nX ] # 0
			
			lRet := .F.
			
			EXIT
			
		End If
		
	Next nX
	
Return lRet


Static Function AddSintet( aAux, oNatureza, nLen )
	
	Local nStart     := 1
	Local nPos       := 1
	Local aPos       := {}
	Local aSintetica := {}
	Local oAux       := Nil
	Local aArea      := GetArea()
	Local nX         := 0
	Local nY         := 0
	Local cNatureza  := oNatureza:cCodigo
	
	// Verifica a posição dos pontos separadores de níveis
	Do While nPos # 0
		
		nPos := At( '.', cNatureza, nStart )
		
		nStart := nPos + 1
		
		If nPos # 0
			
			aAdd( aPos, nPos )
			
		End If
		
	End Do
	
	// Com as posições dos pontos separadores de níveis verifica quais naturezas sintéticas serão populadas com o saldo natureza
	For nX := 1 To Len( aPos )
		
		aAdd( aSintetica, SubStr( cNatureza, 1, aPos[ nX ] - 1 ) )
		
	Next nX
	
	// Verifica se a natureza já existe na lista, se não existe inclui na lista com saldo, se não apenas soma saldo da natureza
	For nX := 1 To Len( aSintetica )
		
		nPos := aScan( aAux, { |X| X:cCodigo == aSintetica[ nX ] } )
		
		If nPos == 0
			
			oAux := FC022NAT():New( nLen )
			
			oAux:cCodigo   := aSintetica[ nX ]
			oAux:cNatureza := AllTrim( NoAcento( Posicione( 'SED', 1, xFilial( 'SED' ) + oAux:cCodigo, 'ED_DESCRIC' ) ) )
			oAux:cCondicao := oNatureza:cCondicao
			oAux:cTipo     := 'S'
			oAux:cRedutora := ''
			oAux:cSeq      := oNatureza:cSeq
			oAux:cCart     := oNatureza:cCart
			oAux:aSaldos    := aClone( oNatureza:aSaldos )
			
			aAdd( aAux, oAux )
			
		Else
			
			oAux := aAux[ nPos ]
			
			For nY := 1 To Len( oAux:aSaldos )
				
				oAux:aSaldos[ nY ] += oNatureza:aSaldos[ nY ]
				
			Next nY
			
		End If
		
	Next nX
	
	RestArea( aArea )
	
Return
