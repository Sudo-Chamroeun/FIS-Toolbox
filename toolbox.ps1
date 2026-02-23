<#
    FOOTPRINTS IT TOOLBOX - MASTER MENU
    Hosted at: fistoolbox.automizze.us
#>

# --- STEP 0: FIX PERMISSIONS (CRITICAL FOR VM) ---
# 1. Force TLS 1.2 for GitHub downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. Force Script Execution (Fixes "running scripts is disabled" error)
# This allows the downloaded tools to run within this specific window.
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

# --- STEP 1: POPUP LOGIC ---
$WindowTitle = "Footprints IT Console"

if ($Host.UI.RawUI.WindowTitle -ne $WindowTitle) {
    Write-Host "Launching Console..." -ForegroundColor Cyan
    # We pass the execution policy into the new window as well
    Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-Command `"`$Host.UI.RawUI.WindowTitle='$WindowTitle'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm security.footprints.work | iex`""
    break
}

# --- STEP 2: PRO THEME SETTINGS ---
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Gray"
[Console]::ResetColor()
Clear-Host 

$RepoURL = "https://raw.githubusercontent.com/Sudo-Chamroeun/FIS-Toolbox/refs/heads/main"
$ActivateURL = "https://activate.footprints.work"

function Show-Header {
    [Console]::Clear()
    $c = "Cyan"; $g = "Green"; $w = "White"

    # Top Border (Total Width: 80 chars)
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $c
    Write-Host "║                                                                              ║" -ForegroundColor $c
    
    # ASCII ART: FOOTPRINTS (Centered)
    # The logo is 52 chars wide. We use 13 spaces on left & 13 on right to equal 78 inner chars.
    
    Write-Host "║             ##### #### #### ##### #### #### ### #   # ##### ####             ║" -ForegroundColor $g
    Write-Host "║             #     #  # #  #   #   #  # #  #  #  ##  #   #   #                ║" -ForegroundColor $g
    Write-Host "║             ##### #  # #  #   #   #### ####  #  # # #   #   ####             ║" -ForegroundColor $g
    Write-Host "║             #     #  # #  #   #   #    # #   #  #  ##   #      #             ║" -ForegroundColor $g
    Write-Host "║             #     #### ####   #   #    #  # ### #   #   #   ####             ║" -ForegroundColor $g
    
    Write-Host "║                                                                              ║" -ForegroundColor $c
    
    # TEXT: IT TEAM (Centered)
    # Text is 20 chars wide. We use 29 spaces on left & 29 on right.
    Write-Host "║                             -  I T   T E A M  -                              ║" -ForegroundColor $w
    
    Write-Host "║                                                                              ║" -ForegroundColor $c
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $c
    Write-Host ""
}

# --- STEP 3: MAIN LOOP ---
do {
    Show-Header
    
    Write-Host "    [1] Folder Restriction" -ForegroundColor White
    Write-Host "    [2] Browser Control" -ForegroundColor White
    Write-Host "    [3] Block Change Setting" -ForegroundColor White
    Write-Host "    [4] Delete Chrome Profile" -ForegroundColor White
    Write-Host "    [5] Display Control" -ForegroundColor White
    Write-Host "    [6] Office Removal" -ForegroundColor White
    Write-Host ""
    
    Write-Host "    ----------------------- INSTRUCTIONS -----------------------" -ForegroundColor DarkGray
    Write-Host "     * Run this tool as Administrator for full access." -ForegroundColor Gray
    Write-Host "     * Scripts are temporarily unlocked for this session." -ForegroundColor Gray
    Write-Host "     * Internet connection is required make sure of it." -ForegroundColor Gray
    Write-Host "    ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "    [Q] Quit" -ForegroundColor Red
    Write-Host ""

    $input = Read-Host "    Select an option"

    switch ($input) {
        '1' { 
            Write-Host "    > Initializing Folder Restriction..." -ForegroundColor Cyan
            
            $ToolPath = "$env:TEMP\FolderRestrictionTool.ps1"
            $ToolUrl  = "$RepoURL/FolderRestrictionTool.ps1"

            try {
                Invoke-WebRequest -Uri $ToolUrl -OutFile $ToolPath -ErrorAction Stop -UseBasicParsing
                
                # Execute the downloaded script
                # The execution policy fix at the top makes this work now!
                . $ToolPath
                
                if (Test-Path $ToolPath) { Remove-Item $ToolPath -Force -ErrorAction SilentlyContinue }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error running tool." -ForegroundColor Red
                Write-Host "    Info: $($_.Exception.Message)" -ForegroundColor DarkRed
                Pause
            }
        }
        
        '2' { 
            Write-Host "    > Initializing Browser Controls Tool..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\Browser-Controls.bat"  
            $BatUrl   = "$RepoURL/Browser-Controls.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop -UseBasicParsing
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
                Write-Host "    Info: $($_.Exception.Message)" -ForegroundColor DarkRed
                Pause
            }
        }
        
        '3' { 
            Write-Host "    > Initializing Block Setting Tool..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\block-change-settingV2.bat"  
            $BatUrl   = "$RepoURL/block-change-settingV2.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop -UseBasicParsing
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
                Write-Host "    Info: $($_.Exception.Message)" -ForegroundColor DarkRed
                Pause
            }
        } 

        '4' { 
            Write-Host "    > Initializing Chrome Profile Delete Tool..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\DeleteChromeProfileV2.bat"  
            $BatUrl   = "$RepoURL/DeleteChromeProfileV2.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop -UseBasicParsing
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
                Write-Host "    Info: $($_.Exception.Message)" -ForegroundColor DarkRed
                Pause
            }
        }

        '5' { 
            Write-Host "    > Initializing Display Control..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\Display-Control.bat"  
            $BatUrl   = "$RepoURL/Display-Control.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop -UseBasicParsing
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
                Write-Host "    Info: $($_.Exception.Message)" -ForegroundColor DarkRed
                Pause
            }
        }

        '6' { 
            # 1. Setup paths
            Write-Host "    > Initializing Office Removal Tool..." -ForegroundColor Cyan
            #$ExeFile = "$env:TEMP\Office-Removal-Tool.exe"
            $ExeFile = "$env:TEMP\AIO.cmd"
            #$ExeUrl  = "$RepoURL/Office-Removal-Tool.exe"
            $ExeUrl  = "$ActivateURL/AIO.cmd"

            try {
                # 2. Download the EXE
                Write-Host "    > Downloading tool..." -NoNewline
                Invoke-WebRequest -Uri $ExeUrl -OutFile $ExeFile -ErrorAction Stop -UseBasicParsing
                Write-Host " [OK]" -ForegroundColor Green

                # 3. Message to User
                Write-Host "    > Launching Application..." -ForegroundColor Yellow
                Write-Host "    --------------------------------------------------" -ForegroundColor Gray
                Write-Host "    [INFO] The menu is paused." -ForegroundColor Gray
                Write-Host "    [INFO] Please use the Office Tool window." -ForegroundColor Gray
                Write-Host "    [INFO] Close the tool to return to this menu." -ForegroundColor Gray
                Write-Host "    --------------------------------------------------" -ForegroundColor Gray
                
                # 4. RUN AND WAIT (The Magic Trick)
                # The -Wait switch forces PowerShell to pause until the .exe is closed.
                Start-Process -FilePath $ExeFile -Wait -NoNewWindow
                
                # 5. Cleanup (Delete the .exe after use to keep PC clean)
                if (Test-Path $ExeFile) { 
                    Remove-Item -Path $ExeFile -Force 
                }
                
                Write-Host "    > Tool closed. Returning..." -ForegroundColor Green
                Start-Sleep -Seconds 1
            }
            catch {
                Write-Host " [FAILED]" -ForegroundColor Red
                Write-Host "    [!] Error downloading or running the tool." -ForegroundColor Red
                Write-Host "    Info: $($_.Exception.Message)" -ForegroundColor DarkRed
                Pause
            }
        }        

        'Q' { 
            Write-Host "    Closing..." -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            Stop-Process -Id $PID
        }

        Default { 
            Write-Host "    [!] Invalid selection." -ForegroundColor Red
            Start-Sleep -Seconds 1 
        }
    }
} until ($input -eq 'Q')
