# Check-VPN.ps1
$Host.UI.RawUI.WindowTitle = "VPN Detective - FOOTPRINTS INTERNATIONAL SCHOOL"
Clear-Host

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "                 VPN & PROXY DETECTIVE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# List of common VPN/Proxy keywords to hunt for
$VPNKeywords = "VPN|NordVPN|ExpressVPN|Proton|Windscribe|Hotspot Shield|CyberGhost|TunnelBear|Surfshark|Psiphon|Betternet|ZenMate|SetupVPN|TouchVPN|Hola"
$KeywordArray = $VPNKeywords -split '\|'

# ---------------------------------------------------------
# STEP 1: CHECK ACTIVE INSTALLATIONS (Registry)
# ---------------------------------------------------------
Write-Host "[1] Checking Active Installations..." -ForegroundColor Yellow
$Installed = @()
$ActiveKeywords = @() # Memory array to hide leftovers of actively installed apps

$UninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($Key in $UninstallKeys) {
    # (?i) makes the regex case-insensitive
    $Apps = Get-ItemProperty $Key -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match "(?i)$VPNKeywords" }
    if ($Apps) { 
        foreach ($App in $Apps) {
            $Name = $App.DisplayName
            if ($Installed -notcontains $Name) { $Installed += $Name }
            
            # Figure out exactly which keyword triggered this to deduplicate later
            foreach ($KW in $KeywordArray) {
                if ($Name -match "(?i)$KW" -and $ActiveKeywords -notcontains $KW) {
                    $ActiveKeywords += $KW
                }
            }
        }
    }
}

if ($Installed.Count -gt 0) {
    $Installed | ForEach-Object { Write-Host "    [!] FOUND INSTALLED: $_" -ForegroundColor Red }
} else {
    Write-Host "    [OK] No active VPN installations found." -ForegroundColor Green
}
Write-Host ""

# ---------------------------------------------------------
# STEP 2: CHECK FOR LEFTOVERS ("The Sneaky Check")
# ---------------------------------------------------------
Write-Host "[2] Checking for Leftover Files/Folders..." -ForegroundColor Yellow
$Leftovers = @()
$SearchPaths = @(
    "C:\Program Files\*",
    "C:\Program Files (x86)\*",
    "C:\ProgramData\*",
    "C:\Users\*\AppData\Local\*",
    "C:\Users\*\AppData\Roaming\*"
)

foreach ($Path in $SearchPaths) {
    $Folders = Get-Item $Path -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "(?i)$VPNKeywords" }
    if ($Folders) {
        foreach ($Folder in $Folders) {
            $IsDuplicate = $false
            
            # If this folder matches a VPN that is CURRENTLY installed, ignore it (Deduplication)
            foreach ($ActiveKW in $ActiveKeywords) {
                if ($Folder.Name -match "(?i)$ActiveKW") {
                    $IsDuplicate = $true
                    break
                }
            }
            
            if (-not $IsDuplicate -and $Leftovers -notcontains $Folder.FullName) { 
                $Leftovers += $Folder.FullName 
            }
        }
    }
}

if ($Leftovers.Count -gt 0) {
    Write-Host "    [!] SUSPICIOUS LEFTOVERS FOUND (User may have recently uninstalled):" -ForegroundColor Magenta
    $Leftovers | ForEach-Object { Write-Host "    -> $_" -ForegroundColor DarkGray }
} else {
    Write-Host "    [OK] No obvious leftover folders found." -ForegroundColor Green
}
Write-Host ""

# ---------------------------------------------------------
# STEP 3: CHECK BROWSER EXTENSIONS (Chrome, Brave, Edge)
# ---------------------------------------------------------
Write-Host "[3] Checking Browser Extensions..." -ForegroundColor Yellow
$FoundExtensions = @()

$ManifestPaths = @(
    "C:\Users\*\AppData\Local\Google\Chrome\User Data\*\Extensions\*\*\manifest.json",
    "C:\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\Extensions\*\*\manifest.json",
    "C:\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Extensions\*\*\manifest.json"
)

foreach ($Manifest in $ManifestPaths) {
    $Files = Get-ChildItem -Path $Manifest -ErrorAction SilentlyContinue
    foreach ($File in $Files) {
        $ExtDir = $File.Directory.FullName
        
        # 1. Check the main manifest file raw text
        $ManifestRaw = Get-Content $File.FullName -Raw -ErrorAction SilentlyContinue
        $IsMatch = ($ManifestRaw -match "(?i)$VPNKeywords")
        
        # 2. If no match yet, dig into the localized language files (The fix for tricky extensions)
        if (-not $IsMatch) {
            $LocaleFiles = Get-ChildItem -Path "$ExtDir\_locales" -Filter "messages.json" -Recurse -ErrorAction SilentlyContinue
            foreach ($Locale in $LocaleFiles) {
                $LocaleRaw = Get-Content $Locale.FullName -Raw -ErrorAction SilentlyContinue
                if ($LocaleRaw -match "(?i)$VPNKeywords") {
                    $IsMatch = $true
                    break
                }
            }
        }

        # 3. If we caught it, log it
        if ($IsMatch) {
            $BrowserName = if ($ExtDir -match "Chrome") {"Chrome"} elseif ($ExtDir -match "Brave") {"Brave"} else {"Edge"}
            
            # Try to grab the readable name
            $ExtName = "Unknown/Hidden VPN Extension"
            try {
                $Json = $ManifestRaw | ConvertFrom-Json -ErrorAction SilentlyContinue
                if ($Json.name -notmatch "__MSG_") {
                    $ExtName = $Json.name
                } else {
                    $ExtName = "Localized VPN Extension (ID: $($File.Directory.Parent.Name))"
                }
            } catch {}

            $ResultString = "[$BrowserName] $ExtName"
            if ($FoundExtensions -notcontains $ResultString) {
                $FoundExtensions += $ResultString
            }
        }
    }
}

if ($FoundExtensions.Count -gt 0) {
    $FoundExtensions | ForEach-Object { Write-Host "    [!] FOUND EXTENSION: $_" -ForegroundColor Red }
} else {
    Write-Host "    [OK] No VPN browser extensions detected." -ForegroundColor Green
}
Write-Host ""

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Scan Complete." -ForegroundColor Cyan
Pause
