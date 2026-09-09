# Übergabe – SerKal Website-Chatty

Datum: 09.09.2026
Status: AKTIVER ARBEITSAUFTRAG / WEBSITE NOCH NICHT FERTIG

## An den Nachfolger

Du übernimmst die SerKal-Website. Bitte beginne NICHT damit, Kurt nach den Unterlagen oder nach einer ersten Einzelaufgabe zu fragen. Die Unterlagen und der Auftrag stehen hier.

Lies vor jeder Arbeit:
1. dieses Dokument;
2. `docs/website_entwicklerhandbuch.md` im Repository `KurtV731/serkal-pages`;
3. das gemeinsame schwarze Brett `1 docs/schwarzes_brett.md` im Repository `KurtV731/serkal_desktop`;
4. anschließend die tatsächlich betroffenen Dateien frisch aus dem aktuellen GitHub-Stand.

Alte Chat-Erinnerungen sind keine Dateiquelle.

## Der von Kurt erteilte Gesamtauftrag

Die SerKal-Website ist als GESAMTPROJEKT fertigzustellen.

Alle noch nicht erledigten Seiten müssen in EINEM zusammenhängenden Arbeitsgang an das vereinbarte aktuelle Website-Schema angepasst werden. Das ist ausdrücklich KEINE Folge von Einzelaufträgen nach dem Muster „Seite fertig – Kurt fragen – nächste Seite“. Kurt möchte erst wieder einen Gesamtstand sehen, wenn die Website in sich schlüssig und prüfbar ist.

### Was „fertigstellen“ konkret bedeutet

- sämtliche noch vorhandenen Spuren des früheren SerKal-Endnutzerwegs über Google Apps Script/Skriptinstallation beseitigen oder dort, wo sie historisch dokumentiert werden, eindeutig als Vergangenheit kennzeichnen;
- HASA nicht fälschlich ent-skripten: HASA bleibt ein eigenständiges Assistenzskript für Horizon; nur die Website-Seite `hasa.html` liegt im Zuständigkeitsbereich des Website-Chattys;
- DE- und EN-Seiten auf denselben aktuellen fachlichen und optischen Stand bringen;
- Header, Footer, Navigation, Sprachumschaltung und Logo-Pfade vereinheitlichen;
- Zielnavigation konsequent verwenden: `Start · Download · Hilfe · FAQ · Über SerKal · Rechtliches · Werkstatt` (EN entsprechend);
- Logo-Pfade auf `/icon/logo/serkallogo.png`, `/icon/logo/chatgptlogo.png`, `/icon/logo/tmdblogo.png` bringen;
- Installation und Hilfe auf SerKal Desktop ausrichten;
- Downloadseite, Installation, Hilfe, FAQ, TMDB-Hilfe, Google-Kalender-Hilfe und HASA-Verweis sinnvoll miteinander verknüpfen;
- unnötiges Scrollen auf normalen Seiten vermeiden, aber echte Inhaltsseiten nicht künstlich zusammenquetschen;
- interne Links, Bilder und DE/EN-Gegenlinks vollständig kontrollieren;
- keine sichtbaren Fehler, keine redundanten Angaben, keine vermeidbaren Klicks;
- die Website anschließend über den echten Veröffentlichungsweg auf serkal.de prüfen.

## Besonders wichtig: nicht den bisherigen halbfertigen Stand kopieren

Am 09.09.2026 wurden mehrere Seiten schnell auf ein kompakteres Schema umgebaut. Kurt hat den veröffentlichten Gesamtstand anschließend ausdrücklich als „sehr viel nicht korrekt“ beurteilt. Diese Seiten sind daher nur Arbeitsmaterial und keine Designfreigabe.

Bereits bearbeitet wurden u. a. `start`, `download`, `installation`, `about`, `legal` in DE/EN. Trotzdem müssen auch diese Seiten in der Gesamtprüfung nochmals gegen die übrige Website und Kurts Vorgaben kontrolliert werden.

## Konkrete noch erkennbare Altlasten

Der Nachfolger soll mindestens folgende Dateien/Paare prüfen:

- `help.html` / `help-en.html`: alte doppelte CSS-/Header-Blöcke, alte Logo-Pfade, Navigation nicht vollständig.
- `faq.html` / `faq-en.html`: Inhalt grundsätzlich brauchbar, aber Schema/Abstände/Logos gegen Gesamtstandard prüfen.
- `tmdb-hilfe.html` / `tmdb-help.html`: alte Header-/Logo-Struktur; deutlicher Rückweg direkt `serkal://start/` fehlt.
- `google-kalender-hilfe.html` / `google-calendar-help.html`: Rückweg direkt `serkal://start/`; Navigation/Logos vereinheitlichen.
- `privacy.html` / `privacy-en.html`: alte doppelte CSS-Struktur und alte Logo-Pfade.
- `datenschutz.html`, `impressum.html`: deutlich älteres Layout; in die Gesamtstruktur einpassen, ohne rechtliche Inhalte leichtfertig zu verändern.
- `werkstatt.html`: alte Navigation/Logo-Pfade. Historische Apps-Script-Erwähnungen dürfen als Geschichte bleiben, müssen aber eindeutig Geschichte sein.
- `howtogetarchivefolder.html` / EN: alter Google-Drive-Ordner-ID-Endnutzerweg; für Desktop fachlich überholt und neu entscheiden/umleiten.
- `howtogetgoogleaccount.html` / EN: behauptet noch Google Drive + Google Apps Script seien Voraussetzung; für Desktop veraltet.
- `howtogetapi.html` / EN: derzeit bewusst Redirect zur TMDB-Hilfe; Redirect-Funktion erhalten, sofern kein guter Grund zur Änderung besteht.
- `sitemap.xml`: nach Bereinigung auf aktuelle öffentliche Seiten prüfen; enthält derzeit noch SKDEVHMB-Einträge.
- `up/start`: Protokollbrücke zu SerKal. Schwarzes Brett beachten; Brücke nicht kaputtmodernisieren.

## Index – die Haustür bleibt vorläufig

`up/index.html` ist derzeit absichtlich eine Warnseite mit dem Hinweis, dass nach dem Umbau einzelne Dinge noch nicht perfekt funktionieren können.

Die endgültige Indexseite wird NICHT während der Bereinigungsrunde freigegeben.

Verbindliche Abfolge:

1. Website vollständig bereinigen und vereinheitlichen.
2. Den Gesamtstand veröffentlichen und live auf serkal.de prüfen.
3. Kurt prüft die gesamte Website.
4. Seine Schlusskorrekturen vollständig einarbeiten.
5. Erst danach die endgültige `index.html` freigeben – „Haustür auf“.

## Arbeits- und Git-Regeln

- Vor jeder Dateiänderung aktuelle Datei aus GitHub lesen.
- Vollständige Dateien ändern, Kurt keine Patchzeilen zum Einsetzen geben.
- Kurt soll nicht zwischen Chattys vermitteln oder Branches verwalten müssen.
- Git-Verwaltung übernimmt Chatty.
- `C:\serkal-pages\up` ist Kurts lokale Website-Wahrheit.
- Live-Test benötigt Veröffentlichung: GitHub -> lokaler `up`-Ordner -> serkal.de.
- Keine Website-Änderung an Desktop-Fachcode, Installer oder HASA-Quellcode.
- `index.php` im Serverkontext gehört zur HASA-API und ist NICHT die Website-Startseite; nicht löschen oder als vermeintliche Ursache für die HTML-Haustür behandeln.

## Aktuelle wichtige Website-Commits vor Übergabe

- `2f185f1` – deutsche Installation auf SerKal Desktop umgestellt.
- `65b15a0` – deutsche Startseite kompakter, „wird erwachsen“-Box entfernt.
- `452019f` – Rechtliches kompakter, Logo-Pfade korrigiert.
- `afb472c` – englische Rechtliches-Seite angepasst.
- `d350c6b` / `6ecd8f3` – About DE/EN angepasst.
- `889c22d` – Start EN angepasst.
- `4bcd238` – Installation EN auf Desktop umgestellt.
- `a0ed089` – Download EN angepasst.
- `69b3602` – aktuelle Warn-/Umbau-Indexseite.

Diese Commits zeigen die jüngste Richtung, sind aber ausdrücklich NICHT gleichbedeutend mit „Gesamtwebsite freigegeben“.

## Kurts Abnahmewunsch

Kurt will am Ende keine Serie von Meldungen „Seite X ist fertig, soll ich Seite Y machen?“. Der Nachfolger soll die Gesamtaufgabe selbständig durcharbeiten und erst dann einen prüfbaren Gesamtstand melden.

Wenn fachlich unklar ist, ob ein alter Inhalt noch gelten soll, zuerst aktuellen Desktop-/Schwarzes-Brett-Stand prüfen. Nur echte Produktentscheidungen, die sich daraus nicht beantworten lassen, bei Kurt erfragen.

## Zielzustand

Am Ende soll ein Besucher der Website den Eindruck einer einzigen, konsistenten SerKal-Website erhalten: SerKal Desktop als aktuelles Produkt, klare Installation und Hilfe, funktionierende DE/EN-Wege, korrekte Logos und Links, HASA sauber als separates Projekt, keine versehentlichen Relikte des früheren Installationsmodells und keine halbfertige Mischung mehrerer Website-Generationen.
