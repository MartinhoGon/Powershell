########################################
##   Developed By Martinho Gonçalves  ##
##             24/06/2022             ##
########################################

## Este script move pastas de um destino para o outro dentro de um diretório
## Recebe: 
## 1 ficheiro .txt com os nomes das pastas a mover (um nome de pasta por linha)
## O Path que é o caminho origem das pastas
## A Destination que é o caminho destino das pastas

param(
    [Parameter(Mandatory=$true)] $FoldersFile,
    [Parameter(Mandatory=$true)] $Path,
    [Parameter(Mandatory=$true)] $Destination,
    #  [string]$Parameter1
    [switch]$MoverServicos # Este parametro pode ser irelevante
 )

$file_list = Get-Content $FoldersFile -Encoding utf8 #'C:\Teste_Mudanca_NAS\nomes_utilizadores.txt' 
$erro = 0
$msgErro = "Ocorreu um erro ao mover as seguintes pastas:"
$newDestination = $Destination;



# if( -not $MoverServicos) {
    Write-Host "A mover pastas..."
    Write-Host "Por favor aguarde que processo seja concluido!"
    foreach ($folderName in $file_list)
    {   
        try{
            if( $folderName.StartsWith("#")){
                # Cria a pasta mão caso necessário e por ordem do ficheiro de entrada
                $pastaMae = $folderName.substring(1)
                Write-Host "A criar pasta '$pastaMae'" -ForegroundColor Yellow
                New-Item -Path $Destination -Name $pastaMae -ItemType "directory" -ErrorAction Stop | Out-Null
                # Write-Host "Criou a pasta com sucesso!" -ForegroundColor Yellow
                $newDestination = $Destination+$pastaMae+"\"
                Write-Host "Pasta Mae: $newDestination"
            }else {
                Write-Host "A mover a pasta: $folderName"
                Move-Item -Path $Path$folderName -Destination $newDestination -ErrorAction Stop
                Write-Host "Pasta movida com sucesso!!" -ForegroundColor Green 
            }
        }catch {
            Write-Host "Ocorreu um erro ao mover a pasta '$folderName'" -ForegroundColor Red
            $erro = 1
            $msgErro += " $folderName ||"
        }

    }

if($erro -eq 0){
    Write-Host "Todas as pastas foram movidas com sucesso!!" -ForegroundColor Green
}else{
    Write-Host $msgErro -ForegroundColor Red
}