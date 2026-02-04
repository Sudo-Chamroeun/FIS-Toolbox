$usersToBlock = @("Sec-Teacher", "Pri-Teacher", "ECP-Teacher", "Student")
$baseFolder = "C:\Users"

# Install NTFSSecurity module if not already installed
if (-not (Get-Module -ListAvailable -Name NTFSSecurity)) {
    Install-Module -Name NTFSSecurity -Force -Scope CurrentUser
}

# Import the NTFSSecurity module
Import-Module -Name NTFSSecurity

foreach ($user in $usersToBlock) {
    $userFolder = Join-Path -Path $baseFolder -ChildPath $user
    if (Test-Path $userFolder) {
        $foldersToBlock = Get-ChildItem -Path $userFolder -Directory -Recurse | Select-Object -ExpandProperty FullName
        foreach ($folderPath in $foldersToBlock) {
            Write-Host "Restoring original permissions for users in folder $folderPath"
            $usersToBlock | ForEach-Object {
                Remove-NTFSAccess -Path $folderPath -Account $_ -AccessRights Write -AccessType Deny -AppliesTo ThisFolderOnly
            }
        }
    } else {
        Write-Host "User folder $userFolder not found."
    }
}
