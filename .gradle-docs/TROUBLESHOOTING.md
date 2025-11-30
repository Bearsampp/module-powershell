# Troubleshooting Guide

Common issues and solutions for the Bearsampp module Shell Gradle build system.

---

## Table of Contents

- [Build Environment Issues](#build-environment-issues)
- [Build Execution Issues](#build-execution-issues)
- [Dependency Issues](#dependency-issues)
- [Archive Creation Issues](#archive-creation-issues)
- [Network Issues](#network-issues)
- [Performance Issues](#performance-issues)
- [Platform-Specific Issues](#platform-specific-issues)
- [Getting Help](#getting-help)

---

## Build Environment Issues

### Java Not Found

**Symptoms**:
```
'java' is not recognized as an internal or external command
```

**Cause**: Java is not installed or not in system PATH

**Solutions**:

1. **Install Java JDK 8 or later**:
   - Download from: https://adoptium.net/
   - Install to default location
   - Installer should add to PATH automatically

2. **Verify Java installation**:
   ```powershell
   java -version
   ```

3. **Manually set JAVA_HOME**:
   ```powershell
   setx JAVA_HOME "C:\Program Files\Java\jdk-17"
   setx PATH "%PATH%;%JAVA_HOME%\bin"
   ```

4. **Restart terminal** after setting environment variables

---

### Gradle Wrapper Issues

**Symptoms**:
```
gradlew: command not found
```

**Cause**: Gradle wrapper not executable or missing

**Solutions**:

1. **On Windows, use gradlew.bat**:
   ```powershell
   gradlew.bat tasks
   ```

2. **Check wrapper files exist**:
   ```
   gradle/wrapper/gradle-wrapper.jar
   gradle/wrapper/gradle-wrapper.properties
   gradlew
   gradlew.bat
   ```

3. **Re-download wrapper** if missing:
   ```powershell
   gradle wrapper
   ```

---

### 7-Zip Not Found

**Symptoms**:
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Cause**: 7-Zip not installed or not in expected location

**Solutions**:

1. **Install 7-Zip**:
   - Download from: https://www.7-zip.org/
   - Install to default location: `C:\Program Files\7-Zip\`

2. **Set 7Z_HOME environment variable**:
   ```powershell
   setx 7Z_HOME "C:\Program Files\7-Zip"
   ```

3. **Add 7-Zip to PATH**:
   ```powershell
   setx PATH "%PATH%;C:\Program Files\7-Zip"
   ```

4. **Alternative: Use ZIP format**:
   Edit `build.properties`:
   ```properties
   bundle.format = zip
   ```

5. **Verify 7-Zip installation**:
   ```powershell
   "C:\Program Files\7-Zip\7z.exe"
   ```

---

### Build Properties Not Found

**Symptoms**:
```
build.properties not found at: E:/Bearsampp-development/module-shell/build.properties
```

**Cause**: Missing or misplaced build.properties file

**Solutions**:

1. **Verify file exists**:
   ```powershell
   dir build.properties
   ```

2. **Check current directory**:
   ```powershell
   pwd
   ```
   Should be: `E:/Bearsampp-development/module-shell`

3. **Create build.properties** if missing:
   ```properties
   bundle.name = shell
   bundle.release = 2025.11.13
   bundle.type = tools
   bundle.format = 7z
   ```

---

## Build Execution Issues

### Version Not Found

**Symptoms**:
```
Bundle version not found: shell7.5.4

Available versions:
  (none found)
```

**Cause**: Version directory doesn't exist in bin/ or bin/archived/

**Solutions**:

1. **List available versions**:
   ```powershell
   gradlew listVersions
   ```

2. **Check bin directory structure**:
   ```powershell
   dir bin
   ```
   Should contain: `shell{version}/`

3. **Verify directory naming**:
   - Correct: `shell7.5.4`
   - Incorrect: `shell7.5.4` (case matters)
   - Incorrect: `shell-7.5.4` (no dash)

4. **Create version directory**:
   ```powershell
   mkdir bin\shell7.5.4
   ```

5. **Download version**:
   ```powershell
   gradlew downloadshell -PshellVersion=7.5.4
   ```

---

### Console.exe Not Found

**Symptoms**:
```
Console.exe not found in downloaded module
```

**Cause**: Downloaded module doesn't contain Console.exe

**Solutions**:

1. **Verify releases.properties URL**:
   ```properties
   7.5.4 = https://github.com/Bearsampp/module-shell/releases/download/2025.11.13/bearsampp-shell-7.5.4-2025.11.13.7z
   ```

2. **Check download integrity**:
   - Clear download cache
   - Re-download module

3. **Manual verification**:
   ```powershell
   # Extract archive manually
   7z x bearsampp-shell-7.5.4-2025.11.13.7z
   # Check for Console.exe
   dir Console.exe
   ```

4. **Check extraction path**:
   - Module might be in nested directory
   - Look for `shell{version}/Console.exe`

---

### Permission Denied

**Symptoms**:
```
Access denied
java.io.IOException: Access is denied
```

**Cause**: Insufficient permissions to write to build directory

**Solutions**:

1. **Run as Administrator**:
   - Right-click PowerShell/Command Prompt
   - Select "Run as administrator"

2. **Change build path**:
   Edit `build.properties`:
   ```properties
   build.path = D:/MyBuilds/Bearsampp
   ```

3. **Check directory permissions**:
   ```powershell
   icacls "C:\Bearsampp-build"
   ```

4. **Grant write permissions**:
   ```powershell
   icacls "C:\Bearsampp-build" /grant Users:F
   ```

---

### Out of Memory Error

**Symptoms**:
```
java.lang.OutOfMemoryError: Java heap space
```

**Cause**: Insufficient memory allocated to Gradle

**Solutions**:

1. **Increase heap size**:
   Edit `gradle.properties`:
   ```properties
   org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g
   ```

2. **Close other applications** to free memory

3. **Build one version at a time**:
   ```powershell
   # Instead of releaseAll
   gradlew release -PbundleVersion=7.5.4
   ```

4. **Disable daemon** if memory is very limited:
   ```properties
   org.gradle.daemon=false
   ```

---

## Dependency Issues

### Dependency Download Failed

**Symptoms**:
```
Failed to download from URL
java.net.UnknownHostException
```

**Cause**: Network connectivity or URL issues

**Solutions**:

1. **Check internet connection**:
   ```powershell
   ping github.com
   ping sourceforge.net
   ```

2. **Verify URLs in deps.properties**:
   ```properties
   ansicon=https://github.com/adoxa/ansicon/releases/download/v1.89/ansi189.zip
   ```

3. **Test URL manually**:
   - Open URL in browser
   - Verify file downloads

4. **Check firewall/proxy settings**:
   - Whitelist GitHub and SourceForge
   - Configure proxy in gradle.properties

5. **Use cached downloads**:
   - Downloads are cached in temp directory
   - Check: `%TEMP%\bearsampp-build\downloads`

---

### Dependency Extraction Failed

**Symptoms**:
```
Failed to extract dependency
```

**Cause**: Corrupted download or extraction issues

**Solutions**:

1. **Clear download cache**:
   ```powershell
   rmdir /s "%TEMP%\bearsampp-build"
   ```

2. **Re-download dependency**:
   ```powershell
   gradlew clean release -PbundleVersion=7.5.4
   ```

3. **Verify archive integrity**:
   ```powershell
   7z t downloaded-file.zip
   ```

4. **Check disk space**:
   ```powershell
   wmic logicaldisk get size,freespace,caption
   ```

---

### Dependency Verification Failed

**Symptoms**:
```
ansicon.exe not found after extraction
clink.bat not found after extraction
```

**Cause**: Dependency structure changed or extraction path incorrect

**Solutions**:

1. **Check dependency structure**:
   - Extract archive manually
   - Verify expected files exist

2. **Update deps.properties**:
   - Use correct version URL
   - Verify URL points to expected structure

3. **Check extraction logic**:
   - Review build.gradle dependency processing
   - Verify extraction paths match structure

---

## Archive Creation Issues

### 7z Compression Failed

**Symptoms**:
```
7zip compression failed with exit code: 2
```

**Cause**: 7-Zip error during compression

**Solutions**:

1. **Check 7-Zip installation**:
   ```powershell
   "C:\Program Files\7-Zip\7z.exe"
   ```

2. **Verify source files exist**:
   ```powershell
   dir "%TEMP%\bearsampp-build\prep"
   ```

3. **Check disk space**:
   - Ensure sufficient space for archive
   - Typical archive size: 5-20 MB

4. **Try ZIP format instead**:
   Edit `build.properties`:
   ```properties
   bundle.format = zip
   ```

5. **Run with debug output**:
   ```powershell
   gradlew release -PbundleVersion=7.5.4 --debug
   ```

---

### Hash Generation Failed

**Symptoms**:
```
Failed to generate hash files
```

**Cause**: File access or algorithm issues

**Solutions**:

1. **Verify archive exists**:
   ```powershell
   dir "C:\Bearsampp-build\tools\shell\2025.11.13\*.7z"
   ```

2. **Check file permissions**:
   ```powershell
   icacls "C:\Bearsampp-build\tools\shell\2025.11.13"
   ```

3. **Manually generate hashes**:
   ```powershell
   certutil -hashfile archive.7z MD5
   certutil -hashfile archive.7z SHA1
   certutil -hashfile archive.7z SHA256
   certutil -hashfile archive.7z SHA512
   ```

---

## Network Issues

### Proxy Configuration

**Symptoms**:
```
Connection timed out
Unable to tunnel through proxy
```

**Cause**: Corporate proxy blocking connections

**Solutions**:

1. **Configure HTTP proxy**:
   Edit `gradle.properties`:
   ```properties
   systemProp.http.proxyHost=proxy.company.com
   systemProp.http.proxyPort=8080
   systemProp.http.proxyUser=username
   systemProp.http.proxyPassword=password
   ```

2. **Configure HTTPS proxy**:
   ```properties
   systemProp.https.proxyHost=proxy.company.com
   systemProp.https.proxyPort=8080
   systemProp.https.proxyUser=username
   systemProp.https.proxyPassword=password
   ```

3. **Bypass proxy for local addresses**:
   ```properties
   systemProp.http.nonProxyHosts=localhost|127.0.0.1
   ```

---

### SSL Certificate Issues

**Symptoms**:
```
PKIX path building failed
unable to find valid certification path
```

**Cause**: SSL certificate validation failure

**Solutions**:

1. **Import certificate** (not recommended for production):
   ```powershell
   keytool -import -alias github -file github.cer -keystore "%JAVA_HOME%\lib\security\cacerts"
   ```

2. **Disable SSL verification** (not recommended):
   ```properties
   systemProp.javax.net.ssl.trustAll=true
   ```

3. **Update Java** to latest version with updated certificates

---

### GitHub Rate Limiting

**Symptoms**:
```
API rate limit exceeded
403 Forbidden
```

**Cause**: Too many requests to GitHub API

**Solutions**:

1. **Wait for rate limit reset** (typically 1 hour)

2. **Use authentication token**:
   ```properties
   systemProp.github.token=your_personal_access_token
   ```

3. **Use cached downloads**:
   - Downloads are cached in temp directory
   - Avoid repeated downloads

---

## Performance Issues

### Slow Build Times

**Symptoms**: Build takes longer than expected

**Solutions**:

1. **Enable build cache**:
   ```properties
   org.gradle.caching=true
   ```

2. **Enable parallel execution**:
   ```properties
   org.gradle.parallel=true
   ```

3. **Enable daemon**:
   ```properties
   org.gradle.daemon=true
   ```

4. **Increase memory allocation**:
   ```properties
   org.gradle.jvmargs=-Xmx4g
   ```

5. **Use local build path**:
   - Avoid network drives
   - Use SSD if available

6. **Clean old builds**:
   ```powershell
   gradlew clean
   ```

---

### Slow Downloads

**Symptoms**: Dependency downloads are very slow

**Solutions**:

1. **Check network speed**:
   ```powershell
   speedtest-cli
   ```

2. **Use wired connection** instead of WiFi

3. **Download during off-peak hours**

4. **Use mirror sites** if available

5. **Pre-download dependencies**:
   - Download manually
   - Place in cache directory

---

## Platform-Specific Issues

### Windows-Specific Issues

#### Long Path Issues

**Symptoms**:
```
The filename or extension is too long
```

**Solutions**:

1. **Enable long paths** (Windows 10 1607+):
   ```powershell
   # Run as Administrator
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
   ```

2. **Use shorter build path**:
   ```properties
   build.path = C:/Build
   ```

3. **Move project closer to root**:
   ```
   C:/Projects/module-shell
   ```

---

#### PowerShell Execution Policy

**Symptoms**:
```
gradlew.bat : File cannot be loaded because running scripts is disabled
```

**Solutions**:

1. **Change execution policy**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Use Command Prompt** instead of PowerShell

3. **Run specific script**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File gradlew.bat
   ```

---

#### Antivirus Interference

**Symptoms**: Build randomly fails or is very slow

**Solutions**:

1. **Add exclusions** to antivirus:
   - Project directory
   - Gradle cache directory
   - Build output directory
   - Java installation directory

2. **Temporarily disable** antivirus during build

3. **Use Windows Defender exclusions**:
   ```powershell
   Add-MpPreference -ExclusionPath "E:\Bearsampp-development"
   Add-MpPreference -ExclusionPath "C:\Users\username\.gradle"
   ```

---

## Getting Help

### Diagnostic Information

When reporting issues, include:

1. **Gradle version**:
   ```powershell
   gradlew --version
   ```

2. **Java version**:
   ```powershell
   java -version
   ```

3. **Operating system**:
   ```powershell
   systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
   ```

4. **Build configuration**:
   ```powershell
   type build.properties
   type gradle.properties
   ```

5. **Full error output**:
   ```powershell
   gradlew release -PbundleVersion=7.5.4 --stacktrace > error.log 2>&1
   ```

---

### Debug Mode

Run build with debug output:

```powershell
gradlew release -PbundleVersion=7.5.4 --debug --stacktrace
```

---

### Verify Environment

Check build environment:

```powershell
gradlew verify
```

---

### Clean Build

Try clean build:

```powershell
gradlew clean release -PbundleVersion=7.5.4
```

---

### Support Channels

| Channel                | URL                                                          | Purpose                          |
|------------------------|--------------------------------------------------------------|----------------------------------|
| GitHub Issues          | https://github.com/bearsampp/bearsampp/issues                | Bug reports and feature requests |
| GitHub Discussions     | https://github.com/bearsampp/bearsampp/discussions           | Questions and discussions        |
| Official Website       | https://bearsampp.com                                        | Documentation and downloads      |

---

### Reporting Bugs

When reporting bugs, include:

1. **Clear description** of the issue
2. **Steps to reproduce** the problem
3. **Expected behavior** vs actual behavior
4. **Environment information** (OS, Java, Gradle versions)
5. **Full error output** with stacktrace
6. **Configuration files** (build.properties, gradle.properties)
7. **Build command** used

**Example Bug Report**:

```markdown
## Description
Build fails when trying to create 7z archive

## Steps to Reproduce
1. Run: gradlew release -PbundleVersion=7.5.4
2. Build proceeds normally until archive creation
3. Fails with exit code 2

## Environment
- OS: Windows 10 Pro 21H2
- Java: OpenJDK 17.0.2
- Gradle: 7.6
- 7-Zip: 22.01

## Error Output
```
7zip compression failed with exit code: 2
```

## Configuration
build.properties:
```properties
bundle.name = shell
bundle.release = 2025.11.13
bundle.type = tools
bundle.format = 7z
```
```

---

## Common Error Messages

### Quick Reference

| Error Message                                  | Common Cause                    | Quick Fix                                    |
|------------------------------------------------|---------------------------------|----------------------------------------------|
| `java: command not found`                      | Java not installed              | Install Java JDK 8+                          |
| `7-Zip not found`                              | 7-Zip not installed             | Install 7-Zip or use ZIP format              |
| `build.properties not found`                   | Missing configuration           | Create build.properties file                 |
| `Bundle version not found`                     | Version directory missing       | Check bin/ directory structure               |
| `Console.exe not found`                        | Invalid module download         | Verify releases.properties URL               |
| `Access denied`                                | Permission issues               | Run as Administrator or change build path    |
| `OutOfMemoryError`                             | Insufficient memory             | Increase heap size in gradle.properties      |
| `Connection timed out`                         | Network/proxy issues            | Configure proxy or check connectivity        |
| `7zip compression failed`                      | 7-Zip error                     | Check disk space and 7-Zip installation      |
| `The filename or extension is too long`        | Windows path length limit       | Enable long paths or use shorter paths       |

---

## See Also

- [Main Documentation](README.md)
- [Tasks Reference](TASKS.md)
- [Configuration Guide](CONFIGURATION.md)

---

**Last Updated**: 2024
