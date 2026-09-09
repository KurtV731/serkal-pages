# SerKal Desktop – Endnutzer-Download über serkal.de

Stand: 09.09.2026

## Ziel

Der Endnutzer soll weder GitHub noch npm, Branches, CMD oder interne Entwicklungsordner kennen müssen. SerKal wird über serkal.de angeboten und als normales Windows-Programm installiert.

## Verbindlicher Website-Pfad

Das jeweils freigegebene Windows-Veröffentlichungsartefakt liegt im Webprojekt unter:

`up/download/serkal-desktop.exe`

Öffentlich wird es unter folgendem dauerhaft gleichbleibenden Namen angeboten:

`/download/serkal-desktop.exe`

Der öffentliche Dateiname enthält keine Versionsnummer. Die interne SerKal-/Installer-Version wird vom Installer verwaltet.

Die klassische ZIP-Fassung liegt derzeit zusätzlich unter:

`/download/serkal.zip`

## Verbindliche Freigaberegel

Erst existiert das geprüfte Veröffentlichungsartefakt, danach wird die Website darauf verlinkt bzw. dieses Artefakt veröffentlicht.

- Website erzeugt keinen Installer.
- Installer-Chatty verantwortet Build, Windows-Installation, Updateverhalten und Versionsnummer.
- CE verantwortet den fachlich freizugebenden SerKal-Quellstand.
- Website-Chatty verantwortet Downloadseite und Veröffentlichung des bereits freigegebenen Artefakts.
- Keine zwei installierbaren Test-/Release-Artefakte dürfen dieselbe interne Versionsnummer tragen.

## Aktueller Website-Aufbau

`download.html` und `download-en.html` zeigen getrennte Angebote für:

1. SerKal Desktop für Windows (`serkal-desktop.exe`),
2. klassisches SerKal als ZIP (`serkal.zip`).

HASA wird als separates Projekt auf `hasa.html` geführt und darf nicht mit dem SerKal-Installer vermischt werden.

## Veröffentlichungsweg bei Kurt

Website-Wahrheit lokal:
`C:\serkal-pages\up`

Ablauf:
GitHub -> `C:\serkal-pages\up` -> serkal.de

Der aktuelle Pull-/Publish-Ablauf verwendet `SERKAL_pull_v2.bat`. Eine lokal abweichende EXE kann dabei absichtlich zugelassen sein. Deshalb vor dem Upload sicherstellen, dass genau das freigegebene Artefakt im lokalen Downloadordner liegt.

## App-Start über `/start`

`https://serkal.de/start` ist nur eine Komfort-Brücke und ruft das registrierte Protokoll `serkal://start/` auf. Der normale Endnutzerstart erfolgt über die installierte Windows-Anwendung bzw. deren Verknüpfung.

Für die Website-Brücke gilt laut aktuellem schwarzen Brett:
- Protokollaufruf erhalten;
- nach Möglichkeit zur vorherigen Firefox-Seite zurückkehren bzw. sicheren Selbstschließversuch nutzen;
- wenn Firefox dies verhindert, nur kleine verständliche Rückfallanzeige;
- keine Browser-Erweiterung und kein Native Messaging.

Die Windows-Protokollregistrierung ist Installer-Aufgabe.

## Aktueller Freigabestatus

Die Website befindet sich am 09.09.2026 in einer Gesamtbereinigung und ist noch nicht als vollständig korrekt abgenommen. `up/index.html` bleibt bis nach Gesamtprüfung und Schlusskorrektur eine vorläufige Warn-/Umbauseite.

Für die aktuelle Übergabe siehe:
- `docs/website_entwicklerhandbuch.md`
- `docs/uebergabe_website_chatty_2026-09-09.md`
