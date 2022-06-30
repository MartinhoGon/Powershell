# Colocar este setting para permitir que o script pare após o primeiro erro
# "Continue" é a definição por defeito
$ErrorActionPreference = "Stop"


######  Para dar permissões aos utilizadores usar  ###### 

	## Vai buscar a ACL existente
	$ACL = Get-Acl F:\Partilha\Pessoais\* 
	## Cria a nova regra para a pasta
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("CM-ALVAIAZERE\","Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
	## Adiciona a regra á ACL existente
	$ACL.SetAccessRule($AccessRule)
	## Coloca a ACL atualizada na pasta
	$ACL | Set-Acl -Path F:\Partilha\Pessoais\*


######  Verificar a Existencia do Grupo ou Utilizador ###### 

	Get-ADGroup -Identity $Nome
	Get-ADUser -Identity $Nome


######  Permisões  ###### 

	FullControl -> Permissão total á pasta (Não dar a ninguem, apenas a administradores da NAS)
	ListDirectory -> Permissão apenas para listar o conteudo da pasta
	Modify -> Permissão para Modificar a pasta e os seus conteudos (adicionar, editar e remover)
	Write -> Permite Criar pastas e ficheiros e modificar os ficheiros existentes
	Read -> Pemrite Listar conteudo, ler dados atributos e permissões
	ReadAndExecute -> Listar conteudo, executar ficheiro, ler ficheiros atributos e permissões


	Para mais informação:
	https://blog.netwrix.com/2018/04/18/how-to-manage-file-system-acls-with-powershell-scripts/

	
	A permissão "Read" quando usada em conjunto com o "None" na herança apenas dá permissão de listagem de pastas as quais o utilizador tem permissão,
	todas as outras ficam inivisiveis


######  Formato do JSON  ###### 

{
    "criar": [
        {
            "name": "Teste", ## nome da pasta
            "destination": "C:/", ## caminho destino da pasta
            "permissions": [
                {
                    "nome": "Users - Sales", ## nome do utilizar / grupo
                    "permissao": "ListDirectory", ## referir ao ponto anterior para ver as permissões adequadas
                    "heranca": "[ContainerInherit,ObjectInherit, None]", ## Contaier... -> para dar permissoes a pasta e subpastas; None -> apenas permissão á pasta
                    "tipo": "grupo"  ## pode ser 'grupo' ou  'utilizador' outros tipos serão ignorados
                }
            ]
        }
    ],
    "mover": [
        {
            "name": "ABC", ## nome da pasta
            "path": "C:/ABC", ## caminho para a pasta
            "destination": "F:/Teste/", ## caminho destino da pasta
            "permissions": [
                {
                    "nome": "mjgomes", ## nome do utilizar / grupo
                    "permissao": "Modify", ## referir ao ponto anterior para ver as permissões adequadas
                    "heranca": "[ContainerInherit,ObjectInherit, None]", ## Contaier... -> para dar permissoes a pasta e subpastas; None -> apenas permissão á pasta
                    "tipo": "utilizador" ## pode ser 'grupo' ou  'utilizador' outros tipos serão ignorados
                }
            ]
        }
    ]
}
