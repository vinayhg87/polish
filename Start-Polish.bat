@echo off
REM ===========================================================================
REM  Polish - start the hotkey app.
REM  RECOMMENDED: Right-click this file and select "Run as administrator".
REM  Running as Administrator enables Polish to paste into elevated apps
REM  like SQL Developer, DBeaver, elevated terminals, and enterprise tools.
REM  The window is hidden; look for the teal "P" tray icon near the clock.
REM ===========================================================================
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0Polish.ps1"

