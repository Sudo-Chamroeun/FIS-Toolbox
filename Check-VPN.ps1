# Check-VPN.ps1
$Host.UI.RawUI.WindowTitle = "VPN Detective - FOOTPRINTS INTERNATIONAL SCHOOL"
Clear-Host

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "                 VPN & PROXY DETECTIVE" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# List of common VPN/Proxy keywords to hunt for
$VPNKeywords = "VPN|NordVPN|ExpressVPN|Proton|Windscribe|Hotspot Shield|CyberGhost|TunnelBear|Surfshark|Psiphon|Betternet|ZenMate|SetupVPN|TouchVPN|Hola|Warp|Cloudflare"
$KeywordArray = $VPNKeywords -split '\|'

# Master array to store row-by-row data for the Excel export
$AllFindings = @()

# ---------------------------------------------------------
# STEP 1: CHECK ACTIVE INSTALLATIONS (Registry)
# ---------------------------------------------------------
Write-Host "[1] Checking Active Installations..." -ForegroundColor Yellow
$Installed = @()
$ActiveKeywords = @() 

$UninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($Key in $UninstallKeys) {
    $Apps = Get-ItemProperty $Key -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match "(?i)$VPNKeywords" }
    if ($Apps) { 
        foreach ($App in $Apps) {
            $Name = $App.DisplayName
            if ($Installed -notcontains $Name) { 
                $Installed += $Name 
                $AllFindings += [PSCustomObject]@{ Name = $Name; Type = "Application" }
            }
            
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
            
            foreach ($ActiveKW in $ActiveKeywords) {
                if ($Folder.Name -match "(?i)$ActiveKW") {
                    $IsDuplicate = $true
                    break
                }
            }
            
            if (-not $IsDuplicate -and $Leftovers -notcontains $Folder.FullName) { 
                $Leftovers += $Folder.FullName 
                $AllFindings += [PSCustomObject]@{ Name = $Folder.FullName; Type = "Leftover" }
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
        $RawText = Get-Content $File.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $RawText) { continue }

        $ExtName = ""
        $ExtDesc = ""

        if ($RawText -match '"name"\s*:\s*"([^"]+)"') { $ExtName = $matches[1] }
        if ($RawText -match '"description"\s*:\s*"([^"]+)"') { $ExtDesc = $matches[1] }

        # Safely resolve localized names
        if ($ExtName -match "__MSG_(.*)__") {
            $CleanKey = $matches[1]
            $LocFiles = Get-ChildItem -Path "$ExtDir\_locales\*\messages.json" -ErrorAction SilentlyContinue
            foreach ($Loc in $LocFiles) {
                $LocRaw = Get-Content $Loc.FullName -Raw -ErrorAction SilentlyContinue
                $RegexPattern = '(?s)"' + $CleanKey + '"\s*:\s*\{.*?"message"\s*:\s*"([^"]+)"'
                if ($LocRaw -match $RegexPattern) {
                    $ExtName = $matches[1]
                    break
                }
            }
        }

        if ($ExtDesc -match "__MSG_(.*)__") {
            $CleanKey = $matches[1]
            $LocFiles = Get-ChildItem -Path "$ExtDir\_locales\*\messages.json" -ErrorAction SilentlyContinue
            foreach ($Loc in $LocFiles) {
                $LocRaw = Get-Content $Loc.FullName -Raw -ErrorAction SilentlyContinue
                $RegexPattern = '(?s)"' + $CleanKey + '"\s*:\s*\{.*?"message"\s*:\s*"([^"]+)"'
                if ($LocRaw -match $RegexPattern) {
                    $ExtDesc = $matches[1]
                    break
                }
            }
        }

        if ($ExtName -match "(?i)$VPNKeywords" -or $ExtDesc -match "(?i)$VPNKeywords") {
            $BrowserName = if ($ExtDir -match "Chrome") {"Chrome"} elseif ($ExtDir -match "Brave") {"Brave"} else {"Edge"}
            
            if (-not $ExtName -or $ExtName -match "__MSG_") { 
                $ExtName = "Hidden VPN Extension (ID: $($File.Directory.Parent.Name))" 
            }

            $ResultString = "[$BrowserName] $ExtName"
            if ($FoundExtensions -notcontains $ResultString) {
                $FoundExtensions += $ResultString
                $AllFindings += [PSCustomObject]@{ Name = $ExtName; Type = "$BrowserName Extension" }
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

# ---------------------------------------------------------
# STEP 4: GATHER NETWORK DATA & EXPORT MENU
# ---------------------------------------------------------
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Scan Complete." -ForegroundColor Cyan

# Grab the primary network adapter
$PrimaryNet = Get-WmiObject Win32_NetworkAdapterConfiguration -ErrorAction SilentlyContinue | Where-Object { $_.IPEnabled -eq $true -and $_.DefaultIPGateway } | Select-Object -First 1

# Extract strictly the IPv4 address safely
$CleanIP = "Unknown"
if ($PrimaryNet -and $PrimaryNet.IPAddress) {
    $IPv4 = @($PrimaryNet.IPAddress) | Where-Object { $_ -match '\d+\.\d+\.\d+\.\d+' } | Select-Object -First 1
    if ($IPv4) { $CleanIP = $IPv4 }
}

$CleanMAC = if ($PrimaryNet -and $PrimaryNet.MACAddress) { $PrimaryNet.MACAddress } else { "Unknown" }

do {
    Write-Host ""
    Write-Host "    [1] Export Results to Excel (CSV)" -ForegroundColor White
    Write-Host "    [Q] Quit" -ForegroundColor Red
    Write-Host ""
    $UserChoice = Read-Host "Select an option"

    if ($UserChoice -eq '1') {
        $TimeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $FileTime = (Get-Date).ToString("yyyyMMdd_HHmmss")
        $DesktopPath = [Environment]::GetFolderPath("Desktop")
        $ExportPath = "$DesktopPath\VPN_Report_$FileTime.csv"

        $ExportData = @()

        # If clean, export one row stating "None Detected"
        if ($AllFindings.Count -eq 0) {
            $ExportData += [PSCustomObject]@{
                Timestamp  = $TimeStamp
                IPAddress  = $CleanIP
                MACAddress = $CleanMAC
                VPNs       = "None Detected"
                Type       = "N/A"
            }
        } else {
            # Iterate through findings to create a row-by-row layout
            for ($i = 0; $i -lt $AllFindings.Count; $i++) {
                $ExportData += [PSCustomObject]@{
                    # Only print Time, IP, and MAC on the very first row
                    Timestamp  = if ($i -eq 0) { $TimeStamp } else { "" }
                    IPAddress  = if ($i -eq 0) { $CleanIP } else { "" }
                    MACAddress = if ($i -eq 0) { $CleanMAC } else { "" }
                    VPNs       = $AllFindings[$i].Name
                    Type       = $AllFindings[$i].Type
                }
            }
        }

        # Enforce column order and save
        $ExportData | Select-Object Timestamp, IPAddress, MACAddress, VPNs, Type | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
        
        Write-Host "    [+] Success! Clean report saved to Desktop: $ExportPath" -ForegroundColor Green
        Write-Host "    Opening file..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1
        Invoke-Item $ExportPath
        break
    }
    elseif ($UserChoice -eq 'q' -or $UserChoice -eq 'Q') {
        break
    }
    else {
        Write-Host "    [!] Invalid selection." -ForegroundColor Red
    }
} until ($UserChoice -eq 'q' -or $UserChoice -eq 'Q')
