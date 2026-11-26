# Website-Nachfolge – SerKal

Stand: 20.11.2026  
Zweck: kompakter Einstieg für den nächsten Website-Chatty. Historische Übergaben sind keine Pflichtlektüre.

## 1. Verbindlicher Einstieg

1. Zuerst das gemeinsame Schwarze Brett lesen:  
   https://github.com/KurtV731/serkal_desktop/blob/main/1%20docs/schwarzes_brett.md
2. Danach nur diese Übergabe und die zum konkreten Auftrag gehörenden Dateien lesen.
3. Alte offene Punkte nicht ungeprüft reaktivieren. GitHub-Quelle, lokaler Stand und Live-Website immer getrennt benennen.

## 2. Orte und Zuständigkeit

- Repository: `KurtV731/serkal-pages`
- Hauptzweig: `main`
- Kurts lokaler Ordner: `C:\ppd\serkal\serkal-pages`
- Veröffentlichungsordner: `up`
- Öffentliche Website: https://serkal.de/
- Gemeinsame Gestaltung: `up/serkal-shell.css`
- Serverregeln: `up/.htaccess`
- Sitemap/Robots: `up/sitemap.xml`, `up/robots.txt`
- Websiteprüfung: `support/elwms_website_check.bat`
- Fachliches Entwicklerhandbuch: `docs/website_entwicklerhandbuch.md`

HASA gehört nicht auf serkal.de. HASA-Website und API liegen im eigenen Repository `KurtV731/hasa`.

## 3. Unverrückbare Website-Regeln

- Oben und unten genau sieben Hauptpunkte:
  Start · Download · Hilfe/Help · FAQ · Über/About · Rechtliches/Legal · Werkstatt/Workshop.
- Kopf auf allen Inhaltsseiten gleich: SerKal-, ChatGPT- und TMDB-Logo sowie DE/EN-Umschaltung.
- Zusätzlich feste Fußzeilenlinks zu Impressum/Legal Notice und Datenschutz/Privacy.
- Deutsche und englische Fassung inhaltlich gemeinsam pflegen.
- Mobilansicht mitprüfen; Download und QR-Code müssen auf dem Smartphone verständlich bleiben.
- Canonical-, hreflang- und Sitemap-Angaben nicht beiläufig entfernen.
- Gelöschte oder umgezogene Seiten aus Navigation, Sitemap und internen Links gemeinsam bereinigen.
- Downloads und Prüfsummen nie still ersetzen. Erst freigegebene Artefakte übernehmen und Hash prüfen.
- Öffentliche Website, Website-APK und Google-Play-Test sind getrennte Veröffentlichungskanäle.

## 4. Veröffentlichen

Kurts normale Ein-Klick-Datei:

`C:\ppd\serkal\serkal-pages\PULL-PD.BAT`

Sie prüft den Arbeitsbaum, wechselt auf `main`, holt Git/Git-LFS, prüft Windows-Installer und Android-APK samt SHA-256 und synchronisiert `up` über die gespeicherte WinSCP-Sitzung nach `/serkal.de/`.

`NUR-WEBSITE-HOCHLADEN.BAT` lädt nur den bereits lokalen Stand hoch und führt keinen Git-Pull aus.

Nach jeder Veröffentlichung prüfen:

- https://serkal.de/
- betroffene DE- und EN-Seiten
- https://serkal.de/robots.txt
- https://serkal.de/sitemap.xml
- geänderte Downloads/Hashes, falls betroffen
- Weiterleitungen und Sicherheits-Header, falls `.htaccess` geändert wurde

Erst danach „live/veröffentlicht“ melden.

## 5. Letzter gesicherter Quellenstand

Website-Commit vor dieser Übergabe:

`8ca7735f577801700e4dd9acf165d11e23bb4c61`  
„site: complete SERAWEB legal and accessibility review“

Darin umgesetzt:

- direkte Impressums- und Datenschutzlinks auf allen 26 HTML-Seiten
- Impressum auf § 5 DDG und `support@serkal.de` vereinheitlicht
- Datenschutz DE/EN ergänzt: Art. 21, Limited Use, Drittlandgrundlagen, LfDI Rheinland-Pfalz, Art. 28, Cookies/Browserablage und lokale Desktop-Protokolle
- Überschriftenfolge auf About/Legal korrigiert
- Farbkontraste geprüft; niedrigster Wert 5,38:1
- `.htaccess` mit www-Weiterleitung, HSTS, nosniff und Referrer-Policy vorbereitet
- feste Siebener-Navigation unverändert belassen

Zum Zeitpunkt dieser Übergabe ist dieser Commit auf GitHub gesichert. Ein nachfolgender Serverupload und Live-Nachweis dürfen nur dann als erledigt gelten, wenn `PULL-PD.BAT` erfolgreich gelaufen ist und die öffentlichen Seiten geprüft wurden.

## 6. Aktueller Produktbezug

Zum Übergabestand:

- Windows öffentlich: SerKal Desktop 1.2.6
- Android-APK auf der Website: 1.2.4
- Geschlossener Google-Play-Test: eigene Spur, zuletzt bis 1.2.7/Code51; nicht als öffentliche Website-Version ausgeben
- Datenschutzseiten nennen diese Trennung ausdrücklich
- Downloadprogramme nicht aufgrund einer Websitepflege neu bauen oder ersetzen

Neuere Freigaben ausschließlich aus dem gemeinsamen Schwarzen Brett und dem belegten Releaseauftrag übernehmen.

## 7. Noch offen

1. SERAWEB-Commit nach erfolgreichem Upload live prüfen, besonders:
   - `privacy.html`, `privacy-en.html`, `impressum.html`
   - Fußzeilenlinks
   - www → serkal.de
   - HSTS, X-Content-Type-Options und Referrer-Policy
2. Den bereits im Schwarzen Brett genannten Live-Nachweis für
   `neu-in-1.2.html`, `whats-new-1.2.html`, `werkstatt.html` und `werkstatt-en.html` mit erledigen.
3. Search Console weiter sachlich behandeln:
   - robots.txt und sitemap.xml waren erreichbar
   - kein noindex/X-Robots-Tag festgestellt
   - geringe Indexierung nicht pauschal als Serverblockade darstellen
   - starke interne Verlinkung, eindeutige Canonicals und aktuelle Sitemap beibehalten
4. Bei neuen Programmversionen Downloadtexte, Werkstatt und Datenschutz nur nach belegtem Funktions- und Release-Stand aktualisieren.

## 8. Arbeitsweise mit Kurt

- Diktatfehler aus dem Zusammenhang lesen; Begriffe nicht ungefragt umbenennen.
- Ergebnis zuerst, kurze klare Aussagen, keine unnötigen CMD-Aufgaben.
- Wenn möglich selbst über GitHub arbeiten.
- Keine Versprechen für „später“ oder „morgen“ abgeben. Entweder jetzt erledigen oder ehrlich als offen kennzeichnen.
- Nach Änderungen immer unterscheiden: Quelle fertig · lokal vorhanden · hochgeladen · live geprüft.

## Google Search Console – Bestätigungsdatei

Die Datei `up/google911c81a59d3d0a4d.html` bestätigt die Inhaberschaft von serkal.de für Google Search Console. **Dateiname, Inhalt und Speicherort beibehalten.** Nach Website-Uploads muss sie weiterhin direkt unter https://serkal.de/google911c81a59d3d0a4d.html abrufbar sein. Die Datei bei Aufräumarbeiten und Veröffentlichungen im Ordner `up` belassen.
