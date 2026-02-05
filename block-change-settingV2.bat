@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "TargetUser=Student"
set "HiveName=StudentHive"
set "UserPath=C:\Users\%TargetUser%"

:: Registry Keys
set "GlobalKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set "UserKey=HKU\%HiveName%\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

:: Allowed Pages: Network, Display (Brightness), Sound, Power, Update
set "AllowedPages=showonly:ms-settings:network;ms-settings:display;ms-settings:sound;ms-settings:powersleep;ms-settings:windowsupdate"

:menu
:: Reset Window & Color (Standard Black & White)
mode con: cols=80 lines=25
color 07
cls

echo.
echo ==============================================================================
echo                       SETTINGS ACCESS MANAGER
echo ==============================================================================
echo.
echo    Target Account: %TargetUser%
echo.
echo    [1] RESTRICT Student Settings
echo        (Fixes Admin access & Locks Student to: Wifi, Brightness, Power)
echo.
echo    [2] UNBLOCK / RESET All Settings
echo        (Removes ALL restrictions from Student and Computer)
echo.
echo    [Q] Exit
echo.
echo ==============================================================================
echo.

set /p choice=Select an option: 

if "%choice%"=="1" goto enable
if "%choice%"=="2" goto disable
if /i "%choice%"=="Q" goto exit

goto menu

:: ---------------------------------------------------------
:: OPTION 1: ENABLE RESTRICTIONS (AND FIX ADMIN ACCESS)
:: ---------------------------------------------------------
:enable
cls
echo.
echo [!] Applying Configuration...

:: STEP 1: REMOVE OLD "GLOBAL" LOCK (Fixes the Admin Account)
:: This ensures that if the old script was run, we clean it up right now.
reg delete "%GlobalKey%" /v "SettingsPageVisibility" /f >nul 2>&1

:: STEP 2: LOAD STUDENT PROFILE
if not exist "%UserPath%\NTUSER.DAT" (
    echo [X] ERROR: Profile for '%TargetUser%' not found.
    echo     Has the student logged in at least once?
    pause
    goto menu
)

reg load "HKU\%HiveName%" "%UserPath%\NTUSER.DAT" >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] ERROR: Access Denied.
    echo     The 'Student' account is currently LOGGED IN.
    echo     Please sign out the Student account and try again.
    pause
    goto menu
)

:: STEP 3: APPLY RESTRICTION TO STUDENT ONLY
reg add "%UserKey%" /v "SettingsPageVisibility" /t REG_SZ /d "%AllowedPages%" /f >nul 2>&1

:: STEP 4: SAVE & CLOSE
reg unload "HKU\%HiveName%" >nul 2>&1

echo.
echo [OK] SUCCESS!
echo      1. Global restrictions removed (Admin access restored).
echo      2. 'Student' account is now restricted (Wifi/Power/Display only).
echo.
pause
goto menu

:: ---------------------------------------------------------
:: OPTION 2: DISABLE / RESET (CLEAN EVERYTHING)
:: ---------------------------------------------------------
:disable
cls
echo.
echo [!] Resetting Configuration...

:: STEP 1: REMOVE OLD "GLOBAL" LOCK
reg delete "%GlobalKey%" /v "SettingsPageVisibility" /f >nul 2>&1

:: STEP 2: LOAD STUDENT PROFILE
if not exist "%UserPath%\NTUSER.DAT" (
    echo [!] Student profile not found. Cleaning global settings only...
    goto finish_reset
)

reg load "HKU\%HiveName%" "%UserPath%\NTUSER.DAT" >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] ERROR: Access Denied. Is 'Student' logged in?
    echo     Please sign out the Student account first.
    pause
    goto menu
)

:: STEP 3: REMOVE STUDENT RESTRICTION
reg delete "%UserKey%" /v "SettingsPageVisibility" /f >nul 2>&1

:: STEP 4: SAVE & CLOSE
reg unload "HKU\%HiveName%" >nul 2>&1

:finish_reset
echo.
echo [OK] SUCCESS!
echo      All settings restrictions (Global & Student) have been removed.
echo.
pause
goto menu

:exit
color 07
exit
