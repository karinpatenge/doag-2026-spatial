# Hänsel und Gretel im Geodatenwald – Oracle Spatial Grundlagen

Begleitmaterial zum Vortrag auf der DOAG 2026 in Nürnberg.

- **Termin:** Donnerstag, 19.11.2026, 12:00–12:45, Raum Singapur
- **Vortragende:** Knut Göttling (Enignum AI), Karin Patenge (Oracle Global Services Germany)
- **Format:** Standard Session (45 Min.), Einstieg, Schwerpunkt Coding

## Abstract

Hänsel und Gretel haben sich im Wald verlaufen. Wo befinden sie sich? Wie finden sie den Weg nach Hause? Liegt das
Hexenhaus noch im Wald oder bereits auf der Lichtung? Und wie findet man all diese Informationen schnell und
zuverlässig? Anhand des bekannten Märchens von Hänsel und Gretel führen wir durch die Grundlagen der
Geodatenverarbeitung in Oracle 26ai. Die Geschichte dient dabei als roter Faden, um zentrale Konzepte der räumlichen
Datenverarbeitung anschaulich und praxisnah zu vermitteln. Wir betrachten, wie die reale Welt in Geodaten modelliert
wird – von Punkten über Linien bis hin zu Flächen. Dabei lernen wir die wichtigsten Geometrietypen kennen und zeigen,
wie räumliche Objekte in Oracle gespeichert werden. Anschließend werfen wir einen Blick auf typische räumliche
Fragestellungen: Welche Objekte liegen in der Nähe? Befindet sich ein Objekt innerhalb einer Fläche? Wie lassen sich
Entfernungen berechnen? Darüber hinaus erläutern wir die Bedeutung von Koordinatensystemen und SRIDs und zeigen, warum
räumliche Indizes für die performante Verarbeitung großer Datenmengen unverzichtbar sind. Der Vortrag richtet sich an
Entwickler, Datenbankadministratoren, Architekten und alle, die einen verständlichen Einstieg in die Welt der Geodaten
mit Oracle suchen. Vorkenntnisse im Bereich GIS oder Oracle Spatial sind nicht erforderlich.

**Keywords:** Geodaten, GIS, Oracle Spatial, SDO_GEOMETRY, Spatial Index, Karten, Koordinatensysteme, SRID, APEX Maps,
Spatial Queries, Geometrien

## Inhalt

```
Vortrag/
├── Folien.html            -- Folien als lokale Webseite; Karten und Abfrageergebnisse kommen live per ORDS
├── start.cmd              -- startet den lokalen Webserver und öffnet die Folien
└── assets/                -- Bilder und Bibliotheken der Folien (ohne Internetzugriff lauffähig)
Datenbank/
├── 00_zuruecksetzen.sql   -- als SYS: löscht den Benutzer DOAG_SPATIAL samt allen Objekten
├── 01_benutzer.sql        -- als SYS: legt den Benutzer DOAG_SPATIAL an (fragt das Kennwort ab)
├── pa_geo.pck             -- Package mit der zentralen Toleranz
├── 02_tabellen.sql        -- Tabellen ort, weg, flaeche, baum, land mit Metadaten und Spatial Indizes
├── 03_maerchendaten.sql   -- Wald, See, Lichtung, Orte, Wege und rund eine Million Bäume
├── 05_ords.sql            -- ORDS-Modul „folien“ mit allen Endpunkten der Folien
└── 06_pruefung.sql        -- prüft die Märchendaten; jede Zeile muss „ja“ zeigen
```

## Voraussetzungen

- Oracle AI Database 26ai (lokal, z. B. 26ai Free) mit ORDS unter `http://localhost:8080/ords/`
- Python 3 für den lokalen Webserver
- Ein aktueller Browser

## Einrichten

In FREEPDB1 der Reihe nach ausführen: `00_zuruecksetzen.sql` und `01_benutzer.sql` als SYS, danach als DOAG_SPATIAL
`pa_geo.pck`, `02_tabellen.sql`, `03_maerchendaten.sql` (einige Minuten), `05_ords.sql` und `06_pruefung.sql`.

## Folien zeigen

`Vortrag\start.cmd` starten. Es öffnet die Folien unter `http://localhost:8765/Folien.html`. Als Datei geöffnet
(Doppelklick auf `Folien.html`) lehnt ORDS die Abrufe ab, weil der Browser dann keine Herkunft mitschickt.

Tasten: Pfeiltasten oder Leertaste blättern, `F` Vollbild, `B` Bildschirm schwarz, `T` Soll- und Ist-Zeit einblenden,
`R` Uhr zurücksetzen, `Z` Zaubersprüche hell oder dunkel (der Browser merkt sich die Wahl).
