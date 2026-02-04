$usersToBlock = @("student")
$foldersToBlock = @(
    "C:\Users\student\Videos",
    "C:\Users\student\Music",
    "C:\Users\student\Documents",
    "C:\Users\student\Pictures",
    "C:\Users\student\Downloads",
    "C:\Users\student\3D Objects",
    "C:\Users\student\Desktop"
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
