@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 0A
title SerKal ELWMS FINAL R7 CLEAN

REM ============================================================
REM  ELWMS - EierLegendeWollMilchSau
REM  FINAL R7 CLEAN
REM  Stand: 2026-08-08_ELWMS_FINAL_R7_CLEAN
REM
REM  Verbindliche neue Struktur:
REM
REM  webpage\
REM  |-- support\
REM  |   |-- elwms_serkal_final_r6_clean.bat
REM  |   `-- fanal\
REM  |       |-- fanal.js
REM  |       `-- Start_fanal.bat
REM  |
REM  `-- up\
REM      |-- normale Website
REM      `-- skdevhmb\
REM          |-- manifest\
REM          `-- serkal\
REM              `-- analyse\
REM                  |-- .clasp.json
REM                  `-- appsscript.json
REM
REM  Grundsaetze:
REM  - clasp pull arbeitet DIREKT in analyse\
REM  - Fanal ist ein lokales Werkzeug unter support\fanal\
REM  - keine zweite Fanal-Kopie in up\
REM  - Fanal-Ausgaben entstehen nur in analyse\
REM  - bei Fanal-Fehler wird NICHT weiter hochgeladen
REM  - ui.html wird NACH Fanal zu ui.html.txt umbenannt
REM  - Doppelstart-Schutz gegen parallelen und direkten Zweitlauf
REM ============================================================

set "BUILD=2026-08-08_ELWMS_FINAL_R7_CLEAN"

REM --- Doppelstart-Schutz ---------------------------------------
REM Schutz 1: waehrend eines laufenden ELWMS darf keine zweite
REM Instanz starten.
REM Schutz 2: direkt nach einem erfolgreichen Lauf wird ein
REM versehentlicher zweiter Start fuer 45 Sekunden abgefangen.
set "ELWMS_LOCK=%TEMP%\serkal_elwms_r7_running.lock"
set "ELWMS_LAST=%TEMP%\serkal_elwms_r7_last_success.txt"

if exist "%ELWMS_LOCK%" (
  echo.
  echo ============================================================
  echo   ELWMS LAEUFT BEREITS
  echo ============================================================
  echo.
  echo Eine zweite Instanz wird nicht gestartet.
  echo Falls zuvor ein Lauf hart abgebrochen wurde, kann die Datei
  echo %ELWMS_LOCK%
  echo manuell geloescht werden.
  echo.
  pause
  endlocal
  exit /b 2
)

if exist "%ELWMS_LAST%" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$p='%ELWMS_LAST%'; $age=(Get-Date)-(Get-Item -LiteralPath $p).LastWriteTime; if($age.TotalSeconds -lt 45){exit 23}else{exit 0}"
  if errorlevel 23 (
    echo.
    echo ============================================================
    echo   DOPPELSTART ABGEFANGEN
    echo ============================================================
    echo.
    echo Der letzte erfolgreiche Lauf ist weniger als 45 Sekunden her.
    echo Dieser zweite Start wird beendet.
    echo.
    timeout /t 4 >nul
    endlocal
    exit /b 0
  )
)

>"%ELWMS_LOCK%" echo ELWMS R7 gestartet: %DATE% %TIME%

REM --- Pfade aus dem Standort dieser Batch ableiten -------------
set "SUPPORT=%~dp0"
if "%SUPPORT:~-1%"=="\" set "SUPPORT=%SUPPORT:~0,-1%"

for %%I in ("%SUPPORT%\..") do set "WEBPAGE=%%~fI"
for %%I in ("%WEBPAGE%\..") do set "ROOT=%%~fI"

set "UPLOAD_ROOT=%WEBPAGE%\up"
set "DEVBOX=%UPLOAD_ROOT%\skdevhmb"
set "SERKAL_DIR=%DEVBOX%\serkal"
set "ANALYSE=%SERKAL_DIR%\analyse"

set "FANAL=%SUPPORT%\fanal"
set "FANAL_JS=%FANAL%\fanal.js"
set "FANAL_OUTPUT_FOLDER=%ANALYSE%"

set "MANIFEST_DIR=%DEVBOX%\manifest"
set "ZIP_ANALYSE=serkal_analyse_latest.zip"

REM --- Upload ---------------------------------------------------
set "WINSCP_EXE=C:\Program Files (x86)\WinSCP\WinSCP.com"
set "WINSCP_SESSION=kd239663ftp1@ftp.webspace.bz"
set "REMOTE_DIR=/"
set "WINSCP_SCRIPT=%TEMP%\serkal_elwms_upload.txt"
set "WINSCP_UPLOAD_LOG=%TEMP%\serkal_elwms_upload.log"

REM --- Online-Pruefung ------------------------------------------
set "ONLINE_ANALYSE=https://serkal.de/skdevhmb/serkal/analyse/"

set "STEP_PAUSE=2"
set "LOGFILE=%ANALYSE%\elwms.log"
set "ERRMSG="

cls

if not exist "%ANALYSE%" mkdir "%ANALYSE%" >nul 2>nul
if not exist "%MANIFEST_DIR%" mkdir "%MANIFEST_DIR%" >nul 2>nul

call :HEAD "SERKAL ELWMS FINAL R7 CLEAN - START"

echo ROOT       : %ROOT%
echo WEBPAGE    : %WEBPAGE%
echo SUPPORT    : %SUPPORT%
echo UP         : %UPLOAD_ROOT%
echo ANALYSE    : %ANALYSE%
echo FANAL      : %FANAL%
echo ONLINE     : %ONLINE_ANALYSE%
echo LOG        : %LOGFILE%
echo.

echo.>>"%LOGFILE%"
echo ============================================================>>"%LOGFILE%"
echo ELWMS START %DATE% %TIME% %BUILD%>>"%LOGFILE%"
echo WEBPAGE=%WEBPAGE%>>"%LOGFILE%"
echo ANALYSE=%ANALYSE%>>"%LOGFILE%"
echo FANAL=%FANAL%>>"%LOGFILE%"
echo ============================================================>>"%LOGFILE%"

timeout /t %STEP_PAUSE% >nul


call :STEP "1/8" "VORPRUEFUNG"

if not exist "%UPLOAD_ROOT%" (
  set "ERRMSG=Website-Ordner up fehlt: %UPLOAD_ROOT%"
  goto FEHLER
)

if not exist "%ANALYSE%\.clasp.json" (
  set "ERRMSG=.clasp.json fehlt: %ANALYSE%\.clasp.json"
  goto FEHLER
)

if not exist "%ANALYSE%\appsscript.json" (
  set "ERRMSG=appsscript.json fehlt: %ANALYSE%\appsscript.json"
  goto FEHLER
)

where clasp >nul 2>nul
if errorlevel 1 (
  set "ERRMSG=clasp wurde nicht gefunden."
  goto FEHLER
)

where node >nul 2>nul
if errorlevel 1 (
  set "ERRMSG=Node.js wurde nicht gefunden."
  goto FEHLER
)

if not exist "%FANAL_JS%" (
  set "ERRMSG=Fanal fehlt: %FANAL_JS%"
  goto FEHLER
)

if exist "%WINSCP_EXE%" (
  echo WinSCP gefunden.
  call :LOG "WinSCP gefunden."
) else (
  echo WARNUNG: WinSCP nicht gefunden. Upload wird uebersprungen.
  call :LOG "WARNUNG: WinSCP nicht gefunden: %WINSCP_EXE%"
)

echo Vorpruefung OK.
call :LOG "Vorpruefung OK."
timeout /t %STEP_PAUSE% >nul


call :STEP "2/8" "ANALYSE-ORDNER BEREINIGEN"

call :LOG "Bereinigung ANALYSE START"

dir "%ANALYSE%" /b > "%ANALYSE%\analyse_before.txt"

>"%ANALYSE%\analyse_deleted.txt" echo Geloescht am %DATE% %TIME%

for %%F in ("%ANALYSE%\*") do (
  if exist "%%~fF" (
    call :CLEAN_ANALYSE_FILE "%%~fF" "%%~nxF" "%%~xF"
  )
)

dir "%ANALYSE%" /b > "%ANALYSE%\analyse_after.txt"

call :LOG "Bereinigung ANALYSE ENDE"
echo Analyse-Bereinigung OK.
timeout /t %STEP_PAUSE% >nul


call :STEP "3/8" "CLASP PULL DIREKT IN ANALYSE"

cd /d "%ANALYSE%"
if errorlevel 1 (
  set "ERRMSG=Konnte nicht in ANALYSE wechseln: %ANALYSE%"
  goto FEHLER
)

set "CLASP_TMP=%TEMP%\serkal_elwms_clasp_pull.tmp"
del /f /q "%CLASP_TMP%" >nul 2>nul

echo Starte clasp pull...
call :LOG "Starte clasp pull."

call clasp pull >"%CLASP_TMP%" 2>&1
set "CLASP_EXIT=%ERRORLEVEL%"

type "%CLASP_TMP%"
echo.>>"%LOGFILE%"
echo ---- clasp pull START ---->>"%LOGFILE%"
type "%CLASP_TMP%">>"%LOGFILE%"
echo ---- clasp pull ENDE ---->>"%LOGFILE%"

if not "%CLASP_EXIT%"=="0" (
  set "ERRMSG=clasp pull fehlgeschlagen. Siehe %LOGFILE%"
  goto FEHLER
)

dir "%ANALYSE%" /b > "%ANALYSE%\analyse_after_clasp.txt"

if not exist "%ANALYSE%\Code.gs" (
  if not exist "%ANALYSE%\code.gs" (
    set "ERRMSG=Nach clasp pull wurde Code.gs/code.gs nicht gefunden."
    goto FEHLER
  )
)

if not exist "%ANALYSE%\ui.html" (
  set "ERRMSG=Nach clasp pull wurde ui.html nicht gefunden."
  goto FEHLER
)

call :LOG "clasp pull OK."
echo clasp pull OK.
timeout /t %STEP_PAUSE% >nul


call :STEP "4/8" "FANAL"

call :LOG "FANAL START"
call :LOG "INPUT=%ANALYSE%"
call :LOG "OUTPUT=%FANAL_OUTPUT_FOLDER%"
call :LOG "FANAL_JS=%FANAL_JS%"

del /f /q "%ANALYSE%\fanal_ergebnis.html" >nul 2>nul
del /f /q "%ANALYSE%\fanal_ergebnis.txt"  >nul 2>nul
del /f /q "%ANALYSE%\fanal_ergebnis.json" >nul 2>nul
del /f /q "%ANALYSE%\fanal_node_output.txt" >nul 2>nul

echo node "%FANAL_JS%" "%ANALYSE%" "%FANAL_OUTPUT_FOLDER%"
echo.

node "%FANAL_JS%" "%ANALYSE%" "%FANAL_OUTPUT_FOLDER%" >"%ANALYSE%\fanal_node_output.txt" 2>&1
set "NODE_EXIT=%ERRORLEVEL%"

type "%ANALYSE%\fanal_node_output.txt"
type "%ANALYSE%\fanal_node_output.txt">>"%LOGFILE%"

if not "%NODE_EXIT%"=="0" (
  set "ERRMSG=Fanal fehlgeschlagen. Exitcode %NODE_EXIT%."
  goto FEHLER
)

if not exist "%ANALYSE%\fanal_ergebnis.html" (
  set "ERRMSG=Fanal meldet Erfolg, aber fanal_ergebnis.html fehlt."
  goto FEHLER
)

if not exist "%ANALYSE%\fanal_ergebnis.txt" (
  set "ERRMSG=Fanal meldet Erfolg, aber fanal_ergebnis.txt fehlt."
  goto FEHLER
)

if not exist "%ANALYSE%\fanal_ergebnis.json" (
  set "ERRMSG=Fanal meldet Erfolg, aber fanal_ergebnis.json fehlt."
  goto FEHLER
)

call :LOG "FANAL OK"
echo Fanal OK.
timeout /t %STEP_PAUSE% >nul


call :STEP "5/8" "UI FUER WEB ALS TXT BEREITSTELLEN"

REM Fanal hat bis hierhin die echte ui.html analysiert.
REM Fuer die oeffentliche Website wird sie danach als reine
REM Quelldatei ui.html.txt bereitgestellt. Damit behandeln
REM Website-Checker und Suchmaschinen sie nicht als Webseite.
if not exist "%ANALYSE%\ui.html" (
  set "ERRMSG=ui.html fehlt vor der TXT-Umwandlung."
  goto FEHLER
)

del /f /q "%ANALYSE%\ui.html.txt" >nul 2>nul
move /Y "%ANALYSE%\ui.html" "%ANALYSE%\ui.html.txt" >nul

if not exist "%ANALYSE%\ui.html.txt" (
  set "ERRMSG=ui.html konnte nicht in ui.html.txt umbenannt werden."
  goto FEHLER
)

if exist "%ANALYSE%\ui.html" (
  set "ERRMSG=Nach der Umwandlung ist ui.html unerwartet noch vorhanden."
  goto FEHLER
)

call :LOG "UI WEB-TXT OK: ui.html.txt"
echo ui.html wurde fuer den Web-Umlauf zu ui.html.txt.
timeout /t %STEP_PAUSE% >nul


call :STEP "6/8" "MANIFEST ERZEUGEN"

if not exist "%MANIFEST_DIR%" mkdir "%MANIFEST_DIR%" >nul 2>nul

tree "%DEVBOX%" /f > "%MANIFEST_DIR%\mailbox_tree.txt"
dir "%DEVBOX%" /s /b > "%MANIFEST_DIR%\mailbox_files.txt"

(
echo SerKal Developer-Bereich
echo Erstellt: %DATE% %TIME%
echo Build: %BUILD%
echo.
echo UPLOAD_ROOT=%UPLOAD_ROOT%
echo DEVBOX=%DEVBOX%
echo SERKAL_DIR=%SERKAL_DIR%
echo ANALYSE=%ANALYSE%
echo FANAL_LOCAL=%FANAL%
echo ONLINE_ANALYSE=%ONLINE_ANALYSE%
) > "%MANIFEST_DIR%\buildinfo.txt"

call :LOG "MANIFEST OK"
echo Manifest OK.
timeout /t %STEP_PAUSE% >nul


call :STEP "7/8" "ANALYSE-ZIP ERZEUGEN"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$d='%ANALYSE%';" ^
  "$z=Join-Path $d '%ZIP_ANALYSE%';" ^
  "$files=Get-ChildItem -LiteralPath $d -File | Where-Object { $_.Extension -in '.gs','.html','.json','.txt' -and $_.Name -ne '%ZIP_ANALYSE%' };" ^
  "if(Test-Path -LiteralPath $z){Remove-Item -LiteralPath $z -Force};" ^
  "Compress-Archive -Path $files.FullName -DestinationPath $z -Force"

if errorlevel 1 (
  set "ERRMSG=Analyse-ZIP konnte nicht erstellt werden."
  goto FEHLER
)

call :LOG "ZIP OK"
echo ZIP OK.
timeout /t %STEP_PAUSE% >nul


call :STEP "8/8" "UPLOAD"

if not exist "%WINSCP_EXE%" (
  echo WinSCP fehlt - Upload uebersprungen.
  call :LOG "WinSCP fehlt - Upload uebersprungen."
  goto ERFOLG
)

>"%WINSCP_SCRIPT%" echo open %WINSCP_SESSION%
>>"%WINSCP_SCRIPT%" echo option batch abort
>>"%WINSCP_SCRIPT%" echo option confirm off
>>"%WINSCP_SCRIPT%" echo synchronize remote "%UPLOAD_ROOT%" "%REMOTE_DIR%"
>>"%WINSCP_SCRIPT%" echo exit

echo Starte WinSCP Upload...
call :LOG "Starte WinSCP Upload."

"%WINSCP_EXE%" /script="%WINSCP_SCRIPT%" /log="%WINSCP_UPLOAD_LOG%"
set "UPLOAD_EXIT=%ERRORLEVEL%"

if not "%UPLOAD_EXIT%"=="0" (
  set "ERRMSG=Upload fehlgeschlagen. Siehe %WINSCP_UPLOAD_LOG%"
  goto FEHLER
)

call :LOG "Upload OK."
echo Upload OK.


call :STEP "8a/8" "ONLINE-PRUEFUNG"

where curl >nul 2>nul
if errorlevel 1 (
  echo curl nicht gefunden - Online-Pruefung uebersprungen.
  call :LOG "curl nicht gefunden."
) else (
  curl -f -I "%ONLINE_ANALYSE%fanal_ergebnis.html" >>"%LOGFILE%" 2>>&1
  if errorlevel 1 (
    set "ERRMSG=Online-Pruefung von fanal_ergebnis.html fehlgeschlagen."
    goto FEHLER
  )

  curl -f -I "%ONLINE_ANALYSE%ui.html.txt" >>"%LOGFILE%" 2>>&1
  if errorlevel 1 (
    set "ERRMSG=Online-Pruefung von ui.html.txt fehlgeschlagen."
    goto FEHLER
  )
)

goto ERFOLG


:CLEAN_ANALYSE_FILE
set "CLEAN_SRC=%~1"
set "CLEAN_NAME=%~2"
set "CLEAN_EXT=%~3"

REM Diese Dateien sind die einzigen dauerhaften Steuer-/Logdateien.
if /I "%CLEAN_NAME%"==".clasp.json" exit /b 0
if /I "%CLEAN_NAME%"=="appsscript.json" exit /b 0
if /I "%CLEAN_NAME%"=="elwms.log" exit /b 0

REM Inventurlisten bleiben waehrend des Laufs erhalten/werden erneuert.
if /I "%CLEAN_NAME%"=="analyse_before.txt" exit /b 0
if /I "%CLEAN_NAME%"=="analyse_deleted.txt" exit /b 0
if /I "%CLEAN_NAME%"=="analyse_after.txt" exit /b 0
if /I "%CLEAN_NAME%"=="analyse_after_clasp.txt" exit /b 0

echo Loesche aus ANALYSE: %CLEAN_NAME%
echo %CLEAN_NAME%>>"%ANALYSE%\analyse_deleted.txt"
del /f /q "%CLEAN_SRC%" >>"%LOGFILE%" 2>>&1
exit /b 0


:HEAD
echo.
echo ============================================================
echo   %~1
echo ============================================================
echo.
exit /b 0


:STEP
echo.
echo ============================================================
echo   [%~1] %~2
echo ============================================================
echo.
echo ============================================================>>"%LOGFILE%"
echo [%~1] %~2>>"%LOGFILE%"
echo ============================================================>>"%LOGFILE%"
exit /b 0


:LOG
echo %DATE% %TIME% ^| %~1>>"%LOGFILE%"
exit /b 0


:FEHLER
echo.
echo ============================================================
echo   FEHLER / ABBRUCH
echo ============================================================
echo.
echo %ERRMSG%
echo.
echo Logdatei: %LOGFILE%
echo.
echo Es wird NICHT weiter hochgeladen.
echo %DATE% %TIME% ^| FEHLER ^| %ERRMSG%>>"%LOGFILE%"
del /f /q "%ELWMS_LOCK%" >nul 2>nul
pause
endlocal
exit /b 1


:ERFOLG
echo.
echo ============================================================
echo   ELWMS R7 ERFOLGREICH ABGESCHLOSSEN
echo ============================================================
echo.
echo Analyse lokal : %ANALYSE%
echo Analyse online: %ONLINE_ANALYSE%
echo Logdatei      : %LOGFILE%
echo.
>"%ELWMS_LAST%" echo Erfolgreich: %DATE% %TIME%
del /f /q "%ELWMS_LOCK%" >nul 2>nul
pause
endlocal
exit /b 0
