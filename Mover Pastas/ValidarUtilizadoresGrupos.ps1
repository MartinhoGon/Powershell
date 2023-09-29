########################################
##   Developed By Martinho Gonçalves  ##
##             22/07/2022             ##
########################################


param(
    [Parameter(Mandatory = $true)] $JSONFile
)

function TestIfUserOrGroupExists() {
    param(
        [Parameter(Mandatory = $true)] $Nome, #nome grupo ou utilizador
        [Parameter(Mandatory = $true)] $Tipo #se é grupo ou utilizador
    )
    try {
        if ($tipo.ToLower() -eq "utilizador") {
            Get-ADUser -Identity $Nome  | Out-Null
        }
        elseif ($tipo.ToLower() -eq "grupo") {
            Get-ADGroup -Identity $Nome  | Out-Null
        }
        else {
            Write-Host "Tipo de identidade da permissão nao existe" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Utilizador/Grupo '"$nome"' nao existe." -ForegroundColor Red
    }
}

function ValidarUsersAndGroups () {
    param(
        [Parameter(Mandatory = $true)] $jsonObject #pastas
    )
    foreach ($pasta in $jsonObject) {
        foreach($permissao in $pasta.permissions){
            TestIfUserOrGroupExists -Nome $permissao.nome -Tipo $permissao.tipo
        }
    }
}

try {
    $json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
    
    Write-Host "A validar utilizadores e grupos..."
    $continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)"

    if ($continuar.ToLower() -eq 's' ) {
        if ($json.criar.Count -gt 0) {
            ValidarUsersAndGroups -jsonObject $json.criar
        }
        if ($json.mover.Count -gt 0) {
            ValidarUsersAndGroups -jsonObject $json.mover
        }
    }

}
catch {
    Write-Host "Ocorreu um erro ao ler o ficheiro. Verifique que o JSON esta em conformidade com as regras." -ForegroundColor Red
}