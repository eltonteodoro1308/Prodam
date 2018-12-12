#INCLUDE 'TOTVS.CH'

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
User Function Fluxo2Excel( aParam )
	
	Local cAlias      := aParam[ 2 ]
	Local aArea       := GetArea()
	Local aAreaAlias  := (cAlias)->(GetArea())
	Local aCabec      := aParam[ 3 ]  //{}
	Local cCabec      := ''
	Local nMesBase    := aParam[ 1 ] // Month( dDataBase )
	Local nMesCol     := 0
	Local aLinEntrada := {}
	Local aLinSaida   := {}
	Local aIngresso   := {}
	Local aDesembolso := {}
	Local aSldLiquido := {}
	Local aSldInicial := {}
	Local aSldFinal   := {}
	Local nSldInic    := aParam[ 7 ]
	Local nLen        := 0
	Local aColunas    := {}
	Local oNatureza   := Nil
	Local aNaturezas  := {}
	Local aAux        := {}
	Local cCodNat     := ''
	Local cDescNat    := ''
	Local aSaldos     := Nil
	Local nX          := 0
	Local nY          := 0
	
	// Define a quantidade de colunas do fluxo
	nLen := Len( aCabec )
	
	// Popula Array com a lista de Naturezas que irão compor o Fluxo
	(cAlias)->( DbGoTop() )
	
	nSldInic := aParam[ 7 ]
	
	Do While ! (cAlias)->( Eof() )
		
		MsProcTxt( AllTrim( Upper( NoAcento( (cAlias)->NAT ) ) ) )
		ProcessMessage()
		
		cCodNat   := AllTrim( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 1 ] )
		cDescNat  := AllTrim( NoAcento( StrTokArr2( (cAlias)->NAT, '-', .T.  )[ 2 ] ) )
		
		oNatureza := FC022NAT():New( nLen )
		
		oNatureza:cCodigo   := cCodNat
		oNatureza:cNatureza := cDescNat
		oNatureza:cCondicao := If( Posicione( 'SED', 1, xFilial( 'SED' ) + oNatureza:cCodigo, 'ED_XINGDES' ) = '1', 'R',  'D' )
		
		aAdd( aNaturezas, oNatureza )
		
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
	
	// Executa função para gerar planilha do Excel com base
	// nos dados dos arrays correspondentes a cada linha
	ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido,;
		aSldInicial, aSldFinal, aParam[ 4 ], aParam[ 5 ], aParam[ 6 ] )
	
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
@param nNivIng, numeric, Tamanho de níveis para ingressos
@param nNivDes, numeric, Tamanho de níveis para desembolso
@param cFile, character, Nome de local do planilha a ser gerada
/*/
Static Function ToExcel( aCabec, aIngresso, aLinEntrada, aDesembolso, aLinSaida, aSldLiquido, aSldInicial, aSldFinal, nNivIng, nNivDes, cFile )
	
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
	Local aRet       := { cFile, nNivIng, nNivDes }
		
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
	ProcessMessage()
	
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
	ProcessMessage()
	
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
	ProcessMessage()
	
	oFWMSExcel:SetCelBgColor( '#FFFFFF' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aSldInicial[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aSldInicial[1,1] )
	ProcessMessage()
	
	oFWMSExcel:SetCelBgColor( '#FFFFCC' )
	oFWMSExcel:AddRow( cWorkSheet, cTable, aSldFinal[1], aCelStyle )
	MsProcTxt( 'Montando Planilha: ' + aSldFinal[1,1] )
	ProcessMessage()
	
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

/*/{Protheus.doc} FC022NAT
Classe que representa uma natureza e seus saldos no período do fluxo de caixa
@project MAN0000038865_EF_002
@type class Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
/*/
Class FC022NAT
	
	Data cCodigo
	Data cNatureza
	Data cCondicao // Receita // Despesa
	Data cTipo // Sintetico // Analitico
	Data cRedutora
	Data cSeq // 0 // 1 // 2 // 900 // 999
	Data cCart // P // R // Z
	Data aSaldos
	
	Method New( nLen ) Constructor
	
End Class

/*/{Protheus.doc} New
Método construtor da classe FC022NAT
@project MAN0000038865_EF_002
@type Method Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param nLen, numeric, Número de colunas do fluxo, para definir o tamanho do array de saldos da natureza
/*/
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

/*/{Protheus.doc} GetSaldos
Percorre o alias definido em cAlias e monta o saldo das naturezas
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param oNatureza, object, Objeto que representa a natureza
@param cAlias, character, Nome do alias que tem os dados do fluxo de caixa
@param nMesBase, numeric, Mês base de emissão do fluxo
/*/
Static Function GetSaldos( oNatureza, cAlias, nMesBase )
	
	If ( cAlias )->( DbSeek( oNatureza:cCodigo ) )
		
		AddSaldo( oNatureza, cAlias, nMesBase )
		
	End If	
	
Return

/*/{Protheus.doc} AddSaldo
Adiciona os saldos no array de saldos na natureza
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param oNatureza, object, Objeto que representa a natureza
@param cAlias, character, Nome do alias que tem os dados do fluxo de caixa
@param nMesBase, numeric, Mês base de emissão do fluxo
/*/
Static Function AddSaldo( oNatureza, cAlias, nMesBase )
	
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
			oNatureza:aSaldos[ nX ] += (cAlias)->&( aTpSld[ nTpSld ] + StrZero( nX, 2 ) )
			
			nTotal += oNatureza:aSaldos[ nX ]
			
		End If
		
		If nX == Len( oNatureza:aSaldos )
			
			// Trata inclusão de coluna de total
			oNatureza:aSaldos[ nX ] := nTotal
			
		End If
		
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

/*/{Protheus.doc} AddSintet
Popula o array aAux com alista de contas sintética de cada natureza e popula seus saldos
@project MAN0000038865_EF_002
@type function Rotina Específica
@version P12
@author TOTVS
@since 30/10/2018
@param aAux, array, Array recebido por referencia que será populado com as naturezas sintéticas e seus saldos correspondentes
@param oNatureza, object, Objeto que representa a natureza que irá popular o array aAux xom sua contas sintéticas correspondentes
@param nLen, numeric, Número de colunas que compõem o fluxo para montar o tamanho do array de saldos do objeto da natureza sintética
/*/
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
