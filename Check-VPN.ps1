# Check-VPN.ps1
$Host.UI.RawUI.WindowTitle = "VPN Detective - FOOTPRINTS INTERNATIONAL SCHOOL"
Clear-Host

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "                 VPN & PROXY DETECTIVE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# List of common VPN/Proxy keywords to hunt for
$VPNKeywords = "VPN|NordVPN|ExpressVPN|Proton|Windscribe|Hotspot Shield|CyberGhost|TunnelBear|Surfshark|Psiphon|Betternet|ZenMate|SetupVPN|TouchVPN|Hola"

# ---------------------------------------------------------
# STEP 1: CHECK ACTIVE INSTALLATIONS (Registry)
# ---------------------------------------------------------
Write-Host "[1] Checking Active Installations..." -ForegroundColor Yellow
$Installed = @()
$UninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($Key in $UninstallKeys) {
    $Apps = Get-ItemProperty $Key -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match $VPNKeywords }
    if ($Apps) { $Installed += $Apps.DisplayName }
}

if ($Installed.Count -gt 0) {
    $Installed | Select-Object -Unique | ForEach-Object { Write-Host "    [!] FOUND INSTALLED: $_" -ForegroundColor Red }
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
    $Folders = Get-Item $Path -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $VPNKeywords }
    if ($Folders) { $Leftovers += $Folders.FullName }
}

if ($Leftovers.Count -gt 0) {
    Write-Host "    [!] SUSPICIOUS LEFTOVERS FOUND (User may have recently uninstalled):" -ForegroundColor Magenta
    $Leftovers | Select-Object -Unique | ForEach-Object { Write-Host "    -> $_" -ForegroundColor DarkGray }
} else {
    Write-Host "    [OK] No obvious leftover folders found." -ForegroundColor Green
}
Write-Host ""

# ---------------------------------------------------------
# STEP 3: CHECK BROWSER EXTENSIONS (Chrome, Brave, Edge)
# ---------------------------------------------------------
Write-Host "[3] Checking Browser Extensions..." -ForegroundColor Yellow
$FoundExtensions = @()

# Look for manifest.json files deep in the extension folders
$ManifestPaths = @(
    "C:\Users\*\AppData\Local\Google\Chrome\User Data\*\Extensions\*\*\manifest.json",
    "C:\Users\*\AppData\Local\BraveSoftware\Brave-Browser\User Data\*\Extensions\*\*\manifest.json",
    "C:\Users\*\AppData\Local\Microsoft\Edge\User Data\*\Extensions\*\*\manifest.json"
)

foreach ($Manifest in $ManifestPaths) {
    $Files = Get-ChildItem -Path $Manifest -ErrorAction SilentlyContinue
    foreach ($File in $Files) {
        # Read the JSON file quickly to find the extension name
        $Content = Get-Content $File.FullName -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($Content.name -match $VPNKeywords) {
            # Extract browser name from the path
            $BrowserName = if ($File.FullName -match "Chrome") {"Chrome"} elseif ($File.FullName -match "Brave") {"Brave"} else {"Edge"}
            $FoundExtensions += "[$BrowserName] $($Content.name)"
        }
    }
}

if ($FoundExtensions.Count -gt 0) {
    $FoundExtensions | Select-Object -Unique | ForEach-Object { Write-Host "    [!] FOUND EXTENSION: $_" -ForegroundColor Red }
} else {
    Write-Host "    [OK] No VPN browser extensions detected." -ForegroundColor Green
}
Write-Host ""

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Scan Complete." -ForegroundColor Cyan
Pause
