$ErrorActionPreference = "Stop"

$url = "https://github.com/abduilhameed1206-tech/vxTweeks/releases/download/v1.0/vxTweeks.exe"
$temp = "$env:TEMP\vxTweeks.exe"

Write-Host "Downloading VX TWEeks..." -ForegroundColor Cyan

Invoke-WebRequest `
    -Uri $url `
    -OutFile $temp

if (!(Test-Path $temp)) {
    Write-Host "Failed to download VX TWEeks." -ForegroundColor Red
    exit 1
}

Write-Host "Download completed." -ForegroundColor Green

# إزالة Mark of the Web
Unblock-File -Path $temp -ErrorAction SilentlyContinue

Write-Host "Starting VX TWEeks as Administrator..." -ForegroundColor Cyan

Start-Process `
    -FilePath $temp `
    -Verb RunAs