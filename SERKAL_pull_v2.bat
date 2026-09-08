@echo off
setlocal EnableExtensions
title SERKAL - GitHub holen und serkal.de aktualisieren

set "ROOT=C:\serkal-pages"
set "UPLOAD_ROOT=C:\serkal-pages\up"
set "WINSCP_EXE=%ProgramFiles(x86)%\WinSCP\WinSCP.com"
set "REMOTE_DIR=/"
set "WINSCP_SCRIPT=%TEMP%\serkal_pull_upload.txt"
set "WINSCP_LOG=%TEMP%\serkal_pull_upload.log"
set "PUBLISH_EXE=up/download/serkal-desktop.exe"

rem Diese Werte dienen nur dazu, die bereits in WinSCP gespeicherte Sitzung zu finden.
set "WINSCP_HOST=ftp.webspace.bz"
set "WINSCP_USER=kd239663ftp1"
set "WINSCP_SESSION="
set "UNTRACKED_UP="

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

rem Die Installer-EXE darf lokal absichtlich neuer/anders sein.
rem Alle anderen getrackten Website-Aenderungen bleiben ein Sicherheits-Abbruch.
git diff --quiet -- . ":(exclude)%PUBLISH_EXE%"
if errorlevel 1 goto LOCAL_CHANGES

git diff --cached --quiet -- . ":(exclude)%PUBLISH_EXE%"
if errorlevel 1 goto STAGED_CHANGES

rem Ungetrackte Dateien innerhalb von UP wuerden von WinSCP mit hochgeladen.
rem Deshalb dort weiterhin strikt abbrechen. Lokale Werkzeuge ausserhalb von UP stoeren nicht.
for /f "usebackq delims=" %%F in (`git ls-files --others --exclude-standard -- "up/"`) do (
    if not defined UNTRACKED_UP echo Ungetrackt in UP: %%F
    if defined UNTRACKED_UP echo Ungetrackt in UP: %%F
    set "UNTRACKED_UP=1"
)
if defined UNTRACKED_UP goto UNTRACKED_UP_ERROR

rem Nur zur Information: eine lokale Installer-EXE ist erlaubt und bleibt erhalten,
rem solange GitHub beim Pull nicht genau diese Datei ebenfalls aendert.
git diff --quiet -- "%PUBLISH_EXE%"
if errorlevel 1 (
    echo HINWEIS: Lokale serkal-desktop.exe weicht von GitHub ab.
    echo          Das ist als lokales Veroeffentlichungsartefakt erlaubt.
    echo.
)

echo [1/3] Schalte sicher auf main...
echo.
git switch main
if errorlevel 1 goto SWITCH_ERROR

echo.
echo [2/3] Hole aktuellen Stand von GitHub...
echo.
git pull --ff-only origin main
if errorlevel 1 goto PULL_ERROR

echo.
echo GitHub-Stand erfolgreich geholt.
echo.
echo [3/3] Suche gespeicherte WinSCP-Sitzung und synchronisiere UP...
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
echo GitHub-main wurde nach C:\serkal-pages geholt.
echo Der Ordner UP wurde mit serkal.de synchronisiert.
echo.
pause
endlocal
exit /b 0

:NO_GIT
echo FEHLER: C:\serkal-pages ist kein Git-Repository.
goto FEHLER

:NO_UP
echo FEHLER: Website-Ordner C:\serkal-pages\up fehlt.
goto FEHLER

:NO_WINSCP
echo FEHLER: WinSCP.com wurde nicht gefunden.
echo Erwarteter Pfad:
echo "%WINSCP_EXE%"
goto FEHLER

:CD_ERROR
echo FEHLER: Wechsel nach C:\serkal-pages fehlgeschlagen.
goto FEHLER

:LOCAL_CHANGES
echo ABBRUCH: Es gibt lokale, noch nicht committete Website-Aenderungen.
echo.
echo Die lokale up\download\serkal-desktop.exe ist dabei ausdruecklich erlaubt.
echo Andere getrackte Aenderungen muessen zuerst geklaert werden.
echo.
git status --short
goto FEHLER

:STAGED_CHANGES
echo ABBRUCH: Es gibt vorgemerkte, aber noch nicht committete Website-Aenderungen.
echo.
echo Die lokale up\download\serkal-desktop.exe ist dabei ausdruecklich erlaubt.
echo Andere vorgemerkte Aenderungen muessen zuerst geklaert werden.
echo.
git status --short
goto FEHLER

:UNTRACKED_UP_ERROR
echo.
echo ABBRUCH: Im Website-Ordner UP liegen ungetrackte Dateien.
echo Diese wuerden sonst von WinSCP unbemerkt mit veroeffentlicht.
echo Lokale Hilfsdateien ausserhalb von UP sind dagegen erlaubt.
goto FEHLER

:SWITCH_ERROR
echo FEHLER: Wechsel auf Branch main ist fehlgeschlagen.
echo serkal.de wird NICHT veraendert.
goto FEHLER

:PULL_ERROR
echo FEHLER: git pull ist fehlgeschlagen.
echo.
echo Falls Git meldet, dass serkal-desktop.exe ueberschrieben wuerde,
echo wurde auch auf GitHub genau dieses Veroeffentlichungsartefakt geaendert.
echo Dann wird absichtlich NICHT automatisch entschieden, welche EXE gewinnt.
echo serkal.de wird NICHT veraendert.
goto FEHLER

:NO_SAVED_SESSION
echo FEHLER: Keine passende gespeicherte WinSCP-Sitzung gefunden.
echo.
echo Gesucht wurde:
echo   Host:     %WINSCP_HOST%
echo   Benutzer: %WINSCP_USER%
echo.
echo In WinSCP muss die funktionierende Verbindung einmal als Sitzung
echo gespeichert sein. Ein Passwort wird absichtlich NICHT in dieser BAT abgelegt.
echo serkal.de wurde NICHT synchronisiert.
goto FEHLER

:UPLOAD_ERROR
echo FEHLER: Upload zu serkal.de fehlgeschlagen.
echo WinSCP-Log:
echo "%WINSCP_LOG%"
goto FEHLER

:FEHLER
del /q "%WINSCP_SCRIPT%" >nul 2>nul
echo.
echo ============================================================
echo   ABBRUCH - serkal.de wurde nicht weiter synchronisiert
echo ============================================================
echo.
pause
endlocal
exit /b 1
