@echo off
:: Run-Inventory (double-click me).bat
:: One-click launcher for Inventory.ps1 — works from USB or desktop
:: No admin rights needed, leaves zero trace

:: Find the folder where THIS batch file lives
set "ScriptDir=%~dp0"
set "ScriptPath=%ScriptDir%Inventory.ps1"

:: Safety check — if the .ps1 is missing, tell the user
if not exist "%ScriptPath%" (
    echo.
    echo ERROR: Inventory.ps1 not found in this folder!
    echo.
    echo Expected location: "%ScriptPath%"
    echo.
    pause
    exit /b 1
)

:: Launch PowerShell with Bypass policy, run the script in its own folder
powershell -NoProfile -ExecutionPolicy Bypass -File "%ScriptPath%"

:: Optional: keep window open if you want to see any errors
:: (comment out the line below if you want the window to auto-close on success)
:: pause