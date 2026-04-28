@echo off
REM Bearsampp PowerShell Launcher
REM This script launches PowerShell with the custom Bearsampp profile
REM
REM Usage: powershell.bat [--title "Title"] [--startingDirectory "Path"]
REM   --title              - Optional: Window title
REM   --startingDirectory  - Optional: Starting directory

setlocal EnableDelayedExpansion
pushd "%CD%"

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
set "FONT_NAME=CaskaydiaMono NF"

REM Check if we are running in a specialized console that doesn't need re-config
if defined BEARSAMPP_SHELL goto skip_registry_config

REM Check if a valid font is already configured in the registry to save time
reg query "HKCU\Console" /v FaceName >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=2,*" %%A in ('reg query "HKCU\Console" /v FaceName') do (
        set "CURRENT_FONT=%%B"
        echo "!CURRENT_FONT!" | findstr /i "NF Nerd Cascadia Caskaydia JetBrains Meslo" >nul
        if not errorlevel 1 (
            set "FONT_NAME=!CURRENT_FONT!"
            set "SKIP_FONT_CHECK=1"
        )
    )
)

REM Parse command line arguments
:parse_args
if "%~1"=="" goto end_parse
if /i "%~1"=="--title" (
    if not "%~2"=="" (
        set "WINDOW_TITLE=%~2"
        set "SKIP_FONT_CHECK="
    )
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--startingDirectory" (
    if not "%~2"=="" set "START_DIR=%~2"
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

REM Font and registry configuration
if "!SKIP_FONT_CHECK!"=="1" goto skip_font_config

REM We use a single PowerShell call to handle font discovery and registration for speed
set "FONTS_SRC="
if exist "%SHELL_ROOT%\vendor\fonts" (
    set "FONTS_SRC=%SHELL_ROOT%\vendor\fonts"
)

set "FONTS_DEST=%LOCALAPPDATA%\Microsoft\Windows\Fonts"
set "REGISTER_FONTS_PS1=%SHELL_ROOT%\config\register-fonts.ps1"

REM Fast font discovery and registration
REM This script outputs the FONT_NAME to be used
set "POWERSHELL_SCRIPT=$fontName = '!FONT_NAME!'; if (-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name '*!FONT_NAME!*' -ErrorAction SilentlyContinue)) { $fallbacks = @('CaskaydiaMono NF', 'CaskaydiaCove NF', 'JetBrainsMono NF', 'MesloLGS NF', 'Cascadia Mono NF'); foreach ($f in $fallbacks) { if (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name '*$f*' -ErrorAction SilentlyContinue) { $fontName = $f; break } } }; if ('!FONTS_SRC!' -ne '' -and (Test-Path '!REGISTER_FONTS_PS1!')) { $captured = & '!REGISTER_FONTS_PS1!' '!FONTS_SRC!' '!FONTS_DEST!'; if ($captured -and $captured -notmatch 'WARNING:|ERROR:') { $fontName = $captured } }; $fontName"

for /f "usebackq delims=" %%F in (`^""!PS_EXE!" -NoProfile -ExecutionPolicy Bypass -Command "!POWERSHELL_SCRIPT!"^"`) do (
    set "FONT_NAME=%%~F"
)

:skip_font_config

REM Escape single quotes for PowerShell
set "PS_WINDOW_TITLE=!WINDOW_TITLE:'=''!"
set "PS_START_DIR=!START_DIR:'=''!"
set "PS_CUSTOM_PROFILE=!CUSTOM_PROFILE:'=''!"

REM Configure console font via registry BEFORE launching PowerShell
REM This ensures ALL console windows use !FONT_NAME! font with proper UTF-8 support

if "!SKIP_FONT_CHECK!"=="1" goto skip_registry_config

REM Set font for the specific window title being used
if not "!WINDOW_TITLE!"=="" (
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FaceName /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v ScreenBufferSize /t REG_DWORD /d 0x0bb8006e /f >nul 2>&1
    reg add "HKCU\Console\!WINDOW_TITLE!" /v WindowSize /t REG_DWORD /d 0x001e006e /f >nul 2>&1

REM Force current window to use the font by setting title
    title !WINDOW_TITLE!
    
    REM Extra "kick" to force conhost to update
    powershell -NoProfile -Command "$Host.UI.RawUI.WindowTitle='Refreshing...'; $Host.UI.RawUI.WindowTitle='!PS_WINDOW_TITLE!'" >nul 2>&1
    
    REM Optional: Briefly clear screen to force a redraw in some conhost versions
    cls
)

REM Set default console properties (applies to all new console windows)
reg add "HKCU\Console" /v FaceName /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
reg add "HKCU\Console" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
reg add "HKCU\Console" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
reg add "HKCU\Console" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1

REM Ensure the font is registered as a valid console font in HKCU and HKLM
REM HKLM is often required for conhost.exe to recognize the font
for /f "tokens=2,*" %%A in ('reg query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "!FONT_NAME! (TrueType)" 2^>nul') do (
    set "FONT_PATH=%%B"
    if not "!FONT_PATH!"=="" reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "!FONT_NAME! (TrueType)" /t REG_SZ /d "!FONT_PATH!" /f >nul 2>&1
)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" /v "000" /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" /v "0000" /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" /v "0" /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" /v "00" /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" /v "000" /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1

REM Also explicitly set for common Bearsampp titles as a fallback
for %%T in ("Bearsampp PowerShell Console" "MariaDB" "MySQL" "PostgreSQL" "Git" "Python" "Composer" "PEAR" "Perl" "Ruby" "Ghostscript" "ngrok" "Node.js" "Console") do (
    reg add "HKCU\Console\%%~T" /v FaceName /t REG_SZ /d "!FONT_NAME!" /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontFamily /t REG_DWORD /d 54 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontSize /t REG_DWORD /d 0x00100000 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
    reg add "HKCU\Console\%%~T" /v CodePage /t REG_DWORD /d 65001 /f >nul 2>&1
)

REM Re-apply title
title !WINDOW_TITLE!

:skip_registry_config

REM Set UTF-8 code page for current console
chcp 65001 >nul 2>&1

REM Ensure the final window title is set
title !WINDOW_TITLE!

REM Set marker to skip re-config in sub-shells
set "BEARSAMPP_SHELL=1"

REM Build the PowerShell command with UTF-8 encoding and title refresh
REM We set the title to a temporary value then back to the target title
REM This forces conhost.exe to re-read registry settings for the target title
set "PS_COMMAND=[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::InputEncoding = [System.Text.Encoding]::UTF8; $Host.UI.RawUI.WindowTitle='Refreshing...'; $Host.UI.RawUI.WindowTitle='!PS_WINDOW_TITLE!'; Set-Location -LiteralPath '!PS_START_DIR!'; . '!PS_CUSTOM_PROFILE!'"

REM Extra attempt to force font refresh in some conhost versions
title !WINDOW_TITLE!

REM Launch PowerShell with custom profile and parameters
REM We use cmd /c start to launch in a new process which reliably picks up registry font settings
REM then we exit the current (incorrectly fonted) window.
if "%NO_EXIT%"=="1" (
    start "!WINDOW_TITLE!" "!PS_EXE!" -NoExit -NoProfile -Command "!PS_COMMAND!"
    exit
) else (
    start "!WINDOW_TITLE!" "!PS_EXE!" -NoProfile -Command "!PS_COMMAND!; exit"
    exit
)
popd
goto :eof

endlocal
