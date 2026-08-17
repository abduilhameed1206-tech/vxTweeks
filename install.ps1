Clear-Host
$ErrorActionPreference = "Stop"

# ============================================================
# VX TWEeks - Launcher
# ============================================================

$banner = @'
____   ________  ___ ___________  __      __  __      _________________  __.
\   \ /   /\   \/  / \__    ___/ /  \    /  \/  \    /  \_   _____/    |/ _|
 \   Y   /  \     /    |    |    \   \/\/   /\   \/\/   /|    __)_|      <  
  \     /   /     \    |    |     \        /  \        / |        \    |  \ 
   \___/   /___/\  \   |____|      \__/\  /    \__/\  / /_______  /____|__ \
                 \_/                    \/          \/          \/        \/

             Windows Optimization & Performance Suite
                          Created By VXOZN
'@

# ============================================================
# Colors
# ============================================================

$Purple = "Magenta"
$Cyan   = "Cyan"
$Green  = "Green"
$Red    = "Red"
$Gray   = "DarkGray"

# ============================================================
# Display Banner
# ============================================================

Write-Host ""
Write-Host $banner -ForegroundColor $Purple
Write-Host ""

Write-Host "============================================================" -ForegroundColor $Purple
Write-Host "                    VX TWEeks Launcher" -ForegroundColor $Purple
Write-Host "============================================================" -ForegroundColor $Purple
Write-Host ""

# ============================================================
# Download Settings
# ============================================================

$url = "https://github.com/abduilhameed1206-tech/vxTweeks/releases/download/v1.0/vxTweeks.exe"
$temp = Join-Path $env:TEMP "vxTweeks.exe"

# ============================================================
# Remove Previous File
# ============================================================

if (Test-Path $temp) {
    try {
        Remove-Item $temp -Force -ErrorAction SilentlyContinue
    }
    catch {
        # Ignore old file removal errors
    }
}

# ============================================================
# Download
# ============================================================

Write-Host "Downloading VX TWEeks..." -ForegroundColor $Cyan
Write-Host ""

try {

    $request = [System.Net.HttpWebRequest]::Create($url)

    $request.Method = "GET"
    $request.UserAgent = "VX-TWEeks-Launcher"

    $response = $request.GetResponse()

    $totalBytes = $response.ContentLength

    $stream = $response.GetResponseStream()

    $fileStream = New-Object System.IO.FileStream(
        $temp,
        [System.IO.FileMode]::Create
    )

    $buffer = New-Object byte[] 8192

    $downloadedBytes = 0

    $lastTime = Get-Date
    $lastBytes = 0
    $speedText = "Calculating..."

    while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {

        $fileStream.Write($buffer, 0, $read)

        $downloadedBytes += $read

        # ----------------------------------------------------
        # Calculate Percentage
        # ----------------------------------------------------

        if ($totalBytes -gt 0) {

            $percent = [math]::Round(
                ($downloadedBytes / $totalBytes) * 100
            )

        }
        else {

            $percent = 0

        }

        # ----------------------------------------------------
        # Calculate Download Speed
        # ----------------------------------------------------

        $now = Get-Date

        $elapsed = ($now - $lastTime).TotalSeconds

        if ($elapsed -ge 0.5) {

            $speed = ($downloadedBytes - $lastBytes) / $elapsed

            if ($speed -ge 1MB) {

                $speedText = "{0:N2} MB/s" -f ($speed / 1MB)

            }
            elseif ($speed -ge 1KB) {

                $speedText = "{0:N2} KB/s" -f ($speed / 1KB)

            }
            else {

                $speedText = "{0:N0} B/s" -f $speed

            }

            $lastTime = $now
            $lastBytes = $downloadedBytes
        }

        # ----------------------------------------------------
        # File Size
        # ----------------------------------------------------

        if ($downloadedBytes -ge 1MB) {

            $downloadedText = "{0:N2} MB" -f (
                $downloadedBytes / 1MB
            )

        }
        else {

            $downloadedText = "{0:N0} KB" -f (
                $downloadedBytes / 1KB
            )

        }

        if ($totalBytes -gt 0) {

            $totalText = "{0:N2} MB" -f (
                $totalBytes / 1MB
            )

            # ------------------------------------------------
            # Progress Bar
            # ------------------------------------------------

            $barWidth = 40

            $filled = [math]::Floor(
                ($percent / 100) * $barWidth
            )

            $empty = $barWidth - $filled

            $bar = ("#" * $filled) + ("-" * $empty)

            $line = "  [$bar] $percent% | $downloadedText / $totalText | $speedText"

            Write-Host "`r$line" `
                -NoNewline `
                -ForegroundColor $Purple
        }
    }

    $fileStream.Close()
    $stream.Close()
    $response.Close()

    Write-Host ""
    Write-Host ""

    Write-Host "Download completed successfully." `
        -ForegroundColor $Green
}
catch {

    Write-Host ""
    Write-Host ""

    Write-Host "Download failed." `
        -ForegroundColor $Red

    Write-Host ""
    Write-Host "Error:" -ForegroundColor $Red
    Write-Host $_.Exception.Message -ForegroundColor $Gray
    Write-Host ""

    if (Test-Path $temp) {

        Remove-Item $temp `
            -Force `
            -ErrorAction SilentlyContinue
    }

    exit 1
}

# ============================================================
# Verify Download
# ============================================================

if (!(Test-Path $temp)) {

    Write-Host ""
    Write-Host "Downloaded file was not found." `
        -ForegroundColor $Red

    exit 1
}

# ============================================================
# Remove Mark of the Web
# ============================================================

try {

    Unblock-File `
        -Path $temp `
        -ErrorAction SilentlyContinue
}
catch {
    # Ignore unblock errors
}

# ============================================================
# Starting VX TWEeks
# ============================================================

Write-Host ""

Write-Host "============================================================" `
    -ForegroundColor $Purple

Write-Host "                 Starting VX TWEeks..." `
    -ForegroundColor $Purple

Write-Host "============================================================" `
    -ForegroundColor $Purple

Write-Host ""

Start-Sleep -Milliseconds 800

# ============================================================
# Launch As Administrator
# ============================================================

try {

    Start-Process `
        -FilePath $temp `
        -Verb RunAs

    Write-Host ""
    Write-Host "VX TWEeks started successfully." `
        -ForegroundColor $Green

}
catch {

    Write-Host ""
    Write-Host "Failed to start VX TWEeks." `
        -ForegroundColor $Red

    Write-Host ""
    Write-Host $_.Exception.Message `
        -ForegroundColor $Gray

    exit 1
}

Write-Host ""
Write-Host "Thank you for using VX TWEeks." `
    -ForegroundColor $Gray

Write-Host ""