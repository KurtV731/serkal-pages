# Google-Kalender-Hilfe für SerKal Desktop

Stand: 03.09.2026

## Anlass

Im Endnutzertest wurde der neue SerKal-Button **„SerKal-Hilfe öffnen“** erfolgreich im Browser geöffnet. Die bisher verwendete Zielseite auf serkal.de existierte jedoch noch nicht und führte zu einem 404-Fehler.

Zusätzlich ist SerKal Desktop zweisprachig. Deshalb muss die Google-Kalender-Hilfe ohne nachträgliche Sprachabfrage direkt in der aktuell in SerKal gewählten Sprache geöffnet werden.

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

## Endgültige Website-Ziele

Deutsch:

`https://serkal.de/google-kalender-hilfe.html`

Englisch:

`https://serkal.de/google-calendar-help.html`

Beide Dateien liegen im Website-Repository unter `up/`.

## Aufgabe für CE / SerKal Desktop

Der Hilfe-Button muss abhängig von der aktuell gewählten SerKal-Sprache das passende Ziel öffnen:

- DE -> `https://serkal.de/google-kalender-hilfe.html`
- EN -> `https://serkal.de/google-calendar-help.html`

Die Auswahl erfolgt in SerKal. Auf der Website soll der Benutzer nicht erst nach seiner Sprache gefragt werden.

## Rückwege

Beide Hilfeseiten bieten zwei Wege zurück:

- SerKal Desktop über den bereits vorhandenen Startweg `/start` öffnen.
- Die normale SerKal-Hilfe der jeweiligen Sprache öffnen.

## Veröffentlichungsstatus

Die Seiten wurden zunächst ausschließlich auf dem Arbeitsbranch `website-chatty` angelegt. Sie werden erst nach Test und Freigabe durch Kurt in `main` übernommen.
