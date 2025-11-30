# Gradle Tasks Reference

Complete reference for all available Gradle tasks in the Bearsampp module Shell build system.

---

## Table of Contents

- [Build Tasks](#build-tasks)
- [Verification Tasks](#verification-tasks)
- [Information Tasks](#information-tasks)
- [Gradle Built-in Tasks](#gradle-built-in-tasks)
- [Task Dependencies](#task-dependencies)
- [Advanced Usage](#advanced-usage)

---

## Build Tasks

### release

Build a release package for a specific shell version.

**Group**: `build`

**Syntax**:
```powershell
gradlew release -PbundleVersion=<version>
```

**Parameters**:

| Parameter       | Required | Description                                | Example          |
|-----------------|----------|--------------------------------------------|------------------|
| bundleVersion   | No*      | Version to build                           | 7.5.4     |

*If not provided, interactive mode will prompt for version selection.

**Examples**:
```powershell
# Build specific version (non-interactive)
gradlew release -PbundleVersion=7.5.4

# Build with interactive version selection
gradlew release
```

**Process**:
1. Validates version exists in `bin/` or `bin/archived/`
2. Downloads module from modules-untouched repository
3. Processes dependencies from `deps.properties`
4. Prepares files in temporary directory
5. Creates compressed archive (.7z or .zip)
6. Generates hash files (MD5, SHA1, SHA256, SHA512)
7. Outputs to build directory

**Output Location**:
```
{build.path}/{bundle.type}/{bundle.name}/{bundle.release}/
```

Default: `C:/Bearsampp-build/tools/shell/2025.11.13/`

---

### releaseAll

Build release packages for all available versions.

**Group**: `build`

**Syntax**:
```powershell
gradlew releaseAll
```

**Parameters**: None

**Examples**:
```powershell
# Build all versions
gradlew releaseAll
```

**Process**:
1. Scans `bin/` and `bin/archived/` directories
2. Identifies all version directories
3. Executes `release` task for each version
4. Provides summary of successful and failed builds

**Output**:
- Individual archives for each version
- Build summary with success/failure counts
- List of failed versions (if any)

---

### clean

Clean build artifacts and temporary files.

**Group**: `build`

**Syntax**:
```powershell
gradlew clean
```

**Parameters**: None

**Examples**:
```powershell
# Clean build artifacts
gradlew clean

# Clean and rebuild
gradlew clean release -PbundleVersion=7.5.4
```

**Removes**:
- `build/` directory (Gradle build output)
- Temporary build directory (system temp)
- Downloaded dependency caches

---

### downloadshell

Download shell package directly from modules-untouched repository.

**Group**: `build`

**Syntax**:
```powershell
gradlew downloadshell -PshellVersion=<version>
```

**Parameters**:

| Parameter        | Required | Description                                | Example          |
|------------------|----------|--------------------------------------------|------------------|
| shellVersion  | Yes      | shell version to download               | 7.5.4     |

**Examples**:
```powershell
# Download specific version
gradlew downloadshell -PshellVersion=7.5.4
```

**Process**:
1. Reads version URL from `releases.properties`
2. Downloads archive from modules-untouched
3. Extracts to temporary directory
4. Displays extraction location

**Use Cases**:
- Testing new versions before adding to build
- Manual inspection of module contents
- Troubleshooting download issues

---

## Verification Tasks

### verify

Verify build environment and dependencies.

**Group**: `verification`

**Syntax**:
```powershell
gradlew verify
```

**Parameters**: None

**Examples**:
```powershell
# Verify build environment
gradlew verify
```

**Checks**:

| Check                | Description                                | Pass Criteria                    |
|----------------------|--------------------------------------------|----------------------------------|
| Java 8+              | Java Development Kit version               | JDK 8 or higher installed        |
| build.properties     | Build configuration file                   | File exists and readable         |
| releases.properties  | Version mappings file                      | File exists and readable         |
| dev directory        | Parent dev directory                       | Directory exists                 |
| bin directory        | Version storage directory                  | Directory exists                 |
| 7-Zip                | Archive compression tool                   | Executable found (if format=7z)  |

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

### validateProperties

Validate build.properties configuration.

**Group**: `verification`

**Syntax**:
```powershell
gradlew validateProperties
```

**Parameters**: None

**Examples**:
```powershell
# Validate configuration
gradlew validateProperties
```

**Validates**:

| Property        | Required | Valid Values                               |
|-----------------|----------|--------------------------------------------|
| bundle.name     | Yes      | Non-empty string                           |
| bundle.release  | Yes      | Non-empty string (e.g., 2025.11.13, r2)            |
| bundle.type     | Yes      | Non-empty string (e.g., tools, apps)       |
| bundle.format   | Yes      | 7z or zip                                  |

**Output**:
```
[SUCCESS] All required properties are present:
    bundle.name = shell
    bundle.release = 2025.11.13
    bundle.type = tools
    bundle.format = 7z
```

---

### checkDeps

Check dependencies configuration in bin directories.

**Group**: `verification`

**Syntax**:
```powershell
gradlew checkDeps
```

**Parameters**: None

**Examples**:
```powershell
# Check dependencies
gradlew checkDeps
```

**Process**:
1. Scans all version directories in `bin/`
2. Checks for `deps.properties` file
3. Lists configured dependencies

**Output**:
```
Checking shell dependencies configuration...
--------------------------------------------------------------------------------

shell7.5.4:
  Dependencies file: Found (5 dependencies)
    - ansicon: https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip
    - clink: https://github.com/chrisant996/clink/releases/download/v1.5.3/clink-1.5.3.zip
    - clink_completions: https://github.com/vladimir-kotikov/clink-completions/archive/refs/tags/0.4.0.zip
    - gnuwin32_coreutils_bin: https://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-bin.zip
    - gnuwin32_coreutils_dep: https://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-dep.zip
--------------------------------------------------------------------------------
```

---

## Information Tasks

### info

Display build information and available tasks.

**Group**: `help`

**Syntax**:
```powershell
gradlew info
```

**Parameters**: None

**Examples**:
```powershell
# Show build information
gradlew info
```

**Output**:
```
================================================================
  Bearsampp module Shell - Build Information
================================================================

Bundle Configuration:
  Name:           shell
  Release:        2025.11.13
  Type:           tools
  Format:         7z

Paths:
  Project:        E:/Bearsampp-development/module-shell
  Dev:            E:/Bearsampp-development/dev
  Build Output:   C:/Bearsampp-build

Available Tasks:
  gradle info              - Show this information
  gradle listVersions      - List available bundle versions
  gradle listReleases      - List releases from releases.properties
  gradle release           - Build release (use -PbundleVersion=X.X.X.X)
  gradle releaseAll        - Build all available versions
  gradle verify            - Verify build environment
  gradle validateProperties - Validate build.properties
  gradle checkDeps         - Check dependencies configuration
  gradle clean             - Clean build artifacts

Examples:
  gradle release -PbundleVersion=7.5.4
  gradle releaseAll

================================================================
```

---

### listVersions

List available bundle versions in bin/ and bin/archived/ directories.

**Group**: `help`

**Syntax**:
```powershell
gradlew listVersions
```

**Parameters**: None

**Examples**:
```powershell
# List available versions
gradlew listVersions
```

**Output**:
```
Available shell versions:
------------------------------------------------------------
  7.5.4         [bin]
------------------------------------------------------------
Total versions: 1

To build a specific version:
  gradle release -PbundleVersion=7.5.4
```

---

### listReleases

List all available releases from releases.properties.

**Group**: `help`

**Syntax**:
```powershell
gradlew listReleases
```

**Parameters**: None

**Examples**:
```powershell
# List releases
gradlew listReleases
```

**Output**:
```
Available shell Releases:
--------------------------------------------------------------------------------
  7.5.4    -> https://github.com/Bearsampp/module-shell/releases/download/2025.11.13/bearsampp-shell-7.5.4-2025.11.13.7z
--------------------------------------------------------------------------------
Total releases: 1
```

---

## Gradle Built-in Tasks

### tasks

Show all available Gradle tasks.

**Syntax**:
```powershell
gradlew tasks
```

**Examples**:
```powershell
# Show all tasks
gradlew tasks

# Show all tasks including hidden ones
gradlew tasks --all
```

---

### help

Display help information for a specific task.

**Syntax**:
```powershell
gradlew help --task <taskName>
```

**Examples**:
```powershell
# Get help for release task
gradlew help --task release
```

---

### properties

Display all project properties.

**Syntax**:
```powershell
gradlew properties
```

**Examples**:
```powershell
# Show all properties
gradlew properties
```

---

## Task Dependencies

### Task Execution Order

When running tasks, Gradle executes them in dependency order:

```
release
├── (no dependencies)
└── Executes: downloadModuleUntouched, processDependencies, createArchive

releaseAll
├── Depends on: release (for each version)
└── Executes: Multiple release tasks sequentially

clean
├── (no dependencies)
└── Executes: Delete build directories

verify
├── (no dependencies)
└── Executes: Environment checks
```

---

## Advanced Usage

### Combining Tasks

Execute multiple tasks in sequence:

```powershell
# Clean, verify, and build
gradlew clean verify release -PbundleVersion=7.5.4

# Validate and build all
gradlew validateProperties releaseAll
```

### Parallel Execution

Enable parallel execution for faster builds:

```powershell
# Already enabled in gradle.properties
# org.gradle.parallel=true
```

### Dry Run

See what tasks would be executed without running them:

```powershell
gradlew release -PbundleVersion=7.5.4 --dry-run
```

### Debug Mode

Run tasks with debug output:

```powershell
gradlew release -PbundleVersion=7.5.4 --debug
```

### Info Mode

Run tasks with info-level logging:

```powershell
gradlew release -PbundleVersion=7.5.4 --info
```

### Stacktrace

Show full stacktrace on errors:

```powershell
gradlew release -PbundleVersion=7.5.4 --stacktrace
```

### Continuous Build

Automatically re-run tasks when files change:

```powershell
gradlew release -PbundleVersion=7.5.4 --continuous
```

### Build Cache

Use build cache for faster builds (already enabled):

```powershell
# Already enabled in gradle.properties
# org.gradle.caching=true
```

### Offline Mode

Build without network access (uses cached dependencies):

```powershell
gradlew release -PbundleVersion=7.5.4 --offline
```

---

## Task Output Examples

### Successful Release Build

```
======================================================================
Building shell 7.5.4 release
======================================================================

Bundle path: E:/Bearsampp-development/module-shell/bin/shell7.5.4

Downloading shell 7.5.4 from modules-untouched...
  Downloading from: https://github.com/Bearsampp/module-shell/releases/download/2025.11.13/bearsampp-shell-7.5.4-2025.11.13.7z
  Destination: bearsampp-shell-7.5.4-2025.11.13.7z
  Progress: 100% - Complete
Extracting bearsampp-shell-7.5.4-2025.11.13.7z...
Verified: Console.exe found

Copying bundle files...

Processing dependencies...

Download ANSICON
  Downloading from: https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip
  Destination: ansi189.zip
  Progress: 100% - Complete
  Extracting to: E:\Temp\bearsampp-build\ansicon-temp
Check ANSICON
Verified: ansicon.exe

Download Clink
  Downloading from: https://github.com/chrisant996/clink/releases/download/v1.5.3/clink-1.5.3.zip
  Destination: clink-1.5.3.zip
  Progress: 100% - Complete
  Extracting to: E:\Temp\bearsampp-build\clink-temp
Check Clink
Verified: clink.bat

Preparing archive...
Compressing shell7.5.4 to bearsampp-shell-7.5.4-2025.11.13.7z...
Using 7-Zip: C:\Program Files\7-Zip\7z.exe
Archive created: C:\Bearsampp-build\tools\shell\2025.11.13\bearsampp-shell-7.5.4-2025.11.13.7z

Generating hash files...
  Created: bearsampp-shell-7.5.4-2025.11.13.7z.md5
  Created: bearsampp-shell-7.5.4-2025.11.13.7z.sha1
  Created: bearsampp-shell-7.5.4-2025.11.13.7z.sha256
  Created: bearsampp-shell-7.5.4-2025.11.13.7z.sha512

======================================================================
[SUCCESS] Release build completed successfully for version 7.5.4
Output directory: C:\Bearsampp-build\tools\shell\2025.11.13
Archive: bearsampp-shell-7.5.4-2025.11.13.7z
======================================================================
```

---

## See Also

- [Main Documentation](README.md)
- [Configuration Guide](CONFIGURATION.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)

---

**Last Updated**: 2024
