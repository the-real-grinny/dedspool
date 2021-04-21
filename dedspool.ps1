# dedspool.ps1 remote-execution powershell script
# By Grinny, April 2021
# Got a print server that's being stupid? Dedspool it.
# All you need is an admin username and password for that machine
# Organically coded with all-natural ingredients
# Only tested on prod servers because I live on the edge
# ========================================

# Clear all sessions
#Invoke-Expression -Command "Get-PSSession | Remove-PSSession"
#$cred = Get-Credential # Set up a new credential
$ses = New-PSSession -Computername (Read-Host "Enter print server computer name") -Credential (Get-Credential) -Name "dedspool"# Set up session with credentials
#Enter-PSSession $ses # creates interactive session
Invoke-Command -Session $ses -ScriptBlock {
    Write-Host "Stopping spooler"
    Stop-Service -Force -Name "Spooler"
    Set-Location "C:\Windows\System32\spool\PRINTERS"
    Write-Host "Clearing C:\Windows\System32\spool\PRINTERS directory"
    try {
        Remove-Item .\*
    } catch  {
        Write-Host "The print server's spool file(s) are actively in use.`nTry again later."
    }
    Start-Service -Name "Spooler"
    Write-Host "Spooler restarted"
}
#Get-PSSession # debug
Invoke-Expression -Command "Get-PSSession | Remove-PSSession"
#Set-Location U:\
Exit 0