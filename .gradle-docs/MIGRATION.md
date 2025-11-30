# Migration Guide: Ant to Gradle

Guide for migrating from Ant-based build to pure Gradle build system.

---

## Table of Contents

- [Overview](#overview)
- [What Changed](#what-changed)
- [Ant to Gradle Command Mapping](#ant-to-gradle-command-mapping)
- [Configuration Migration](#configuration-migration)
- [Build Process Changes](#build-process-changes)
- [Benefits of Migration](#benefits-of-migration)
- [Backward Compatibility](#backward-compatibility)

---

## Overview

The Bearsampp module Shell build system has been migrated from Apache Ant to Gradle, providing a modern, maintainable, and feature-rich build automation solution.

### Migration Summary

| Aspect                | Before (Ant)                    | After (Gradle)                              |
|-----------------------|---------------------------------|---------------------------------------------|
| Build File            | build.xml                       | build.gradle                                |
| Configuration         | build.properties                | build.properties + gradle.properties        |
| Task Execution        | ant {target}                    | gradlew {task}                              |
| Dependencies          | Manual XML configuration        | Groovy-based DSL                            |
| Caching               | Limited                         | Advanced build caching                      |
| Parallel Execution    | Not supported                   | Fully supported                             |
| IDE Integration       | Basic                           | Excellent (IntelliJ, Eclipse, VS Code)      |

---

## What Changed

### Removed Files

The following Ant-related files have been removed:

| File                  | Status    | Reason                                     |
|-----------------------|-----------|--------------------------------------------|
| build.xml             | Removed   | Replaced by build.gradle                   |

### Added Files

New Gradle-related files:

| File                  | Purpose                                                        |
|-----------------------|----------------------------------------------------------------|
| build.gradle          | Main Gradle build script (replaces build.xml)                  |
| settings.gradle       | Gradle project settings                                        |
| gradle.properties     | Gradle runtime configuration                                   |
| gradlew               | Gradle wrapper script (Unix/Linux/Mac)                         |
| gradlew.bat           | Gradle wrapper script (Windows)                                |
| gradle/wrapper/*      | Gradle wrapper files                                           |

### Added Documentation

Comprehensive documentation in `.gradle-docs/`:

| Document                  | Purpose                                                    |
|---------------------------|------------------------------------------------------------|
| README.md                 | Main documentation and getting started guide               |
| TASKS.md                  | Complete task reference                                    |
| CONFIGURATION.md          | Configuration options and settings                         |
| TROUBLESHOOTING.md        | Common issues and solutions                                |
| MIGRATION.md              | This migration guide                                       |
| INDEX.md                  | Documentation index                                        |

### Unchanged Files

These files remain unchanged:

| File                  | Purpose                                                        |
|-----------------------|----------------------------------------------------------------|
| build.properties      | Bundle configuration (same format)                             |
| releases.properties   | Version to URL mappings (same format)                          |
| bin/*/deps.properties | Dependency configuration (same format)                         |

---

## Ant to Gradle Command Mapping

### Build Commands

| Ant Command                           | Gradle Command                                             | Notes                          |
|---------------------------------------|------------------------------------------------------------|--------------------------------|
| `ant release.build`                   | `gradlew release -PbundleVersion=X.X.X.X`                  | Version now specified as parameter |
| `ant clean`                           | `gradlew clean`                                            | Same functionality             |
| N/A                                   | `gradlew releaseAll`                                       | New: Build all versions        |
| N/A                                   | `gradlew verify`                                           | New: Verify environment        |

### Information Commands

| Ant Command                           | Gradle Command                                             | Notes                          |
|---------------------------------------|------------------------------------------------------------|--------------------------------|
| N/A                                   | `gradlew info`                                             | New: Show build information    |
| N/A                                   | `gradlew listVersions`                                     | New: List available versions   |
| N/A                                   | `gradlew listReleases`                                     | New: List releases             |
| N/A                                   | `gradlew tasks`                                            | New: Show all tasks            |

### Verification Commands

| Ant Command                           | Gradle Command                                             | Notes                          |
|---------------------------------------|------------------------------------------------------------|--------------------------------|
| N/A                                   | `gradlew validateProperties`                               | New: Validate configuration    |
| N/A                                   | `gradlew checkDeps`                                        | New: Check dependencies        |

---

## Configuration Migration

### build.properties

**No changes required** - The format remains the same:

```properties
# Before (Ant) - Same format
bundle.name = shell
bundle.release = 2025.11.13
bundle.type = tools
bundle.format = 7z

# After (Gradle) - Same format
bundle.name = shell
bundle.release = 2025.11.13
bundle.type = tools
bundle.format = 7z
```

### New: gradle.properties

Additional Gradle-specific configuration:

```properties
# Gradle runtime configuration
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
```

### releases.properties

**No changes required** - The format remains the same:

```properties
# Before (Ant) - Same format
7.5.4 = https://github.com/Bearsampp/module-shell/releases/download/2025.11.13/bearsampp-shell-7.5.4-2025.11.13.7z

# After (Gradle) - Same format
7.5.4 = https://github.com/Bearsampp/module-shell/releases/download/2025.11.13/bearsampp-shell-7.5.4-2025.11.13.7z
```

### deps.properties

**No changes required** - The format remains the same:

```properties
# Before (Ant) - Same format
ansicon=https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip
clink=https://github.com/chrisant996/clink/releases/download/v1.5.3/clink-1.5.3.zip

# After (Gradle) - Same format
ansicon=https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip
clink=https://github.com/chrisant996/clink/releases/download/v1.5.3/clink-1.5.3.zip
```

---

## Build Process Changes

### Ant Build Process

```xml
<!-- build.xml -->
<project name="module-shell" basedir=".">
  <property file="build.properties"/>
  <import file="${dev.path}/build/build-commons.xml"/>
  <import file="${dev.path}/build/build-bundle.xml"/>
  
  <target name="release.build">
    <!-- Complex XML-based build logic -->
  </target>
</project>
```

**Execution**:
```bash
ant release.build
```

### Gradle Build Process

```groovy
// build.gradle
plugins {
    id 'base'
}

// Load properties
def buildProps = new Properties()
file('build.properties').withInputStream { buildProps.load(it) }

// Define tasks
tasks.register('release') {
    // Groovy-based build logic
}
```

**Execution**:
```powershell
gradlew release -PbundleVersion=7.5.4
```

### Key Differences

| Aspect                    | Ant                                | Gradle                                     |
|---------------------------|------------------------------------|--------------------------------------------|
| Language                  | XML                                | Groovy DSL                                 |
| Configuration             | Verbose XML                        | Concise Groovy                             |
| Task Definition           | XML targets                        | Groovy tasks                               |
| Dependency Management     | Manual                             | Automated                                  |
| Build Logic               | Procedural                         | Declarative + Imperative                   |
| Extensibility             | Limited                            | Highly extensible                          |

---

## Benefits of Migration

### Performance Improvements

| Feature                   | Ant                                | Gradle                                     |
|---------------------------|------------------------------------|--------------------------------------------|
| Build Caching             | Not available                      | Advanced caching (up to 90% faster)        |
| Incremental Builds        | Limited                            | Full support                               |
| Parallel Execution        | Not supported                      | Automatic parallelization                  |
| Daemon Mode               | Not available                      | Persistent JVM (faster startup)            |

### Developer Experience

| Feature                   | Ant                                | Gradle                                     |
|---------------------------|------------------------------------|--------------------------------------------|
| IDE Integration           | Basic                              | Excellent (IntelliJ, Eclipse, VS Code)     |
| Task Discovery            | Manual documentation               | `gradlew tasks`                            |
| Error Messages            | Generic                            | Detailed and actionable                    |
| Documentation             | Limited                            | Comprehensive (.gradle-docs/)              |

### Maintainability

| Feature                   | Ant                                | Gradle                                     |
|---------------------------|------------------------------------|--------------------------------------------|
| Code Readability          | Verbose XML                        | Concise Groovy                             |
| Modularity                | Limited                            | Excellent                                  |
| Testing                   | Difficult                          | Built-in support                           |
| Debugging                 | Limited                            | Excellent (--debug, --stacktrace)          |

### New Features

Features not available in Ant build:

1. **Interactive Mode**: Select version from menu
2. **Build All Versions**: `gradlew releaseAll`
3. **Environment Verification**: `gradlew verify`
4. **Dependency Checking**: `gradlew checkDeps`
5. **Configuration Validation**: `gradlew validateProperties`
6. **Comprehensive Documentation**: `.gradle-docs/` directory
7. **Hash Generation**: Automatic MD5, SHA1, SHA256, SHA512
8. **Build Cache**: Reuse outputs from previous builds
9. **Parallel Execution**: Build faster on multi-core systems
10. **Better Error Handling**: Detailed error messages and stacktraces

---

## Backward Compatibility

### Configuration Files

All existing configuration files remain compatible:

- ✅ `build.properties` - Same format
- ✅ `releases.properties` - Same format
- ✅ `bin/*/deps.properties` - Same format

### Directory Structure

The directory structure remains the same:

```
module-shell/
├── bin/                          # Same
│   └── shell{version}/        # Same
├── build.properties              # Same format
├── releases.properties           # Same format
└── ...
```

### Build Output

Build output remains in the same location:

```
C:/Bearsampp-build/
└── tools/
    └── shell/
        └── 2025.11.13/
            └── bearsampp-shell-{version}-2025.11.13.7z
```

### Archive Format

Archives maintain the same format and structure:

- Same compression format (7z or zip)
- Same internal directory structure
- Same file naming convention
- **New**: Additional hash files (.md5, .sha1, .sha256, .sha512)

---

## Migration Checklist

### For Developers

- [x] Remove Ant build file (build.xml)
- [x] Add Gradle build files (build.gradle, settings.gradle)
- [x] Add Gradle wrapper (gradlew, gradlew.bat, gradle/wrapper/*)
- [x] Add gradle.properties for runtime configuration
- [x] Create comprehensive documentation in .gradle-docs/
- [x] Update README.md with Gradle instructions
- [x] Test all build scenarios
- [x] Verify output compatibility

### For Users

- [ ] Install Java JDK 8+ (if not already installed)
- [ ] Install 7-Zip (if using .7z format)
- [ ] Update build scripts to use Gradle commands
- [ ] Review new documentation in .gradle-docs/
- [ ] Test build with: `gradlew verify`
- [ ] Build a test release: `gradlew release -PbundleVersion=X.X.X.X`

---

## Common Migration Issues

### Issue: "ant command not found" in scripts

**Solution**: Replace `ant` commands with `gradlew`:

```bash
# Before
ant release.build

# After
gradlew release -PbundleVersion=7.5.4
```

### Issue: Missing build.xml

**Solution**: This is expected. The build.xml file has been replaced by build.gradle.

### Issue: Different command syntax

**Solution**: Refer to [Ant to Gradle Command Mapping](#ant-to-gradle-command-mapping) section.

### Issue: Need to specify version

**Solution**: Gradle requires explicit version parameter:

```powershell
# Ant (version from directory context)
ant release.build

# Gradle (explicit version parameter)
gradlew release -PbundleVersion=7.5.4

# Or use interactive mode
gradlew release
```

---

## Getting Help

### Documentation

- [Main Documentation](.gradle-docs/README.md)
- [Tasks Reference](.gradle-docs/TASKS.md)
- [Configuration Guide](.gradle-docs/CONFIGURATION.md)
- [Troubleshooting Guide](.gradle-docs/TROUBLESHOOTING.md)

### Support Channels

| Channel                | URL                                                          |
|------------------------|--------------------------------------------------------------|
| GitHub Issues          | https://github.com/bearsampp/bearsampp/issues                |
| GitHub Discussions     | https://github.com/bearsampp/bearsampp/discussions           |
| Official Website       | https://bearsampp.com                                        |

---

## Rollback (Not Recommended)

If you need to rollback to Ant (not recommended):

1. Restore build.xml from git history:
   ```bash
   git checkout HEAD~1 build.xml
   ```

2. Remove Gradle files (optional):
   ```bash
   rm build.gradle settings.gradle gradle.properties
   rm -rf gradle .gradle
   ```

3. Use Ant commands:
   ```bash
   ant release.build
   ```

**Note**: Rollback is not recommended as the Gradle build provides significant improvements.

---

## Future Enhancements

Planned enhancements for Gradle build:

1. **Automated Testing**: Unit and integration tests
2. **Continuous Integration**: GitHub Actions integration
3. **Release Automation**: Automated GitHub releases
4. **Dependency Updates**: Automated dependency version checks
5. **Multi-Platform Support**: Linux and macOS builds
6. **Docker Support**: Containerized builds
7. **Plugin System**: Extensible build plugins

---

## Feedback

We welcome feedback on the migration:

- **Issues**: Report problems on GitHub
- **Suggestions**: Submit pull requests
- **Questions**: Ask in GitHub Discussions

---

**Migration Date**: 2024
**Gradle Version**: 7.0+
**Build System**: Pure Gradle (Ant-free)
