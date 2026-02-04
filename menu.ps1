<#
    FOOTPRINTS IT TOOLBOX - MASTER MENU
    Hosted at: fistoolbox.automizze.us
#>

# --- STEP 1: POPUP LOGIC (NON-DESTRUCTIVE) ---
$WindowTitle = "Footprints IT Console"

# If the current window is NOT the "Footprints Console", open a new one.
if ($Host.UI.RawUI.WindowTitle -ne $WindowTitle) {
    Write-Host "Launching Console..." -ForegroundColor Cyan
    
    # Start the NEW window with the correct title and run the script
    Start-Process powershell -ArgumentList "-NoExit", "-Command `"`$Host.UI.RawUI.WindowTitle='$WindowTitle'; irm fistoolbox.automizze.us | iex`""
    
    # The script in THIS window stops here.
    break
}

# --- STEP 2: PRO THEME SETTINGS (Black & Green) ---
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Gray"
# Force the console to reset immediately to apply the black background
[Console]::ResetColor()
Clear-Host 

# Define your GitHub URL base here for easy updating
$RepoURL = "https://raw.githubusercontent.com/Sudo-Chamroeun/FIS-Toolbox/refs/heads/main"

function Show-Header {
    # [Console]::Clear() is stronger than Clear-Host. 
    # It fixes the "Ghost Text" bug where the menu prints in the middle of the screen.
    [Console]::Clear()

    $c = "Cyan"   # Frame Color
    $b = "Green"  # Branding Color (Changed to Green for Pro look)
    $w = "White"  # Text Color

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

# --- STEP 3: THE MAIN LOOP ---
do {
    Show-Header
    
    # --- THE MENU OPTIONS ---
    Write-Host "    [1] Folder Restriction" -ForegroundColor White
    Write-Host "    [2] Browser Control" -ForegroundColor White
    Write-Host "    [3] Block Change Setting" -ForegroundColor White
    Write-Host "    [4] Delete Chrome Profile" -ForegroundColor White
    #Write-Host "    [5] Delete Chrome Profile Laptop" -ForegroundColor DarkGray
    Write-Host ""
    
    # --- THE STATIC INSTRUCTIONS ---
    Write-Host "    ------------------- INSTRUCTIONS -------------------" -ForegroundColor DarkGray
    Write-Host "     * Run this tool as Administrator for full access." -ForegroundColor Gray
    Write-Host "     * Type the number of the tool you want to use." -ForegroundColor Gray
    Write-Host "     * If a script fails, check your internet connection." -ForegroundColor Gray
    Write-Host "    ----------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "    [Q] Quit" -ForegroundColor Red
    Write-Host ""

    # This fixes the cursor position bug
    $input = Read-Host "    Select an option"

    switch ($input) {
     '1' { 
            Write-Host "    > Initializing Folder Restriction..." -ForegroundColor Cyan
            
            # 1. Define where to put the tool
            $ToolPath = "$env:TEMP\FolderRestrictionTool.ps1"
            # 2. Your new RAW link (Update this!)
            $ToolUrl  = "$RepoURL/Folder-Restriction/FolderRestrictionTool.ps1"

            try {
                # 3. Download the single all-in-one script
                Invoke-WebRequest -Uri $ToolUrl -OutFile $ToolPath -ErrorAction Stop
                
                # 4. Run it inside the current window
                # We use dot-sourcing (.) so it runs in the same session
                . $ToolPath
                
                # 5. Cleanup
                Remove-Item $ToolPath -Force -ErrorAction SilentlyContinue
                
                # Reset screen when coming back
                [Console]::Clear()
            }
            catch {
                Write-Host "    [!] Error: Could not download tool." -ForegroundColor Red
                Pause
            }
        }
        
        '2' { 
            Write-Host "    > Initializing Browser Controls Tool..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\Browser-Controls.bat"  
            $BatUrl   = "$RepoURL/Browser-Controls.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop
                
                # Run the Batch file
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                
                # CLEANUP & RESET
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                
                # CRITICAL FIX: Give PowerShell a second to regain control of the window
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
                Pause
            }
        }
        
        '3' { 
            Write-Host "    > Initializing Block Setting Tools..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\block-change-setting.bat"  
            $BatUrl   = "$RepoURL/block-change-setting.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop
                
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
                Pause
            }
        } 

        '4' { 
            Write-Host "    > Applying Delete Chrome Profile..." -ForegroundColor Cyan
            $TempFile = "$env:TEMP\DeleteChromeProfilesTask_Final.bat"  
            $BatUrl   = "$RepoURL/DeleteChromeProfilesTask_Final.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop
                
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
                Start-Sleep -Milliseconds 500
            }
            catch {
                Write-Host "    [!] Error downloading script." -ForegroundColor Red
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
