# Bearsampp module Shell - Gradle Build Documentation

<p align="center">
  <a href="https://bearsampp.com/contribute" target="_blank">
    <img width="250" src="../img/Bearsampp-logo.svg">
  </a>
</p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-shell.svg?style=flat-square)](https://github.com/bearsampp/module-shell/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-shell/total.svg?style=flat-square)

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving PowerPowerShell with enhanced features, built using Gradle.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Build Configuration](#build-configuration)
- [Available Tasks](#available-tasks)
- [Build Process](#build-process)
- [Directory Structure](#directory-structure)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## Overview

The PowerShell module provides PowerShell 7+ with enhanced console features including PSReadLine (built-in) for advanced command-line editing and Oh My Posh for beautiful prompt themes. This Gradle build system automates the process of downloading, configuring, and packaging PowerShell releases for Bearsampp.

### Key Features

- **Pure Gradle Build**: Modern build system with no Ant dependencies
- **Automated Downloads**: Fetches PowerShell and dependencies from modules-untouched repository
- **Dependency Management**: Handles Oh My Posh and themes
- **Hash Generation**: Automatically generates MD5, SHA1, SHA256, and SHA512 checksums
- **Multi-Version Support**: Build single or multiple versions simultaneously
- **Interactive Mode**: User-friendly version selection interface

---

## Prerequisites

### Required Software

| Software      | Version    | Purpose                                    | Download                                    |
|---------------|------------|--------------------------------------------|---------------------------------------------|
| Java JDK      | 8 or later | Required to run Gradle                     | https://adoptium.net/                       |
| Gradle        | 8.0+       | Build automation tool                      | https://gradle.org/                         |
| 7-Zip         | Latest     | Required for .7z archive compression       | https://www.7-zip.org/                      |

### Environment Setup

1. **Java Installation**
   ```powershell
   # Verify Java installation
   java -version
   ```

2. **7-Zip Installation**
   - Install 7-Zip to default location: `C:\Program Files\7-Zip\`
   - Or set `7Z_HOME` environment variable to custom installation path

3. **Gradle Installation**
   - Install Gradle 8.0+ locally from https://gradle.org/
   - This project does not include the Gradle wrapper

---

## Quick Start

### Build a Specific Version

```powershell
# Build a specific shell version
gradle release -PbundleVersion=7.5.4
```

### Build All Versions

```powershell
# Build all available versions in bin/ directory
gradle releaseAll
```

### List Available Versions

```powershell
# Show all versions available for building
gradle listVersions
```

### Verify Build Environment

```powershell
# Check if all prerequisites are met
gradle verify
```

---

## Build Configuration

### build.properties

Core build configuration file:

| Property        | Value         | Description                                |
|-----------------|---------------|--------------------------------------------|
| bundle.name     | shell         | Module name                                |
| bundle.release  | 2025.11.13    | Release identifier                         |
| bundle.type     | tools         | Bundle category (tools, apps, etc.)        |
| bundle.format   | 7z            | Archive format (7z or zip)                 |
| build.path      | (optional)    | Custom output path for build artifacts     |

**Default Output Path**: `C:/Bearsampp-build/tools/shell/2025.11.13/`

### gradle.properties

Gradle runtime configuration:

| Property                      | Value                                                          | Description                        |
|-------------------------------|----------------------------------------------------------------|------------------------------------|
| org.gradle.daemon             | true                                                           | Enable Gradle daemon               |
| org.gradle.parallel           | true                                                           | Enable parallel execution          |
| org.gradle.caching            | true                                                           | Enable build caching               |
| org.gradle.jvmargs            | -Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError | JVM memory settings                |
| org.gradle.console            | auto                                                           | Console output mode                |
| org.gradle.warning.mode       | all                                                            | Show all warnings                  |

### releases.properties

Maps shell versions to download URLs:

```properties
7.5.4 = https://github.com/Bearsampp/module-shell/releases/download/2025.11.13/bearsampp-shell-7.5.4-2025.11.13.7z
```

---

## Available Tasks

### Build Tasks

| Task                          | Description                                                    | Example                                      |
|-------------------------------|----------------------------------------------------------------|----------------------------------------------|
| `release`                     | Build release for specific version                             | `gradle release -PbundleVersion=7.5.4`       |
| `releaseAll`                  | Build all available versions                                   | `gradle releaseAll`                          |
| `clean`                       | Clean build artifacts and temporary files                      | `gradle clean`                               |

### Verification Tasks

| Task                          | Description                                                    | Example                                      |
|-------------------------------|----------------------------------------------------------------|----------------------------------------------|
| `verify`                      | Verify build environment and dependencies                      | `gradle verify`                              |
| `validateProperties`          | Validate build.properties configuration                        | `gradle validateProperties`                  |
| `checkDeps`                   | Check dependencies configuration in bin directories            | `gradle checkDeps`                           |

### Information Tasks

| Task                          | Description                                                    | Example                                      |
|-------------------------------|----------------------------------------------------------------|----------------------------------------------|
| `info`                        | Display build information and available tasks                  | `gradle info`                                |
| `listVersions`                | List available bundle versions in bin/ directories             | `gradle listVersions`                        |
| `listReleases`                | List releases from releases.properties                         | `gradle listReleases`                        |
| `tasks`                       | Show all available Gradle tasks                                | `gradle tasks`                               |

---

## Build Process

### Step-by-Step Build Flow

1. **Version Selection**
   - Specify version via `-PbundleVersion` parameter
   - Or use interactive mode to select from available versions

2. **Module Download**
   - Downloads PowerShell from modules-untouched repository
   - Extracts to temporary directory
   - Verifies pwsh.exe exists

3. **Dependency Processing**
   - Reads `deps.properties` from version directory
   - Downloads and extracts dependencies:
     - **Oh My Posh**: Beautiful prompt themes
     - **Oh My Posh Themes**: Theme configuration files

4. **File Preparation**
   - Copies bundle files to temporary preparation directory
   - Organizes dependencies in proper structure
   - Removes temporary configuration files

5. **Archive Creation**
   - Compresses prepared files using 7-Zip or ZIP
   - Generates hash files (MD5, SHA1, SHA256, SHA512)
   - Outputs to build directory

6. **Output Organization**
   ```
   C:/Bearsampp-build/
   └── tools/
       └── shell/
           └── 2025.11.13/
               ├── bearsampp-shell-7.5.4-2025.11.13.7z
               ├── bearsampp-shell-7.5.4-2025.11.13.7z.md5
               ├── bearsampp-shell-7.5.4-2025.11.13.7z.sha1
               ├── bearsampp-shell-7.5.4-2025.11.13.7z.sha256
               └── bearsampp-shell-7.5.4-2025.11.13.7z.sha512
   ```

---

## Directory Structure

```
module-shell/
├── .gradle/                      # Gradle cache and build data
├── .gradle-docs/                 # Build documentation (this directory)
│   ├── README.md                 # Main documentation
│   ├── TASKS.md                  # Detailed task reference
│   ├── CONFIGURATION.md          # Configuration guide
│   └── TROUBLESHOOTING.md        # Common issues and solutions
├── bin/                          # shell version directories
│   ├── shell-7.5.4/              # Version-specific files
│   │   ├── pwsh.exe              # Main executable
│   │   ├── bearsampp.conf        # Configuration
│   │   └── deps.properties       # Dependency URLs
│   └── archived/                 # Archived versions
├── build/                        # Gradle build output
├── img/                          # Images and assets
│   └── Bearsampp-logo.svg
├── build.gradle                  # Main Gradle build script
├���─ build.properties              # Bundle configuration
├── gradle.properties             # Gradle runtime configuration
├── releases.properties           # Version to URL mappings
├── settings.gradle               # Gradle project settings
└── README.md                     # Project overview
```

---

## Dependencies

### PowerShell dependencies

PowerShell bundles include the following dependencies, configured in `deps.properties`:

| Dependency                    | Purpose                                    | Location                          |
|-------------------------------|--------------------------------------------|------------------------------------|
| PSReadLine                    | Advanced command-line editing (built-in)   | Built into PowerShell 7+           |
| Oh My Posh                    | Beautiful prompt themes                    | `vendor/oh-my-posh/`               |
| Oh My Posh Themes             | Theme configuration files                  | `vendor/oh-my-posh/themes/`        |

### Example deps.properties

```properties
oh_my_posh = https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-windows-amd64.exe
oh_my_posh_theme = https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/paradox.omp.json
```

---

## Troubleshooting

### Common Issues

#### 7-Zip Not Found

**Error**: `7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.`

**Solution**:
1. Install 7-Zip from https://www.7-zip.org/
2. Or set `7Z_HOME` environment variable:
   ```powershell
   setx 7Z_HOME "C:\Path\To\7-Zip"
   ```

#### Java Version Issues

**Error**: `Unsupported class file major version`

**Solution**:
- Ensure Java 8 or later is installed
- Check Java version: `java -version`
- Update `JAVA_HOME` environment variable if needed

#### Build Path Access Denied

**Error**: `Access denied` when writing to build path

**Solution**:
1. Run PowerShell/Command Prompt as Administrator
2. Or change `build.path` in `build.properties` to a writable location

#### Version Not Found

**Error**: `Bundle version not found: shell-7.5.4`

**Solution**:
- Check available versions: `gradle listVersions`
- Ensure version directory exists in `bin/` or `bin/archived/`
- Verify directory name matches pattern: `shell-{version}`

#### Download Failures

**Error**: `Failed to download from URL`

**Solution**:
1. Check internet connection
2. Verify URL in `releases.properties` or `deps.properties`
3. Check if GitHub is accessible
4. Try manual download and place in temp directory

---

## Contributing

### Adding New Versions

1. Create version directory in `bin/`:
   ```
   bin/shell-{version}/
   ```

2. Add version files:
   - `pwsh.exe` (main executable)
   - `bearsampp.conf` (configuration)
   - `deps.properties` (optional, for dependencies)

3. Update `releases.properties`:
   ```properties
   {version} = {download_url}
   ```

4. Build and test:
   ```powershell
   gradle release -PbundleVersion={version}
   ```

### Modifying Build Process

1. Edit `build.gradle` for build logic changes
2. Update `build.properties` for configuration changes
3. Modify `gradle.properties` for Gradle runtime settings
4. Test changes thoroughly:
   ```powershell
   gradle clean verify release -PbundleVersion=7.5.4
   ```

---

## Documentation and Downloads

- **Official Website**: https://bearsampp.com/module/shell
- **GitHub Repository**: https://github.com/bearsampp/module-shell
- **Issue Tracker**: https://github.com/bearsampp/bearsampp/issues
- **Bearsampp Main Project**: https://github.com/bearsampp/bearsampp

---

## Sponsors

We would like to thank our sponsors to the project:

[N6REJ](https://github.com/N6REJ)

<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.png" width="80">

[![Code Shelter](https://www.codeshelter.co/static/badges/badge-flat.svg)](https://www.codeshelter.co/)

---

## License

This project is part of the Bearsampp ecosystem. See [LICENSE](../LICENSE) for details.

---

**Last Updated**: 2025
**Gradle Version**: 8.0+
**Build System**: Pure Gradle (no wrapper, no Ant)

**Notes**:
- This project deliberately does not ship the Gradle Wrapper. Install Gradle 8+ locally and run with `gradle ...`.
