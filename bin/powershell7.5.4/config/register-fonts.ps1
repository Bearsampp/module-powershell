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

    $fontFiles = @(Get-ChildItem -Path $fontsSrc -Include *.ttf, *.otf)
    if ($fontFiles.Count -eq 0) {
        # Silent exit if no fonts found - powershell.bat will use its default FONT_NAME
        exit 0
    }

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
        # Try a different approach if the above failed
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
    
    $detectedName = $allNames | Where-Object { $_ -match "Mono|NFM" } | Select-Object -First 1
    $fallbackName = $allNames | Select-Object -First 1

    $fontFiles | ForEach-Object {
        $fontFile = $_.FullName
        $destFile = Join-Path $fontsDest $_.Name
        
        # We still need the internal name for the registry entry of this specific file
        $fileFc = New-Object System.Drawing.Text.PrivateFontCollection
        try {
            $fileFc.AddFontFile($fontFile)
            $internalName = $fileFc.Families | ForEach-Object { $_.Name } | Select-Object -Last 1
        } catch {
            $internalName = $null
        }

        if ($internalName) {
            if (-not (Test-Path $destFile)) {
                try {
                    Copy-Item $fontFile $fontsDest -Force
                    
                    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
                    $regValue = "$internalName (TrueType)"
                    Set-ItemProperty -Path $regPath -Name $regValue -Value $_.Name -Force
                    
                    # Verification: Ensure it was actually set
                    $verify = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
                    if (-not $verify) {
                        Write-Warning "Registry entry for $internalName could not be verified."
                    }
                } catch {
                    Write-Error "Failed to install font $internalName"
                }
            }
        }
    }
    
    $finalName = if ($detectedName) { $detectedName } else { $fallbackName }
    if ($finalName) {
        Write-Output $finalName
    } else {
        Write-Warning "No valid fonts detected in $fontsSrc"
    }
} else {
    Write-Error "Fonts source path does not exist: $fontsSrc"
}
