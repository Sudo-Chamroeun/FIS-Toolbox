@echo off

rem Get the path to the script's directory
set "ScriptDir=%~dp0"

rem Create a PowerShell script file
echo # PowerShell script to delete Chrome user profiles for all users > "%ScriptDir%\DeleteChromeProfiles.ps1"
echo. >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo # Get all user profiles >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo $profiles = Get-WmiObject Win32_UserProfile ^| Where-Object { $_.Special -eq $false } >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo. >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo # Loop through each user profile and delete Chrome user data >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo foreach ($profile in $profiles) { >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo     $chromePath = Join-Path $profile.LocalPath 'AppData\Local\Google\Chrome\User Data' >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo     if (Test-Path $chromePath) { >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo         Remove-Item -Path $chromePath -Recurse -Force >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo         Write-Host "Chrome profiles deleted for user: $($profile.LocalPath)" >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo     } else { >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo         Write-Host "Chrome profiles directory not found for user: $($profile.LocalPath)" >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo     } >> "%ScriptDir%\DeleteChromeProfiles.ps1"
echo } >> "%ScriptDir%\DeleteChromeProfiles.ps1"

rem Create a scheduled task to run the PowerShell script at startup for all users
schtasks /create /tn "DeleteChromeProfilesTask" /tr "powershell.exe -ExecutionPolicy Bypass -File \"%ScriptDir%\DeleteChromeProfiles.ps1\"" /sc onstart /ru SYSTEM /F

rem Configure the task to run for all users
schtasks /run /tn "DeleteChromeProfilesTask"

echo Scheduled task created. Chrome user profiles will be deleted at computer startup for all users.

exit
