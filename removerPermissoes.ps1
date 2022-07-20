########################################
##   Developed By Martinho Gonçalves  ##
##             20/07/2022             ##
########################################

param(
    [Parameter(Mandatory = $true)] $JSONFile
)

function RemoverPerissoes() {
    param(
        [Parameter(Mandatory = $true)] $jsonObject
    )

    foreach ($pasta in $jsonObject) {
        try {
            ## Remover permissões da pasta Mãe
            $permissoesPastaMae = get-acl $folder.path  | ForEach-Object { $_.Access }
            $ACLPastaMae = get-acl $folder.path

            write-host "A remover permissões a pasta:" $folder.path -ForegroundColor Yellow

            foreach ($acl in $permissoesPastaMae) {
                Write-Host $acl.IdentityReference "-" $acl.FileSystemRights "-" $acl.AccessControlType
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acl.IdentityReference, $acl.FileSystemRights, $acl.InheritanceFlags, $acl.PropagationFlags, $acl.AccessControlType)
                # write-host $AccessRule
                $ACLPastaMae.RemoveAccessRule($AccessRule)
            }
            $ACLPastaMae | Set-acl $folder.path

            ## Remover as permissões das pastas filhos
            $folders = Get-ChildItem -Directory -Path $folder.path -Recurse

            foreach ($folder in $folders) {
                # $permissoesFilho = Get-ChildItem -Path $folder.FullName -Recurse | Get-ACL  | ForEach-Object { $_.Access }
                $permissoesFilho = get-acl $folder.FullName | ForEach-Object { $_.Access }

                write-host "Sub-Pasta:"$folder.FullName -ForegroundColor Yellow
                $ACLPasta = get-acl $folder.FullName

                foreach ($acl in $permissoesFilho) {
                    Write-Host $acl.IdentityReference "-" $acl.FileSystemRights "-" $acl.AccessControlType
                    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acl.IdentityReference, $acl.FileSystemRights, $acl.InheritanceFlags, $acl.PropagationFlags, $acl.AccessControlType)
                    # write-host $AccessRule
                    $ACLPasta.RemoveAccessRule($AccessRule)
                }
                $ACLPasta | Set-Acl $folder.FullName
            }

        }
        catch {
            #Adicionar objeto a lista caso haja um erro a mover para depois criar um novo ficheiro
            $list.Add($pasta)

            Write-Host "Ocorreu um erro ao mover a pasta " $pasta.name -ForegroundColor Red
            $erro = 1
            $msgErro += $pasta.name + " || "; 
        }
    }

}

try {
    $json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
    
    Write-Host "A remover permissões de pelo menos '"$json.mover.Count"' pastas."
    $continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)"
    if ($continuar.ToLower() -eq 's' ) {
        if ($json.mover.Count -gt 0) {
            RemoverPerissoes -jsonObject $json.mover
        }
    }

}
catch {
    Write-Host "Ocorreu um erro ao ler o ficheiro. Verifique que o JSON esta em conformidade com as regras." -ForegroundColor Red
}




