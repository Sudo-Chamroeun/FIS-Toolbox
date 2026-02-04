$usersToBlock = @("Pri-Teacher")
$foldersToBlock = @(
    "C:\Users\pri-teacher\Videos",
    "C:\Users\pri-teacher\Music",
    "C:\Users\pri-teacher\Documents",
    "C:\Users\pri-teacher\Pictures",
    "C:\Users\pri-teacher\Downloads",
    "C:\Users\pri-teacher\3D Objects",
    "C:\Users\pri-teacher\Desktop"
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
