# Bearsampp PowerShell Profile
# This profile configures PowerShell with enhanced console features
# PowerShell 7+ includes PSReadLine by default for command-line editing

# Get the shell root directory
$SHELL_ROOT = Split-Path -Parent $PSScriptRoot

# Set environment variables for Oh My Posh
$env:POSH_ROOT = Join-Path $SHELL_ROOT "vendor\oh-my-posh"

# Set PowerShell module path to include bundled modules
$env:PSModulePath = (Join-Path $SHELL_ROOT "vendor\modules") + ";" + $env:PSModulePath

# Configure console to use Nerd Font (Cascadia Mono NF)
# This is required for Oh My Posh icons and glyphs to display correctly
# Note: Font configuration is handled by the launcher (powershell.bat) via registry.

# Initialize Oh My Posh with theme
$ohMyPoshExe = "$env:POSH_ROOT\posh-windows-amd64.exe"
$ohMyPoshTheme = "$env:POSH_ROOT\themes\paradox.omp.json"

if (Test-Path $ohMyPoshExe -PathType Leaf) {
    & $ohMyPoshExe init pwsh --config $ohMyPoshTheme | Invoke-Expression
}

# Import Terminal-Icons for colorful file/folder icons
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# Set PowerShell options for better experience
if ($PSVersionTable.PSVersion.Major -ge 5) {
    # Use a single call to Set-PSReadLineOption for speed if possible (not all options can be combined)
    Set-PSReadLineOption -EditMode Windows -HistorySearchCursorMovesToEnd -MaximumHistoryCount 10000 -HistoryNoDuplicates
    Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
    Set-PSReadLineOption -Colors @{
        Command   = 'Green'
        Parameter = 'Gray'
        String    = 'DarkCyan'
    }

    # Key bindings
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# Welcome message
# Only show banner in interactive ConsoleHost and not when running commands
if ($Host.Name -eq "ConsoleHost" -and $ExecutionContext.SessionState.LanguageMode -eq "FullLanguage" -and -not $MyInvocation.BoundParameters.ContainsKey('Command')) {
    Write-Host "Bearsampp PowerShell" -ForegroundColor Cyan
    Write-Host "Enhanced with PSReadLine, Oh My Posh, and Terminal-Icons" -ForegroundColor Gray
    Write-Host ""
}
