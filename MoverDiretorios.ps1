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

function CreateFolders () {
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
                #Vai atribuir as permissões á pasta
                AtribuirPermissoes -jsonObject $pasta.permissions -FolderPath $newFolder -folderName $pasta.name
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

function MoveFolders {
    param(
        [Parameter(Mandatory = $true)] $jsonObject #pastas
    )
    $erro = 0
    $msgErro = "Ocorreu um erro ao mover as seguintes pastas: "
    Write-Host "A mover pastas..."
    foreach ($pasta in $jsonObject) {
        try {
            if (Test-Path -Path $pasta.path) {
                Write-Host "A mover a pasta: "$pasta.name
                Move-Item -Path $pasta.path -Destination $pasta.destination -ErrorAction Stop
                Write-Host "Pasta movida com sucesso!!" -ForegroundColor Green 
                $newFolder = $pasta.destination + $pasta.name
                AtribuirPermissoes -jsonObject $pasta.permissions -FolderPath $newFolder -folderName $pasta.name
            }
            else {
                $erro = 1
                $msgErro += $pasta.name + " nao existe ||"
            }
        }
        catch {
            Write-Host "Ocorreu um erro ao mover a pasta "+$pasta.name -ForegroundColor Red
            $erro = 1
            $msgErro += $pasta.name + " || "
        }
    }

    if ($erro -eq 0) {
        Write-Host "Todas as pastas foram movidas com sucesso!!" -ForegroundColor Green
    }
    else {
        Write-Host $msgErro -ForegroundColor Red
    }
}

function AtribuirPermissoes () {
    param(
        [Parameter(Mandatory = $true)] $jsonObject, # permissoes
        [String] $FolderPath, # Path para a pasta a dar permissões
        [String] $folderName # nome da pasta
    )

    Write-Host "A atribuir permissoes a pasta: '$folderName'..." -ForegroundColor Yellow
    try {
        $ACL = Get-Acl $FolderPath
        foreach ($permissao in $jsonObject) {
            if (TestIfUserOrGroupExists -Nome $permissao.nome -Tipo $permissao.tipo) {
                write-host $permissao.nome " - " $permissao.permissao
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permissao.nome, $permissao.permissao, $permissao.heranca, "None", "Allow")
                $ACL.SetAccessRule($AccessRule)
            }
        }
        $ACL | Set-Acl -Path $FolderPath #-ErrorAction Stop
    }
    catch {
        Write-Host "Ocorreu um erro ao atribuir permissoes a pasta: $folderName" -ForegroundColor Red
    }

}

function TestIfUserOrGroupExists() {
    param(
        [Parameter(Mandatory = $true)] $Nome, #nome grupo ou utilizador
        [Parameter(Mandatory = $true)] $Tipo #se é grupo ou utilizador
    )
    $existe = False
    try {
        if ($tipo.ToLower() -eq "utilizador") {
            Get-ADUser -Identity $Nome
            $existe = True
        }
        elseif ($tipo.ToLower() -eq "grupo") {
            Get-ADGroup -Identity $Nome
            $existe = True
        }
        else {
            Write-Host "Tipo de identidade da permissão nao existe" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Utilizador/Grupo '"$nome"' nao existe." -ForegroundColor Red
        $existe = False
    }
    return $existe
}

$json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
Write-Host "Pastas a criar: "$json.criar.Count
Write-Host "Pastas a mover: "$json.mover.Count
if ($json.criar.Count -gt 0) {
    CreateFolders -jsonObject $json.criar
}
if ($json.mover.Count -gt 0) {
    MoveFolders -jsonObject $json.mover
}