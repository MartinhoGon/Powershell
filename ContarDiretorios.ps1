########################################
##   Developed By Martinho Gonçalves  ##
##             30/06/2022             ##
########################################

param(
    [Parameter(Mandatory = $true)] $JSONFile
)

try {
    $json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
    
    $continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)"
    
    if($continuar.ToLower() -eq 's' ){
        Write-Host "Pastas a criar: "$json.criar.Count
        Write-Host "Pastas a mover: "$json.mover.Count
    }else{
        Write-Host "Fujam!! A abortar missao!"
    }
}
catch {
    Write-Host "Ocorreu um erro ao ler o ficheiro. Verifique que o JSON esta em conformidade com as regras." -ForegroundColor Red
}