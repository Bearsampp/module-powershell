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

REM Determine which PowerShell executable to use
if exist "%SHELL_ROOT%\pwsh.exe" (
    set "PS_EXE=%SHELL_ROOT%\pwsh.exe"
) else (
    set "PS_EXE=powershell.exe"
)

REM Set the custom profile path
set "CUSTOM_PROFILE=%SHELL_ROOT%\config\Microsoft.PowerShell_profile.ps1"

REM Default values
set "WINDOW_TITLE=Bearsampp PowerShell Console"
set "START_DIR=%CD%"
set "NO_EXIT=1"

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
REM If 'exit' or any other non-flag argument is passed, it might be intended for PowerShell
REM We check if it's 'exit' specifically to handle the -NoExit flag
if /i "%~1"=="exit" (
    set "NO_EXIT=0"
)
shift
goto parse_args
:end_parse

REM Install Nerd Font for Oh My Posh (per-user, no admin required)
REM Fonts are bundled in vendor\fonts\ and installed to the user profile on first run
set "FONTS_SRC=%SHELL_ROOT%\vendor\fonts"
set "FONTS_DEST=%LOCALAPPDATA%\Microsoft\Windows\Fonts"
set "REGISTER_FONTS_PS1=%SHELL_ROOT%\config\register-fonts.ps1"
set "FONT_NAME=Cascadia Mono NF"

REM Check if fonts directory exists and register-fonts script exists
if exist "%FONTS_SRC%" (
    if exist "%REGISTER_FONTS_PS1%" (
        REM Call PowerShell to register fonts and get the font name
        for /f "usebackq delims=" %%F in (`^""!PS_EXE!" -NoProfile -ExecutionPolicy Bypass -File "!REGISTER_FONTS_PS1!" "!FONTS_SRC!" "!FONTS_DEST!"^"`) do (
            set "CAPTURED_FONT=%%~F"
            if not "!CAPTURED_FONT!"=="" (
                REM Basic validation: font names don't usually start with "WARNING:" or "ERROR:"
                echo "!CAPTURED_FONT!" | findstr /i "WARNING: ERROR:" >nul
                if errorlevel 1 (
                    set "FONT_NAME=!CAPTURED_FONT!"
                )
            )
        )
    )
)

REM Configure console font via registry BEFORE launching PowerShell
REM This ensures ALL console windows use !FONT_NAME! font with proper UTF-8 support

REM Set default console properties (applies to all new console windows)
reg add "HKCU\Console" /v FaceName /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
if errorlevel 1 echo [WARNING] Failed to update HKCU\Console font.

reg add "HKCU\Console" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
reg add "HKCU\Console" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
reg add "HKCU\Console" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1

REM Set font for the specific window title being used
REM Windows Console Host stores settings per window title
if not "!WINDOW_TITLE!"=="" (
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FaceName /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1
)

REM Also set for common Bearsampp console titles to ensure consistency
for %%T in ("Bearsampp PowerShell Console" "MariaDB" "MySQL" "PostgreSQL" "Git" "Python" "Composer" "PEAR" "Perl" "Ruby" "Ghostscript" "ngrok" "Node.js") do (
    reg add "HKCU\Console\%%~T" /v FaceName /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1
)

REM Set UTF-8 code page for current console
chcp 65001 >nul 2>&1

REM Build the PowerShell command with UTF-8 encoding
set "PS_COMMAND=[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::InputEncoding = [System.Text.Encoding]::UTF8; $Host.UI.RawUI.WindowTitle='!WINDOW_TITLE!'; Set-Location -LiteralPath '!START_DIR!'; . '!CUSTOM_PROFILE!'"

REM Launch PowerShell with custom profile and parameters
if "%NO_EXIT%"=="1" (
    "!PS_EXE!" -NoExit -NoProfile -Command "!PS_COMMAND!"
) else (
    "!PS_EXE!" -NoProfile -Command "!PS_COMMAND!; exit"
)

endlocal
