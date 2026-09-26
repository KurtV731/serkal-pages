# SerKal Android – Entwicklungschronik und technische Abgrenzung

Stand: 26.09.2026

Dieses Dokument hält die bisherige Android-Entwicklung dauerhaft fest. Es ergänzt die öffentliche Werkstattseite und verhindert, dass frühe Versuche, praktische Tests und daraus entstandene Produktentscheidungen verloren gehen.

## 1. Ausgangspunkt

Nach der Veröffentlichung von SerKal Desktop 1.0 begann die vorsichtige Erprobung einer späteren Android-Ausgabe. Ziel war ausdrücklich nicht, die Windows-Anwendung schnell zu kopieren oder voreilig eine öffentliche Mobilversion zu versprechen. Zuerst sollten Installation, Aktualisierung, Bedienbarkeit und Bildschirmaufteilung auf echten Geräten verstanden werden.

Die Android-Arbeit läuft deshalb getrennt von SerKal Desktop. Eigene Branches, Paketkennungen und APKs verhindern, dass Trainings- und Vorschaufassungen die veröffentlichte Windows-Version oder deren Daten beeinflussen.

## 2. 18.09.2026 – Android Training 0.0.1

Branch: `android-training-0.0.1`  
Quellcommit: `83fc27e070e83d369534d7c84e750dff85bf75d8`  
Paketkennung: `de.serkal.android.training`

Die erste App war bewusst klein. Sie diente dem Üben des vollständigen APK-Ablaufs:

1. APK auf ein Android-Gerät übertragen und installieren.
2. App starten.
3. zwischen Deutsch und Englisch umschalten.
4. einen beliebigen Testserientitel lokal speichern.
5. App schließen und erneut öffnen; der Eintrag muss erhalten bleiben.
6. später eine höhere Fassung darüber installieren können.

Die Trainings-App besitzt keine Internet-, TMDB-, Kalender- oder Dateiberechtigung. Sie ist kein früher Produktivstand und verwendet absichtlich eine eigene Paketkennung sowie einen nur für diese wertlose Übungs-App vorgesehenen Trainingsschlüssel.

Der automatische GitHub-Workflow baut die APK mit Java 17, Gradle 8.10.2 und Android API 35. Mindestversion ist Android 8.

### Praktisches Ergebnis

Die APK ließ sich auf Kurts Google Pixel 8 und anschließend auch auf dem Samsung-Tablet installieren. Damit waren Download, Übertragung, Installation, Start und Sprachumschaltung praktisch erprobt. Die Hürde „Wie bekomme ich überhaupt eine selbst gebaute APK auf meine Geräte?“ war genommen.

## 3. 23.09.2026 – Android-Präversion 0.0.2

Branch: `android-preview-0.0.2`  
Quellcommit: `cf33ab65693144c19f1edab2cb5060ea4670351e`  
Paketkennung: `de.serkal.android.preview`

Mit 0.0.2 begann die eigentliche Oberflächenstudie. Die App zeigte erstmals eine an SerKal angelehnte dreigeteilte Darstellung im Querformat:

- Archivliste,
- Eintrag mit Serieninformationen und Posterbereich,
- Suche und nächste Kalendertermine.

Deutsch und Englisch konnten direkt umgeschaltet werden. Beispieldaten wie „Lucky“ machten die geplante Arbeitsweise sichtbar. Die Fassung blieb jedoch ein reiner Darstellungstest: Sie suchte nicht bei TMDB, änderte kein Archiv und schrieb keinen Kalendertermin.

### Erkenntnisse aus dem Gerätetest

Der erste echte Blick auf Handy und Tablet war wichtiger als eine Betrachtung am Entwicklungsrechner. Dabei wurden mehrere verbindliche Anforderungen sichtbar:

- Querformat ist für die dreigeteilte SerKal-Oberfläche sinnvoll und soll erzwungen werden.
- Android-Status- und Navigationsleisten dürfen die Oberfläche nicht störend überlagern; eine echte Produktfassung benötigt einen gut bedienbaren Vollbildmodus.
- Die Oberfläche muss auf verschiedenen Displaygrößen sinnvoll skalieren.
- Bedienelemente dürfen weder winzig noch durch große Android-Systemschrift unbrauchbar werden.
- Die fachliche Reihenfolge soll sich am Desktop orientieren: Suche, Anzeige/Bearbeitung und Archiv müssen verständlich zusammenwirken.

## 4. 23.09.2026 – Android-Präversion 0.0.3

Branch: `android-preview-0.0.3`  
Quellcommit: `9c33392e0fe925f132dbee9fbc4eb676dd820615`

0.0.3 reagierte unmittelbar auf den ersten Darstellungstest. Schriftgrößen, Abstände, Überschriften, Schaltflächen und Kopfbereich wurden deutlich kompakter. Die Vorschau verwendet für ihre feste Bildschirmaufteilung bewusst DIP-Größen, damit eine sehr große Android-Systemschrift das gesamte Layout nicht unkontrolliert auseinanderzieht. Die App bleibt im sensorabhängigen Querformat.

Der praktische Test zeigte, dass die Schriftgröße nun grundsätzlich brauchbar ist. Gleichzeitig bleiben Vollbildverhalten, echte Skalierbarkeit und die endgültige Anordnung der drei Arbeitsbereiche offene Gestaltungsaufgaben.

Auch 0.0.3 ist weiterhin nur eine Oberflächenpräversion. Beispieldaten werden angezeigt, aber Archiv und Kalender werden nicht verändert.

## 5. Verbindliche Produktgrenzen

- Android-Training und Android-Präversion sind keine öffentliche SerKal-Android-Ausgabe.
- Sie verändern SerKal Desktop 1.0 beziehungsweise die freigegebenen Windows-Reparaturstände nicht.
- Eine spätere echte Android-App erhält eine eigene endgültige Paketkennung und einen privaten Veröffentlichungsschlüssel.
- Echte TMDB-, Archiv- und Kalenderfunktionen werden erst schrittweise angeschlossen, nachdem Oberfläche und Geräteverhalten praktisch tragfähig sind.
- Es wird keine eigenständige zweite Archivwelt für Android geschaffen.

## 6. Verbindung zum gemeinsamen persönlichen Archiv

Kurts verbindliche Produktregel lautet: Pro Person darf es nur ein SerKal-Archiv geben, unabhängig von der Anzahl der verwendeten Computer oder mobilen Geräte.

Für Android bedeutet das:

- PC, Laptop und spätere Android-Geräte derselben Person müssen denselben persönlichen Archivbestand verwenden.
- Unterschiedliche Geräte dürfen Änderungen nicht stillschweigend überschreiben.
- Vor Schreib- und Löschvorgängen muss der aktuelle gemeinsame Stand gelesen werden.
- Konflikterkennung, atomare Schreibvorgänge und Sicherungen gehören vor eine produktive Freigabe.
- Android darf nicht einfach ein isoliertes lokales Archiv erhalten, das später mühsam mit Windows zusammengeführt werden müsste.

Diese Architektur ist noch nicht umgesetzt. Die Vorschaufassungen vermeiden deshalb bewusst jeden echten Archivzugriff.

## 7. Nächste fachliche Schritte

1. Vollbild- und Systemleistenverhalten auf Pixel 8 und Samsung-Tablet sauber lösen.
2. Skalierung und nutzbare Größen der drei Arbeitsbereiche festlegen.
3. Bedienreihenfolge Suche – Anzeige/Bearbeitung – Archiv praktisch bestätigen.
4. Eine echte Suche zunächst ohne schreibenden Archivzugriff anbinden.
5. Gemeinsames persönliches Archiv einschließlich Konfliktschutz konzipieren und testen.
6. Erst danach schreibende Archiv- und Kalenderfunktionen auf Android aufbauen.

## 8. Dokumentationsregel

Jeder neue Android-Meilenstein wird künftig an drei Stellen festgehalten:

1. im SerKal-Schwarzen Brett als verbindlicher technischer Stand;
2. in dieser ausführlichen Entwicklungschronik;
3. in verständlicher, gekürzter Form auf `up/werkstatt.html`.

So bleiben technische Einzelheiten, öffentliche Entwicklungsgeschichte und Aufgabenübergabe miteinander verbunden.
