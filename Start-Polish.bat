@echo off
REM ===========================================================================
REM  Polish - start the hotkey app.
REM  Uses built-in Windows PowerShell (STA, needed for clipboard). No install.
REM  The window is hidden; look for the tray icon near the clock.
REM ===========================================================================
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0Polish.ps1"
