# Colocar este setting para permitir que o script pare após o primeiro erro
# "Continue" é a definição por defeito
$ErrorActionPreference = "Stop"



##
Para dar permissões aos utilizadores usar:

// Vai buscar a ACL existente
$ACL = Get-Acl F:\Partilha\Pessoais\* 
// Cria a nova regra para a pasta
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("CM-ALVAIAZERE\","Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
// Adiciona a regra á ACL existente
$ACL.SetAccessRule($AccessRule)
// Coloca a ACL atualizada na pasta
$ACL | Set-Acl -Path F:\Partilha\Pessoais\*


///////  Verificar a Existencia do Grupo ou Utilizador
Get-ADGroup -Identity $Nome
Get-ADUser -Identity $Nome


///////////////////////
Formato do JSON:

{
    "criar": [
        {
            "name": "Teste",
            "destination": "C:/",
            "permissions": [
                {
                    "nome": "Users - Sales",
                    "permissao": "ListDirectory",
                    "heranca": "ContainerInherit,ObjectInherit",
                    "tipo": "grupo"
                }
            ]
        }
    ],
    "mover": [
        {
            "name": "ABC",
            "path": "C:/ABC",
            "destination": "F:/Teste/",
            "permissions": [
                {
                    "nome": "mjgomes",
                    "permissao": "Modify",
                    "heranca": "ContainerInherit,ObjectInherit",
                    "tipo": "utilizador"
                }
            ]
        }
    ]
}