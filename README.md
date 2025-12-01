<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-powershell.svg?style=flat-square)](https://github.com/bearsampp/module-powershell/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-powershell/total.svg?style=flat-square)

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving PowerShell with enhanced features, built with a pure Gradle build system.

---

## Overview

This module provides PowerShell 7+ with enhanced console features including:
- **Oh My Posh** - Beautiful and customizable prompt themes
- **PSReadLine** - Advanced command-line editing and history
- **Nerd Fonts** - Rich icon and glyph support

This module provides automated building and packaging for Bearsampp.

### Font Requirement

This PowerShell module requires a **Nerd Font** to display Oh My Posh icons and glyphs correctly.

#### Required Font
- **Font Name**: CaskaydiaCove NF (Cascadia Code Nerd Font)
- **Installation**: Should be installed system-wide via Bearsampp prerequisites

#### Configuring the Font

**Windows Terminal (Recommended)**

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

**Windows Console Host (conhost.exe)**
1. Right-click the title bar → Properties
2. Go to the Font tab
3. Select "CaskaydiaCove NF" from the font list
4. Click OK

**PowerShell Console**

The font is automatically used if it's set as the default console font in Windows.

### Build System

- **Pure Gradle Build**: Modern build automation with no Ant dependencies
- **Automated Downloads**: Fetches PowerShell and dependencies from modules-untouched repository
- **Multi-Version Support**: Build single or multiple versions simultaneously
- **Hash Generation**: Automatically generates MD5, SHA1, SHA256, and SHA512 checksums

---

## Quick Start

### Prerequisites

| Software      | Version    | Required | Download                                    |
|---------------|------------|----------|---------------------------------------------|
| Java JDK      | 8 or later | Yes      | https://adoptium.net/                       |
| Gradle        | 8.0+       | Yes      | https://gradle.org/                         |
| 7-Zip         | Latest     | Yes**    | https://www.7-zip.org/ (**for .7z format)   |

### Build Commands

```powershell
# Build a specific version
gradle release -PbundleVersion=7.5.4

# Build all available versions
gradle releaseAll

# List available versions
gradle listVersions

# Verify build environment
gradle verify

# Show all available tasks
gradle tasks
```

---

## Documentation

Comprehensive documentation is available in the `.gradle-docs/` directory:

| Document                                              | Description                                    |
|-------------------------------------------------------|------------------------------------------------|
| [README.md](.gradle-docs/README.md)                   | Main documentation and getting started guide   |
| [TASKS.md](.gradle-docs/TASKS.md)                     | Complete task reference and examples           |
| [CONFIGURATION.md](.gradle-docs/CONFIGURATION.md)     | Configuration options and settings             |
| [TROUBLESHOOTING.md](.gradle-docs/TROUBLESHOOTING.md) | Common issues and solutions                    |

---

## Project Structure

```
module-powershell/
├── .gradle-docs/                 # Build documentation
│   ├── README.md                 # Main documentation
│   ├── TASKS.md                  # Task reference
│   ├── CONFIGURATION.md          # Configuration guide
│   └── TROUBLESHOOTING.md        # Troubleshooting guide
├── bin/                          # Shell version directories
│   └── powershell{version}/           # Version-specific files
│       ├── deps.properties       # Dependencies configuration
│       └── bearsampp.conf        # Bearsampp configuration
├── build.gradle                  # Main Gradle build script
├── build.properties              # Bundle configuration
├── gradle.properties             # Gradle runtime configuration
├── releases.properties           # Version to URL mappings
└── settings.gradle               # Gradle project settings
```

---

## Configuration

### build.properties

Core build configuration:

```properties
bundle.name     = powershell           # Module name
bundle.release  = 2025.11.13      # Release identifier
bundle.type     = tools           # Bundle category
bundle.format   = 7z              # Archive format (7z or zip)
#build.path     = C:/Bearsampp-build  # Optional: custom output path
```

### deps.properties

Dependencies configuration for each version (located in `bin/powershell{version}/deps.properties`):

```properties
oh_my_posh = https://github.com/Bearsampp/modules-untouched/releases/download/Cmder-2025.11.25/posh-windows-amd64.exe
oh_my_posh_theme = https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/paradox.omp.json
```

### Available Tasks

| Task                          | Description                                                    |
|-------------------------------|----------------------------------------------------------------|
| `release`                     | Build release for specific version                             |
| `releaseAll`                  | Build all available versions                                   |
| `clean`                       | Clean build artifacts and temporary files                      |
| `verify`                      | Verify build environment and dependencies                      |
| `listVersions`                | List available bundle versions                                 |
| `listReleases`                | List releases from modules-untouched                           |
| `checkDeps`                   | Check dependencies configuration                               |
| `info`                        | Display build information                                      |

---

## Examples

### Build Specific Version

```powershell
# Non-interactive mode
gradle release -PbundleVersion=7.5.4

# Interactive mode (prompts for version selection)
gradle release
```

### Build All Versions

```powershell
gradle releaseAll
```

### Verify Environment

```powershell
gradle verify
```

**Output**:
```
Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     build.properties
  [PASS]     dev directory
  [PASS]     bin directory
  [PASS]     7-Zip
------------------------------------------------------------

[SUCCESS] All checks passed! Build environment is ready.
```

---

## Output

Build artifacts are organized as follows:

```
C:/Bearsampp-build/
└── tools/
    └── powershell/
        └── 2025.11.13/
            ├── bearsampp-powershell-7.5.4-2025.11.13.7z
            ├── bearsampp-powershell-7.5.4-2025.11.13.7z.md5
            ├── bearsampp-powershell-7.5.4-2025.11.13.7z.sha1
            ├── bearsampp-powershell-7.5.4-2025.11.13.7z.sha256
            └── bearsampp-powershell-7.5.4-2025.11.13.7z.sha512
```

---

## Features

### Enhanced Console Features

- **Oh My Posh Themes**: Beautiful, customizable prompt themes
- **PSReadLine**: Advanced command-line editing with syntax highlighting
- **Auto-completion**: Intelligent command and path completion
- **Command History**: Persistent command history across sessions
- **Nerd Font Icons**: Rich visual indicators and glyphs

### Configuration Files

- **Microsoft.PowerShell_profile.ps1** - Main PowerShell profile
  - Configures PSReadLine (command-line editing)
  - Initializes Oh My Posh with paradox theme
  - Sets up history and key bindings
  - Requires CaskaydiaCove NF font for proper icon display

### Environment Variables

The profile sets these environment variables:
- `POSH_ROOT` - Path to Oh My Posh installation
- `POSH_THEMES_PATH` - Path to Oh My Posh themes directory

### Customization

**Change Oh My Posh Theme**

Edit the profile and change the theme file:
```powershell
$ohMyPoshTheme = Join-Path $env:POSH_ROOT "themes\YOUR_THEME.omp.json"
```

Available themes are in `vendor/oh-my-posh/themes/`

**Modify PSReadLine Settings**

Edit the `Set-PSReadLineOption` calls in the profile to customize:
- Colors
- Key bindings
- History behavior
- Prediction settings

### Build Features

- **Dependency Management**: Automatic download and integration of dependencies
- **Version Control**: Support for multiple PowerShell versions
- **Automated Packaging**: Creates distribution-ready archives with checksums
- **Caching**: Downloads are cached to speed up subsequent builds

---

## Documentation and Downloads

- **Official Website**: https://bearsampp.com/module/powershell
- **GitHub Repository**: https://github.com/bearsampp/module-powershell
- **Build Documentation**: [.gradle-docs/README.md](.gradle-docs/README.md)

---

## Notes

This project deliberately does not ship the Gradle Wrapper. Install Gradle 8+ locally and run with `gradle ...`.

---

## Issues

Issues must be reported on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).
