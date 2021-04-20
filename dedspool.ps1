﻿# Clear all sessions
Invoke-Expression -Command "Get-PSSession | Remove-PSSession"
$cred = Get-Credential # Set up a new credential
$ses = New-PSSession -Computername PRINTSRV -Credential $cred # Set up session with credentials
Enter-PSSession $ses # creates interactive session
    try {
        Write-Host "Stopping spooler"
        Stop-Service -Force -Name "Spooler"
        Set-Location "C:\Windows\System32\spool\PRINTERS"
        Write-Host "Clearing C:\Windows\System32\spool\PRINTERS directory"
        Remove-Item .\*
        Start-Service -Name "Spooler"
        Write-Host "Spooler restarted"
    } catch {
        Write-Host $error
        Write-Host "it dun broke"
    }
#Invoke-Expression -Command "Get-PSSession | Remove-PSSession"
#Exit