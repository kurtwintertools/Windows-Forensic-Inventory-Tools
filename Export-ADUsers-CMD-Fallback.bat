:: Export-ADUsers-CMD-Fallback.bat
@echo off
set CSV=%~dp0AD_Users_CMD_Export.csv
echo SamAccountName,Name,LastLogon,Enabled,DistinguishedName > "%CSV%"
for /f "skip=1 delims=" %%A in ('wmic /node:@domains.txt useraccount get Name^,SID^,LastLogon^,Disabled^,DistinguishedName /format:list ^| findstr /v /r "^$"') do (
    set "line=%%A"
    setlocal enabledelayedexpansion
    REM Extremely basic parsing - good enough for emergency
    echo !line! >> "%CSV%.tmp"
    endlocal
)
echo Done - rough export in %CSV%
pause