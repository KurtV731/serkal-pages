@echo off
setlocal EnableExtensions

title ELWMS Website Check

rem ============================================================
rem ELWMS WEBSITE CHECK - STARTER
rem
rem Optional:
rem   elwms_website_check.bat "G:\Pfad\zum\Website-Root"
rem
rem Ohne Parameter wird der bekannte SerKal-Pfad verwendet.
rem ============================================================

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%elwms_website_check.ps1"

if not exist "%PS_SCRIPT%" (
    echo.
    echo FEHLER: PowerShell-Modul nicht gefunden:
    echo %PS_SCRIPT%
    echo.
    pause
    exit /b 10
)

if not "%~1"=="" (
    set "WEBSITE_ROOT=%~1"
) else (
    set "WEBSITE_ROOT=G:\Meine Ablage\Serkal_Haupt\webpage\up"
)

if not exist "%WEBSITE_ROOT%\" (
    echo.
    echo FEHLER: Website-Ordner nicht gefunden:
    echo %WEBSITE_ROOT%
    echo.
    echo Du kannst den Ordner auch auf diese BAT-Datei ziehen.
    echo.
    pause
    exit /b 11
)

echo.
echo ============================================================
echo  ELWMS WEBSITE CHECK
echo ============================================================
echo Website-Root: %WEBSITE_ROOT%
echo ============================================================
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass ^
  -File "%PS_SCRIPT%" ^
  -WebsiteRoot "%WEBSITE_ROOT%" ^
  -BaseUrl "https://serkal.de"

set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (
    echo Ergebnis: Keine Fehler oder Warnungen.
) else if "%RC%"=="1" (
    echo Ergebnis: Warnungen gefunden.
) else if "%RC%"=="2" (
    echo Ergebnis: Fehler gefunden.
) else (
    echo Ergebnis: Programmfehler. Rueckgabecode %RC%.
)

echo.
pause
exit /b %RC%
