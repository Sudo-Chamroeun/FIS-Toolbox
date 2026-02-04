<#
    FOOTPRINTS IT TOOLBOX - MASTER MENU
    Hosted at: fistoolbox.automizze.us
#>

# --- STEP 0: FIX CONNECTIVITY FOR ALL WINDOWS VERSIONS ---
# This forces PowerShell to use TLS 1.2 (Required by GitHub)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- STEP 1: POPUP LOGIC (NON-DESTRUCTIVE) ---
$WindowTitle = "Footprints IT Console"

if ($Host.UI.RawUI.WindowTitle -ne $WindowTitle) {
    Write-Host "Launching Console..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-NoExit", "-Command `"`$Host.UI.RawUI.WindowTitle='$WindowTitle'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm fistoolbox.automizze.us | iex`""
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
    $c = "Cyan"; $b = "Green"; $w = "White"

    Write-Host "╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor $c
    Write-Host "║                                                                      ║" -ForegroundColor $c
    Write-Host "║    #######  #######  #######  #######  ######   ######   #  #     #  ║" -ForegroundColor $b
    Write-Host "║    #        #     #  #     #     #     #     #  #     #  #  ##    #  ║" -ForegroundColor $b
    Write-Host "║    #####    #     #  #     #     #     ######   ######   #  # #   #  ║" -ForegroundColor $b
    Write-Host "║    #        #     #  #     #     #     #        #   #    #  #  #  #  ║" -ForegroundColor $b
    Write-Host "║    #        #######  #######     #     #        #    #   #  #   # #  ║" -ForegroundColor $b
    Write-Host "║                                                                      ║" -ForegroundColor $c
    Write-Host "║                   S C H O O L   T O O L B O X                        ║" -ForegroundColor $w
    Write-Host "║                                                                      ║" -ForegroundColor $c
    Write-Host "╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor $c
    Write-Host ""
}

# --- STEP 3: MAIN LOOP ---
do {
    Show-Header
    
    Write-Host "    [1] Folder Restriction" -ForegroundColor White
    Write-Host "    [2] Browser Control" -ForegroundColor White
    Write-Host "    [3] Block Change Setting" -ForegroundColor White
    Write-Host "    [4] Delete Chrome Profile Desktop" -ForegroundColor White
    Write-Host ""
    
    Write-Host "    ------------------- INSTRUCTIONS -------------------" -ForegroundColor DarkGray
    Write-Host "     * Run this tool as Administrator for full access." -ForegroundColor Gray
    Write-Host "     * Type the number of the tool you want to use." -ForegroundColor Gray
    Write-Host "    ----------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "    [Q] Quit" -ForegroundColor Red
    Write-Host ""

    $input = Read-Host "    Select an option"

    switch ($input) {
        '1' { 
            Write-Host "    > Initializing Folder Restriction..." -ForegroundColor Cyan
            
            $ToolPath = "$env:TEMP\FolderRestrictionTool.ps1"
            $ToolUrl  = "$RepoURL/FolderRestrictionTool.ps1"

            try {
                # Added -UseBasicParsing for compatibility
                Invoke-WebRequest -Uri $ToolUrl -OutFile $ToolPath -ErrorAction Stop -UseBasicParsing
                
                # Execute the downloaded script
                . $ToolPath
                
                if (Test-Path $ToolPath) { Remove-Item $ToolPath -Force -ErrorAction SilentlyContinue }
                
                # Wait before redrawing menu
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading tool." -ForegroundColor Red
                # Prints the specific error code (e.g. 404 or TLS issue)
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
