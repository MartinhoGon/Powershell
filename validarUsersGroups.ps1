########################################
##   Developed By Martinho Gonçalves  ##
##             24/08/2023             ##
########################################

param(
    [Parameter(Mandatory = $true)] $JSONFile
)


function ValidarUsersAndGroups() {
    param(
        [Parameter(Mandatory = $true)] $jsonObject, #nome grupo ou utilizador
    )

    $criar = $jsonObject.criar;
    $mover = $jsonObject.mover;
    $newJson= $criar + $mover;

    
    # $existe = $false
    # try {
    #     if ($tipo.ToLower() -eq "utilizador") {
    #         Get-ADUser -Identity $Nome
    #         $existe = $true
    #     }
    #     elseif ($tipo.ToLower() -eq "grupo") {
    #         Get-ADGroup -Identity $Nome
    #         $existe = $true
    #     }
    #     else {
    #         Write-Host "Tipo de identidade da permissão nao existe" -ForegroundColor Red
    #     }
    # }
    # catch {
    #     Write-Host "Utilizador/Grupo '"$nome"' nao existe." -ForegroundColor Red
    #     $existe = $false
    # }
    # return $existe
}


##-- Main

try {
    $json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
    
    Write-Host "Validar utilizadores e grupos"
    $continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)"
    if ($continuar.ToLower() -eq 's' ) {
            ValidarUsersAndGroups -jsonObject $json
    }

}
catch {
    Write-Host "Ocorreu um erro ao ler o ficheiro. Verifique que o JSON esta em conformidade com as regras." -ForegroundColor Red
}