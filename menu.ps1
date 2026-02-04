# menu.ps1
function Show-Menu {
    Clear-Host
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "   FIS IT - MASTER TOOLBOX   " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "1. Folder Restriction"
    Write-Host "2. Browser Control"
    Write-Host "3. Delete Chrome Profiles"
    Write-Host "4. Delete Chrome Profiles Laptop"
    Write-Host "Q. Quit"
    Write-Host "==============================" -ForegroundColor Cyan
}

# This is the 'Base URL' where your raw scripts live on GitHub
# We will update this later in Step 3
$RepoURL = "https://raw.githubusercontent.com/YOUR_USERNAME/IT-Toolbox/main"

do {
    Show-Menu
    $input = Read-Host "Please make a selection"

    switch ($input) {
        '1' { 
            Write-Host "Running Drive Restriction..." -ForegroundColor Green
            # This downloads and runs the specific script from your repo immediately
            Invoke-Expression (Invoke-WebRequest -Uri "$RepoURL/restrict-drive.ps1" -UseBasicParsing).Content 
            Pause
        }
        '2' { 
            Write-Host "Starting Interactive Tool..." -ForegroundColor Cyan
            
            # 1. SETTINGS
            # We save it to Temp
            $TempFile = "$env:TEMP\Option2.bat"  
            
            # UPDATE THIS LINK to point to your .bat file, not menu.ps1
            $BatUrl   = "https://raw.githubusercontent.com/Sudo-Chamroeun/FIS-Toolbox/refs/heads/main/Browser-Controls.bat" 

            # 2. DOWNLOAD
            Write-Host "Downloading..." -NoNewline
            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop
                Write-Host "Done." -ForegroundColor Green
            }
            catch {
                Write-Host "Error downloading! Check URL." -ForegroundColor Red
                break 
            }

            # 3. RUN (The Fix)
            Write-Host "Launching..."
            Write-Host "--------------------------------"
            
            # cmd /c means "Run command"
            # -Wait means "Don't continue until the user closes the batch file"
            # -NoNewWindow means "Show the batch menu RIGHT HERE, not in a new window"
            Start-Process "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait -NoNewWindow

            # 4. CLEANUP
            Write-Host "--------------------------------"
            if (Test-Path $TempFile) {
                Remove-Item -Path $TempFile -Force
            }
            
            Write-Host "Cleanup Complete." -ForegroundColor Yellow
            Pause
        }
        '3' { 
            Write-Host "Apply Delete Chrome profile" -ForegroundColor Cyan
            
            # 1. SETTINGS
            # Save it as a .bat file in the temp folder
            $TempFile = "$env:TEMP\DeleteChromeProfilesTask_Final.bat"  
            # Your GitHub Raw Link to the .bat file
            $BatUrl   = "https://github.com/Sudo-Chamroeun/FIS-Toolbox/tree/main/DeleteChromeProfilesTask_Final.bat" 

            # 2. DOWNLOAD
            Write-Host "Applying..." -NoNewline
            try {
                Invoke-WebRequest -Uri $BatUrl -OutFile $TempFile -ErrorAction Stop
                Write-Host "Done." -ForegroundColor Green
            }
            catch {
                Write-Host "Error downloading! Check URL." -ForegroundColor Red
                break 
            }

            # 3. RUN (The Change is Here)
            Write-Host "Executing Batch File..."
            # We explicitly tell cmd.exe to run the file
            # /c means "Run this and then close"
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$TempFile`"" -Wait 

            # 4. CLEANUP
            if (Test-Path $TempFile) {
                Remove-Item -Path $TempFile -Force
            }
            
            Write-Host "Cleanup Complete." -ForegroundColor Yellow
            Pause
        }
        'Q' { 
            Write-Host "Exiting..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            Clear-Host  # <--- This wipes the screen clean
            break 
        }
        Default { Write-Host "Invalid selection, try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} until ($input -eq 'Q')
