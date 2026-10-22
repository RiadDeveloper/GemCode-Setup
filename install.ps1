# GemCode Universal 1-Click Windows Installer
# Author: Riad Developer (https://github.com/RiadDeveloper)
$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "           🚀  GemCode AI Engine Setup                    " -ForegroundColor Green
Write-Host "     Supercharged Free Claude Code for Everyone           " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$InstallDir = "$env:LOCALAPPDATA\GemCode\bin"
$ExePath = "$InstallDir\gemcode.exe"
$ClaudeDir = "$HOME\.claude"
$SettingsPath = "$ClaudeDir\settings.json"

# 1. Prepare Target Directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}
if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
}

# 2. Stop any old running instance
Stop-Process -Name "gemcode" -ErrorAction SilentlyContinue

# 3. Retrieve Native Binary
$Version = "2.0.0"
if (Test-Path "$PSScriptRoot\VERSION") {
    $Version = (Get-Content "$PSScriptRoot\VERSION" -Raw).Trim()
}

$LocalBinary = Get-ChildItem "$PSScriptRoot\bin\gemcode-windows-amd64-*.exe" -ErrorAction SilentlyContinue | Select-Object -Last 1
$DownloadUrl = "https://raw.githubusercontent.com/RiadDeveloper/GemCode-Setup/main/bin/gemcode-windows-amd64-v$Version.exe"

if ($LocalBinary -and (Test-Path $LocalBinary.FullName)) {
    Copy-Item -Path $LocalBinary.FullName -Destination $ExePath -Force
    Write-Host "[√] Deployed local GemCode engine ($($LocalBinary.Name))" -ForegroundColor Green
} else {
    Write-Host "[*] Downloading GemCode native engine v$Version..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ExePath -UseBasicParsing
    Write-Host "[√] Downloaded and installed GemCode engine" -ForegroundColor Green
}

# 4. Configure Windows Auto-Start on Boot (Silent Background Service)
$VbsPath = "$InstallDir\run-hidden.vbs"
Set-Content -Path $VbsPath -Value 'CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False' -Encoding ASCII
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $RegPath -Name "GemCodeEngine" -Value "wscript.exe `"$VbsPath`" `"$ExePath`""
Write-Host "[√] Configured Windows Auto-Start on Boot (Runs invisibly in background)" -ForegroundColor Green

# 5. Start the engine right now silently
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$VbsPath`" `"$ExePath`""
Write-Host "[√] GemCode background engine is actively running on http://localhost:8081" -ForegroundColor Green

# 5. Configure ~/.claude/settings.json
$ClaudeSettings = @{
    "env" = @{
        "ANTHROPIC_BASE_URL" = "http://localhost:8081"
        "ANTHROPIC_AUTH_TOKEN" = "gemcode"
        "ANTHROPIC_MODEL" = "claude-3-5-sonnet-20241022"
        "DISABLE_AUTOUPDATER" = "1"
    }
    "theme" = "dark"
}
$ClaudeSettings | ConvertTo-Json -Depth 5 | Set-Content -Path $SettingsPath -Encoding UTF8
Write-Host "[√] Configured Claude Code settings (Auto-mapped to GemCode)" -ForegroundColor Green

# 6. Ensure Claude Code CLI is ready
$LocalBin = "$HOME\.local\bin"
if ($env:Path -notlike "*$LocalBin*") {
    $env:Path += ";$LocalBin"
    [Environment]::SetEnvironmentVariable(
        "Path",
        ([Environment]::GetEnvironmentVariable("Path", "User") -replace ';*$', '') + ";$LocalBin",
        "User"
    )
}

if (-not (Get-Command "claude" -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Installing official Claude Code CLI..." -ForegroundColor Yellow
    irm https://claude.ai/install.ps1 | iex
}

# 7. Start Engine in background
Start-Process -FilePath $ExePath -WindowStyle Hidden
Write-Host "[√] GemCode Engine active & listening on http://localhost:8081" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  🎉 SUCCESS! GemCode is ready to use!                   " -ForegroundColor Green
Write-Host "  👉 Just open any terminal and type: claude             " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
