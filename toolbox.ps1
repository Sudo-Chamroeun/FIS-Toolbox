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
    Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-Command `"`$Host.UI.RawUI.WindowTitle='$WindowTitle'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm fistoolbox.automizze.us | iex`""
    break
}

# --- STEP 2: PRO THEME SETTINGS ---
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Gray"
[Console]::ResetColor()
Clear-Host 

$RepoURL = "https://raw.githubusercontent.com/Sudo-Chamroeun/FIS-Toolbox/refs/heads/main"

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
    Write-Host "║             ##### #### ####   #   #### ####  #  # # #   #   ####             ║" -ForegroundColor $g
    Write-Host "║             #     #  # #  #   #   #    # #   #  #  ##   #       #            ║" -ForegroundColor $g
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
            $TempFile = "$env:TEMP\block-change-setting.bat"  
            $BatUrl   = "$RepoURL/block-change-setting.bat" 

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
            Write-Host "    > Applying Delete Chrome Profile..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\DeleteChromeProfilesTask_Final.bat"  
            $BatUrl   = "$RepoURL/DeleteChromeProfilesTask_Final.bat" 

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
