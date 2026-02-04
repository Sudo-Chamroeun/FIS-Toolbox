Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class PInvoke {
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

        public const uint SWP_SHOWWINDOW = 0x0040;
        public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
    }
"@

function Set-ConsoleWindowPosition {
    $consoleHandle = [PInvoke]::GetConsoleWindow()
    [PInvoke]::SetWindowPos($consoleHandle, [PInvoke]::HWND_TOPMOST, 100, 100, 500, 300, [PInvoke]::SWP_SHOWWINDOW) > $null
}

function Set-ConsoleWindowTitle {
    $host.UI.RawUI.WindowTitle = "IT Department - FIS - Folder Restriction"
}

function Show-Menu {
    Write-Host "==========================="
    Write-Host " Folder Restriction Menu"
    Write-Host "==========================="
    Write-Host "1. Restrict Sec-Teacher"
    Write-Host "2. Restrict Pri-Teacher"
    Write-Host "3. Restrict ECP-Teacher"
    Write-Host "4. Restrict Student"
    Write-Host "5. Remove Folder Restrictions"
    Write-Host "6. Exit"
    Write-Host

    return Read-Host "Enter your choice"
}

function Restrict-SecTeacher {
    & "C:\Folder Restriction\restrict_sec_teacher.ps1"
}

function Restrict-PriTeacher {
    & "C:\Folder Restriction\restrict_pri_teacher.ps1"
}

function Restrict-ECPTeacher {
    & "C:\Folder Restriction\restrict_ecp_teacher.ps1"
}

function Restrict-Student {
    & "C:\Folder Restriction\restrict_student.ps1"
}

function Remove-Folder-Restrictions {
    & "C:\Folder Restriction\remove_folder_restrictions.ps1"
}

Set-ConsoleWindowPosition
Set-ConsoleWindowTitle

while ($true) {
    $choice = Show-Menu

    switch ($choice) {
        "1" {
            Restrict-SecTeacher
        }
        "2" {
            Restrict-PriTeacher
        }
        "3" {
            Restrict-ECPTeacher
        }
        "4" {
            Restrict-Student
        }
        "5" {
            Remove-Folder-Restrictions
        }
        "6" {
            exit
        }
        default {
            Write-Host "Invalid choice. Please try again."
        }
    }
}
