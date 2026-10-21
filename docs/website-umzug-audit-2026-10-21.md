# SerKal-Website – Umzugs- und Linkaudit vom 21.10.2026

## Verbindliche lokale Ablage

Repository:

`C:\ppd\serkal\serkal-pages`

Öffentlich zu übertragender Website-Inhalt:

`C:\ppd\serkal\serkal-pages\up`

Die aktiven Batchdateien leiten den Repositorypfad jetzt aus ihrem eigenen Speicherort
ab. Dadurch arbeiten sie am neuen Pfad und nicht mehr fest unter `C:\serkal-pages`.

## 1. Lokale Pfade und Hilfsprogramme

Direkt erledigt:

- `PULL-PD.BAT` verwendet seinen eigenen Speicherort als Repositorywurzel;
- `SERKAL_pull_v2.bat` verwendet seinen eigenen Speicherort;
- `RELEASE-1-0005-FESTSCHREIBEN.BAT` verwendet seinen eigenen Speicherort;
- `support/elwms_website_check.bat` findet `up` relativ zu seinem Speicherort;
- Entwicklerhandbuch, Übergabe und Downloaddokumentation nennen den neuen Pfad.

Nicht verändert:

- `%APPDATA%`- und `%TEMP%`-Verzeichnisse sind normale Windows-Laufzeit- bzw.
  Arbeitsverzeichnisse und gehören nicht unter `ppd`;
- `support/elwms_serkal_final_r7_clean.bat` ermittelt seine Arbeitsordner bereits relativ
  zum eigenen Standort. Seine alte Uploadsitzung bleibt jedoch vorläufig unverändert.

Kurts Test:

1. Im Explorer `C:\ppd\serkal\serkal-pages` öffnen.
2. `support\elwms_website_check.bat` doppelklicken.
3. In der ersten Ausgabe muss als Website-Root
   `C:\ppd\serkal\serkal-pages\up` erscheinen.
4. Die Upload-Batchdateien bis zur All-Inkl-Umstellung noch nicht für den endgültigen
   Umzug verwenden.

## 2. Veröffentlichung und All-Inkl

Aktueller Blocker:

Die beiden gegenwärtigen Veröffentlichungsdateien suchen noch die alte gespeicherte
WinSCP-Verbindung über Host `ftp.webspace.bz` und Benutzer `kd239663`; als Ziel ist `/`
eingetragen. Diese Angaben dürfen nicht geraten oder einfach auf All-Inkl umbenannt werden.

Benötigte Unterstützung von Kurt/All-Inkl:

- funktionierende, in WinSCP gespeicherte All-Inkl-Sitzung;
- tatsächlicher Hostname der Verbindung;
- verwendeter Benutzername;
- exaktes Server-Zielverzeichnis für `serkal.de`;
- später das getrennte Zielverzeichnis für `hasa.li`.

Danach direkt durch Website-Chatty änderbar:

- vollständige neue `NUR-WEBSITE-HOCHLADEN.BAT` bzw. Nachfolgerin;
- eindeutige Auswahl der SerKal-Sitzung und des SerKal-Zielordners;
- Vorprüfung auf lokale Änderungen, ungetrackte Dateien und fehlende Downloadartefakte;
- verständliche Fehlertexte und WinSCP-Protokoll;
- getrennte HASA-Veröffentlichung ohne Zugriff auf SerKal-Dateien.

Kurts Test nach Fertigstellung:

1. Zuerst eine harmlose erkennbare Textänderung auf einer Testseite veröffentlichen.
2. Im Browser mit `Strg+F5` neu laden und die Änderung kontrollieren.
3. SerKal-Downloadseite und Installer nur auf Erreichbarkeit prüfen; keinen neuen Build
   erzeugen.
4. Anschließend WinSCP-Protokoll auf das richtige Zielverzeichnis und Fehlercode 0 prüfen.

## 3. Interne Links, Dateien und Groß-/Kleinschreibung

Geprüft wurden alle 25 HTML-Dateien unter `up`, ihre lokalen `href`-/`src`-Ziele,
Bilddateien, Stylesheet, Downloadziele und die Sitemap.

Ergebnis:

- kein fehlendes lokales Link- oder Bildziel;
- keine doppelte HTML-ID;
- alle 24 Sitemap-Adressen besitzen eine passende lokale Datei;
- alle 24 derzeit veröffentlichten Sitemap-Adressen antworteten am 21.10.2026 mit HTTP 200;
- kein `X-Robots-Tag` blockierte diese Seiten.

Kurts Test:

- `support\elwms_website_check.bat` ausführen;
- anschließend auf Start, Download, Hilfe, FAQ, Über SerKal, Rechtliches und Werkstatt
  jeweils einmal klicken;
- auf einer englischen Seite den Sprachwechsel zurück zu Deutsch und wieder nach Englisch
  prüfen;
- Bilder und Downloadschaltflächen kontrollieren.

## 4. Google-Indexierung

Festgestellter Zustand:

- `robots.txt` erlaubt das Crawlen und nennt die Sitemap;
- die Sitemap ist syntaktisch gültig;
- eine aktuelle Google-Suche `site:serkal.de SerKal` zeigte weiterhin nur zwei Ergebnisse;
- 22 der 25 HTML-Dateien besaßen vor diesem Audit keinen Canonical-Link;
- die meisten DE/EN-Paare besaßen im HTML keine `hreflang`-Angaben;
- `https://serkal.de/` und `https://www.serkal.de/` lieferten beide denselben Inhalt mit
  HTTP 200 statt einer eindeutigen Domainweiterleitung.

Direkt erledigt:

- Canonical-Link für jede öffentliche HTML-Seite ergänzt;
- DE/EN- und `x-default`-Verweise für alle Sprachpaare ergänzt;
- Sitemap um passende `x-default`-Angaben ergänzt;
- reine Programmstart-Brücke `/start` auf `noindex,nofollow` gesetzt;
- alte HTML-Weiterleitung `datenschutz.html` auf `noindex,follow` gesetzt.

Unterstützung in All-Inkl erforderlich:

- `www.serkal.de` dauerhaft per HTTP 301 auf `https://serkal.de` weiterleiten;
- HTTP weiterhin dauerhaft auf HTTPS umleiten;
- unbekannte Pfade müssen echte 404-Antworten liefern und dürfen nicht mit 200 auf eine
  allgemeine Seite fallen;
- nach dem Umzug beide Varianten und Zertifikat prüfen.

Kurts Google-Test nach Veröffentlichung:

1. In Google Search Console die Property `https://serkal.de/` öffnen.
2. `https://serkal.de/sitemap.xml` erneut einreichen.
3. Mit „URL-Prüfung“ zunächst `start.html`, `help.html`, `werkstatt.html` und
   `tmdb-hilfe.html` einzeln prüfen.
4. Bei jeder Seite muss „Indexierung zulässig“ erscheinen; danach „Indexierung beantragen“.
5. Google braucht anschließend Zeit. Eine sofortige Anzeige aller Seiten ist nicht zu
   erwarten; die Prüfung nach einigen Tagen wiederholen.

## 5. HASA aus SerKal herauslösen

Gefundene Bestandteile:

- `up/hasa.html`;
- HASA-Blöcke in `up/download.html` und `up/download-en.html`;
- HASA-Eintrag in `up/sitemap.xml`;
- sämtliche Dateien unter `up/download/others/hasa/`;
- Hinweise auf Anmeldung und Galaxiedatenbank unter `serkal.de`.

Noch nicht entfernt, weil zuerst benötigt werden:

- All-Inkl-Zielordner und Veröffentlichungsweg für `hasa.li`;
- Entscheidung über HASA-Repository bzw. HASA-Unterordner unter `C:\ppd\serkal`;
- neue Backend-/Anmelde-/Datenbankadressen vom HASA-Verantwortlichen;
- geprüfte Zuordnung jeder alten SerKal-Adresse zu einer neuen HASA-Adresse.

Danach direkt durch Website-Chatty:

- eigene HASA-Seite, Downloads, Sitemap und robots.txt unter `hasa.li` erstellen;
- HASA aus den beiden SerKal-Downloadseiten entfernen;
- HASA aus der SerKal-Sitemap entfernen;
- alte HASA-Adressen per 301 auf die jeweils passende neue Adresse umleiten;
- keine funktionierende Datei löschen, bevor neues Ziel und Weiterleitung geprüft sind.

Kurts Test:

- `hasa.li` am PC und Smartphone öffnen;
- jeden HASA-Download anklicken und Dateiname/Größe kontrollieren;
- Anmeldung und eine harmlose Lesefunktion der Galaxiedatenbank prüfen;
- alte Adresse `https://serkal.de/hasa.html` aufrufen: Browser muss sichtbar zu `hasa.li`
  wechseln;
- anschließend darf die SerKal-Downloadseite keinen HASA-Bereich mehr enthalten.

## 6. Datenschutz, Impressum und externe Dienste

Geprüfte externe Links waren erreichbar. Die TMDB-Einstellungsseite verlangt erwartungsgemäß
eine Anmeldung und antwortet bei einer automatischen Prüfung ohne Sitzung mit 401.

Noch nicht direkt ändern:

- Datenschutz nennt derzeit INWX als Hostinganbieter. Erst zum tatsächlichen Providerwechsel
  auf die dann korrekten All-Inkl-Vertrags- und Serverangaben ändern;
- Cloudflare nur dann weiterhin nennen, wenn DNS/Proxy nach dem Umzug tatsächlich noch genutzt
  wird;
- HASA benötigt für `hasa.li` eine eigene, inhaltlich passende Datenschutz- und
  Impressumszuordnung.

Benötigte Unterstützung:

- Bestätigung, welcher Vertragspartner/Anbietername in der All-Inkl-Rechnung bzw. im Vertrag
  steht;
- Bestätigung, ob Cloudflare nach dem Wechsel noch DNS oder Proxy bereitstellt;
- fachliche Angaben des HASA-Verantwortlichen zu Anmeldung, E-Mail, Datenbank und Löschung.

## 7. Downloads und Programm-Rückwege

Geprüft:

- SerKal-Downloadseiten zeigen auf `/download/serkal-desktop.exe`;
- Prüfsummendatei und klassisches ZIP sind im Repository vorhanden;
- Hilfeseiten verwenden für den Rückweg das eigene Protokoll `serkal://start/`;
- die Bridge `/start` bleibt technisch erhalten, wird aber nicht als Suchergebnis angeboten.

Vor jeder Veröffentlichung weiterhin zwingend:

- nur ausdrücklich freigegebenes Installerartefakt verwenden;
- SHA-256 und Dateigröße prüfen;
- keine ungetrackten Rest- oder Temporärdateien im Ordner `up` hochladen;
- Android-APK und QR-Code erst nach ausdrücklicher Freigabe veröffentlichen.

## 8. Abschlussreihenfolge

1. Diese direkt erledigten Repositoryänderungen auf GitHub veröffentlichen.
2. Kurt holt sie nach `C:\ppd\serkal\serkal-pages`.
3. All-Inkl-Verbindungsdaten und Zielordner festhalten.
4. Neue SerKal-Uploadbatch vollständig erstellen und zunächst ungefährlich testen.
5. SerKal zu All-Inkl umschalten und Live-Prüfung durchführen.
6. Datenschutz und technische Anbieterangaben auf den realen Endzustand aktualisieren.
7. HASA vollständig auf `hasa.li` bereitstellen.
8. Alte HASA-Adressen weiterleiten und erst danach aus SerKal entfernen.
9. Sitemaps in den beiden Google-Search-Console-Properties einreichen und Indexierung
   stichprobenartig kontrollieren.
