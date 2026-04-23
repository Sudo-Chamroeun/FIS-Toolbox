# 👣 Footprints IT Toolbox (FIS-Toolbox)

A centralized, cloud-hosted administrative toolkit designed specifically for the Footprints International School IT Team. 

This toolbox provides a single unified command-line interface (CLI) to deploy essential maintenance scripts, enforce system policies, and perform diagnostics on student and staff devices. Built with a "Zero-Footprint" philosophy, the toolbox downloads and executes scripts directly into system memory or temporary folders, cleaning up after itself entirely upon exit.

## 🚀 Key Features

* **Zero-Footprint Execution:** Scripts are fetched on-demand to `$env:TEMP`, executed, and immediately securely deleted. No clutter left on the host machine.
* **Always Up-to-Date:** Because the master menu dynamically fetches the payload scripts from this repository, the IT team always runs the latest version without needing to redownload any `.exe` or `.ps1` files.
* **Auto-Privilege Management:** Automatically bypasses local PowerShell execution policies (`Set-ExecutionPolicy Bypass -Scope Process`) strictly for the duration of the session.
* **Cross-Platform Diagnostics:** Includes the native Windows PowerShell toolkit alongside standalone macOS shell scripts for comprehensive coverage.

## 🧰 Included Modules

| Module | Type | Description |
|---|---|---|
| **[1] Folder Restriction** | `.ps1` | Locks down or restricts specific user directories to enforce school compliance. |
| **[2] Browser Control** | `.bat` | Manages enterprise browser policies, clears stubborn cache, and resets states. |
| **[3] Block Change Setting** | `.bat` | Restricts access to native Windows settings to prevent unauthorized tampering. |
| **[4] Delete Chrome Profile** | `.bat` | Wipes corrupted or unauthorized local Google Chrome user profiles. |
| **[5] Display Control** | `.bat` | Fixes display orientation, scaling, or multiple-monitor configuration bugs. |
| **[6] Office Removal** | `.exe` | A heavy-duty uninstaller for deeply rooted or corrupted Microsoft Office deployments. |
| **[7] VPN Detective** | `.ps1` | Scans the Windows system and browser extensions for unauthorized VPNs and proxies. |

## 💻 Quick Start Guide

### Windows Deployment (Master Menu)
To launch the full IT Console on any Windows machine, open an **Administrator PowerShell** window and run the following command:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm security.footprints.work | iex


macOS Deployment (Standalone VPN Scanner)
To scan a student's MacBook for installed VPNs, network profiles, and browser extensions without leaving a file behind, open the macOS Terminal and run:

zsh -c "$(curl -fsSL [https://mac-checker.footprints.work/Check-VPN.sh](https://mac-checker.footprints.work/Check-VPN.sh))"

⚠️ System Requirements & Notes
Operating System: Windows 10/11 (for the Master Menu) / macOS 12+ (for Mac tools).

Permissions: The Master Menu must be run as an Administrator to successfully apply system-level changes (like registry edits or restricted folder deletion).

Network: Tools will fail to load if GitHub raw content servers (raw.githubusercontent.com) are blocked on the network.

Developed and maintained by the Footprints International School IT Department.
