@echo off
REM Bearsampp PowerShell Launcher
REM This script launches PowerShell with the custom Bearsampp profile
REM
REM Usage: powershell.bat [--title "Title"] [--startingDirectory "Path"]
REM   --title              - Optional: Window title
REM   --startingDirectory  - Optional: Starting directory

setlocal EnableDelayedExpansion

REM Get the directory where this script is located
set "SHELL_ROOT=%~dp0"
set "SHELL_ROOT=%SHELL_ROOT:~0,-1%"

REM Set the custom profile path
set "CUSTOM_PROFILE=%SHELL_ROOT%\config\Microsoft.PowerShell_profile.ps1"

REM Default values
set "WINDOW_TITLE=Bearsampp PowerShell Console"
set "START_DIR=%CD%"

REM Parse command line arguments
:parse_args
if "%~1"=="" goto end_parse
if /i "%~1"=="--title" (
    set "WINDOW_TITLE=%~2"
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--startingDirectory" (
    set "START_DIR=%~2"
    shift
    shift
    goto parse_args
)
shift
goto parse_args
:end_parse

REM Configure console font via registry BEFORE launching PowerShell
REM This ensures ALL console windows use CaskaydiaCove NF font with proper UTF-8 support

REM Set default console properties (applies to all new console windows)
reg add "HKCU\Console" /v FaceName /t REG_SZ /d "CaskaydiaCove NF" /f >nul 2>&1
reg add "HKCU\Console" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
reg add "HKCU\Console" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
reg add "HKCU\Console" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1

REM Set font for the specific window title being used
REM Windows Console Host stores settings per window title
if not "!WINDOW_TITLE!"=="" (
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FaceName /t REG_SZ /d "CaskaydiaCove NF" /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1
)

REM Also set for common Bearsampp console titles to ensure consistency
for %%T in ("Bearsampp PowerShell Console" "MariaDB" "MySQL" "PostgreSQL" "Git" "Python" "Composer" "PEAR" "Perl" "Ruby" "Ghostscript" "ngrok" "Node.js") do (
    reg add "HKCU\Console\%%~T" /v FaceName /t REG_SZ /d "CaskaydiaCove NF" /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1
)

REM Set UTF-8 code page for current console
chcp 65001 >nul 2>&1

REM Build the PowerShell command with UTF-8 encoding
set "PS_COMMAND=[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::InputEncoding = [System.Text.Encoding]::UTF8; $Host.UI.RawUI.WindowTitle='!WINDOW_TITLE!'; Set-Location '!START_DIR!'; . '!CUSTOM_PROFILE!'"

REM Launch PowerShell with custom profile and parameters
"%SHELL_ROOT%\pwsh.exe" -NoExit -NoProfile -Command "!PS_COMMAND!"

endlocal
