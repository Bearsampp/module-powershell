@echo off
REM Bearsampp PowerShell Launcher
REM This script launches PowerShell with the custom Bearsampp profile

setlocal

REM Get the directory where this script is located
set "SHELL_ROOT=%~dp0"
set "SHELL_ROOT=%SHELL_ROOT:~0,-1%"

REM Set the custom profile path
set "CUSTOM_PROFILE=%SHELL_ROOT%\config\Microsoft.PowerShell_profile.ps1"

REM Launch PowerShell with custom profile using dot-sourcing
"%SHELL_ROOT%\pwsh.exe" -NoExit -NoProfile -Command ". '%CUSTOM_PROFILE%'"

endlocal
