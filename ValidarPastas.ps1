########################################
##   Developed By Martinho Gonçalves  ##
##             24/05/2023             ##
########################################


param(
    [Parameter(Mandatory = $true)] $JSONFile
)

function ValidarPastas {
    param(
        [Parameter(Mandatory = $true)] $jsonObject #pastas
    )
    Write-Host "A validar pastas..."


    try {
        $erro = 0
        $naoExistem = ""
        foreach ($pasta in $jsonObject) {
            Write-Host $pasta.name
            if (Test-Path -Path $pasta.path) {
                
            }else{
                $naoExistem = $naoExistem + "`n" + $pasta.name
                $erro = 1;
            }

        }
    }
    catch {
        Write-Host "Ocurreu um erro ao validar a existencia de pastas a migrar."
    }
    

    if ($erro -eq 0) {
        Write-Host "Todas as pastas foram validadas com sucesso" -ForegroundColor Green
    }
    else {
        Write-Host "As seguintes pastas nao existem: "$naoExistem -ForegroundColor Red
    }

}
###  -- MAIN

try {
    $json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
    
    Write-Host "A validar existencia das pastas a migrar."
    $continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)"
    if ($continuar.ToLower() -eq 's' ) {
        if ($json.mover.Count -gt 0) {
            ValidarPastas -jsonObject $json.mover
        }
    }

}
catch {
    Write-Host "Ocorreu um erro ao ler o ficheiro. Verifique que o JSON esta em conformidade com as regras." -ForegroundColor Red
}
