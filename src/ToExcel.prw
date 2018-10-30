#include 'protheus.ch'
#include 'parmtype.ch'

user function ToExcel()

	Local cArquivo    := GetTempPath()+'zTstExc2c.xml'
	Local oFWMSEx        := FWMsExcelEx():New()
	Local oExcel

	//Criando a Aba Teste 1
	oFWMSEx:AddworkSheet("Teste - 1")
	//Adicionando a tabela
	oFWMSEx:AddTable ("Teste - 1","Titulo de teste 1")
	//Adicionando as colunas
	oFWMSEx:AddColumn("Teste - 1","Titulo de teste 1","Col1",1,1)
	oFWMSEx:AddColumn("Teste - 1","Titulo de teste 1","Col2",2,2)
	oFWMSEx:AddColumn("Teste - 1","Titulo de teste 1","Col3",3,3)
	oFWMSEx:AddColumn("Teste - 1","Titulo de teste 1","Col4",1,1)

	//Alterando atributos da linha e adicionando
	oFWMSEx:SetCelBold(.T.)
	oFWMSEx:SetCelFont('Arial')
	oFWMSEx:SetCelItalic(.T.)
	oFWMSEx:SetCelUnderLine(.T.)
	oFWMSEx:SetCelSizeFont(10)
	oFWMSEx:AddRow("Teste - 1","Titulo de teste 1",{11,12,13,14},{1,3})

	//Alterando atributos da linha e adicionando
	oFWMSEx:SetCelBold(.T.)
	oFWMSEx:SetCelFont('Arial')
	oFWMSEx:SetCelItalic(.T.)
	oFWMSEx:SetCelUnderLine(.T.)
	oFWMSEx:SetCelSizeFont(15)
	oFWMSEx:SetCelFrColor("#FFFFFF")
	oFWMSEx:SetCelBgColor("#000666")
	oFWMSEx:AddRow("Teste - 1","Titulo de teste 1",{21,22,23,24},{1})

	//Alterando atributos da linha e adicionando
	oFWMSEx:SetCelBold(.T.)
	oFWMSEx:SetCelFont('Courier New')
	oFWMSEx:SetCelItalic(.F.)
	oFWMSEx:SetCelUnderLine(.T.)
	oFWMSEx:SetCelSizeFont(10)
	oFWMSEx:SetCelFrColor("#FFFFFF")
	oFWMSEx:SetCelBgColor("#000333")
	oFWMSEx:AddRow("Teste - 1","Titulo de teste 1",{31,32,33,34},{2,4})

	//Alterando atributos da linha e adicionando
	oFWMSEx:SetCelBold(.T.)
	oFWMSEx:SetCelFont('Line Draw')
	oFWMSEx:SetCelItalic(.F.)
	oFWMSEx:SetCelUnderLine(.F.)
	oFWMSEx:SetCelSizeFont(12)
	oFWMSEx:SetCelFrColor("#FFFFFF")
	oFWMSEx:SetCelBgColor("#D7BCFB")
	oFWMSEx:AddRow("Teste - 1","Titulo de teste 1",{41,42,43,44},{3})

	//Adicionando aba Teste 2
	oFWMSEx:AddworkSheet("Teste - 2")
	//Adicionando a tabela
	oFWMSEx:AddTable("Teste - 2","Titulo de teste 1")
	//Adicionando as colunas
	oFWMSEx:AddColumn("Teste - 2","Titulo de teste 1","Col1",1)
	oFWMSEx:AddColumn("Teste - 2","Titulo de teste 1","Col2",2)
	oFWMSEx:AddColumn("Teste - 2","Titulo de teste 1","Col3",3)
	oFWMSEx:AddColumn("Teste - 2","Titulo de teste 1","Col4",1)
	//Adicionando as linhas
	oFWMSEx:AddRow("Teste - 2","Titulo de teste 1",{11,12,13,stod("20121212")})
	oFWMSEx:AddRow("Teste - 2","Titulo de teste 1",{21,22,23,stod("20121212")})
	oFWMSEx:AddRow("Teste - 2","Titulo de teste 1",{31,32,33,stod("20121212")})
	oFWMSEx:AddRow("Teste - 2","Titulo de teste 1",{41,42,43,stod("20121212")})
	oFWMSEx:AddRow("Teste - 2","Titulo de teste 1",{51,52,53,stod("20121212")})

	//Criando o XML
	oFWMSEx:Activate()
	oFWMSEx:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de taref
return