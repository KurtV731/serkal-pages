# Google-Kalender-Hilfe für SerKal Desktop

Stand: 09.09.2026

## Verbindliche Endnutzerregel

Die Hilfe darf den normalen Benutzer nicht mit internen Google-OAuth-Entwicklerangaben belasten.

Der Benutzer braucht ausdrücklich **nicht**:

- Google Cloud,
- eine Client-ID,
- eine JSON-Datei,
- eine Kalender-ID.

Der normale Ablauf lautet:

1. In SerKal **„Google Kalender verbinden“** auswählen.
2. Google-Konto im Browser auswählen.
3. Angezeigten Zugriff erlauben.
4. Zu SerKal zurückkehren.
5. SerKal sucht den Kalender `SerKal` selbst oder erstellt ihn automatisch.

## Website-Ziele

Deutsch:
`https://serkal.de/google-kalender-hilfe.html`

Englisch:
`https://serkal.de/google-calendar-help.html`

Beide Dateien liegen im Website-Repository unter `up/`.

## Sprachregel

SerKal Desktop soll abhängig von der aktuell gewählten SerKal-Sprache direkt das passende Ziel öffnen:

- DE -> `https://serkal.de/google-kalender-hilfe.html`
- EN -> `https://serkal.de/google-calendar-help.html`

Auf der Website soll der Benutzer nicht erst nach seiner Sprache gefragt werden.

## Rückweg – aktueller verbindlicher Auftrag

Beide Hilfeseiten müssen einen deutlich sichtbaren Rückweg direkt zur installierten SerKal-Anwendung anbieten:

- DE: **„Zurück zu SerKal“**
- EN: **„Back to SerKal“**
- Ziel jeweils exakt: `serkal://start/`

Nicht als Ersatz auf eine allgemeine Start-, Hilfe- oder Downloadseite verlinken. Die normale Website-Hilfe darf zusätzlich erreichbar bleiben.

## Veröffentlichungsstatus

Die Hilfeseiten liegen auf `main`, sind aber am 09.09.2026 noch Teil der laufenden Website-Gesamtbereinigung. Insbesondere Header, Navigation, Logo-Pfade und der direkte `serkal://start/`-Rückweg sind vor der Schlussfreigabe zu prüfen bzw. anzupassen.

Siehe:
- `docs/website_entwicklerhandbuch.md`
- `docs/uebergabe_website_chatty_2026-09-09.md`
