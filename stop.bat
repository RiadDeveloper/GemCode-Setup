@echo off
title Stop GemCode Engine
taskkill /F /IM gemcode-windows-amd64.exe 2>nul
taskkill /F /IM gemcode.exe 2>nul
echo [√] GemCode background service stopped.
timeout /t 2 >nul
