# Bearsampp PowerShell Configuration

## Font Requirement

This PowerShell module requires a **Nerd Font** to display Oh My Posh icons and glyphs correctly.

### Required Font
- **Font Name**: CaskaydiaCove NF (Cascadia Code Nerd Font)
- **Installation**: Should be installed system-wide via Bearsampp prerequisites

### Configuring the Font

#### Windows Terminal (Recommended)
If using Windows Terminal, add this to your `settings.json`:

```json
{
    "profiles": {
        "defaults": {
            "font": {
                "face": "CaskaydiaCove NF",
                "size": 10
            }
        }
    }
}
```

#### Windows Console Host (conhost.exe)
1. Right-click the title bar → Properties
2. Go to the Font tab
3. Select "CaskaydiaCove NF" from the font list
4. Click OK

#### PowerShell Console
The font is automatically used if it's set as the default console font in Windows.

## Files

- **Microsoft.PowerShell_profile.ps1** - Main PowerShell profile
  - Configures PSReadLine (command-line editing)
  - Initializes Oh My Posh with paradox theme
  - Sets up history and key bindings
  - Requires CaskaydiaCove NF font for proper icon display

## Environment Variables

The profile sets these environment variables:
- `POSH_ROOT` - Path to Oh My Posh installation
- `POSH_THEMES_PATH` - Path to Oh My Posh themes directory

## Customization

### Change Oh My Posh Theme
Edit the profile and change the theme file:
```powershell
$ohMyPoshTheme = Join-Path $env:POSH_ROOT "themes\YOUR_THEME.omp.json"
```

Available themes are in `vendor/oh-my-posh/themes/`

### Modify PSReadLine Settings
Edit the `Set-PSReadLineOption` calls in the profile to customize:
- Colors
- Key bindings
- History behavior
- Prediction settings
