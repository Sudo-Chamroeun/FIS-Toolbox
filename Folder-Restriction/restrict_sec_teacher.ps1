$usersToBlock = @("Sec-Teacher")
$foldersToBlock = @(
    "C:\Users\sec-teacher\Videos",
    "C:\Users\sec-teacher\Music",
    "C:\Users\sec-teacher\Documents",
    "C:\Users\sec-teacher\Pictures",
    "C:\Users\sec-teacher\Downloads",
    "C:\Users\sec-teacher\3D Objects",
    "C:\Users\sec-teacher\Desktop"
)

# Install NTFSSecurity module if not already installed
if (-not (Get-Module -ListAvailable -Name NTFSSecurity)) {
    Install-Module -Name NTFSSecurity -Force -Scope CurrentUser
}

# Import the NTFSSecurity module
Import-Module -Name NTFSSecurity

foreach ($folderPath in $foldersToBlock) {
    if (Test-Path $folderPath) {
        Write-Host "Denying write access for users $($usersToBlock -join ', ') in folder $folderPath"
        $usersToBlock | ForEach-Object {
            Add-NTFSAccess -Path $folderPath -Account $_ -AccessRights Write -AccessType Deny -AppliesTo ThisFolderAndSubfolders
        }
    } else {
        Write-Host "Folder $folderPath not found."
    }
}
