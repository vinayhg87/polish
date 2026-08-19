@echo off
REM ===========================================================================
REM  Polish - run automatically at login.
REM  RECOMMENDED: Right-click this file and select "Run as administrator".
REM  Creates a shortcut in the Startup folder and launches Polish now.
REM ===========================================================================
setlocal
set "SCRIPT=%~dp0Polish.ps1"

powershell -NoProfile -Command ^
  "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([IO.Path]::Combine([Environment]::GetFolderPath('Startup'),'Polish.lnk')); $s.TargetPath='powershell.exe'; $s.Arguments='-NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File \"%SCRIPT%\"'; $s.WorkingDirectory='%~dp0'; $s.WindowStyle=7; $s.Save()"

echo Added Polish to startup (runs hidden at login).
echo Recommended: Ensure Polish is launched with Administrator rights if using elevated SQL tools.
echo Starting it now...
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%SCRIPT%"
echo.
echo To remove later: delete "Polish.lnk" from the folder that opens with:  shell:startup
echo.
pause

