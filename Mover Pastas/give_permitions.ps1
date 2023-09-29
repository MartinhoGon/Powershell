########################################
##   Developed By Martinho Gonçalves  ##
##             27/06/2022             ##
########################################

param(
    [Parameter(Mandatory=$true)] $PermitionsFile,
    [Parameter(Mandatory=$true)] $Path,
    [Parameter(Mandatory=$true)] $Destination
    #  [string]$Parameter1
    # [switch]$MoverServicos # Este parametro pode ser irelevante
 )

$file_list = Get-Content $FoldersFile -Encoding utf8 #'C:\Teste_Mudanca_NAS\nomes_utilizadores.txt' $erro = 0
$msgErro = "Ocorreu um erro ao mover as seguintes pastas:"
#$newDestination = $Destination;

Write-Host "A atribuir permissões..."
Write-Host "Por favor aguarde que processo seja concluido!"

foreach ($folderName in $file_list)
{   
    try{
        
    }catch {
        Write-Host "Ocorreu um erro ao atribuir permissões a pasta '$folderName'" -ForegroundColor Red
        $erro = 1
        $msgErro += " $folderName ||"
    }

}

if($erro -eq 0){
    Write-Host "Todas as pastas foram movidas com sucesso!!" -ForegroundColor Green
}else{
    Write-Host $msgErro -ForegroundColor Red
}