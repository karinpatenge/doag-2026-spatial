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
├── Folien.html     -- Folien als lokale Webseite; Karten und Abfrageergebnisse kommen live per ORDS aus der Datenbank
└── assets/         -- Bilder, Schriften und Bibliotheken der Folien (ohne Internetzugriff lauffähig)
Datenbank/          -- SQL-Skripte: Schema, Märchendaten, ORDS-Endpunkte, Zurücksetzen
```

## Voraussetzungen

- Oracle AI Database 26ai (lokal, z. B. 26ai Free) mit ORDS
- Ein aktueller Browser
