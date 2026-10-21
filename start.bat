@echo off
title GemCode Engine
cd /d "%~dp0"
if exist "bin\gemcode-windows-amd64.exe" (
    start "" "bin\gemcode-windows-amd64.exe"
    echo [√] GemCode started silently in background on http://localhost:8081
) else (
    echo [!] Binary not found in bin\. Running install.ps1...
    powershell -ExecutionPolicy Bypass -File install.ps1
)
timeout /t 2 >nul
