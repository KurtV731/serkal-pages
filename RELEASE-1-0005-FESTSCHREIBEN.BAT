@echo off
setlocal EnableExtensions
title SerKal Desktop 1.0005 festschreiben

set "ROOT=C:\serkal-pages"
set "INSTALLER=%ROOT%\up\download\serkal-desktop.exe"
set "CHECKSUM=%ROOT%\up\download\serkal-desktop.sha256"
set "BRANCH=main"
set "VISIBLE_VERSION=1.0005"
set "TECHNICAL_VERSION=1.0.5"
set "SOURCE_COMMIT=150d9ce464176f616cf958e83618a1173568521a"

echo.
echo ============================================================
echo   SerKal Desktop Version 1 - Build 1.0005 festschreiben
echo ============================================================
echo.
echo WICHTIG: Diese Routine baut keine neue EXE.
echo Sie uebernimmt ausschliesslich die bereits gepruefte Datei:
echo "%INSTALLER%"
echo.

if not exist "%ROOT%\.git" goto :no_git
if not exist "%INSTALLER%" goto :no_installer

cd /d "%ROOT%"
if errorlevel 1 goto :cd_error

for /f "delims=" %%B in ('git branch --show-current') do set "CURRENT_BRANCH=%%B"
if /i not "%CURRENT_BRANCH%"=="%BRANCH%" goto :wrong_branch

git lfs version >nul 2>nul
if errorlevel 1 goto :no_lfs

findstr /X /C:"up/download/serkal-desktop.exe filter=lfs diff=lfs merge=lfs -text" ".gitattributes" >nul
if errorlevel 1 goto :lfs_not_configured

echo [1/5] Pruefe, ob der lokale Website-Stand aktuell ist...
git fetch origin "%BRANCH%"
if errorlevel 1 goto :fetch_error

for /f "delims=" %%H in ('git rev-parse HEAD') do set "LOCAL_HEAD=%%H"
for /f "delims=" %%H in ('git rev-parse origin/%BRANCH%') do set "REMOTE_HEAD=%%H"
if /i not "%LOCAL_HEAD%"=="%REMOTE_HEAD%" goto :not_current

set "STATUS_FILE=%TEMP%\serkal_release_status.txt"
git status --porcelain --untracked-files=no -- . ":(exclude)up/download/serkal-desktop.exe" ":(exclude)up/download/serkal-desktop.sha256" > "%STATUS_FILE%"
for %%F in ("%STATUS_FILE%") do if %%~zF GTR 0 goto :other_changes
del /q "%STATUS_FILE%" >nul 2>nul

echo [2/5] Pruefe Groesse und bilde SHA-256...
for %%F in ("%INSTALLER%") do set "INSTALLER_SIZE=%%~zF"
if not defined INSTALLER_SIZE goto :invalid_installer
if %INSTALLER_SIZE% LSS 10000000 goto :invalid_installer

for /f "usebackq delims=" %%H in (`powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath '%INSTALLER%').Hash.ToLowerInvariant()"`) do set "INSTALLER_SHA256=%%H"
if not defined INSTALLER_SHA256 goto :hash_error

> "%CHECKSUM%" echo %INSTALLER_SHA256% *serkal-desktop.exe
if errorlevel 1 goto :hash_write_error

echo Datei:    serkal-desktop.exe
echo Groesse:  %INSTALLER_SIZE% Bytes
echo SHA-256:  %INSTALLER_SHA256%
echo.

echo [3/5] Uebergib die EXE an Git LFS und merke die Pruefsumme vor...
git add -- ".gitattributes" "up/download/serkal-desktop.exe" "up/download/serkal-desktop.sha256"
if errorlevel 1 goto :git_add_error

git diff --cached --quiet
if not errorlevel 1 goto :nothing_changed

echo [4/5] Schreibe den geprueften Release fest...
git commit -m "release: SerKal Desktop Version 1 - Build 1.0005"
if errorlevel 1 goto :commit_error

for /f "usebackq delims=" %%H in (`powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath '%INSTALLER%').Hash.ToLowerInvariant()"`) do set "HASH_AFTER_COMMIT=%%H"
if /i not "%HASH_AFTER_COMMIT%"=="%INSTALLER_SHA256%" goto :hash_changed

echo [5/5] Lade Commit und grosse EXE ueber Git LFS nach GitHub...
git push origin "%BRANCH%"
if errorlevel 1 goto :push_error

echo.
echo ============================================================
echo   RELEASE 1.0005 FESTGESCHRIEBEN
echo ============================================================
echo Oeffentliche Bezeichnung: SerKal Desktop Version 1
echo Sichtbarer Build:         %VISIBLE_VERSION%
echo Technische Version:       %TECHNICAL_VERSION%
echo Quellstand des Builds:    %SOURCE_COMMIT%
echo SHA-256:                  %INSTALLER_SHA256%
echo.
echo Naechster Schritt: PULL-PD.BAT ausfuehren.
echo Noch kein neuer Build und keine andere EXE verwenden.
echo.
pause
exit /b 0

:no_git
echo FEHLER: Git-Repository nicht gefunden: "%ROOT%"
goto :fail
:no_installer
echo FEHLER: Die gepruefte EXE fehlt: "%INSTALLER%"
goto :fail
:cd_error
echo FEHLER: Wechsel nach "%ROOT%" fehlgeschlagen.
goto :fail
:wrong_branch
echo FEHLER: Erwartet wird Branch "%BRANCH%", aktiv ist "%CURRENT_BRANCH%".
goto :fail
:no_lfs
echo FEHLER: Git LFS ist nicht installiert oder nicht erreichbar.
goto :fail
:lfs_not_configured
echo FEHLER: serkal-desktop.exe ist in .gitattributes nicht korrekt fuer Git LFS eingetragen.
goto :fail
:fetch_error
echo FEHLER: Der GitHub-Stand konnte nicht abgefragt werden.
goto :fail
:not_current
echo FEHLER: Der lokale main-Stand entspricht nicht origin/main.
echo Bitte erst die Abweichung klaeren. Die gepruefte EXE wurde nicht veraendert.
goto :fail
:other_changes
echo FEHLER: Es gibt weitere Aenderungen an bereits verwalteten Website-Dateien.
echo Bitte erst klaeren. Die gepruefte EXE wurde nicht veraendert.
del /q "%STATUS_FILE%" >nul 2>nul
goto :fail
:invalid_installer
echo FEHLER: Die EXE ist zu klein, unvollstaendig oder nicht lesbar.
goto :fail
:hash_error
echo FEHLER: Die SHA-256-Pruefsumme konnte nicht berechnet werden.
goto :fail
:hash_write_error
echo FEHLER: Die Pruefsummendatei konnte nicht geschrieben werden.
goto :fail
:git_add_error
echo FEHLER: EXE und Pruefsumme konnten nicht vorgemerkt werden.
goto :fail
:nothing_changed
echo FEHLER: Git erkennt keine neue EXE beziehungsweise keine neue Pruefsumme.
echo Es wurde nichts festgeschrieben.
goto :fail
:commit_error
echo FEHLER: Der Release-Commit konnte nicht erstellt werden.
goto :fail
:hash_changed
echo FEHLER: Die EXE hat sich waehrend des Festschreibens veraendert.
echo Der GitHub-Upload wurde aus Sicherheitsgruenden nicht gestartet.
goto :fail
:push_error
echo FEHLER: Der Push nach GitHub oder der Git-LFS-Upload ist fehlgeschlagen.
goto :fail
:fail
echo.
echo Keine Veroeffentlichung durchgefuehrt.
echo.
pause
exit /b 1
