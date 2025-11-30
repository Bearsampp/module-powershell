@echo off

:: Root dir
set CONSOLE_ROOT=%~dp0

:: Remove trailing '\'
if "%CONSOLE_ROOT:~-1%" == "\" SET "CONSOLE_ROOT=%CONSOLE_ROOT:~0,-1%"

:: Get architecture
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set architecture=86
) else (
    set architecture=64
)

set PATH=%CONSOLE_ROOT%\vendor\gnuwin32;%PATH%

:: Run clink
"%CONSOLE_ROOT%\vendor\clink\clink_x%architecture%.exe" inject --quiet --profile "%CONSOLE_ROOT%\config" --scripts "%CONSOLE_ROOT%\vendor"
