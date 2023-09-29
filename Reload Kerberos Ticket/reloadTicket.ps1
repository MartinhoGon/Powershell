########################################
##   Developed By Martinho Gonçalves  ##
##             29/09/2023             ##
########################################

####
#### This script allows the executuner to reload its keerberos ticket and reload his group permissions
####


 


$user = Read-Host "Introduza o seu utilizador"
Write-Host "Ola $user o seu ambiente de trabalho ira ser refrescado. Por favor guarde todos os documentos que tem em utilização." -ForegroundColor Yellow
$continuar = Read-Host "Tem a certeza que pretende continuar? (s/n)" 
    
if($continuar.ToLower() -eq 's' ){
    try{
        Write-Host "A iniciar processo..."
        klist purge  ## deletes all tickets
        taskkill /f /im explorer.exe  ## Kills file explorer ticket
        runas /user:cm-alvaiazere.pt\$user explorer.exe  # restart File Explorer
        #kinit $user@cm-alvaiazere.pt
        Write-Host "Processo concluído com sucesso"
    }catch {
        Write-Host "Introduziu a plavra-passe incorreta"
        Stop-Process -Name explorer -Force
        Start-Process explorer
        Start-Sleep -Seconds 10
    }finally {
        Stop-Process -Name explorer -Force
        Start-Process explorer
    }
}else{
    Write-Host "Operação cancelada..."
}
