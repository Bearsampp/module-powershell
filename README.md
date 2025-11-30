<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-consolez.svg?style=flat-square)](https://github.com/bearsampp/module-consolez/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-consolez/total.svg?style=flat-square)

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving ConsoleZ, built with a pure Gradle build system.

---

## Overview

ConsoleZ is an enhanced console window for Windows featuring tabs, text editor-like text selection, and various customization options. This module provides automated building and packaging for Bearsampp.

### Build System

- **Pure Gradle Build**: Modern build automation with no Ant dependencies
- **Automated Downloads**: Fetches ConsoleZ and dependencies from modules-untouched repository
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
gradle release -PbundleVersion=1.19.0.19104

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
module-consolez/
├── .gradle-docs/                 # Build documentation
│   ├── README.md                 # Main documentation
│   ├── TASKS.md                  # Task reference
│   ├── CONFIGURATION.md          # Configuration guide
│   └── TROUBLESHOOTING.md        # Troubleshooting guide
├── bin/                          # ConsoleZ version directories
│   └── consolez{version}/        # Version-specific files
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
bundle.name     = consolez        # Module name
bundle.release  = r1              # Release identifier
bundle.type     = tools           # Bundle category
bundle.format   = 7z              # Archive format (7z or zip)
#build.path     = C:/Bearsampp-build  # Optional: custom output path
```

### Available Tasks

| Task                          | Description                                                    |
|-------------------------------|----------------------------------------------------------------|
| `release`                     | Build release for specific version                             |
| `releaseAll`                  | Build all available versions                                   |
| `clean`                       | Clean build artifacts and temporary files                      |
| `verify`                      | Verify build environment and dependencies                      |
| `listVersions`                | List available bundle versions                                 |
| `listReleases`                | List releases from releases.properties                         |
| `info`                        | Display build information                                      |

---

## Examples

### Build Specific Version

```powershell
# Non-interactive mode
gradle release -PbundleVersion=1.19.0.19104

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
  [PASS]     releases.properties
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
    └── consolez/
        └── r1/
            ├── bearsampp-consolez-1.19.0.19104-r1.7z
            ├── bearsampp-consolez-1.19.0.19104-r1.7z.md5
            ├── bearsampp-consolez-1.19.0.19104-r1.7z.sha1
            ├── bearsampp-consolez-1.19.0.19104-r1.7z.sha256
            └── bearsampp-consolez-1.19.0.19104-r1.7z.sha512
```

---

## Documentation and Downloads

- **Official Website**: https://bearsampp.com/module/consolez
- **GitHub Repository**: https://github.com/bearsampp/module-consolez
- **Build Documentation**: [.gradle-docs/README.md](.gradle-docs/README.md)

---

## Notes

This project deliberately does not ship the Gradle Wrapper. Install Gradle 8+ locally and run with `gradle ...`.

---

## Issues

Issues must be reported on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).

## Sponsors

We would like to thank our sponsors to the project:

[N6REJ](https://github.com/N6REJ)<br />

<img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.png" width="80">

[![Code Shelter](https://www.codeshelter.co/static/badges/badge-flat.svg)](https://www.codeshelter.co/)
