@echo off
title Display Reset Manager V3
:: Set color to Light Green text on Black background
color 0A
set "startup_file=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\ForceDuplicate.bat"

:menu
cls
:: --- STATUS CHECK ---
if exist "%startup_file%" (
    set "status_msg=ENABLED (Screens will reset to Duplicate on startup)"
) else (
    set "status_msg=DISABLED (User settings will remain changed)"
)

echo ========================================================
echo        DISPLAY RESET MANAGER (With Delay)
echo ========================================================
echo.
echo    CURRENT STATUS: %status_msg%
echo.
echo ========================================================
echo.
echo    1. ENABLE  (Turn ON auto-reset)
echo    2. DISABLE (Turn OFF auto-reset)
echo    3. EXIT
echo.
echo ========================================================
set /p choice=Select Option (1, 2, or 3): 

if "%choice%"=="1" goto enable
if "%choice%"=="2" goto disable
if "%choice%"=="3" goto end
goto menu

:enable
cls
echo Enabling auto-reset...

:: Create the startup script with a delay
(
echo @echo off
echo :: Waiting for Windows to load graphics drivers...
echo timeout /t 6 /nobreak ^>nul
echo :: First attempt
echo DisplaySwitch.exe /clone
echo timeout /t 2 /nobreak ^>nul
echo :: Second attempt to ensure it sticks
echo DisplaySwitch.exe /clone
echo exit
) > "%startup_file%"

echo.
echo [OK] Task created successfully.
echo Windows will now wait 6 seconds after login, then force Duplicate.
timeout /t 3 >nul
goto menu

:disable
cls
echo Disabling auto-reset...

if exist "%startup_file%" (
    del "%startup_file%"
    echo [OK] Task removed.
) else (
    echo [INFO] It was already disabled.
)

timeout /t 2 >nul
goto menu

:end
exit
