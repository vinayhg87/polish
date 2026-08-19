@echo off
REM ===========================================================================
REM  Polish - one-time setup
REM  Installs Ollama (signed installer) and downloads the local model.
REM  Run this once. No admin rights required.
REM ===========================================================================
setlocal
echo.
echo === Polish setup ===
echo.

echo [1/2] Installing Ollama (this is a signed Microsoft-store-style install)...
winget install --id Ollama.Ollama -e --accept-source-agreements --accept-package-agreements
echo.

echo [2/2] Downloading the local model (~400 MB, one time)...
echo    - qwen2.5:0.5b  (text rephrasing + summarize: P / C / F / G / S)
set "OLLAMA=%LOCALAPPDATA%\Programs\Ollama\ollama.exe"
if not exist "%OLLAMA%" set "OLLAMA=ollama"
"%OLLAMA%" pull qwen2.5:0.5b

echo.
echo Note: "Fix SQL" (Ctrl+Alt+Q) and the optional cloud toggle use an Ollama
echo Cloud model (gemma4:cloud) - no download needed, but sign in once with:
echo    ollama signin
echo.
echo === Done ===
echo Start it now by double-clicking Start-Polish.bat
echo (or Install-Autostart.bat to have it launch automatically at login).
echo.
pause
