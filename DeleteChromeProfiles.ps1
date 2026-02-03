# PowerShell script to delete Chrome user profiles for all users 
 
# Get all user profiles 
$profiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false } 
 
# Loop through each user profile and delete Chrome user data 
foreach ($profile in $profiles) { 
    $chromePath = Join-Path $profile.LocalPath 'AppData\Local\Google\Chrome\User Data' 
    if (Test-Path $chromePath) { 
        Remove-Item -Path $chromePath -Recurse -Force 
        Write-Host "Chrome profiles deleted for user: $($profile.LocalPath)" 
    } else { 
        Write-Host "Chrome profiles directory not found for user: $($profile.LocalPath)" 
    } 
} 
