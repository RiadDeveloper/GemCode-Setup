@echo off
title GemCode Engine
cd /d "%~dp0"

for %%F in ("bin\gemcode-windows-amd64-*.exe") do (
    start "" "%%~fF"
    echo [√] GemCode started silently in background on http://localhost:8081 [%%~nxF]
    timeout /t 2 >nul
    exit /b 0
)

echo [!] Binary not found in bin\. Running install.ps1...
powershell -ExecutionPolicy Bypass -File install.ps1
timeout /t 2 >nul
