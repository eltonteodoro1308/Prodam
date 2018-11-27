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
	
	aUsButtons := { { '', bMsAguarde, '', 'Portal Transpar�ncia' } }
	
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
	Local aFluxo      := {}
	Local oNatureza   := Nil
	Local nTotal      := 0
	Local nSaldo      := 0
	Local cNat        := ''
	Local nX          := 0
	Local lExecuta    := .T.
	U_Tab2TXT( cAlias )
	
	lExecuta := lExecuta .And. lFluxSint // Verifica se Fluxo � Sint�tico
	lExecuta := lExecuta .And. MV_PAR13 == 2 // Verifica se exibe Naturezas Sint�ticas
	lExecuta := cValToChar( MV_PAR05 ) $ '13' // Verifica se Mostra Per�odos em Dias ou Meses
	
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
		AutoGrLog( '- Fluxo definido como Sint�tico' )
		AutoGrLog( '' )
		AutoGrLog( '- Definir para n�o exibir as naturezas sint�ticas' )
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
			
			aAdd( aCabec, StrTran( StrTokArr2(cCabec,' ', .T.)[2] + ' - ' + StrTokArr2(cCabec,' ', .T.)[1], 'ORCADO', 'PREVISTO' ) )
			
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
		
		If (cAlias)->( AllTrim( SEQ ) $ '/001/002/' .And. Alltrim( CART ) $ 'PR' )
			
			oNatureza := FC022NAT():New()
			
			oNatureza:cCodigo   := AllTrim( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 1 ] )
			oNatureza:cNatureza := AllTrim( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 2 ] )
			oNatureza:cCondicao := Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo,'ED_COND' )
			oNatureza:cTipo     := IF( Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo,'ED_TIPO' )=='1','S','A')
			oNatureza:cPai      := AllTrim( Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo,'ED_PAI' ) )
			oNatureza:cSeq      := (cAlias)->SEQ
			oNatureza:cCart     := (cAlias)->CART
			
			// Fluxo Di�rio
			If MV_PAR05 = 1
				
				For nX := 1 To Day( LastDate ( MV_PAR04 ) )
					
					aAdd( oNatureza:aSaldos, (cAlias)->&('REAL0' + StrZero( nX, 2 ) ) )
					
				Next nX
				
				// Fluxo Anual
			ElseIf MV_PAR05 = 3
				
				For nX := 1 To 12
					
					If nMesBase >= nX // Se M�s maior ou igual ao corrente inclui o realizado
						
						nSaldo := (cAlias)->&('REAL0' + StrZero( nX, 2 ) )
						
						nTotal += nSaldo
						
						aAdd( oNatureza:aSaldos, nSaldo )
						
						
					Else // Sen�o inclui o OR�ADO
						
						nSaldo := (cAlias)->&('ORC0' + StrZero( nX, 2 ) )
						
						nTotal += nSaldo
						
						aAdd( oNatureza:aSaldos, nSaldo )
						
					End If
					
				Next nX
				
				aAdd( oNatureza:aSaldos, nTotal )
				
				nTotal := 0
				
			End If
			
			//TODO Ajustar para n�o incluir conta com todos os saldos zerados
			aAdd( aFluxo, oNatureza )
			
		End If
		
		(cAlias)->( DbSkip() )
		
	End Do
	
	//TODO Tratar para popular os array�s
	//TODO aLinEntrada
	//TODO aLinSaida
	//TODO aIngresso
	//TODO aDesembolso
	//TODO aSldLiquido
	//TODO aSldInicial
	//TODO aSldFinal
	
	// Ajuste de contas de ingresso com desemboldo e de desembolso com ingresso
	AjIngrDes( @aIngresso, @aLinEntrada, @aDesembolso, @aLinSaida )
	
	//Ordena o c�digo das naturezas de ingressos e desembolsos
	//aSort( aLinEntrada,,, { | X, Y | Transforma( X[1] ) < Transforma( Y[1] ) 	} )
	//aSort( aLinSaida ,,,  { | X, Y | Transforma( X[1] ) < Transforma( Y[1] ) 	} )
	
	RestArea( aAreaAlias )
	RestArea( aArea )
	
	// Executa fun��o para gerar planilha do Excel com base nos dados dos arrays correspondentes a cada linha
	//ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido, aSldInicial, aSldFinal )
	
Return

/*/{Protheus.doc} MesNum
Fun��o que localiza no nome da coluna o m�s correspondente e retorna o n�mero deste m�s
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
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

/*/{Protheus.doc} IsZerada
Verifica se o array de uma linha da planilha a ser gerada tem todas as colunas de valores zerada
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param aColunas, array, Array com os valores das colunas da linha a ser verificada
@Return logic, Retorno l�gico indicando se as colunas de valores est�o zeradas
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


/*/{Protheus.doc} AjIngrDes
Executa o ajuste dos arrays recebidos por refer�ncia de Entradas e Sa�das e seus saldos de ingresso e desembolso correspondentes,
visto que naturezas de Receita recebem lan�amentos de Despesas e naturezas de Despesas recebem lan�amentos
de Receita, assim verifica-se a condi��o da natureza (ED_COND) sendo Receita soma-se as entradas e subtrai-se
as Sa�das e sendo Despesas soma-se as Sa�das e subtrai-se as entradas, faz tamb�m os ajustes na linhas de
Total de ingressos e desembolsos.
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param aIngresso, array, Saldos totais de Ingressos da Naturezas
@param aLinEntrada, array, Saldos de Entradas na Natureza
@param aDesembolso, array, Saldos totais de Desembolso da Naturezas
@param aLinSaida, array, Saldos de Sa�das na Natureza
/*/
Static Function AjIngrDes( aIngresso, aLinEntrada, aDesembolso, aLinSaida )
	
	Local uLinEntrada := aClone( aLinEntrada )
	Local uLinSaida   := aClone( aLinSaida   )
	Local nX          := 0
	Local nY          := 0
	Local aArea       := SED->( GetArea() )
	Local cCodNat     := ''
	Local nPos        := 0
	
	aSize( aLinEntrada, 0 )
	aSize( aLinSaida  , 0 )
	
	// Ajusta linhs de entradas
	For nX := 1 To Len( uLinEntrada )
		
		cCodNat := AllTrim( StrTokArr2( uLinEntrada[ nX,1 ], '-', .T. )[1] )
		
		// Verifica se Natureza � um Receita
		If Posicione( 'SED', 1, xFilial( 'SED' ) + cCodNat , 'ED_COND' ) == 'R'
			
			// Sendo Receita Inclui na lista de entradas
			aAdd( aLinEntrada, uLinEntrada[ nX ]  )
			
		Else
			
			// Sendo Despesa Inclui na lista de Sa�das
			aAdd( aLinSaida, uLinEntrada[ nX ]  )
			
			// Exclui os valores desta linha dos saldos de Ingresso e Desembolso se a Natureza
			// for sint�tica de n�vel 1 ou seja ED_TIPO == 1-Sint�tico e ED_PAI  == ''
			If Posicione( 'SED', 1, xFilial( 'SED' ) + cCodNat , 'ED_TIPO' ) == '1' .And.;
					Empty( Posicione( 'SED', 1, xFilial( 'SED' ) + cCodNat , 'ED_TIPO' ) )
				For nY := 2 To Len( uLinEntrada[ nX ] )
					
					aIngresso  [ 1, nY ] := aIngresso  [ 1, nY ] - uLinEntrada[ nX, nY ]
					aDesembolso[ 1, nY ] := aDesembolso[ 1, nY ] - uLinEntrada[ nX, nY ]
					
				Next nY
				
			End If
			
		End If
		
	Next nX
	
	
	// Ajusta linhs de sa�das
	For nX := 1 To Len( uLinSaida )
		
		cCodNat := AllTrim( StrTokArr2( uLinSaida[ nX,1 ], '-', .T. )[1] )
		
		// Verifica se Natureza � um Despesa
		If Posicione( 'SED', 1, xFilial( 'SED' ) + cCodNat , 'ED_COND' ) == 'D'
			
			// Sendo Despesa Inclui na lista de Sa�das
			
			// Verifica posi��o da natureza na lista de despesas
			nPos := aScan( aLinSaida, { |X| X[1] == uLinSaida[ nX,1 ] } )
			
			// Verifica se a mesma j� existe na lista
			If nPos == 0
				
				// Se n�o existir inclui
				aAdd( aLinSaida, uLinSaida[ nX ]  )
				
			Else
				
				// Se Existir soma valores na posi��o
				For nY := 2 To Len( aLinSaida[ nPos ] )
					
					aLinSaida[ nPos, nY ] := aLinSaida[ nPos, nY ] + uLinSaida[ nX, nY ]
					
				Next nY
				
				
			End If
			
		Else
			
			// Sendo Receita Inclui na lista de entradas
			
			// Verifica posi��o da natureza na lista de receitas
			nPos := aScan( aLinEntrada, { |X| X[1] == uLinSaida[ nX,1 ] } )
			
			// Verifica se a mesma j� existe na lista
			If nPos == 0
				
				// Se n�o existir inclui
				aAdd( aLinEntrada, uLinSaida[ nX ]  )
				
			Else
				
				// Se Existir soma valores na posi��o
				For nY := 2 To Len( aLinEntrada[ nPos ] )
					
					aLinEntrada[ nPos, nY ] := aLinEntrada[ nPos, nY ] - uLinSaida[ nX, nY ]
					
				Next nY
				
				
			End If
			
			// Exclui os valores desta linha dos saldos de Ingresso e Desembolso se a Natureza
			// for sint�tica de n�vel 1 ou seja ED_TIPO == 1-Sint�tico e ED_PAI  == ''
			If Posicione( 'SED', 1, xFilial( 'SED' ) + cCodNat , 'ED_TIPO' ) == '1' .And.;
					Empty( Posicione( 'SED', 1, xFilial( 'SED' ) + cCodNat , 'ED_TIPO' ) )
				
				For nY := 2 To Len( uLinSaida[ nX ] )
					
					aIngresso  [ 1, nY ] := aIngresso  [ 1, nY ] - uLinSaida[ nX, nY ]
					aDesembolso[ 1, nY ] := aDesembolso[ 1, nY ] - uLinSaida[ nX, nY ]
					
				Next nY
				
			End If
			
		End If
		
	Next nX
	
	SED->( RestArea( aArea ) )
	
Return
/*/{Protheus.doc} ToExcel
Gera planilha do Excel com base nos dados coletados do Alias exibido no Fluxo de Caixa
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
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
	Local cValid     := 'Eval( { || MV_PAR01 := cGetFile( ,,, SubStr( MV_PAR01, 1, Rat( "\", MV_PAR01 ) - 1 ),,, .F. ), .T. } )'
	Local aBkParam   := Array( 60 )
	
	For nX := 1 To Len( aBkParam )
		
		aBkParam[nX] := &( 'MV_PAR' + StrZero( nX, 2 ) )
		
	Next nX
	
	aAdd( aParam, { 1, 'Local e Nome do Arquivo'  , Space(255), '@', cValid ,, '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'N�vel de Ingressos'       , 000       , '@', '.T.'  ,, '.T.', 90, .F. } )
	aAdd( aParam, { 1, 'N�vel de Desembolsos'     , 000       , '@', '.T.'  ,, '.T.', 90, .F. } )
	
	// Verifica a quantidade n�veis do Fluxo para ingressos e desembolsos
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
	
	ApMsgInfo( 'O arquivo ' + cArquivo + ' foi gerado com sucesso.', 'Aten��o !!!' )
	
	SED->( RestArea( aArea ) )
	
Return

/*/{Protheus.doc} Transforma
Transforma o c�digo da natureza aplicando PadL( cVal, 3, '0' ) a cada n�vel, permitindo facilitar a orden��o do c�digo das naturezas
@project MAN0000038865_EF_002
@type function Rotina Espec�fica
@version P12
@author TOTVS
@since 30/10/2018
@param cItem, character, C�digo da Natureza
@return character, C�digo da Natureza ajustado para facilitar a orden��o
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

User Function Tab2TXT( cAlias )
	
	Local cTxt := ''
	Local nX   := 0
	
	( cAlias )->( DbGoTop() )
	
	For nX := 1 To ( cAlias )->( FCount() )
		
		cTxt += FieldName( nX )
		
		If nX # ( cAlias )->( FCount() )
			
			cTxt += ';'
			
		End If
		
	Next nX
	
	cTxt += Chr( 13 ) + Chr( 10 )
	
	Do While ( cAlias )->( ! Eof() )
		
		For nX := 1 To ( cAlias )->( FCount() )
			
			If ValType( ( cAlias )->( FieldGet( nX ) ) ) == 'N'
				
				cTxt += StrTran(cValToChar( ( cAlias )->( FieldGet( nX ) ) ), '.', ',' )
				
			Else
				
				cTxt += ( cAlias )->( FieldGet( nX ) )
				
			End If
			
			If nX # ( cAlias )->( FCount() )
				
				cTxt += ';'
				
			End If
			
		Next nX
		
		( cAlias )->( DbSkip() )
		
		cTxt += Chr( 13 ) + Chr( 10 )
		
	End Do
	
	MemoWrite( 'c:/temp/' + FWTimeStamp() + '.csv', cTxt )
	
Return


Class FC022NAT
	
	Data cCodigo
	Data cNatureza
	Data cCondicao // Receita // Despesa
	Data cTipo // Sintetico // Analitico
	Data cPai
	Data cSeq // 0 // 1 // 2 // 900 // 999
	Data cCart // P // R // Z
	Data aSaldos
	
	Method New( ) Constructor
	
End Class

Method New() Class FC022NAT
	
	::cCodigo   := ''
	::cNatureza := ''
	::cCondicao := ''
	::cTipo     := ''
	::cPai      := ''
	::cSeq      := ''
	::cCart     := ''
	::aSaldos   := {}
	
Return Self
