# Windows Forensic Inventory Tools

Two lightweight, offline-capable PowerShell scripts designed for incident response, malware investigations, and decommissioning projects.

Both scripts require **zero software installation** and can be run directly from a USB drive.

## Scripts

### 1. Inventory.ps1 – Per-Machine Hardware & OS Inventory
Run on **every offline workstation or server** you need to document or decommission.

**Features**
- Collects: Computer Name, Manufacturer, Model, Serial Number, full Windows version, architecture, last boot time
- Creates one human-readable `<ComputerName>.log` file per machine
- Appends all results to a single master `Inventory.csv` on the USB drive
- Shows a completion pop-up so the technician knows it worked
- Works on Windows 7 through Windows 11 / Server 2022 (no RSAT or extra modules needed)

**Use case examples**
- Asset inventory before OS re-imaging
- Evidence collection during malware containment
- Decommissioning or warranty lookup projects

### 2. Export-ADUsers-Forensics.ps1 – Full Forest User Export
Run **once** from any domain-joined machine that can reach a Domain Controller.

**Features**
- Exports every user account from the entire forest (all domains)
- Includes the most useful forensic/IR attributes:
  - Last logon (replicated + most accurate)
  - Password last set
  - Bad password attempts & lockouts
  - Account creation / modification dates
  - Manager, department, title, description, etc.
- Outputs a clean, sorted CSV ready for timeline analysis or SIEM ingestion
- Built-in handling of `LastLogonTimestamp` and `pwdLastSet` conversion to readable dates

**Use case examples**
- Malware lateral movement investigations
- Compromised credential hunting
- Dormant account identification
- Post-breach user activity baselining

## Requirements

- Windows 7+ / Server 2008 R2+ (PowerShell is built-in)
- For the AD script: domain connectivity to at least one DC (no RSAT install required on Windows 10/11 or Server 2016+)
- Execution Policy: both scripts use only built-in cmdlets that work even under Restricted policy

## Usage

1. Copy the scripts to a USB drive
2. On each target workstation → double-click `Inventory.ps1` (or Run with PowerShell)
3. On any domain-joined machine → run `Export-ADUsers-Forensics.ps1` as a domain user with read permissions (normal user is usually enough)

## Legal / Responsible Use

These tools are intended for authorized system administrators, incident responders, and penetration testers working on systems they have explicit permission to access.

Do not run the AD export script in environments where you do not have proper authorization.

## License

MIT License – feel free to use, modify, and redistribute.

## Author

Published for the incident response and digital forensics community.

---
*Tested and used in multiple real-world ransomware and credential-theft investigations.*
