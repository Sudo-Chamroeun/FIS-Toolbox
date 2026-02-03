@echo off
setlocal enabledelayedexpansion

:menu
cls
mode con: cols=75 lines=15
title IT Department - FOOTPRINTS INTERNATIONAL SCHOOL

echo.
echo ====================
echo   Browser Controls
echo ====================
echo.

echo 1. Restrict Sign-in
echo 2. Block Browsers
echo 3. Reset Setting
echo 4. Exit
echo.

set /p choice=Enter your choice: 

if "%choice%"=="1" (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /t REG_DWORD /d 2 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /t REG_SZ /d "*@*t*t*o*.edu.kh" /f

    echo Restrict Sign-in pattern has been set to *@*t*t*o*.edu.kh domain.
    pause
    goto menu
)

if "%choice%"=="2" (
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DisallowRun" /v "DisallowRun" /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\safari.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\launcher.exe" /v "Debugger" /t REG_SZ /d "C:\Windows\System32\taskkill.exe" /f
    echo Browsers have been blocked. Only Chrome is allowed.
    echo Press any key to continue...
    pause >nul
    goto menu
)

if "%choice%"=="3" (
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DisallowRun" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\opera.exe" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\safari.exe" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brave.exe" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe" /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\launcher.exe" /f

    rem Resetting option 1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserSignin" /t REG_DWORD /d 0 /f
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "RestrictSigninToPattern" /f

    echo All settings have been reset.
    echo Press any key to continue...
    pause >nul
    goto menu
)

if "%choice%"=="4" (
    exit
)

goto menu
