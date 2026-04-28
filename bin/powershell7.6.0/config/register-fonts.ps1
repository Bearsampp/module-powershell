Add-Type -AssemblyName System.Drawing

$fontsSrc = $args[0]
$fontsDest = $args[1]

if (Test-Path $fontsSrc) {
    if (-not (Test-Path $fontsDest)) {
        try {
            New-Item -ItemType Directory -Path $fontsDest -Force | Out-Null
        } catch {
            Write-Error "Failed to create fonts destination directory"
        }
    }

    $fontFiles = @(Get-ChildItem -Path $fontsSrc -Include *.ttf, *.otf -Recurse)
    if ($fontFiles.Count -eq 0) {
        Write-Warning "No font files found in $fontsSrc"
        exit 0
    }

    # Fast Path: If there's only one font file, we can potentially skip expensive collection loading
    # if we can determine the name simply. But for Nerd Fonts, the file name != family name often.
    
    # Explicitly load and extract font names
    $fc = New-Object System.Drawing.Text.PrivateFontCollection
    foreach ($file in $fontFiles) {
        try {
            $fc.AddFontFile($file.FullName)
        } catch {
            Write-Warning ("Failed to load font file: " + $file.FullName)
        }
    }

    if ($fc.Families.Count -eq 0) {
        foreach ($file in $fontFiles) {
            try {
                $fileBytes = [System.IO.File]::ReadAllBytes($file.FullName)
                $handle = [System.Runtime.InteropServices.GCHandle]::Alloc($fileBytes, 'Pinned')
                $fc.AddMemoryFont($handle.AddrOfPinnedObject(), $fileBytes.Length)
                $handle.Free()
            } catch {}
        }
    }

    if ($fc.Families.Count -eq 0) {
        Write-Warning "No font families found in $fontsSrc"
        exit 0
    }

    $allNames = @($fc.Families | ForEach-Object { $_.Name } | Select-Object -Unique)
    # Prefer Nerd Font Mono (NFM) or Mono variants for console
    $detectedName = $allNames | Where-Object { $_ -match "NFM|NF|Mono" } | Select-Object -First 1
    $fallbackName = $allNames | Select-Object -First 1

    $regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    if (-not (Test-Path $regPath)) {
        New-Item -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion" -Name "Fonts" -Force | Out-Null
    }

    $fontFiles | ForEach-Object {
        $fontFile = $_.FullName
        $destFile = Join-Path $fontsDest $_.Name
        
        $fileFc = New-Object System.Drawing.Text.PrivateFontCollection
        try {
            $fileFc.AddFontFile($fontFile)
            $internalName = $fileFc.Families[0].Name
        } catch {
            $internalName = $null
        }

        if ($internalName) {
            $regValueName = "$internalName (TrueType)"
            $currentRegValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValueName -ErrorAction SilentlyContinue
            
            $needsInstall = $false
            if (-not (Test-Path $destFile)) {
                $needsInstall = $true
            } else {
                $srcFileItem = Get-Item $fontFile
                $destFileItem = Get-Item $destFile
                if ($srcFileItem.Length -ne $destFileItem.Length -or $srcFileItem.LastWriteTime -gt $destFileItem.LastWriteTime) {
                    $needsInstall = $true
                }
            }

            if ($null -eq $currentRegValue -or ($currentRegValue -ne $destFile -and $currentRegValue -ne $_.Name)) {
                $needsInstall = $true
            }

            if ($needsInstall) {
                try {
                    Copy-Item $fontFile $destFile -Force
                    Set-ItemProperty -Path $regPath -Name $regValueName -Value $destFile -Force
                    
                    $signature = @'
[DllImport("gdi32.dll", CharSet = CharSet.Auto)]
public static extern int AddFontResourceEx(string lpszFilename, uint fl, IntPtr res);
'@
                    $gdi32 = Add-Type -MemberDefinition $signature -Name "Gdi32" -Namespace "Win32" -PassThru
                    $gdi32::AddFontResourceEx($destFile, 0, [IntPtr]::Zero) | Out-Null
                } catch {
                    Write-Error "Failed to install font $internalName"
                }
            }
        }
    }
    
    $finalName = if ($detectedName) { $detectedName } else { $fallbackName }
    if ($finalName) {
        # Ensure the font is also registered in Console\TrueTypeFont
        $trueTypeFontKey = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"
        if (-not (Test-Path $trueTypeFontKey)) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console" -Name "TrueTypeFont" -Force | Out-Null
        }
        Set-ItemProperty -Path $trueTypeFontKey -Name "00" -Value $finalName -Force

        $signature = @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);
'@
        try {
            $user32 = Add-Type -MemberDefinition $signature -Name "User32" -Namespace "Win32" -PassThru
            $HWND_BROADCAST = [IntPtr]0xffff
            $WM_SETTINGCHANGE = 0x001A
            $SMTO_ABORTIFHUNG = 0x0002
            $result = [IntPtr]::Zero
            $user32::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, "Fonts", $SMTO_ABORTIFHUNG, 1000, [ref]$result) | Out-Null
        } catch {}

        Write-Output $finalName
    } else {
        Write-Warning "No valid fonts detected in $fontsSrc"
    }
} else {
    Write-Error "Fonts source path does not exist: $fontsSrc"
}

