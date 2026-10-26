@echo off
setlocal EnableExtensions
title SERKAL - Nur Website hochladen

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "UPLOAD_ROOT=%ROOT%\up"
set "WINSCP_EXE=%ProgramFiles(x86)%\WinSCP\WinSCP.com"
set "REMOTE_DIR=/"
set "WINSCP_SCRIPT=%TEMP%\serkal_nur_website_upload.txt"
set "WINSCP_LOG=%TEMP%\serkal_nur_website_upload.log"
set "WINSCP_HOST=ftp.webspace.bz"
set "WINSCP_USER=kd239663"
set "WINSCP_SESSION="

cls
echo.
echo ============================================================
echo   SERKAL - NUR WEBSITE HOCHLADEN
echo ============================================================
echo.
echo Quelle: "%UPLOAD_ROOT%"
echo Kein Git-Pull. Installer und Programmpakete bleiben unberuehrt.
echo.

if not exist "%ROOT%\.git" goto NO_GIT
if not exist "%UPLOAD_ROOT%" goto NO_UP
if not exist "%WINSCP_EXE%" goto NO_WINSCP

cd /d "%ROOT%"
if errorlevel 1 goto CD_ERROR

set "STATUS_FILE=%TEMP%\serkal_website_only_status.txt"
git status --porcelain --untracked-files=all -- "up/" > "%STATUS_FILE%"
for %%F in ("%STATUS_FILE%") do if %%~zF GTR 0 goto LOCAL_CHANGES
del /q "%STATUS_FILE%" >nul 2>nul

for /f "usebackq delims=" %%S in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$b='HKCU:\Software\Martin Prikryl\WinSCP 2\Sessions'; if(Test-Path $b){foreach($k in (Get-ChildItem $b)){try{$p=Get-ItemProperty $k.PSPath -ErrorAction Stop;if($p.HostName -eq '%WINSCP_HOST%' -and $p.UserName -eq '%WINSCP_USER%'){[Uri]::UnescapeDataString($k.PSChildName);break}}catch{}}}"`) do if not defined WINSCP_SESSION set "WINSCP_SESSION=%%S"
if not defined WINSCP_SESSION goto NO_SAVED_SESSION

> "%WINSCP_SCRIPT%" echo open "%WINSCP_SESSION%"
>>"%WINSCP_SCRIPT%" echo option batch abort
>>"%WINSCP_SCRIPT%" echo option confirm off
>>"%WINSCP_SCRIPT%" echo synchronize remote -filemask="| *.exe;*.msi;*.apk;*.sha256;*.zip;*.bat;*.cmd;*.dat;pd.txt" "%UPLOAD_ROOT%" "%REMOTE_DIR%"
>>"%WINSCP_SCRIPT%" echo exit

"%WINSCP_EXE%" /script="%WINSCP_SCRIPT%" /log="%WINSCP_LOG%"
if errorlevel 1 goto UPLOAD_ERROR
del /q "%WINSCP_SCRIPT%" >nul 2>nul

echo.
echo ============================================================
echo   FERTIG - NUR WEBSITE SYNCHRONISIERT
echo ============================================================
echo.
echo HTML, CSS, Bilder, robots.txt und sitemap.xml wurden gespiegelt.
echo Ausgeschlossene Installer und Programmpakete blieben unberuehrt.
echo.
pause
exit /b 0

:NO_GIT
echo FEHLER: Git-Repository nicht gefunden: "%ROOT%"
goto FAIL
:NO_UP
echo FEHLER: Website-Ordner nicht gefunden: "%UPLOAD_ROOT%"
goto FAIL
:NO_WINSCP
echo FEHLER: WinSCP.com wurde nicht gefunden: "%WINSCP_EXE%"
goto FAIL
:CD_ERROR
echo FEHLER: Wechsel in "%ROOT%" ist fehlgeschlagen.
goto FAIL
:LOCAL_CHANGES
echo FEHLER: Unter UP liegen lokale Aenderungen oder ungetrackte Dateien.
type "%STATUS_FILE%"
del /q "%STATUS_FILE%" >nul 2>nul
goto FAIL
:NO_SAVED_SESSION
echo FEHLER: Keine passende gespeicherte WinSCP-Sitzung gefunden.
echo Gesucht: Host "%WINSCP_HOST%", Benutzer "%WINSCP_USER%".
goto FAIL
:UPLOAD_ERROR
echo FEHLER: Website-Synchronisation fehlgeschlagen.
echo WinSCP-Protokoll: "%WINSCP_LOG%"
del /q "%WINSCP_SCRIPT%" >nul 2>nul
goto FAIL
:FAIL
echo.
echo Es wurde nichts erfolgreich veroeffentlicht.
echo.
pause
exit /b 1
