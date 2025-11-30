# Project Directory Structure

## Overview

The Bearsampp Shell module uses a clear separation between different types of documentation:

```
module-shell/
├── docs/                         # Non-Gradle documentation
│   ├── README.md                 # Documentation index
│   ├── CHANGES.md                # Quick reference of changes
│   ├── CONVERSION-COMPLETE.md    # Detailed conversion documentation
│   └── DIRECTORY-STRUCTURE.md    # This file
│
├── .gradle-docs/                 # Gradle build system documentation
│   ├── README.md                 # Main build documentation
│   ├── INDEX.md                  # Documentation navigation
│   ├── TASKS.md                  # Task reference
│   ├── CONFIGURATION.md          # Configuration guide
│   ├── TROUBLESHOOTING.md        # Troubleshooting guide
│   ├── MIGRATION.md              # Migration guide
│   └── CONVERSION-SUMMARY.md     # Conversion summary
│
├── bin/                          # Version-specific files
│   └── shell-7.5.4/              # PowerShell 7.5.4
│       ├── deps.properties       # Dependencies configuration
│       └── bearsampp.conf        # Bearsampp configuration
│
├── img/                          # Images and assets
│   └── Bearsampp-logo.svg
│
├── gradle/                       # Gradle wrapper files
│   └── wrapper/
│
├── build.gradle                  # Main Gradle build script
├── build.properties              # Bundle configuration
├── gradle.properties             # Gradle runtime configuration
├── releases.properties           # Version to URL mappings
├── settings.gradle               # Gradle project settings
└── README.md                     # Main project README
```

## Documentation Types

### 1. Project Documentation (`/docs`)
**Purpose**: General project information, conversion notes, and change logs

**Files**:
- `README.md` - Documentation index
- `CHANGES.md` - Summary of all changes
- `CONVERSION-COMPLETE.md` - Detailed conversion documentation
- `DIRECTORY-STRUCTURE.md` - This file

**Audience**: Developers, contributors, and users interested in project history

---

### 2. Build Documentation (`/.gradle-docs`)
**Purpose**: Gradle build system documentation

**Files**:
- `README.md` - Main build documentation
- `TASKS.md` - Complete task reference
- `CONFIGURATION.md` - Configuration options
- `TROUBLESHOOTING.md` - Build troubleshooting
- `MIGRATION.md` - Ant to Gradle migration
- `CONVERSION-SUMMARY.md` - Build system conversion

**Audience**: Developers building and maintaining the module

---

### 3. Main README (`/README.md`)
**Purpose**: Project overview and quick start

**Contents**:
- Project description
- Quick start guide
- Build commands
- Feature overview
- Links to detailed documentation

**Audience**: All users, especially newcomers

---

## Navigation Guide

### For New Users
1. Start with `/README.md` for project overview
2. Read `/docs/README.md` for documentation index
3. Check `/.gradle-docs/README.md` for build instructions

### For Building
1. Read `/.gradle-docs/README.md` for prerequisites
2. Check `/.gradle-docs/TASKS.md` for available tasks
3. Use `/.gradle-docs/CONFIGURATION.md` for customization
4. Refer to `/.gradle-docs/TROUBLESHOOTING.md` if issues arise

### For Understanding Changes
1. Read `/docs/CHANGES.md` for quick summary
2. Check `/docs/CONVERSION-COMPLETE.md` for detailed information
3. Review `/.gradle-docs/MIGRATION.md` for build system changes

---

## File Organization Principles

### `/docs` - Project Documentation
- **Non-technical documentation**
- **Project history and changes**
- **Conversion and migration notes**
- **General information**

### `/.gradle-docs` - Build Documentation
- **Technical build documentation**
- **Task references**
- **Configuration guides**
- **Build troubleshooting**

### Root Directory
- **Essential project files**
- **Main README**
- **Configuration files**
- **Build scripts**

---

## Quick Links

### Documentation
- [Project Documentation Index](/docs/README.md)
- [Build Documentation](/.gradle-docs/README.md)
- [Main Project README](/README.md)

### Key Files
- [Changes Summary](/docs/CHANGES.md)
- [Conversion Details](/docs/CONVERSION-COMPLETE.md)
- [Task Reference](/.gradle-docs/TASKS.md)
- [Configuration Guide](/.gradle-docs/CONFIGURATION.md)
- [Troubleshooting](/.gradle-docs/TROUBLESHOOTING.md)

---

**Last Updated**: November 2025
**Module Version**: 7.5.4
**Build System**: Gradle 8.0+
