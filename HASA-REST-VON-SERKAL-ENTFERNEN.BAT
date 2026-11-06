@echo off
setlocal EnableExtensions
title SERKAL - alten HASA-Rest entfernen

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "WINSCP_EXE=%ProgramFiles(x86)%\WinSCP\WinSCP.com"
set "WINSCP_HOST=w0223f39.kasserver.com"
set "WINSCP_USER=w0223f39"
set "WINSCP_SESSION="
set "WINSCP_SCRIPT=%TEMP%\serkal_hasa_rest_entfernen.txt"
set "WINSCP_LOG=%TEMP%\serkal_hasa_rest_entfernen.log"

cls
echo.
echo ============================================================
echo   SERKAL - ALTEN HASA-REST ENTFERNEN
echo ============================================================
echo.
echo Es wird ausschliesslich diese alte Serverdatei entfernt:
echo /serkal.de/hasa.html
echo.
echo Lokale Dateien, GitHub, Downloads und hasa.li bleiben unberuehrt.
echo.

if not exist "%WINSCP_EXE%" goto NO_WINSCP

for /f "usebackq delims=" %%S in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$b='HKCU:\Software\Martin Prikryl\WinSCP 2\Sessions'; if(Test-Path $b){foreach($k in (Get-ChildItem $b)){try{$p=Get-ItemProperty $k.PSPath -ErrorAction Stop;if($p.HostName -eq '%WINSCP_HOST%' -and $p.UserName -eq '%WINSCP_USER%'){[Uri]::UnescapeDataString($k.PSChildName);break}}catch{}}}"`) do if not defined WINSCP_SESSION set "WINSCP_SESSION=%%S"
if not defined WINSCP_SESSION goto NO_SESSION

> "%WINSCP_SCRIPT%" echo open "%WINSCP_SESSION%"
>>"%WINSCP_SCRIPT%" echo option batch abort
>>"%WINSCP_SCRIPT%" echo option confirm off
>>"%WINSCP_SCRIPT%" echo rm "/serkal.de/hasa.html"
>>"%WINSCP_SCRIPT%" echo exit

"%WINSCP_EXE%" /script="%WINSCP_SCRIPT%" /log="%WINSCP_LOG%"
if errorlevel 1 goto DELETE_ERROR

del /q "%WINSCP_SCRIPT%" >nul 2>nul

echo.
echo ============================================================
echo   FERTIG - /serkal.de/hasa.html wurde entfernt
echo ============================================================
echo.
pause
exit /b 0

:NO_WINSCP
echo FEHLER: WinSCP.com wurde nicht gefunden:
echo "%WINSCP_EXE%"
goto FAIL

:NO_SESSION
echo FEHLER: Keine passende gespeicherte WinSCP-Sitzung gefunden.
echo Gesucht: Host "%WINSCP_HOST%", Benutzer "%WINSCP_USER%".
goto FAIL

:DELETE_ERROR
echo FEHLER: Die alte HASA-Datei wurde nicht entfernt.
echo WinSCP-Protokoll: "%WINSCP_LOG%"
goto FAIL

:FAIL
echo.
echo Es wurde nichts entfernt.
echo.
pause
exit /b 1
