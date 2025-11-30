# Configuration Guide

Comprehensive guide for configuring the Bearsampp Module ConsoleZ Gradle build system.

---

## Table of Contents

- [Configuration Files](#configuration-files)
- [Build Properties](#build-properties)
- [Gradle Properties](#gradle-properties)
- [Release Properties](#release-properties)
- [Dependency Configuration](#dependency-configuration)
- [Environment Variables](#environment-variables)
- [Advanced Configuration](#advanced-configuration)

---

## Configuration Files

### Overview

The build system uses multiple configuration files:

| File                  | Purpose                                    | Format     | Required |
|-----------------------|--------------------------------------------|------------|----------|
| build.properties      | Bundle configuration                       | Properties | Yes      |
| gradle.properties     | Gradle runtime settings                    | Properties | Yes      |
| releases.properties   | Version to URL mappings                    | Properties | Yes      |
| deps.properties       | Version-specific dependencies              | Properties | No       |
| settings.gradle       | Gradle project settings                    | Groovy     | Yes      |
| build.gradle          | Build script and task definitions          | Groovy     | Yes      |

---

## Build Properties

### File Location

```
module-consolez/build.properties
```

### Configuration Options

#### bundle.name

**Description**: Module name identifier

**Type**: String

**Default**: `consolez`

**Valid Values**: Any non-empty string (lowercase recommended)

**Example**:
```properties
bundle.name = consolez
```

**Usage**: Used in:
- Archive filenames
- Directory structure
- Version identification

---

#### bundle.release

**Description**: Release identifier for versioning

**Type**: String

**Default**: `r1`

**Valid Values**: Any non-empty string (format: r{number})

**Example**:
```properties
bundle.release = r1
bundle.release = r2
bundle.release = r3-beta
```

**Usage**: Used in:
- Archive filenames
- Output directory structure
- Release tracking

---

#### bundle.type

**Description**: Bundle category classification

**Type**: String

**Default**: `tools`

**Valid Values**: 
- `tools` - Utility applications
- `apps` - Full applications
- `libs` - Libraries
- Custom categories

**Example**:
```properties
bundle.type = tools
```

**Usage**: Used in:
- Output directory structure
- Organization of build artifacts

**Directory Structure**:
```
{build.path}/
└── {bundle.type}/
    └── {bundle.name}/
        └── {bundle.release}/
```

---

#### bundle.format

**Description**: Archive compression format

**Type**: String

**Default**: `7z`

**Valid Values**: 
- `7z` - 7-Zip format (requires 7-Zip installed)
- `zip` - ZIP format (uses Ant zip task)

**Example**:
```properties
bundle.format = 7z
```

**Comparison**:

| Format | Compression | Speed  | Compatibility | Requirements |
|--------|-------------|--------|---------------|--------------|
| 7z     | Excellent   | Medium | Good          | 7-Zip        |
| zip    | Good        | Fast   | Excellent     | None         |

---

#### build.path

**Description**: Custom output path for build artifacts

**Type**: String (file path)

**Default**: `C:/Bearsampp-build`

**Valid Values**: Any valid writable directory path

**Example**:
```properties
# Default (commented out)
#build.path = C:/Bearsampp-build

# Custom path
build.path = D:/MyBuilds/Bearsampp

# Relative path (not recommended)
build.path = ../build-output
```

**Notes**:
- Path must be writable
- Directory will be created if it doesn't exist
- Use forward slashes (/) or escaped backslashes (\\\\)

---

### Complete Example

```properties
# Bearsampp Module ConsoleZ - Build Configuration

# Bundle identification
bundle.name = consolez
bundle.release = r1
bundle.type = tools

# Archive format (7z or zip)
bundle.format = 7z

# Build output path (optional)
# Uncomment and modify to use custom path
#build.path = C:/Bearsampp-build

# Alternative paths
#build.path = D:/Builds/Bearsampp
#build.path = E:/Development/bearsampp-output
```

---

## Gradle Properties

### File Location

```
module-consolez/gradle.properties
```

### Configuration Options

#### org.gradle.daemon

**Description**: Enable Gradle daemon for faster builds

**Type**: Boolean

**Default**: `true`

**Valid Values**: `true`, `false`

**Example**:
```properties
org.gradle.daemon=true
```

**Benefits**:
- Faster subsequent builds
- Reduced startup time
- Persistent JVM instance

---

#### org.gradle.parallel

**Description**: Enable parallel task execution

**Type**: Boolean

**Default**: `true`

**Valid Values**: `true`, `false`

**Example**:
```properties
org.gradle.parallel=true
```

**Benefits**:
- Faster multi-task builds
- Better CPU utilization
- Reduced total build time

---

#### org.gradle.caching

**Description**: Enable build caching

**Type**: Boolean

**Default**: `true`

**Valid Values**: `true`, `false`

**Example**:
```properties
org.gradle.caching=true
```

**Benefits**:
- Reuse outputs from previous builds
- Skip unchanged tasks
- Significantly faster incremental builds

---

#### org.gradle.jvmargs

**Description**: JVM arguments for Gradle process

**Type**: String (JVM arguments)

**Default**: `-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError`

**Example**:
```properties
# Default configuration
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError

# Increased memory for large builds
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g -XX:+HeapDumpOnOutOfMemoryError

# Minimal memory for resource-constrained systems
org.gradle.jvmargs=-Xmx1g -XX:MaxMetaspaceSize=256m
```

**Arguments Explained**:

| Argument                        | Purpose                                    |
|---------------------------------|--------------------------------------------|
| -Xmx2g                          | Maximum heap size (2GB)                    |
| -XX:MaxMetaspaceSize=512m       | Maximum metaspace size (512MB)             |
| -XX:+HeapDumpOnOutOfMemoryError | Create heap dump on OOM errors             |

---

#### org.gradle.console

**Description**: Console output mode

**Type**: String

**Default**: `auto`

**Valid Values**: 
- `auto` - Automatically detect console capabilities
- `plain` - Plain text output
- `rich` - Rich console output with colors
- `verbose` - Verbose output

**Example**:
```properties
org.gradle.console=auto
```

---

#### org.gradle.warning.mode

**Description**: Warning display mode

**Type**: String

**Default**: `all`

**Valid Values**: 
- `all` - Show all warnings
- `summary` - Show warning summary
- `none` - Suppress warnings

**Example**:
```properties
org.gradle.warning.mode=all
```

---

#### org.gradle.configureondemand

**Description**: Configure projects on demand

**Type**: Boolean

**Default**: `false`

**Valid Values**: `true`, `false`

**Example**:
```properties
org.gradle.configureondemand=false
```

**Note**: Set to `false` for single-project builds

---

### Complete Example

```properties
# Gradle Build Properties for Bearsampp Module ConsoleZ

# ============================================================================
# GRADLE DAEMON
# ============================================================================
# Enable daemon for faster builds
org.gradle.daemon=true

# ============================================================================
# PARALLEL EXECUTION
# ============================================================================
# Enable parallel task execution
org.gradle.parallel=true

# ============================================================================
# BUILD CACHING
# ============================================================================
# Enable build caching for faster incremental builds
org.gradle.caching=true

# ============================================================================
# JVM SETTINGS
# ============================================================================
# Configure JVM memory and options
# -Xmx: Maximum heap size
# -XX:MaxMetaspaceSize: Maximum metaspace size
# -XX:+HeapDumpOnOutOfMemoryError: Create heap dump on OOM
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError

# ============================================================================
# CONSOLE OUTPUT
# ============================================================================
# Configure console output mode (auto, plain, rich, verbose)
org.gradle.console=auto

# ============================================================================
# WARNING MODE
# ============================================================================
# Show all warnings during build
org.gradle.warning.mode=all

# ============================================================================
# CONFIGURATION ON DEMAND
# ============================================================================
# Disable for single-project builds
org.gradle.configureondemand=false

# ============================================================================
# GRADLE VERSION COMPATIBILITY
# ============================================================================
# This project is compatible with Gradle 7.0+
```

---

## Release Properties

### File Location

```
module-consolez/releases.properties
```

### Format

Maps version identifiers to download URLs:

```properties
{version} = {url}
```

### Configuration

#### Adding New Releases

**Syntax**:
```properties
1.19.0.19104 = https://github.com/Bearsampp/module-consolez/releases/download/r1/bearsampp-consolez-1.19.0.19104-r1.7z
```

**Components**:

| Component | Description                                | Example                          |
|-----------|--------------------------------------------|----------------------------------|
| Version   | ConsoleZ version identifier                | 1.19.0.19104                     |
| URL       | Download URL for the release               | https://github.com/...           |

**Example**:
```properties
# ConsoleZ Releases
1.19.0.19104 = https://github.com/Bearsampp/module-consolez/releases/download/r1/bearsampp-consolez-1.19.0.19104-r1.7z
1.20.0.20000 = https://github.com/Bearsampp/module-consolez/releases/download/r2/bearsampp-consolez-1.20.0.20000-r2.7z
```

---

### URL Patterns

#### GitHub Releases

```properties
{version} = https://github.com/{org}/{repo}/releases/download/{tag}/{filename}
```

**Example**:
```properties
1.19.0.19104 = https://github.com/Bearsampp/module-consolez/releases/download/r1/bearsampp-consolez-1.19.0.19104-r1.7z
```

#### Direct URLs

```properties
{version} = https://example.com/path/to/file.7z
```

---

## Dependency Configuration

### File Location

```
module-consolez/bin/consolez{version}/deps.properties
```

### Format

Maps dependency names to download URLs:

```properties
{dependency_name} = {url}
```

### Supported Dependencies

#### ANSICON

**Purpose**: ANSI color support for Windows console

**Property**: `ansicon`

**Example**:
```properties
ansicon=https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip
```

**Extraction**:
- Extracts `x86/` directory contents
- Copies to `ansicon/` in bundle
- Verifies `ansicon.exe` exists

---

#### Clink

**Purpose**: Command-line editing and completion

**Property**: `clink`

**Example**:
```properties
clink=https://github.com/chrisant996/clink/releases/download/v1.5.3/clink-1.5.3.zip
```

**Extraction**:
- Extracts archive contents
- Copies to `vendor/clink/` in bundle
- Verifies `clink.bat` exists

---

#### Clink Completions

**Purpose**: Additional completion scripts for Clink

**Property**: `clink_completions`

**Example**:
```properties
clink_completions=https://github.com/vladimir-kotikov/clink-completions/archive/refs/tags/0.4.0.zip
```

**Extraction**:
- Extracts archive contents
- Copies to `vendor/clink-completions/` in bundle
- Verifies `.init.lua` exists

---

#### GnuWin32 CoreUtils (Binary)

**Purpose**: Unix-like utilities for Windows

**Property**: `gnuwin32_coreutils_bin`

**Example**:
```properties
gnuwin32_coreutils_bin=https://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-bin.zip
```

**Extraction**:
- Extracts `bin/` directory contents
- Copies to `vendor/gnuwin32/` in bundle
- Verifies `ls.exe` exists

---

#### GnuWin32 CoreUtils (Dependencies)

**Purpose**: Required DLLs for CoreUtils

**Property**: `gnuwin32_coreutils_dep`

**Example**:
```properties
gnuwin32_coreutils_dep=https://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-dep.zip
```

**Extraction**:
- Extracts `bin/` directory contents
- Copies to `vendor/gnuwin32/` in bundle
- Verifies `libintl3.dll` exists

---

### Complete Example

```properties
# ConsoleZ Dependencies Configuration

# ANSICON - ANSI color support
ansicon=https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip

# Clink - Command-line editing and completion
clink=https://github.com/chrisant996/clink/releases/download/v1.5.3/clink-1.5.3.zip

# Clink Completions - Additional completion scripts
clink_completions=https://github.com/vladimir-kotikov/clink-completions/archive/refs/tags/0.4.0.zip

# GnuWin32 CoreUtils - Unix-like utilities
gnuwin32_coreutils_bin=https://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-bin.zip
gnuwin32_coreutils_dep=https://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-dep.zip
```

---

## Environment Variables

### Optional Environment Variables

#### 7Z_HOME

**Description**: Custom 7-Zip installation path

**Type**: Directory path

**Default**: Auto-detected from common locations

**Example**:
```powershell
# Windows
setx 7Z_HOME "C:\Program Files\7-Zip"

# PowerShell
$env:7Z_HOME = "C:\Program Files\7-Zip"
```

**Auto-Detection Order**:
1. `C:\Program Files\7-Zip\7z.exe`
2. `C:\Program Files (x86)\7-Zip\7z.exe`
3. `%7Z_HOME%\7z.exe`
4. System PATH

---

#### JAVA_HOME

**Description**: Java Development Kit installation path

**Type**: Directory path

**Default**: Auto-detected from system

**Example**:
```powershell
# Windows
setx JAVA_HOME "C:\Program Files\Java\jdk-17"

# PowerShell
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
```

---

## Advanced Configuration

### Custom Build Paths

#### Per-User Configuration

Create `gradle.properties` in user home directory:

**Location**: `C:\Users\{username}\.gradle\gradle.properties`

**Example**:
```properties
# User-specific Gradle configuration
org.gradle.jvmargs=-Xmx4g
buildPath=D:/MyBuilds
```

---

### Build Cache Configuration

#### Local Cache

Configured in `settings.gradle`:

```groovy
buildCache {
    local {
        enabled = true
        directory = file("${rootDir}/.gradle/build-cache")
    }
}
```

#### Custom Cache Location

```groovy
buildCache {
    local {
        enabled = true
        directory = file("D:/GradleCache")
    }
}
```

---

### Logging Configuration

#### Log Levels

Set via command line:

```powershell
# Quiet (errors only)
gradlew release -PbundleVersion=1.19.0.19104 --quiet

# Info level
gradlew release -PbundleVersion=1.19.0.19104 --info

# Debug level
gradlew release -PbundleVersion=1.19.0.19104 --debug
```

---

### Network Configuration

#### Proxy Settings

Add to `gradle.properties`:

```properties
# HTTP Proxy
systemProp.http.proxyHost=proxy.example.com
systemProp.http.proxyPort=8080
systemProp.http.proxyUser=username
systemProp.http.proxyPassword=password

# HTTPS Proxy
systemProp.https.proxyHost=proxy.example.com
systemProp.https.proxyPort=8080
systemProp.https.proxyUser=username
systemProp.https.proxyPassword=password
```

---

## Configuration Best Practices

### Security

1. **Never commit sensitive data**:
   - Passwords
   - API keys
   - Personal paths

2. **Use environment variables** for sensitive configuration

3. **Use `.gitignore`** to exclude local configuration:
   ```
   gradle.properties.local
   local.properties
   ```

---

### Performance

1. **Enable daemon**: `org.gradle.daemon=true`
2. **Enable caching**: `org.gradle.caching=true`
3. **Enable parallel execution**: `org.gradle.parallel=true`
4. **Allocate sufficient memory**: `-Xmx2g` or higher

---

### Maintainability

1. **Document custom configurations**
2. **Use comments** in properties files
3. **Keep configuration files organized**
4. **Version control** all non-sensitive configuration

---

## See Also

- [Main Documentation](README.md)
- [Tasks Reference](TASKS.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)

---

**Last Updated**: 2024
