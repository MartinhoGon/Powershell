########################################
##   Developed By Martinho Gonçalves  ##
##             28/06/2022             ##
########################################

param(
    [Parameter(Mandatory = $true)] $JSONFile
    # [Parameter(Mandatory=$true)] $Path,
    # [Parameter(Mandatory=$true)] $Destination
    #  [string]$Parameter1
    # [switch]$MoverServicos # Este parametro pode ser irelevante
)

function CreateFolder () {
    param(
        [Parameter(Mandatory = $true)] $jsonObject #pastas
    )
    Write-Host "A criar pastas..."
    $erro = 0
    $msgErro = "Ocorreu um erro ao mover as seguintes pastas:"
    foreach ($pasta in $jsonObject) {
        $newFolder = $pasta.destination + $pasta.name
        $folderName = $pasta.name
        try {
            if (Test-Path -Path $newFolder) {
                Write-Host "A pasta $folderName ja existe!" -ForegroundColor Yellow
            }
            else {
                New-Item -Path $pasta.destination -Name $pasta.name -ItemType "directory" -ErrorAction Stop | Out-Null
                Write-Host "Foi criada com sucesso a pasta: $folderName" -ForegroundColor Green
            }
        }
        catch {
            $erro = 1
            Write-Host "Ocorreu um erro ao criar a pasta: $folderName" -ForegroundColor Red
            $msgErro += " $folderName ||"
        }
    }
    if ($erro -eq 0) {
        Write-Host "Todas as pastas foram criadas com sucesso!!" -ForegroundColor Green
    }
    else {
        Write-Host $msgErro -ForegroundColor Red
    }
}

function AtribuirPermissoes () {
    param(
        [Parameter(Mandatory = $true)] $jsonObject, #permissoes
        [String] $Destination,
        [String] $folderName
    )
    $erro = 0
    Write-Host "A atribuir permissoes á pasta $folderName...."
    try {
        $ACL = Get-Acl $Destination
        foreach($permissao in $jsonObject){
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($oermissao.utilizador, $permissao.permissao, "ContainerInherit,ObjectInherit", "None", "Allow")
            $ACL.SetAccessRule($AccessRule)
        }
        $ACL | Set-Acl -Path $Destination -ErrorAction Stop
    }
    catch {
    }

    if ($erro -eq 0) {
        Write-Host "Todas as permissões foram atribuidas com sucesso!" -ForegroundColor Green
    }
    else {
        Write-Host $msgErro -ForegroundColor Red
    }

}

# $erroPermissoes = 0
# $msgErroPermissoes = "Ocorreu um erro ao atribuir as seguintes permissões:"

# Write-Host $json.criar[0].name

$json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
CreateFolder -jsonObject $json.criar