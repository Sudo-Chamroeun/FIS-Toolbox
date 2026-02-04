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
    
    # We REMOVED the 'exit' command here, so the original window stays open.
    # The script in THIS window stops here.
    break
}

# --- STEP 2: CONSOLE STYLING ---
$Host.UI.RawUI.BackgroundColor = "DarkBlue"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host 

# Define your GitHub URL base here for easy updating
$RepoURL = "https://raw.githubusercontent.com/Sudo-Chamroeun/FIS-Toolbox/refs/heads/main"

function Show-Header {
    Clear-Host
    $c = "Cyan"   # Frame Color
    $b = "Yellow" # Branding Color
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
    Write-Host "    [1] Folder Restriction" -ForegroundColor Green
    Write-Host "    [2] Browser Control" -ForegroundColor Green
    Write-Host "    [3] Block Change Setting" -ForegroundColor Green
    Write-Host "    [4] Delete Chrome Profile Desktop" -ForegroundColor DarkGray
    Write-Host "    [5] Delete Chrome Profile Laptop" -ForegroundColor DarkGray
    Write-Host ""
    
    # --- THE STATIC INSTRUCTIONS ---
    Write-Host "    ------------------- INSTRUCTIONS -------------------" -ForegroundColor Cyan
    Write-Host "     * Run this tool as Administrator for full access." -ForegroundColor Gray
    Write-Host "     * Type the number of the tool you want to use." -ForegroundColor Gray
    Write-Host "     * If a script fails, check your internet connection." -ForegroundColor Gray
    Write-Host "    ----------------------------------------------------" -ForegroundColor Cyan
    Write-Host "    [Q] Quit" -ForegroundColor Red
    Write-Host ""

    $input = Read-Host "    Select an option"

    switch ($input) {
        '1' { 
            Write-Host "    > Loading Drive Restriction..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            # Option 1 Code will go here
        }
        
        '2' { 
            Write-Host "    > Initializing Tool #2..." -ForegroundColor Yellow
            $TempFile = "$env:TEMP\Browser-Controls.bat"  
            $BatUrl   = "$RepoURL/Browser-Controls.bat" 

            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop
                Write-Host "    > Launching Interface..." -ForegroundColor Green
                Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow
                if (Test-Path $TempFile) { Remove-Item -Path $TempFile -Force }
            }
            catch {
                Write-Host "    [!] Error: Could not download file. Check $BatUrl" -ForegroundColor Red
                Pause
            }
        }

        '3' {
             Write-Host "    > Checking for updates..." -ForegroundColor Yellow
             Start-Sleep -Seconds 2
        }

        'Q' { 
            Write-Host "    Good bye!" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            Stop-Process -Id $PID # Closes ONLY the console window
        }

        Default { 
            Write-Host "    [!] Invalid selection." -ForegroundColor Red
            Start-Sleep -Seconds 1 
        }
    }
} until ($input -eq 'Q')
