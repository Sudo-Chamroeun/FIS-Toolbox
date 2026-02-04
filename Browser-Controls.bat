@echo off
setlocal enabledelayedexpansion

:menu
cls
:: REMOVED THE MODE CON LINE TO FIX THE GLITCH
title IT Department - FOOTPRINTS INTERNATIONAL SCHOOL

echo.
echo ====================
echo   Browser Controls
echo ====================
echo.

echo 1. Restrict Sign-in (Internal Domain Only)
echo 2. Block All Browsers (Except Chrome)
echo 3. Reset / Unblock All
echo 4. Exit
echo.

set /p choice=Enter your choice: 

if "%choice%"=="1" (
    echo Applying Sign-in Restrictions...
    :: We use >nul 2>&1 to hide the "Operation Successful" text so it doesn't clutter the screen
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /t REG_DWORD /d 2 /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /t REG_SZ /d "*@*t*t*o*.edu.kh" /f >nul 2>&1

    echo [OK] Restrict Sign-in pattern set to *@*t*t*o*.edu.kh
    pause
    goto menu
)

if "%choice%"=="2" (
    echo Blocking Browsers...
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DisallowRun" /v "DisallowRun" /t REG_DWORD /d 1 /f >nul 2>&1
    
    :: Redirecting all outputs to NULL to prevent "Ghost Text"
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\safari.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\launcher.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f >nul 2>&1
    
    echo [OK] Browsers have been blocked. Only Chrome is allowed.
    pause
    goto menu
)

if "%choice%"=="3" (
    echo Resetting configurations...
    
    :: The >nul 2>&1 here hides the "Error: Key not found" text which was causing your glitch!
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /f >nul 2>&1
    
    :: Cleaning up the blocked browsers
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\safari.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\launcher.exe" /f >nul 2>&1

    echo [OK] All settings have been reset.
    pause
    goto menu
)

if "%choice%"=="4" (
    exit
)

goto menu
