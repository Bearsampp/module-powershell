# Bearsampp PowerShell Profile
# This profile configures PowerShell with enhanced console features
# PowerShell 7+ includes PSReadLine by default for command-line editing

# Get the shell root directory
$SHELL_ROOT = Split-Path -Parent $PSScriptRoot

# Set environment variables for Oh My Posh
$env:POSH_ROOT = Join-Path $SHELL_ROOT "vendor\oh-my-posh"

# Set PowerShell module path to include bundled modules
$env:PSModulePath = (Join-Path $SHELL_ROOT "vendor\modules") + ";" + $env:PSModulePath

# Configure console to use Nerd Font (CaskaydiaCove NF)
# This is required for Oh My Posh icons and glyphs to display correctly
try {
    # Attempt to set console font programmatically
    $setFontScript = Join-Path $PSScriptRoot "Set-ConsoleFont.ps1"
    if (Test-Path $setFontScript) {
        & $setFontScript -FontName "CaskaydiaCove NF" -FontSize 16 -ErrorAction SilentlyContinue
    }

    # Only set default title if one hasn't been set already
    # This allows the launcher to set custom titles per console type
    if ($Host.UI.RawUI.WindowTitle -eq "Administrator: C:\WINDOWS\system32\cmd.exe" -or
        $Host.UI.RawUI.WindowTitle -eq "C:\WINDOWS\system32\cmd.exe" -or
        $Host.UI.RawUI.WindowTitle -match "pwsh\.exe") {
        $Host.UI.RawUI.WindowTitle = "Bearsampp PowerShell Console"
    }

    # Note: Font configuration is typically set in Windows Terminal settings.json
    # or via registry for Windows Console Host. The font should be installed system-wide.
    # Oh My Posh will automatically use the console's configured font.

    # Set POSH_THEMES_PATH for easy theme switching
    $env:POSH_THEMES_PATH = Join-Path $env:POSH_ROOT "themes"
} catch {
    # Silently continue if console configuration fails
}

# Initialize Oh My Posh with theme
$ohMyPoshExe = Join-Path $env:POSH_ROOT "posh-windows-amd64.exe"
$ohMyPoshTheme = Join-Path $env:POSH_ROOT "themes\paradox.omp.json"

if (Test-Path $ohMyPoshExe) {
    if (Test-Path $ohMyPoshTheme) {
        # Initialize Oh My Posh with the paradox theme
        & $ohMyPoshExe init pwsh --config $ohMyPoshTheme | Invoke-Expression
    } else {
        Write-Host "Oh My Posh theme not found: $ohMyPoshTheme" -ForegroundColor Yellow
    }
} else {
    Write-Host "Oh My Posh not found: $ohMyPoshExe" -ForegroundColor Yellow
}

# Import Terminal-Icons for colorful file/folder icons
try {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
} catch {
    # Silently continue if Terminal-Icons is not available
}

# Set PowerShell options for better experience
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -Colors @{
    Command   = 'Green'
    Parameter = 'Gray'
    String    = 'DarkCyan'
}

# Set history options
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -HistoryNoDuplicates

# Key bindings for better navigation
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Welcome message
Write-Host "Bearsampp PowerShell" -ForegroundColor Cyan
Write-Host "Enhanced with PSReadLine, Oh My Posh, and Terminal-Icons" -ForegroundColor Gray
Write-Host ""
