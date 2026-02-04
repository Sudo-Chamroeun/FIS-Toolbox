<#
    FOOTPRINTS IT - FOLDER RESTRICTION TOOL
    Status: Consolidated All-In-One Script
#>

# --- MODULE CHECK ---
# We check this first. If missing, we install it immediately.
if (-not (Get-Module -ListAvailable -Name NTFSSecurity)) {
    Write-Host "Installing required module (NTFSSecurity)..." -ForegroundColor Yellow
    try {
        Install-Module -Name NTFSSecurity -Force -Scope CurrentUser -ErrorAction Stop
        Import-Module -Name NTFSSecurity
        Write-Host "Module Installed." -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing NTFSSecurity module. Check internet." -ForegroundColor Red
        Pause
        exit
    }
}
else {
    Import-Module -Name NTFSSecurity
}

# --- FUNCTIONS ---

function Apply-Restriction {
    param (
        [string]$TargetUser,
        [string[]]$Folders
    )

    Write-Host "Applying restrictions for: $TargetUser" -ForegroundColor Cyan
    
    foreach ($folderPath in $Folders) {
        if (Test-Path $folderPath) {
            Write-Host "  [+] Locking: $folderPath" -ForegroundColor Gray
            try {
                Add-NTFSAccess -Path $folderPath -Account $TargetUser -AccessRights Write -AccessType Deny -AppliesTo ThisFolderAndSubfolders -ErrorAction Stop
            }
            catch {
                Write-Host "      [!] Failed to lock. (Is user valid?)" -ForegroundColor Red
            }
        } else {
            Write-Host "  [-] Skipped (Not found): $folderPath" -ForegroundColor DarkGray
        }
    }
    Write-Host "Done." -ForegroundColor Green
    Write-Host ""
}

function Remove-Restrictions {
    # This unblocks EVERYONE (Teachers + Students)
    $AllUsers = @("Sec-Teacher", "Pri-Teacher", "ECP-Teacher", "Student")
    $BaseDir  = "C:\Users"
    
    Write-Host "Removing ALL restrictions..." -ForegroundColor Yellow

    foreach ($user in $AllUsers) {
        $userPath = Join-Path -Path $BaseDir -ChildPath $user
        if (Test-Path $userPath) {
            # Get all subfolders in that user's directory
            $targetFolders = Get-ChildItem -Path $userPath -Directory -Recurse | Select-Object -ExpandProperty FullName
            
            foreach ($folder in $targetFolders) {
                # We try to remove the specific DENY rule we added earlier
                try {
                    Remove-NTFSAccess -Path $folder -Account $user -AccessRights Write -AccessType Deny -AppliesTo ThisFolderOnly -ErrorAction SilentlyContinue
                } catch {}
            }
            Write-Host "  [OK] Cleaned user: $user" -ForegroundColor Green
        }
    }
    Write-Host "All restrictions removed." -ForegroundColor Cyan
}

function Show-SubMenu {
    [Console]::Clear()
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "      FOLDER RESTRICTION MANAGER" -ForegroundColor White
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host " [1] Restrict Secondary Teacher (Sec-Teacher)"
    Write-Host " [2] Restrict Primary Teacher (Pri-Teacher)"
    Write-Host " [3] Restrict ECP Teacher (ECP-Teacher)"
    Write-Host " [4] Restrict Student"
    Write-Host " [5] REMOVE ALL RESTRICTIONS (Unlock)"
    Write-Host " [Q] Back to Main Menu"
    Write-Host "==========================================" -ForegroundColor Cyan
}

# --- MAIN LOOP ---
do {
    Show-SubMenu
    $choice = Read-Host " Select an option"

    # Define standard folders to block
    # We dynamically build the path based on the user name
    $StdFolders = @("Videos", "Music", "Documents", "Pictures", "Downloads", "3D Objects", "Desktop")

    switch ($choice) {
        '1' {
            $Paths = $StdFolders | ForEach-Object { "C:\Users\sec-teacher\$_" }
            Apply-Restriction -TargetUser "Sec-Teacher" -Folders $Paths
            Pause
        }
        '2' {
            $Paths = $StdFolders | ForEach-Object { "C:\Users\pri-teacher\$_" }
            Apply-Restriction -TargetUser "Pri-Teacher" -Folders $Paths
            Pause
        }
        '3' {
            $Paths = $StdFolders | ForEach-Object { "C:\Users\ecp-teacher\$_" }
            Apply-Restriction -TargetUser "ECP-Teacher" -Folders $Paths
            Pause
        }
        '4' {
            $Paths = $StdFolders | ForEach-Object { "C:\Users\student\$_" }
            Apply-Restriction -TargetUser "Student" -Folders $Paths
            Pause
        }
        '5' {
            Remove-Restrictions
            Pause
        }
        'Q' {
            return # This exits the script and goes back to your Main Menu
        }
    }
} until ($choice -eq 'Q')
