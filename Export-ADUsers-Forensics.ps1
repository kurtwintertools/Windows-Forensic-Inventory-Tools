# Export-ADUsers-Forensics.ps1
# Run from any domain-joined Windows 10/11 or Server with domain connectivity
# Dumps EVERY user from the entire forest (all 3 domains) with forensic-relevant attributes

# Output location (change if you want)
$OutputPath = "C:\Temp\AD_Users_Forensics_$(Get-Date -Format yyyy-MM-dd_HHmm).csv"
New-Item -ItemType Directory -Path (Split-Path $OutputPath) -Force | Out-Null

# Import AD module (built-in on DCs, works on workstations with RSAT or just AD PS module)
Import-Module ActiveDirectory

Write-Host "Querying the entire forest (all domains)... This may take a while." -ForegroundColor Cyan

$AllUsers = Get-ADUser -Filter * -Properties `
    SamAccountName, `
    UserPrincipalName, `
    DisplayName, `
    Enabled, `
    LastLogonDate, `
    LastLogonTimestamp, `
    pwdLastSet, `
    PasswordExpired, `
    PasswordNeverExpires, `
    LockedOut, `
    whenCreated, `
    whenChanged, `
    DistinguishedName, `
    SID, `
    BadLogonCount, `
    LastBadPasswordAttempt, `
    AccountExpirationDate, `
    LogonCount, `
    Description, `
    Department, `
    Title, `
    Manager `
    -Server (Get-ADForest | Select-Object -First 1 -ExpandProperty Name)

# Convert LastLogonTimestamp from Windows timestamp
$AllUsers | ForEach-Object {
    if ($_.LastLogonTimestamp) {
        $_.LastLogonTimestamp = [DateTime]::FromFileTime($_.LastLogonTimestamp)
    }
    if ($_.pwdLastSet) {
        $_.pwdLastSet = [DateTime]::FromFileTime($_.pwdLastSet)
    }
}

# Export everything
$AllUsers | Sort-Object LastLogonDate -Descending |
    Select-Object `
        SamAccountName,
        UserPrincipalName,
        DisplayName,
        Enabled,
        LastLogonDate,
        @{Name="LastLogonTimestamp";Expression={$_."LastLogonTimestamp"}},
        pwdLastSet,
        PasswordExpired,
        PasswordNeverExpires,
        LockedOut,
        whenCreated,
        whenChanged,
        BadLogonCount,
        LastBadPasswordAttempt,
        AccountExpirationDate,
        LogonCount,
        Description,
        Department,
        Title,
        Manager,
        DistinguishedName,
        SID `
    | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "Export complete!" -ForegroundColor Green
Write-Host "File saved to: $OutputPath" -ForegroundColor Yellow
Invoke-Item (Split-Path $OutputPath)