#INCLUDE 'TOTVS.CH'

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
