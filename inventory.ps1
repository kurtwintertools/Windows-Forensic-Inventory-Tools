# Inventory.ps1 - Run this on every machine (double-click or right-click -> Run with PowerShell)
# Works completely offline, no modules needed

# Get computer name
$ComputerName = $env:COMPUTERNAME

# Build output folder on the same USB drive this script is running from
$UsbDrive = (Get-Location).Drive.Name + ":"
$LogFile = "$UsbDrive\$ComputerName.log"
$CsvFile = "$UsbDrive\Inventory.csv"

# Gather system information using only built-in commands
$SystemInfo = Get-CimInstance -ClassName Win32_ComputerSystem
$BiosInfo   = Get-CimInstance -ClassName Win32_BIOS
$OsInfo     = Get-CimInstance -ClassName Win32_OperatingSystem

$Inventory = [PSCustomObject]@{
    ComputerName           = $ComputerName
    Manufacturer           = $SystemInfo.Manufacturer
    Model                  = $SystemInfo.Model
    SerialNumber           = $BiosInfo.SerialNumber
    OSFriendlyName         = $OsInfo.Caption
    OSVersionExact         = $OsInfo.Version
    OSBuild                = $OsInfo.BuildNumber
    Architecture           = $OsInfo.OSArchitecture
    LastBootUpTime         = $OsInfo.LastBootUpTime
    InventoryDateTime      = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

# Write individual .log file (human readable)
$Inventory | Format-List | Out-File -FilePath $LogFile -Encoding UTF8

# Append to master CSV (create header if CSV doesn't exist yet)
$CsvExists = Test-Path $CsvFile
$Inventory | Export-Csv -Path $CsvFile -NoTypeInformation -Append -Encoding UTF8

if (-not $CsvExists) {
    # Ensure the very first row is the header (in case script creates the file)
    "ComputerName,Manufacturer,Model,SerialNumber,OSFriendlyName,OSVersionExact,OSBuild,Architecture,LastBootUpTime,InventoryDateTime" | Out-File -FilePath $CsvFile -Encoding UTF8
    $Inventory | Select-Object * | Export-Csv -Path $CsvFile -NoTypeInformation -Append -Encoding UTF8
}

# Friendly popup so tech knows it worked
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Inventory complete for $ComputerName`nLog: $LogFile`nCSV updated", "Inventory Done", 0, [System.Windows.Forms.MessageBoxIcon]::Information)