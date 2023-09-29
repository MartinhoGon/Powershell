########################################
##   Developed By Martinho Gonçalves  ##
##             20/07/2022             ##
########################################

### Objecto ACL
# FileSystemRights  : FullControl
# AccessControlType : Allow
# IdentityReference : CM-ALVAIAZERE\airc
# IsInherited       : False
# InheritanceFlags  : ContainerInherit, ObjectInherit
# PropagationFlags  : None

########### parameters #####
#
#  jsonFile - ficheiros json das pastas
#  users - utilizadores separados por ',' - o primeiro utilizador será definido como Owner da pasta - serão dadas permissões de full control
#
#

param(
    [Parameter(Mandatory = $true)] $JSONFile,
    [Parameter(Mandatory = $true)] $users
)

function RemoverPermissoes() {
    param(
        [Parameter(Mandatory = $true)] $jsonObject,
        [Parameter(Mandatory = $true)] $users
    )

    $usersArray = $users.Split(",")

    # foreach ($user in $usersArray){
    #     Write-Host $user
    # }

    foreach ($pasta in $jsonObject) {
        try {
            if (-Not (Test-Path -Path $pasta.path)) {
                Write-Host "A pasta:"$pasta.path"nao existe!" -ForegroundColor Red
                continue
            }

            ## Remover permissões da pasta Mãe
            $permissoesPastaMae = get-acl $pasta.path  | ForEach-Object { $_.Access }
            $ACLPastaMae = get-acl $pasta.path

            write-host "A remover permissoes a pasta:" $pasta.path -ForegroundColor Yellow

            foreach ($acl in $permissoesPastaMae) {
                if(-Not $acl.IsInherited){
                    Write-Host $acl.IdentityReference "-" $acl.FileSystemRights "-" $acl.AccessControlType
                    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acl.IdentityReference, $acl.FileSystemRights, $acl.InheritanceFlags, $acl.PropagationFlags, $acl.AccessControlType)
                    # write-host $AccessRule
                    $ACLPastaMae.RemoveAccessRule($AccessRule)
                }
            }
            foreach ($user in $usersArray){
                $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
                $ACLPastaMae.SetAccessRule($AccessRule)
            }
            # $ACLPastaMae.setOwner([System.Security.Principal.NTAccount]$usersArray[0])
            # Set-Owner -Path $pasta.path -Account $usersArray[0]
            $ACLPastaMae | Set-acl $pasta.path

            ## Remover as permissões das pastas filhos
            $folders = Get-ChildItem -Directory -Path $pasta.path -Recurse

            ## Percorre as pastas filho e remove as ACLs para cada uma delas 
            foreach ($folderChild in $folders) {
                # $permissoesFilho = Get-ChildItem -Path $folder.FullName -Recurse | Get-ACL  | ForEach-Object { $_.Access }
                $permissoesFilho = get-acl $folderChild.FullName | ForEach-Object { $_.Access }

                write-host "Sub-Pasta:"$folderChild.FullName -ForegroundColor Yellow
                $ACLPasta = get-acl $folderChild.FullName

                foreach ($acl in $permissoesFilho) {
                    if(-Not $acl.IsInherited){
                        Write-Host $acl.IdentityReference "-" $acl.FileSystemRights "-" $acl.AccessControlType
                        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($acl.IdentityReference, $acl.FileSystemRights, $acl.InheritanceFlags, $acl.PropagationFlags, $acl.AccessControlType)
                        $ACLPasta.RemoveAccessRule($AccessRule)
                    }
                }
                foreach ($user in $usersArray){
                    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
                    $ACLPasta.SetAccessRule($AccessRule)
                }
                # $ACLPasta.setOwner([System.Security.Principal.NTAccount]$usersArray[0])
                # Set-Owner -Path $folderChild.FullName -Account $usersArray[0]
                $ACLPasta | Set-Acl $folderChild.FullName
            }

        }
        catch {
            Write-Warning $Error[0]
            Write-Host "Ocorreu um erro ao remover as permissoes da pasta: " $pasta.name -ForegroundColor Red
        }
    }

}

try {
    $json = Get-Content $JSONFile -Encoding utf8 | ConvertFrom-Json
    
    Write-Host "A remover permissões de pelo menos '"$json.mover.Count"' pastas."
    $continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)"
    if ($continuar.ToLower() -eq 's' ) {
        if ($json.mover.Count -gt 0) {
            RemoverPermissoes -jsonObject $json.mover -users $users
        }
    }

}
catch {
    Write-Host "Ocorreu um erro ao ler o ficheiro. Verifique que o JSON esta em conformidade com as regras." -ForegroundColor Red
}




