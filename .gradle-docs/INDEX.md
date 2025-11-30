# Bearsampp Module ConsoleZ - Documentation Index

Welcome to the Bearsampp Module ConsoleZ Gradle build documentation.

---

## Documentation Structure

This directory contains comprehensive documentation for building and maintaining the ConsoleZ module using Gradle.

### Available Documents

| Document                                              | Description                                                    |
|-------------------------------------------------------|----------------------------------------------------------------|
| [README.md](README.md)                                | Main documentation, getting started guide, and overview        |
| [TASKS.md](TASKS.md)                                  | Complete reference for all available Gradle tasks              |
| [CONFIGURATION.md](CONFIGURATION.md)                  | Detailed configuration options and settings                    |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md)              | Common issues, solutions, and debugging tips                   |
| [MIGRATION.md](MIGRATION.md)                          | Migration guide from Ant to Gradle build system                |

---

## Quick Navigation

### Getting Started

- [Prerequisites](README.md#prerequisites)
- [Quick Start](README.md#quick-start)
- [Build Configuration](README.md#build-configuration)

### Building

- [Build Tasks](TASKS.md#build-tasks)
- [Build Process](README.md#build-process)
- [Build Examples](README.md#examples)

### Configuration

- [Build Properties](CONFIGURATION.md#build-properties)
- [Gradle Properties](CONFIGURATION.md#gradle-properties)
- [Release Properties](CONFIGURATION.md#release-properties)
- [Dependency Configuration](CONFIGURATION.md#dependency-configuration)

### Tasks Reference

- [Build Tasks](TASKS.md#build-tasks)
- [Verification Tasks](TASKS.md#verification-tasks)
- [Information Tasks](TASKS.md#information-tasks)
- [Advanced Usage](TASKS.md#advanced-usage)

### Troubleshooting

- [Build Environment Issues](TROUBLESHOOTING.md#build-environment-issues)
- [Build Execution Issues](TROUBLESHOOTING.md#build-execution-issues)
- [Dependency Issues](TROUBLESHOOTING.md#dependency-issues)
- [Archive Creation Issues](TROUBLESHOOTING.md#archive-creation-issues)
- [Network Issues](TROUBLESHOOTING.md#network-issues)

---

## Common Tasks

### Build a Release

```powershell
# Build specific version
gradlew release -PbundleVersion=1.19.0.19104

# Build all versions
gradlew releaseAll
```

**Documentation**: [Build Tasks](TASKS.md#build-tasks)

---

### Verify Environment

```powershell
# Check build environment
gradlew verify
```

**Documentation**: [Verification Tasks](TASKS.md#verification-tasks)

---

### List Available Versions

```powershell
# List versions in bin/ directory
gradlew listVersions

# List releases from releases.properties
gradlew listReleases
```

**Documentation**: [Information Tasks](TASKS.md#information-tasks)

---

### Configure Build

Edit configuration files:

- `build.properties` - Bundle configuration
- `gradle.properties` - Gradle runtime settings
- `releases.properties` - Version mappings

**Documentation**: [Configuration Guide](CONFIGURATION.md)

---

### Troubleshoot Issues

Common issues and solutions:

- [7-Zip Not Found](TROUBLESHOOTING.md#7-zip-not-found)
- [Version Not Found](TROUBLESHOOTING.md#version-not-found)
- [Permission Denied](TROUBLESHOOTING.md#permission-denied)
- [Out of Memory Error](TROUBLESHOOTING.md#out-of-memory-error)

**Documentation**: [Troubleshooting Guide](TROUBLESHOOTING.md)

---

## Document Summaries

### README.md

**Purpose**: Main entry point for documentation

**Contents**:
- Project overview and features
- Prerequisites and environment setup
- Quick start guide
- Build configuration
- Available tasks summary
- Build process explanation
- Directory structure
- Dependencies information
- Troubleshooting basics
- Contributing guidelines

**Target Audience**: All users, especially newcomers

---

### TASKS.md

**Purpose**: Complete reference for all Gradle tasks

**Contents**:
- Build tasks (release, releaseAll, clean, downloadConsoleZ)
- Verification tasks (verify, validateProperties, checkDeps)
- Information tasks (info, listVersions, listReleases)
- Gradle built-in tasks
- Task dependencies
- Advanced usage examples
- Task output examples

**Target Audience**: Users who need detailed task information

---

### CONFIGURATION.md

**Purpose**: Comprehensive configuration guide

**Contents**:
- Configuration files overview
- Build properties (bundle.name, bundle.release, bundle.type, bundle.format, build.path)
- Gradle properties (daemon, parallel, caching, JVM args)
- Release properties (version mappings)
- Dependency configuration (ANSICON, Clink, GnuWin32)
- Environment variables
- Advanced configuration options
- Configuration best practices

**Target Audience**: Users who need to customize the build

---

### TROUBLESHOOTING.md

**Purpose**: Solutions for common problems

**Contents**:
- Build environment issues
- Build execution issues
- Dependency issues
- Archive creation issues
- Network issues
- Performance issues
- Platform-specific issues
- Getting help resources
- Diagnostic information
- Common error messages reference

**Target Audience**: Users experiencing build problems

---

## Documentation Standards

### Formatting

All documentation follows these standards:

1. **Markdown Format**: All files use GitHub-flavored Markdown
2. **Table Alignment**: All tables have properly aligned columns
3. **Code Blocks**: All code examples use appropriate syntax highlighting
4. **Consistent Structure**: All documents follow similar organization
5. **Cross-References**: Documents link to related sections

### Tables

Tables are formatted with aligned columns:

```markdown
| Column 1      | Column 2    | Column 3                                   |
|---------------|-------------|--------------------------------------------|
| Value 1       | Value 2     | Value 3                                    |
| Longer value  | Short       | Another value with more text               |
```

### Code Examples

Code examples include:
- Language identifier for syntax highlighting
- Comments explaining complex operations
- Complete, runnable examples
- Expected output when relevant

### Links

- **Internal Links**: Use relative paths within documentation
- **External Links**: Use full URLs
- **Anchor Links**: Use for navigation within documents

---

## Maintenance

### Updating Documentation

When updating documentation:

1. **Keep Consistent**: Maintain formatting and structure
2. **Update All References**: Check cross-references when changing content
3. **Test Examples**: Verify all code examples work
4. **Update Dates**: Update "Last Updated" dates
5. **Review Tables**: Ensure table columns remain aligned

### Version Information

- **Last Updated**: 2024
- **Gradle Version**: 7.0+
- **Build System**: Pure Gradle (Ant-free)

---

## Additional Resources

### External Links

| Resource                      | URL                                                          |
|-------------------------------|--------------------------------------------------------------|
| Bearsampp Official Website    | https://bearsampp.com                                        |
| ConsoleZ Module Page          | https://bearsampp.com/module/consolez                        |
| GitHub Repository             | https://github.com/bearsampp/module-consolez                 |
| Bearsampp Main Project        | https://github.com/bearsampp/bearsampp                       |
| Issue Tracker                 | https://github.com/bearsampp/bearsampp/issues                |
| Gradle Documentation          | https://docs.gradle.org                                      |
| Java Downloads                | https://adoptium.net                                         |
| 7-Zip Downloads               | https://www.7-zip.org                                        |

---

## Contributing to Documentation

### Guidelines

1. **Clarity**: Write clear, concise explanations
2. **Examples**: Include practical examples
3. **Accuracy**: Verify all technical information
4. **Completeness**: Cover all relevant aspects
5. **Formatting**: Follow documentation standards

### Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make documentation changes
4. Test all examples
5. Submit pull request

---

## Feedback

We welcome feedback on documentation:

- **Issues**: Report documentation issues on GitHub
- **Suggestions**: Suggest improvements via pull requests
- **Questions**: Ask questions in GitHub Discussions

---

**Last Updated**: 2024
**Documentation Version**: 1.0
**Build System**: Pure Gradle
