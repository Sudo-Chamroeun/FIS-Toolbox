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
            Write-Host "Blocking Browsers..." -ForegroundColor Green
            Invoke-Expression (Invoke-WebRequest -Uri "$RepoURL/block-browser.ps1" -UseBasicParsing).Content
            Pause
        }
        '3' {
            Write-Host "Checking for updates..." -ForegroundColor Green
            # You can also just run commands directly here without downloading a script
            Get-WindowsUpdate -Install -AcceptAll
            Pause
        }
        '4' {
            Write-Host "Checking for updates..." -ForegroundColor Green
            # You can also just run commands directly here without downloading a script
            Get-WindowsUpdate -Install -AcceptAll
            Pause
        }
        'Q' { 
            Write-Host "Exiting..." -ForegroundColor Yellow
            break 
        }
        Default { Write-Host "Invalid selection, try again." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} until ($input -eq 'Q')
