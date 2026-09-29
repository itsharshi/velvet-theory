@echo off
title NOIR/BLANC - local server
cd /d "%~dp0"

echo.
echo   ==========================================
echo    NOIR/BLANC - starting local server
echo   ==========================================
echo.
echo   Opening the portfolio in your browser...
echo.
echo   Keep this black window OPEN while you browse.
echo   Close it when you're done (or press Ctrl+C).
echo.

rem give the server a moment, then open the browser
start "" /b cmd /c "timeout /t 2 /nobreak >nul & start http://localhost:8765/NOIR-BLANC-PORTFOLIO-FINAL.html"

rem serve this folder; 8765 is unlikely to clash with anything
python -m http.server 8765 --bind 127.0.0.1

rem if python exited immediately something is wrong - keep the window up so the error is readable
if errorlevel 1 (
  echo.
  echo   Server stopped unexpectedly. Error above.
  pause
)
