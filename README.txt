# Colocar este setting para permitir que o script pare após o primeiro erro
# "Continue" é a definição por defeito
$ErrorActionPreference = "Stop"


#### Não foi util
# $arraySubstituicao = @{
#     "à"="\u00E0",
#     "á"="\u00E1",
#     "â"="\u00E2",
#     "ã"="\u00E3", 
#     "è"="\u00E8", 
#     "é"="\u00E9", 
#     "ê"="\u00EA", 
#     "ì"="\u00EC", 
#     "í"="\u00ED", 
#     "î"="\u00EE", 
#     "ò"="\u00F2", 
#     "ó"="\u00F3", 
#     "ô"="\u00F4", 
#     "õ"="\u00F5", 
#     "ù"="\u00F9", 
#     "ú"="\u00FA", 
#     "û"="\u00FB", 
#     "ç"="\u00E7", 
#     "À"="\u00C0",
#     "Á"="\u00C1",
#     "Â"="\u00C2",
#     "Ã"="\u00C3", 
#     "È"="\u00C8", 
#     "É"="\u00C9", 
#     "Ê"="\u00CA", 
#     "Ì"="\u00CC", 
#     "Í"="\u00CD", 
#     "Î"="\u00CE", 
#     "Ò"="\u00D2", 
#     "Ó"="\u00D3", 
#     "Ô"="\u00D4", 
#     "Õ"="\u00D5", 
#     "Ù"="\u00D9", 
#     "Ú"="\u00DA", 
#     "Û"="\u00DB", 
#     "Ç"="\u00C7", 
# }

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
