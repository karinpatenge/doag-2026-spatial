# Hänsel und Gretel im Geodatenwald – Präsentationsstruktur

> **Slot:** 45 Min. → **42 Min. Inhalt + 3 Min. Q&A**
> **Sprecher:** Gretel (Product Manager Oracle Spatial, Oracle) · Hänsel (Knut Göttling, enignum.ai)
> **Grundlage:** [`documents/storybook_haensel_und_gretel_im_geodatenwald.md`](../documents/storybook_haensel_und_gretel_im_geodatenwald.md)
> **Stand:** 26.10.2026 – Entwurf v0.1

---

## 1. Dramaturgie auf einen Blick

```
Es war einmal …  →  Problem  →  Punkte  →  Linien  →  Wo sind wir?  →  Flächen  →  Nähe  →  Index  →  Karte  →  … dann querien sie noch heute
     Prolog           K1          K2         K3          K4              K5          K6       K7        K8          Epilog + Q&A
```

**Prinzipien**
- **Das Märchen bestimmt die Reihenfolge.** Jedes Kapitel beginnt mit einer Märchenszene (Kapitelbild, ca. 15–20 s) und endet mit einer Überleitung zur nächsten Szene.
- **Jedes Kapitel beantwortet eine Frage aus dem Abstract:** Wo sind wir? Wie weit ist es? Liegt das Hexenhaus im Wald oder auf der Lichtung? Wie geht das schnell und zuverlässig?
- **Dialog statt Monolog:** *Hänsel fragt (Praxis) → Gretel erklärt (Konzept) → Hänsel zeigt (Demo).* Sprecherwechsel spätestens alle 2–3 Minuten.
- **Die Karte wächst mit.** Am Ende jedes Kapitels kommt auf der Übersichtskarte eine Ebene hinzu.
- **4 kurze Demos (je ≤ 2 Min.)**, jede mit Backup-Screenshot oder Video.

---

## 2. Zeitplan

| # | Kapitel | Märchenszene | Inhalt | Lead | Min. | Uhr (Ende) |
|---|---|---|---|---|---|---|
| 0 | **Prolog** | Es war einmal … | Vorstellung, Rollen, Fahrplan | beide | 2 | 0:02 |
| 1 | **Die Hungersnot** | Kein Brot im Haus | Warum Spatial in der Datenbank | Gretel | 2 | 0:04 |
| 2 | **Kieselsteine im Mondlicht** | Erster Gang in den Wald | Vektormodell, Punkte, `SDO_GEOMETRY`, WKT/GeoJSON · **Demo 1** | Hänsel → Gretel → Hänsel | 5 | 0:09 |
| 3 | **Brotkrumen und hungrige Vögel** | Zweiter Gang, Vögel picken | Linien, Länge, Toleranz, Validierung | Hänsel / Gretel | 4 | 0:13 |
| 4 | **Verirrt! Wo sind wir?** | Dritter Morgen im Wald | Koordinatensysteme, SRID, X/Y-Falle, `SDO_CS.TRANSFORM` | Gretel | 6 | 0:19 |
| 5 | **Das Lebkuchenhaus auf der Lichtung** | Vöglein, Knusperhaus | Polygone mit Loch, Ringorientierung, topologische Beziehungen · **Demo 2** | Gretel → Hänsel | 6 | 0:25 |
| 6 | **Die feine Witterung der Hexe** | Hexe riecht Kinder | `SDO_WITHIN_DISTANCE`, `SDO_NN`, `SDO_DISTANCE`, Einheiten | Hänsel / Gretel | 5 | 0:30 |
| 7 | **Das Knöchlein** | Hänsel im Stall | R-Baum, MBR, Primär-/Sekundärfilter, `SPATIAL_INDEX_V2` · **Demo 3** | Gretel | 6 | 0:36 |
| 8 | **Die weiße Ente** | Großes Wasser, Heimweg | Linie schneidet Fläche, APEX Maps, Ausblick Network Data Model · **Demo 4** | Hänsel | 4 | 0:40 |
| 9 | **Epilog** | Perlen und Edelsteine | 8 Takeaways, Ressourcen | beide | 2 | 0:42 |
| – | **Q&A** | „Dort läuft eine Maus …“ | Fragen | beide | 3 | 0:45 |

**Puffer:** Kapitel 1 und der Ausblick in Kapitel 8 lassen sich spontan kürzen (zusammen −1,5 Min.). Wird es knapp, Demo 1 durch einen Screenshot ersetzen (−1 Min.).

---

## 3. Folienplan (≈ 38 Folien + Backup)

Legende: 📖 Kapitelbild · 💡 Konzept · 🧙 Zauberspruch (SQL) · 🧪 Demo · ⚠️ „Die Hexe schlägt zu“ · ❓ Interaktion

### Prolog (2 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 1 | 📖 | **Hänsel und Gretel im Geodatenwald** | Titel, Untertitel „Oracle Spatial Grundlagen“, beide Namen + Firmen, Märchenbuch-Illustration | beide |
| 2 | – | Safe Harbor Statement | Pflichtfolie Oracle | Gretel |
| 3 | 💡 | Es war einmal … | Wer ist Gretel, wer ist Hänsel? Fotos als Scherenschnitt- oder Märchenfiguren. Dialog: „Ich glaube, wir haben uns verlaufen.“ / „Wir haben eine Datenbank dabei.“ | beide |
| 4 | 💡 | Die Märchenkarte | Agenda als Wanderkarte mit 9 Stationen (Icons: leerer Brotkorb, Kieselstein, Brotkrume, Kompass, Lebkuchenhaus, Hexennase, Knochen, Ente, Schatztruhe) | Hänsel |

### Kapitel 1 – Die Hungersnot (2 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 5 | 📖 | Die Hungersnot | Szene: leerer Brotkorb. „Kein Budget für ein extra GIS?“ | Hänsel |
| 6 | 💡 | Spatial ist schon da | In jeder Oracle-Datenbank, ohne Zusatzlizenz (seit 12/2019), auch Autonomous und 26ai Free · ein SQL, eine Security, ein Backup · offene Standards (OGC, ISO SQL/MM), WKT/GeoJSON | Gretel |

### Kapitel 2 – Kieselsteine im Mondlicht (5 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 7 | 📖 | Kieselsteine im Mondlicht | Nachtszene, leuchtende Steine | Hänsel |
| 8 | 💡 | Die Welt als Punkt, Linie, Fläche | Vektormodell mit Märchenobjekten: Kieselstein, Weg, Wald. Multi-Typen in einer Zeile. | Gretel |
| 9 | 💡 | Anatomie von `SDO_GEOMETRY` | Schatzkiste mit 5 Fächern: GTYPE, SRID, POINT, ELEM_INFO, ORDINATES. GTYPE-Codes 2001/2002/2003 | Gretel |
| 10 | 🧙 | Drei Wege zum Kieselstein | Konstruktor · WKT · GeoJSON (+ `TO_GEOJSON` zurück) | Gretel |
| 11 | 🧪 | **Demo 1:** Hänsel legt Kieselsteine | Tabelle, Inserts, Punkte erscheinen auf der Nachtkarte | Hänsel |

### Kapitel 3 – Brotkrumen und hungrige Vögel (4 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 12 | 📖 | Brotkrumen | Vögel picken eine gestrichelte Linie. Gag: „Die Kieselsteine waren committed.“ | Hänsel |
| 13 | 🧙 | Vom Punkt zum Weg | `LINESTRING`, Reihenfolge der Stützpunkte, `SDO_GEOM.SDO_LENGTH` in Metern | Gretel |
| 14 | ⚠️ | Wenn die Vögel kommen | Toleranz (0.05 = 5 cm), `VALIDATE_GEOMETRY_WITH_CONTEXT`, `RECTIFY_GEOMETRY` · Mini-Warnbox: Komma statt Punkt bei deutscher NLS-Einstellung | Gretel / Hänsel |

### Kapitel 4 – Verirrt! Wo sind wir? (6 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 15 | 📖 | Verirrt am dritten Morgen | Kinder vor Wegweiser mit lauter Zahlen | Hänsel |
| 16 | 💡 | Globus oder Landkarte? | Geografisch (Grad) vs. projiziert (Meter), Bild Globus ↔ Wanderkarte | Gretel |
| 17 | 💡 | Der SRID ist der Personalausweis | 4326 · 3857 · 25832 (+ Gauß-Krüger als Altlast), wofür man welches verwendet | Gretel |
| 18 | ❓⚠️ | Hand hoch! | „Wer hat schon einmal Länge und Breite vertauscht?“ → Karte: Reichswald → Bosaso (Somalia), ~5.500 km. **X = Länge, Y = Breite** | beide |
| 19 | ⚠️🧙 | SRID `NULL` und Transformation | Entfernung „0,095“ ohne SRID vs. Meter mit 4326 · `SDO_CS.TRANSFORM(geom, 25832)` | Gretel |

### Kapitel 5 – Das Lebkuchenhaus auf der Lichtung (6 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 20 | 📖 | Knusper, knusper, Knäuschen | Weißes Vöglein, Lebkuchenhaus (Nürnberg-Bezug) | Hänsel |
| 21 | 💡 | Wald mit Lichtung | Polygon mit äußerem und innerem Ring, Orientierung (gegen / mit dem Uhrzeigersinn), WKT-Beispiel | Gretel |
| 22 | ❓ | Quiz: Liegt das Hexenhaus im Wald? | Abstimmung per Handzeichen, dann Auflösung: **DISJOINT** | beide |
| 23 | 💡 | Wie Dinge zueinander liegen | Bildtafel der Beziehungen mit Märchenobjekten: INSIDE, COVEREDBY, TOUCH, CONTAINS, OVERLAP, EQUAL, ANYINTERACT, DISJOINT | Gretel |
| 24 | 🧪 | **Demo 2:** Wo steht das Hexenhaus? | `SDO_GEOM.RELATE(... 'DETERMINE' ...)` für alle Orte, `SDO_INSIDE`, Karte mit Lichtungs-Loch | Hänsel |

### Kapitel 6 – Die feine Witterung der Hexe (5 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 25 | 📖 | „Ich rieche Kinder!“ | Hexe mit Nase, Geruchskreise | Gretel (Hexenstimme) |
| 26 | 🧙 | Wer ist in der Nähe? | `SDO_WITHIN_DISTANCE` 500 m. Ergebnis enthält **Rotkäppchen** → Gag Datenqualität | Hänsel |
| 27 | 🧙 | Wer ist am nächsten? | `SDO_NN` + `SDO_NN_DISTANCE`, Hinweis `sdo_batch_size` bei Zusatzfiltern, braucht Index | Gretel |
| 28 | 🧙 | Wie weit ist es nach Hause? | `SDO_GEOM.SDO_DISTANCE` → ≈ 7,3 km. Merksatz: **immer `unit=` angeben** | Hänsel |

### Kapitel 7 – Das Knöchlein (6 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 29 | 📖 | Streck deine Finger heraus! | Hexe tastet durch Gitter, Hänsel hält Knochen (Requisite) | Hänsel |
| 30 | 💡 | Ohne Index: jeden Finger abtasten | Full Scan über 1 Mio. Bäume. Operatoren funktionieren auch ohne Index, aber langsam (außer `SDO_NN`) | Gretel |
| 31 | 💡 | Grob tasten, genau hinschauen | R-Baum als Stammbaum aus Waldstücken. MBR · Primärfilter (Knöchlein!) → Sekundärfilter. Grafik: runde Lichtung im Rechteck, Knochen in den Ecken | Gretel |
| 32 | 🧙 | Index anlegen | `USER_SDO_GEOM_METADATA` + `INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2` | Gretel |
| 33 | 🧪 | **Demo 3:** Die Hexe bekommt eine Brille | Gleiche Abfrage ohne/mit Index (Zeit + Plan); `SDO_FILTER` vs. `SDO_ANYINTERACT` → Differenz = Knöchlein | Gretel |

### Kapitel 8 – Die weiße Ente (4 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 34 | 📖 | Kein Steg und keine Brücke | Ente am großen Wasser | Hänsel |
| 35 | 🧙 | Kreuzt der Heimweg das Wasser? | `SDO_ANYINTERACT` Linie gegen Fläche | Gretel |
| 36 | 🧪 | **Demo 4:** Der Geodatenwald in APEX Maps | Alle Ebenen der Geschichte auf einer Karte, Klick aufs Hexenhaus zeigt Entfernung nach Hause. Kurzer Ausblick: Routing mit dem Network Data Model | Hänsel |

### Epilog + Q&A (2 + 3 Min.)
| Nr. | Typ | Titel | Inhalt / Visual | Sprecher |
|---|---|---|---|---|
| 37 | 💡 | Perlen und Edelsteine zum Mitnehmen | 8 Takeaways als Edelsteine in einer Schürze (siehe Storybook) | beide abwechselnd |
| 38 | – | Der Weg aus dem Wald | Doku-Links, LiveLabs, GitHub-Repo mit Skripten (QR-Code), Kontakt | Hänsel |
| 39 | ❓ | … dann querien sie noch heute | „Mein Vortrag ist aus, dort läuft eine Maus …“ → Fragen | beide |

### Backup-Folien (nicht im Hauptfluss)
- B1: Tabelle aller GTYPE-Codes und ELEM_INFO-Triplets
- B2: Index-Parameter (`layer_gtype`, `sdo_indx_dims`, partitionierte/lokale Indizes)
- B3: Datenimport (ogr2ogr/GDAL, Shapefile/GeoJSON, `SDO_UTIL.FROM_GEOJSON`, OSM-Daten)
- B4: Ausblick 26ai: räumliche Filter kombiniert mit AI Vector Search (hybride Abfragen). Nur falls im Q&A gefragt; vorher Fakten prüfen.
- B5–B8: Screenshots aller vier Demos (Fallback)

---

## 4. Sprecheraufteilung

| | Gretel (Oracle) | Hänsel (Knut, enignum.ai) |
|---|---|---|
| **Schwerpunkt** | Konzepte und Interna: `SDO_GEOMETRY`, SRID, Topologie, Index | Praxis: Fragen aus Projekten, Daten laden, Demos, APEX Maps |
| **Kapitel-Lead** | K1, K4, K5 (Konzept), K7 | K2 (Szene + Demo), K3, K6, K8 |
| **Demos** | Demo 3 (Index) | Demo 1, 2, 4 |
| **Märchenmomente** | Hexenstimme in K6, „Stoß in den Ofen“ als Übergang K7 → K8 | Kieselsteine fallen lassen (Prolog/K2), Knöchlein hochhalten (K7) |
| **Redeanteil (ca.)** | 50 % | 50 % |

Das passt zur Vorlage: Im Märchen sammelt Hänsel die Kieselsteine und lässt den Knochen tasten, und Gretel überlistet am Ende die Hexe.

---

## 5. Demo-Plan

| Demo | Kapitel | Dauer | Werkzeug | Vorbereitete Daten | Fallback |
|---|---|---|---|---|---|
| 1 – Kieselsteine | K2 | 1,5 Min. | SQL-Editor + APEX-Kartenseite (Auto-Refresh) | leere Tabelle `KIESELSTEINE` | Screenshot B5 |
| 2 – Hexenhaus im Wald? | K5 | 2 Min. | SQL-Editor + Karte | `ORTE`, `WALD` (mit Lichtung) | Screenshot B6 |
| 3 – Index | K7 | 2 Min. | SQL-Editor mit Zeitmessung + Ausführungsplan | `BAEUME` (1 Mio. Punkte) mit und ohne Index (zwei Tabellen, damit kein Index-Build live läuft) | Video/Screenshot B7 |
| 4 – APEX Maps | K8 | 2 Min. | APEX-App „Geodatenwald“ | alle Tabellen inkl. `GEWAESSER`, `WALDBEWOHNER` | Video B8 |

**Hinweise**
- SQL vorher in Snippets bzw. Skripten ablegen und nichts live tippen. Großer Font (≥ 20 pt) und helles Theme im Editor.
- Index-Demo vorab mehrfach messen, Werte notieren, Caches „anwärmen“ oder bewusst kalt halten (aber einheitlich).
- Offline-Variante: lokale DB (z. B. Oracle AI Database 26ai Free im Container) mit Hintergrundkarte, die auch ohne Konferenz-WLAN funktioniert. Andernfalls nur auf die Daten-Ebenen setzen.
- Skripte zum Erzeugen aller Demo-Daten gehören in `scripts/`, Rohdaten (z. B. OSM-Extrakt) in `data/`.

---

## 6. Bildsprache und Folien-Design

**Leitidee:** Ein aufgeschlagenes Märchenbuch, in dem eine Karte wächst.

- **Kapitelbilder:** Vollflächige Illustration, Kapitelnummer als Initiale (Schmuckbuchstabe), eine Zeile Märchentext. Danach folgen sofort die Inhaltsfolien.
- **Inhaltsfolien:** Ruhiger Papier- bzw. Pergament-Hintergrund, viel Weißraum, ein Gedanke pro Folie.
- **Zaubersprüche (SQL):** Einheitliche Codebox mit kleinem Label „🧙 Zauberspruch“. Wichtige Teile farbig hervorheben, maximal ca. 12 Zeilen pro Folie.
- **Warnboxen „Die Hexe schlägt zu“:** Rote Box mit Hexen-Icon, immer gleiche Position.
- **Die wachsende Karte:** Eine Übersichtskarte im handgezeichneten Stil, nach jedem Kapitel kommt eine Ebene hinzu (Kieselsteine → Pfad → Wald → Lichtung → Hexenhaus → Geruchskreis → Wasser → Heimweg).
- **Icon-Set (Geometrie ↔ Märchen):** Punkt = Kieselstein · Linie = Brotkrumenspur · Fläche = Wald · Loch = Lichtung · MBR = Gitter des Stalls · Index = Stammbaum.

**Farbpalette (Vorschlag)**

| Rolle | Farbe | Hex |
|---|---|---|
| Waldgrün (Primär) | dunkles Tannengrün | `#2F5D3A` |
| Lebkuchen (Sekundär) | warmes Braun | `#8B5A2B` |
| Mondlicht (Hintergrund Nacht) | kühles Silberblau | `#C9D6E3` |
| Papier (Hintergrund Tag) | Elfenbein | `#F7F1E3` |
| Hexenrot (Warnung / Akzent) | Oracle-Rot | `#C74634` |

Das Oracle-Rot dient zugleich als Hexenfarbe. Damit passt die Märchenwelt zur Corporate-Vorlage.

**Typografie:** Fließtext in der Schrift der Oracle-Vorlage. Für Kapiteltitel optional eine Fraktur- oder Märchenschrift (z. B. *UnifrakturMaguntia*, Google Fonts), aber nur auf Kapitelbildern.

**Illustrationen, zwei Optionen**
1. **Gemeinfreie historische Märchenillustrationen** (z. B. Arthur Rackham, Alexander Zick) über Wikimedia Commons. Lizenzstatus je Bild prüfen.
2. **Eigens erstellter Illustrationssatz** in einheitlichem Stil (Aquarell oder Scherenschnitt), z. B. KI-generiert. Firmenrichtlinien von Oracle bzw. DOAG zu KI-Bildern beachten. Prompts entlang der „Bild“-Abschnitte im Storybook.

**Vorlage:** Oracle-Corporate-Template als Basis (Safe-Harbor-Folie Pflicht), ggf. DOAG-Vorgaben für Titel- und Abschlussfolie prüfen.

---

## 7. Vorbereitung und offene Punkte

- [ ] Storybook und Struktur mit Knut abstimmen (Rollen, Redeanteile, Demos)
- [ ] Demo-Umgebung festlegen (Cloud vs. lokal, APEX-Version)
- [ ] Demo-Datenskripte schreiben (`scripts/`) und Daten erzeugen (`data/`)
- [ ] Illustrationsstil entscheiden und Bilder erstellen (`images/`)
- [ ] Folien im Oracle-Template bauen (`presentation/`)
- [ ] Fakten-Check (siehe Storybook, Abschnitt 6)
- [ ] Zwei vollständige Probedurchläufe mit Stoppuhr, Ziel: 41–42 Min.
- [ ] Backup-Screenshots bzw. Videos aller Demos
- [ ] Requisiten besorgen (Kieselsteine, Knochen, Lebkuchen); Kostüm optional
- [ ] GitHub-Repo mit Skripten veröffentlichen, QR-Code auf Folie 38
