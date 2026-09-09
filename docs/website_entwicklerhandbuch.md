# SerKal Website – Entwicklerhandbuch

Stand: 09.09.2026

Dieses Dokument ist die dauerhafte Arbeitsgrundlage für den Website-Chatty. Für die unmittelbar offene Übernahmeaufgabe zusätzlich `docs/uebergabe_website_chatty_2026-09-09.md` lesen.

## 1. Zuständigkeit und Quellen

- Website-Repository: `KurtV731/serkal-pages`.
- Vor jeder SerKal-Arbeit zuerst das gemeinsame schwarze Brett in `KurtV731/serkal_desktop`, Datei `1 docs/schwarzes_brett.md`, lesen.
- Immer vom aktuellen GitHub-Stand arbeiten. Keine alten Chat-Dateien, Cache-Fassungen oder erinnerte Dateiinhalte als Bearbeitungsbasis verwenden.
- Lokale Website-Wahrheit bei Kurt ist `C:\serkal-pages\up`.
- Veröffentlichungsweg: GitHub -> `C:\serkal-pages\up` -> serkal.de.
- Für die praktische Linkprüfung muss veröffentlicht werden; nur der Live-Stand zeigt den echten Webpfad zuverlässig.

## 2. Zuständigkeitsgrenzen

Der Website-Chatty bearbeitet Website-Dateien, Website-Downloads, Navigation, Hilfeseiten und Veröffentlichung.

Nicht eigenmächtig bearbeiten:
- SerKal-Desktop-Fachlogik: CE.
- Windows-Installer, Protokollregistrierung, Build/Update: Installer-Chatty.
- HASA-Quellprojekt: HASA-Chatty.

Die Website-Datei `up/hasa.html` gehört dagegen zur Website und darf als Website-Seite gepflegt werden. Der HASA-Quellcode und die fachliche HASA-Entwicklung bleiben tabu. Kurzform: lesen projektübergreifend erlaubt, ändern nur im eigenen Zuständigkeitsbereich – „Aache uff, Finger weg“.

## 3. Arbeitsweise mit Kurt

- Kurt entscheidet und testet; Chatty erledigt den Git-Krempel.
- Kurt soll keine einzelnen Codezeilen in Dateien einbauen. Änderungen an HTML/BAT/anderen Projektdateien als vollständige Datei durchführen.
- Keine Seite aus einem alten Chatstand überschreiben. Vor jeder Änderung die aktuelle Datei aus GitHub holen.
- Keine Ankündigung „ich mache später weiter“. Entweder die Arbeit im aktuellen Turn durchführen oder klar sagen, was noch offen ist.
- Keine Seite als fertig melden, solange die Gesamtprüfung des vereinbarten Arbeitsauftrags nicht erfolgt ist.
- Keine unnötigen Bandwurm-Zeilen in HTML. Dateien sollen für Kurt lesbar und bei Bedarf nachvollziehbar editierbar bleiben.
- Keine eigenmächtigen Designrevolutionen. Kleine, nachvollziehbare Änderungen.

## 4. Verbindliches Website-Schema

Zielnavigation für normale DE-Seiten:

`Start · Download · Hilfe · FAQ · Über SerKal · Rechtliches · Werkstatt`

Englische Seiten erhalten die entsprechenden EN-Ziele und dieselbe Struktur.

Logo-Dateien liegen unter:
- `/icon/logo/serkallogo.png`
- `/icon/logo/chatgptlogo.png`
- `/icon/logo/tmdblogo.png`

Alte Pfade wie `icon/serkallogo.png`, `icon/chatgptlogo.png` oder `icon/tmdblogo.png` sind auf den normalen Website-Seiten zu beseitigen bzw. korrekt auf `icon/logo` umzustellen.

Gestaltungsprinzip:
- Header, Footer, Farben, Navigation und Grundoptik über die Website vereinheitlichen.
- `download.html` ist ein wichtiges Muster für den neuen kompakten Stand.
- `legal.html` wurde als kompakte Referenz erprobt, ist aber derzeit bewusst NICHT als starres Höhenmaß festgelegt: Kurt will die Seite noch auf dem Tablet prüfen. Nicht eigenmächtig weiter zusammenschieben.
- Normale Seiten sollen nicht wegen nur 1–4 überflüssiger Zeilen scrollen. Bei inhaltsreichen Seiten ist Scrollen selbstverständlich erlaubt.
- Keine redundanten Informationen und keine vermeidbaren zusätzlichen Klicks.

## 5. Inhaltlicher Stand: SerKal Desktop

SerKal wird als eigenständiges Windows-Programm dargestellt. Die alte Google-Apps-Script-Installation ist kein aktueller Endnutzerweg mehr.

Aktuelle Grundsätze:
- Installation über `serkal-desktop.exe`.
- Normaler Programmstart als Windows-Anwendung; Browser ist dafür nicht erforderlich.
- TMDB: jeder Benutzer verwendet einen eigenen kostenlosen Developer-API-Key.
- Google Kalender ist optional; der Endnutzer braucht keine eigene Google-Cloud-Konfiguration, Client-ID, JSON-Datei oder Kalender-ID.
- Lokale Archivfunktionen bleiben von der TMDB-Verfügbarkeit getrennt.
- Klassisches SerKal kann auf der Downloadseite als separates ZIP-Angebot erhalten bleiben, solange dies der aktuelle freigegebene Website-Stand vorsieht.

## 6. Hilfe und FAQ

Trennung:
- `Hilfe` = Wie mache ich etwas?
- `FAQ` = Warum ist das so / brauche ich das / was passiert wenn?

Wichtige Hilfeziele:
- DE TMDB: `/tmdb-hilfe.html`
- EN TMDB: `/tmdb-help.html`
- DE Google Kalender: `/google-kalender-hilfe.html`
- EN Google Calendar: `/google-calendar-help.html`

TMDB-Hilfe:
- eigener API Key (v3 auth), nicht der lange Read Access Token;
- keine echten persönlichen Schlüssel oder Tokens veröffentlichen;
- TMDB-Hinweis DE: „Dieses Produkt verwendet die TMDB-API, wird jedoch nicht von TMDB unterstützt oder zertifiziert.“
- EN sinngemäß entsprechend.

Google-Kalender-Hilfe:
- Endnutzer nicht mit Entwickler-OAuth belasten;
- keine Google Cloud, Client-ID, JSON-Datei oder Kalender-ID erforderlich.

Rückweg aus den eigentlichen DE/EN-Hilfeseiten soll deutlich sichtbar direkt `serkal://start/` aufrufen („Zurück zu SerKal“ / „Back to SerKal“), nicht irgendeine allgemeine Website-Seite.

## 7. `/start` – Protokollbrücke

`up/start` ist eine Komfort-Brücke von der Website zum installierten Programm und ruft `serkal://start/` bzw. das registrierte SerKal-Protokoll auf.

Ziel laut schwarzem Brett:
- Protokollaufruf erhalten;
- danach möglichst zur vorherigen Firefox-Seite zurückkehren bzw. sicheren Selbstschließversuch nutzen;
- falls Firefox das verhindert, nur kleine verständliche Rückfallanzeige;
- keine Browser-Erweiterung, kein Native Messaging;
- niemals die funktionierende Protokollbrücke durch eine kompliziertere Lösung gefährden.

Die Windows-Protokollregistrierung selbst ist Installer-Aufgabe.

## 8. Download und Veröffentlichung

Aktueller öffentlicher Website-Pfad für den Installer:
`/download/serkal-desktop.exe`

Klassische ZIP:
`/download/serkal.zip`

Regel: Erst existiert ein geprüftes und freigegebenes Veröffentlichungsartefakt, danach verlinkt die Website darauf. Website erzeugt keinen Installer und ändert keine Desktop-Versionierung.

`SERKAL_pull_v2.bat` dient dem Pull-/Publish-Ablauf. Achtung: eine lokal abweichende EXE kann absichtlich zugelassen sein; deshalb nur ein ausdrücklich freigegebenes Artefakt veröffentlichen.

## 9. Aktueller Website-Zustand am 09.09.2026 – NICHT als fertig betrachten

Ein Teil der Hauptseiten wurde bereits auf ein kompakteres Schema gebracht, darunter:
- `start.html`, `start-en.html`
- `download.html`, `download-en.html`
- `installation.html`, `installation-en.html`
- `about.html`, `about-en.html`
- `legal.html`, `legal-en.html`
- `hasa.html` als eigener Website-Bereich.

Dieser Stand wurde von Kurt nach Veröffentlichung ausdrücklich als in vielen Punkten noch nicht korrekt beurteilt. Er ist daher KEINE fertige Designfreigabe.

Noch sichtbar alte bzw. besonders prüfbedürftige Bereiche sind u. a.:
- `help.html`, `help-en.html`: alte doppelte CSS-/Header-Struktur, alte Logo-Pfade, FAQ fehlt teils in der Navigation.
- `tmdb-hilfe.html`, `tmdb-help.html`: alte Logo-Pfade/Navigation; Rückweg zu `serkal://start/` fehlt.
- `google-kalender-hilfe.html`, `google-calendar-help.html`: alte Logo-Pfade/Navigation; Rückweg muss direkt zu `serkal://start/`.
- `privacy.html`, `privacy-en.html`: alte doppelte CSS-Struktur und alte Logo-Pfade.
- `datenschutz.html`, `impressum.html`: deutlich älteres Seitenschema und alte Logo-Pfade.
- `werkstatt.html`: alte Navigation/Logo-Pfade und historischer Text mit Apps-Script-Bezug; historische Entwicklung darf beschrieben werden, darf aber nicht wie der heutige Installationsweg wirken.
- `howtogetarchivefolder.html` und EN: enthalten noch den alten Google-Drive-Archivordner-/Ordner-ID-Weg und sind fachlich für den heutigen Desktop-Endnutzerweg zu prüfen/ersetzen oder als Altseite sauber umzuleiten.
- `howtogetgoogleaccount.html` und EN: behaupten noch, SerKal brauche Google Drive und Google Apps Script; das ist für den heutigen Desktop-Endnutzerweg veraltet.
- `sitemap.xml`: enthält noch SKDEVHMB-Ziele und muss nach Abschluss der Seitenbereinigung gegen die tatsächlich gewünschten öffentlichen Ziele geprüft werden.

`howtogetapi.html` und `howtogetapi-en.html` sind derzeit kleine Weiterleitungen zur neuen TMDB-Hilfe; solche Redirect-Seiten nicht unnötig in Vollseiten zurückverwandeln.

## 10. Index / Haustür

`up/index.html` ist derzeit absichtlich eine Warn-/Umbauseite. Aktueller Hinweis: Website wurde umgebaut, einzelne Seiten/Verknüpfungen/Darstellungen können in den nächsten Tagen noch nicht perfekt sein.

Diese Datei bleibt bis zum Abschluss der Gesamtüberarbeitung die vorläufige Haustür. Nicht vorzeitig durch die endgültige Startseite ersetzen.

Verbindliche Reihenfolge:
1. gesamte Website fertigstellen;
2. veröffentlichen und live prüfen;
3. Kurt prüft die Website als Ganzes;
4. Schlusskorrektur durchführen;
5. erst danach endgültige `index.html` freigeben („Haustür auf“).

## 11. Offener Gesamtauftrag

Der Nachfolger soll NICHT Seite für Seite bei Kurt nachfragen. Der Auftrag ist bereits erteilt: alle noch nicht erledigten Website-Seiten in einem zusammenhängenden Arbeitsgang auf den vereinbarten aktuellen Stand bringen, Inhalte fachlich vom alten Apps-Script-Endnutzerweg bereinigen, DE/EN konsistent machen, Navigation/Logos/Rückwege/Links prüfen und erst danach einen Gesamtstand zur Prüfung vorlegen.

Die genaue Übergabe und Abnahmereihenfolge steht in `docs/uebergabe_website_chatty_2026-09-09.md`.
