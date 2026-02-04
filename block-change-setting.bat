@echo off
setlocal

:: 1. Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    goto menu
) else (
    cls
    echo =======================================================
    echo  ERROR: ADMINISTRATOR PRIVILEGES REQUIRED
    echo =======================================================
    echo.
    echo  This script must be run as an Administrator to
    echo  change system-wide policies.
    echo.
    echo  Please right-click the .bat file and select
    echo  "Run as administrator".
    echo.
    pause
    exit
)

:: 2. Main Menu Loop
:menu
cls
echo =======================================================
echo    Windows 11 Settings Manager for Student Account
echo =======================================================
echo.
echo  This tool restricts the Settings app for all
echo  STANDARD USER accounts (like "student").
echo.
echo  Administrators will still have full access.
echo.
echo  The following pages will be ALLOWED:
echo    - Network & Internet
echo    - Display (includes Brightness)
echo    - Sound
echo    - Power & Battery
echo    - Windows Update
echo.
call :check_status
echo.
echo  Please choose an option:
echo.
echo    1. Enable Restrictions
echo    2. Disable Restrictions
echo    3. Exit
echo.
set /p "choice=Enter your choice (1, 2, or 3): "

if "%choice%"=="1" goto enable
if "%choice%"=="2" goto disable
if "%choice%"=="3" goto exit

echo Invalid choice. Press any key to try again.
pause >nul
goto menu

:: 3. Check Status Function
:check_status
set "REG_KEY=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set "REG_VALUE=SettingsPageVisibility"
    
reg query "%REG_KEY%" /v "%REG_VALUE%" >nul 2>&1
if %errorLevel% == 0 (
    echo  STATUS: Restrictions are currently [ ENABLED ]
) else (
    echo  STATUS: Restrictions are currently [ DISABLED ]
)
goto :eof

:: 4. Enable Restrictions Function
:enable
cls
echo Enabling Settings restrictions...
set "REG_KEY=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set "REG_VALUE=SettingsPageVisibility"
:: This list defines the pages to SHOW. All others will be hidden.
set "PAGES_LIST=showonly:ms-settings:network;ms-settings:system-display;ms-settings:system-sound;ms-settings:system-power;ms-settings:windowsupdate"
    
reg add "%REG_KEY%" /v "%REG_VALUE%" /t REG_SZ /d "%PAGES_LIST%" /f
    
if %errorLevel% == 0 (
    echo.
    echo  SUCCESS: Settings restrictions have been enabled.
    echo.
    echo  The "student" user will need to log out and
    echo  log back in for this change to take effect.
) else (
    echo.
    echo  ERROR: Failed to write to the registry.
)
echo.
pause
goto menu

:: 5. Disable Restrictions Function
:disable
cls
echo Disabling Settings restrictions...
set "REG_KEY=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set "REG_VALUE=SettingsPageVisibility"
    
:: We only try to delete the value. /f (force) prevents an error if it's already gone.
reg delete "%REG_KEY%" /v "%REG_VALUE%" /f >nul 2>&1
    
echo.
echo  SUCCESS: Settings restrictions have been disabled.
echo.
echo  The "student" user will need to log out and
echo  log back in for full access to be restored.
echo.
pause
goto menu

:: 6. Exit
:exit
cls
echo Exiting...
endlocal
exit /b