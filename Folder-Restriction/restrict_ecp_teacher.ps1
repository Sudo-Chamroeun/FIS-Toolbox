$usersToBlock = @("ECP-Teacher")
$foldersToBlock = @(
    "C:\Users\ecp-teacher\Videos",
    "C:\Users\ecp-teacher\Music",
    "C:\Users\ecp-teacher\Documents",
    "C:\Users\ecp-teacher\Pictures",
    "C:\Users\ecp-teacher\Downloads",
    "C:\Users\ecp-teacher\3D Objects",
    "C:\Users\ecp-teacher\Desktop"
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
