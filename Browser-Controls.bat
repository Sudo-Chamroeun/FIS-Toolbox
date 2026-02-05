@echo off
setlocal enabledelayedexpansion

:menu
cls
:: REMOVED THE MODE CON LINE TO FIX THE GLITCH
title IT Department - FOOTPRINTS INTERNATIONAL SCHOOL

echo.
echo ====================
echo    Browser Controls
echo ====================
echo.

echo 1. Restrict Sign-in (Footprints + CenterAR)
echo 2. Block All Browsers (Except Chrome)
echo 3. Reset Sign-in Only (Allow all emails)
echo 4. Reset Browser Block Only (Unblock Edge/Firefox/etc)
echo Q. Exit
echo.

set /p choice=Enter your choice: 

:: ---------------------------------------------------------
:: OPTION 1: RESTRICT SIGN-IN (DUAL DOMAIN)
:: ---------------------------------------------------------
if "%choice%"=="1" (
    echo Applying Sign-in Restrictions...
    
    :: Force sign-in to be intercepted
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /t REG_DWORD /d 2 /f >nul 2>&1
    
    :: Regex Pattern for TWO domains. 
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /t REG_SZ /d ".*@(footprintsschool|centerareducation)\.edu\.kh" /f >nul 2>&1

    echo [OK] Sign-in restricted to:
    echo      - @footprintsschool.edu.kh
    echo      - @centerareducation.edu.kh
    pause
    goto menu
)

:: ---------------------------------------------------------
:: OPTION 2: BLOCK BROWSERS
:: ---------------------------------------------------------
if "%choice%"=="2" (
    echo Blocking Browsers...
    
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

:: ---------------------------------------------------------
:: OPTION 3: RESET SIGN-IN ONLY
:: ---------------------------------------------------------
if "%choice%"=="3" (
    echo Resetting Sign-in Restrictions...
    
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /f >nul 2>&1
    
    echo [OK] Sign-in restrictions removed. Any Gmail can login.
    pause
    goto menu
)

:: ---------------------------------------------------------
:: OPTION 4: RESET BROWSER BLOCK ONLY
:: ---------------------------------------------------------
if "%choice%"=="4" (
    echo Unblocking Browsers...
    
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\safari.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe" /f >nul 2>&1
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\launcher.exe" /f >nul 2>&1

    echo [OK] Browsers unblocked. Edge and others will now work.
    pause
    goto menu
)

:: ---------------------------------------------------------
:: EXIT LOGIC (Case Insensitive)
:: ---------------------------------------------------------
:: The /i switch makes it ignore case (q = Q)
if /i "%choice%"=="Q" (
    exit
)

goto menu
