# Inventory.ps1 - FINAL rock-solid version
# Always saves files next to the script, no matter how you launch it

# Force the script's own folder as working directory
$ScriptPath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
Set-Location $ScriptPath

$ComputerName = $env:COMPUTERNAME
$LogFile      = Join-Path $ScriptPath "$ComputerName.log"
$CsvFile      = Join-Path $ScriptPath "Inventory.csv"

# Gather system info
$System = Get-CimInstance Win32_ComputerSystem
$Bios   = Get-CimInstance Win32_BIOS
$OS     = Get-CimInstance Win32_OperatingSystem

$Record = [PSCustomObject]@{
    InventoryDateTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    ComputerName      = $ComputerName
    Manufacturer      = $System.Manufacturer
    Model             = $System.Model
    SerialNumber      = $Bios.SerialNumber.Trim()
    OSFriendlyName    = $OS.Caption
    OSVersionExact    = $OS.Version
    OSBuild           = $OS.BuildNumber
    Architecture      = $OS.OSArchitecture
    LastBootUpTime    = $OS.LastBootUpTime
}

# Write human-readable log
$Record | Format-List | Out-File -FilePath $LogFile -Encoding UTF8

# Create CSV with headers if missing, otherwise append
if (-not (Test-Path $CsvFile)) {
    $Record | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
} else {
    $Record | Export-Csv -Path $CsvFile -NoTypeInformation -Append -Encoding UTF8
}

# Success message (plain ASCII only - no fancy dashes)
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show(
    "Inventory complete!`n`nFiles saved in this folder:`n$ScriptPath`n`n-> $ComputerName.log`n-> Inventory.csv",
    "Success - Files saved beside script",
    'OK',
    [System.Windows.Forms.MessageBoxIcon]::Information
) | Out-Null