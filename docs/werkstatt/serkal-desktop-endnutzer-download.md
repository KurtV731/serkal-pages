# SerKal Desktop – Endnutzer-Download über serkal.de

Stand: 1. September 2026

## Auftrag

Der Installer-Chatty erstellt eine getestete Windows-Setup-Datei mit dem Namen:

`SerKal Desktop-0.0.5 Setup.exe`

Ziel ist der echte Endnutzerfall. Ein Benutzer soll weder GitHub noch npm, Branches, CMD oder interne Entwicklungsordner kennen müssen.

## Soll-Ablauf für Benutzer

1. Auf serkal.de **„SerKal Desktop herunterladen“** anklicken.
2. Die heruntergeladene `Setup.exe` doppelklicken.
3. SerKal Desktop benutzen.

## Verbindliche Website-Regeln

- Der öffentliche Download erfolgt ausschließlich über einen festen Pfad auf `serkal.de`.
- Die Website verweist für Endnutzer nicht direkt auf GitHub.
- Die Website verweist nicht auf Entwicklungsordner oder interne Branches.
- Der endgültige Download-Link wird erst aktiviert, wenn Installer-Chatty das getestete Release-Paket ausdrücklich freigegeben hat.
- Bis zur Freigabe darf auf `main` kein öffentlicher funktionierender Setup-Download erscheinen.

## Geplanter fester Downloadpfad

Vorgesehen ist ein eigener Desktop-Bereich unter:

`/download/desktop/`

Die freigegebene Setup-Datei soll dort abgelegt werden. Der sichtbare Downloadbereich auf `download.html` wird erst mit der freigegebenen Datei endgültig aktiviert.

## Bestehender App-Start über /start

`https://serkal.de/start` ruft das registrierte externe Protokoll `serkal://start` auf. Der technische Test mit Firefox war erfolgreich: Firefox erkennt das Protokoll und kann SerKal Desktop starten.

### Rückkehr zur vorherigen Browserseite

Eine vollautomatische Rückkehr direkt nach erfolgreichem Start ist im Browser nicht zuverlässig feststellbar. Eine Webseite erhält keine sichere Bestätigung darüber, ob der externe Protokollhandler tatsächlich gestartet wurde oder ob der Benutzer den Firefox-Dialog bestätigt bzw. abgebrochen hat.

Deshalb wird vorerst **kein zeitgesteuertes `history.back()` und kein vergleichbarer Automatismus** eingebaut. Ein solcher Automatismus könnte die Startseite verlassen, bevor der Benutzer den Firefox-Dialog beantwortet, und wäre damit gerade im gewünschten Endnutzerfall unzuverlässig.

Die bestehende Startseite bleibt deshalb technisch einfach und robust. Eine spätere Verbesserung darf nur erfolgen, wenn sie in Firefox zuverlässig getestet werden kann und den Protokollaufruf nicht gefährdet.

## Freigabe-Grenze

Vor der öffentlichen Aktivierung sind mindestens nötig:

- getestete Setup.exe vom Installer-Chatty,
- bestätigter Dateiname und Ablagepfad,
- Test des Downloads direkt von serkal.de,
- Test der Installation im Endnutzerfall,
- anschließend Freigabe durch Kurt.

Erst danach wird der Download auf der öffentlichen Seite aktiviert.
