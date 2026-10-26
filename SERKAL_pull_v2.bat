@echo off
setlocal EnableExtensions
title SERKAL - Weiterleitung zum aktuellen Website-Werkzeug

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "CURRENT=%ROOT%\PULL-PD.BAT"

echo.
echo ============================================================
echo   SERKAL_pull_v2.bat ist nur noch ein alter Dateiname
echo ============================================================
echo.
echo Das aktuelle Werkzeug wird gestartet:
echo "%CURRENT%"
echo.

if not exist "%CURRENT%" (
  echo FEHLER: PULL-PD.BAT wurde nicht gefunden.
  echo Erwarteter Ordner: "%ROOT%"
  pause
  exit /b 1
)

call "%CURRENT%"
exit /b %ERRORLEVEL%
