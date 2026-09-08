@echo off
setlocal EnableExtensions
title SERKAL - GitHub holen und serkal.de aktualisieren

set "ROOT=C:\serkal-pages"
set "UPLOAD_ROOT=C:\serkal-pages\up"
set "INSTALLER=%UPLOAD_ROOT%\download\serkal-desktop.exe"
set "DOWNLOAD_DE=%UPLOAD_ROOT%\download.html"
set "DOWNLOAD_EN=%UPLOAD_ROOT%\download-en.html"
set "WINSCP_EXE=%ProgramFiles(x86)%\WinSCP\WinSCP.com"
set "REMOTE_DIR=/"
set "WINSCP_SCRIPT=%TEMP%\serkal_pull_upload.txt"
set "WINSCP_LOG=%TEMP%\serkal_pull_upload.log"

rem Diese Werte dienen nur dazu, die bereits in WinSCP gespeicherte Sitzung zu finden.
set "WINSCP_HOST=ftp.webspace.bz"
set "WINSCP_USER=kd239663"
set "WINSCP_SESSION="

cls
echo.
echo ============================================================
echo   SERKAL - GitHub ^> lokal ^> serkal.de
echo ============================================================
echo.

if not exist "%ROOT%\.git" goto NO_GIT
if not exist "%UPLOAD_ROOT%" goto NO_UP
if not exist "%WINSCP_EXE%" goto NO_WINSCP

cd /d "%ROOT%"
if errorlevel 1 goto CD_ERROR

rem Die lokale Installer-EXE darf bis zum Public Release bewusst neuer als GitHub sein.
rem Alle anderen lokalen, vorgemerkten oder nicht erfassten Dateien bleiben ein Abbruchgrund.
set "STATUS_FILE=%TEMP%\serkal_git_status.txt"
git status --porcelain --untracked-files=all -- . ":(exclude)up/download/serkal-desktop.exe" > "%STATUS_FILE%"
for %%F in ("%STATUS_FILE%") do if %%~zF GTR 0 goto LOCAL_CHANGES
del /q "%STATUS_FILE%" >nul 2>nul

echo [1/4] Schalte sicher auf main...
echo.
git switch main
if errorlevel 1 goto SWITCH_ERROR

echo.
echo [2/4] Hole aktuellen Stand und grosse Dateien von GitHub...
echo.
git pull --ff-only origin main
if errorlevel 1 goto PULL_ERROR

git lfs version >nul 2>nul
if errorlevel 1 goto NO_LFS

git lfs pull origin main
if errorlevel 1 goto LFS_ERROR

echo.
echo [3/4] Pruefe Installer und Downloadseiten...
echo.
if not exist "%INSTALLER%" goto NO_INSTALLER

for %%F in ("%INSTALLER%") do set "INSTALLER_SIZE=%%~zF"
if not defined INSTALLER_SIZE goto INSTALLER_INVALID
if %INSTALLER_SIZE% LSS 10000000 goto INSTALLER_INVALID

if not exist "%DOWNLOAD_DE%" goto NO_DOWNLOAD_PAGE
if not exist "%DOWNLOAD_EN%" goto NO_DOWNLOAD_PAGE

findstr /C:"/download/serkal-desktop.exe" "%DOWNLOAD_DE%" >nul
if errorlevel 1 goto DOWNLOAD_LINK_ERROR
findstr /C:"/download/serkal-desktop.exe" "%DOWNLOAD_EN%" >nul
if errorlevel 1 goto DOWNLOAD_LINK_ERROR

echo Installer gefunden: "%INSTALLER%"
echo Groesse: %INSTALLER_SIZE% Bytes
echo Downloadseiten verweisen auf serkal-desktop.exe.
echo.

echo [4/4] Suche gespeicherte WinSCP-Sitzung und synchronisiere UP...
echo.

for /f "usebackq delims=" %%S in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$b='HKCU:\Software\Martin Prikryl\WinSCP 2\Sessions'; if(Test-Path $b){foreach($k in (Get-ChildItem $b)){try{$p=Get-ItemProperty $k.PSPath -ErrorAction Stop;if($p.HostName -eq '%WINSCP_HOST%' -and $p.UserName -eq '%WINSCP_USER%'){[Uri]::UnescapeDataString($k.PSChildName);break}}catch{}}}"`) do (
    if not defined WINSCP_SESSION set "WINSCP_SESSION=%%S"
)

if not defined WINSCP_SESSION goto NO_SAVED_SESSION

echo Gefundene WinSCP-Sitzung: "%WINSCP_SESSION%"
echo.

> "%WINSCP_SCRIPT%" echo open "%WINSCP_SESSION%"
>>"%WINSCP_SCRIPT%" echo option batch abort
>>"%WINSCP_SCRIPT%" echo option confirm off
>>"%WINSCP_SCRIPT%" echo synchronize remote "%UPLOAD_ROOT%" "%REMOTE_DIR%"
>>"%WINSCP_SCRIPT%" echo exit

"%WINSCP_EXE%" /script="%WINSCP_SCRIPT%" /log="%WINSCP_LOG%"
if errorlevel 1 goto UPLOAD_ERROR

del /q "%WINSCP_SCRIPT%" >nul 2>nul

echo.
echo ============================================================
echo   FERTIG
echo ============================================================
echo.
echo Website und SerKal-Installer wurden auf serkal.de uebertragen.
echo Die Downloadseite wird jetzt im Browser geoeffnet.
echo.
start "" "https://serkal.de/download.html"
goto SUCCESS

:NO_GIT
echo FEHLER: Git-Repository nicht gefunden:
echo "%ROOT%"
goto FAIL

:NO_UP
echo FEHLER: Website-Ordner nicht gefunden:
echo "%UPLOAD_ROOT%"
goto FAIL

:NO_WINSCP
echo FEHLER: WinSCP.com wurde nicht gefunden:
echo "%WINSCP_EXE%"
goto FAIL

:CD_ERROR
echo FEHLER: Wechsel in "%ROOT%" ist fehlgeschlagen.
goto FAIL

:LOCAL_CHANGES
echo FEHLER: Im Website-Repository liegen lokale Aenderungen ausserhalb
echo der ausdruecklich erlaubten Datei up\download\serkal-desktop.exe.
echo Bitte erst klaeren, bevor etwas veroeffentlicht wird.
del /q "%STATUS_FILE%" >nul 2>nul
goto FAIL

:SWITCH_ERROR
echo FEHLER: Der Wechsel auf den Branch main ist fehlgeschlagen.
goto FAIL

:PULL_ERROR
echo FEHLER: GitHub konnte nicht sauber mit main aktualisiert werden.
goto FAIL

:NO_LFS
echo FEHLER: Git LFS ist auf diesem Rechner nicht installiert oder nicht erreichbar.
goto FAIL

:LFS_ERROR
echo FEHLER: Die grosse SerKal-EXE konnte nicht ueber Git LFS geladen werden.
goto FAIL

:NO_INSTALLER
echo FEHLER: Der freigegebene Installer fehlt:
echo "%INSTALLER%"
goto FAIL

:INSTALLER_INVALID
echo FEHLER: serkal-desktop.exe ist zu klein oder unvollstaendig.
echo Vermutlich wurde nur der Git-LFS-Zeiger statt der EXE geladen.
goto FAIL

:NO_DOWNLOAD_PAGE
echo FEHLER: Mindestens eine Downloadseite fehlt.
goto FAIL

:DOWNLOAD_LINK_ERROR
echo FEHLER: Die Downloadseiten zeigen noch nicht beide auf:
echo /download/serkal-desktop.exe
goto FAIL

:NO_SAVED_SESSION
echo FEHLER: Keine passende gespeicherte WinSCP-Sitzung gefunden.
echo Gesucht wurden Host "%WINSCP_HOST%" und Benutzer "%WINSCP_USER%".
goto FAIL

:UPLOAD_ERROR
echo FEHLER: Der Upload zu serkal.de ist fehlgeschlagen.
echo Das WinSCP-Protokoll liegt hier:
echo "%WINSCP_LOG%"
del /q "%WINSCP_SCRIPT%" >nul 2>nul
goto FAIL

:FAIL
echo.
echo Es wurde nicht erfolgreich veroeffentlicht.
echo.
pause
exit /b 1

:SUCCESS
echo.
pause
exit /b 0
