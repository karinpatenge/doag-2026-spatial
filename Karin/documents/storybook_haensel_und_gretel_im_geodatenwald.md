# Hänsel und Gretel im Geodatenwald – Das Storybook

**Vortrag:** Hänsel und Gretel im Geodatenwald – Oracle Spatial Grundlagen\
**Event:** DOAG Konferenz + Ausstellung 2026, Nürnberg (November 2026)\
**Dauer:** 45 Minuten (ca. 42 Min. Vortrag + 3 Min. Q&A)\
**Sprache:** Deutsch\
**Rollen:** Gretel: Product Manager Oracle Spatial, Oracle; Hänsel: Knut Göttling, enignum.ai\
**Stand:** 26.10.2026 – Entwurf v0.1

---

## 1. Der rote Faden in einem Satz

Zwei Kinder verlaufen sich im Wald und finden mit Kieselsteinen, Brotkrumen, einem weißen Vöglein und einer weißen Ente den Weg zum Hexenhaus und wieder nach Hause. **Jede Station des Märchens beantwortet eine räumliche Frage. Wir lösen sie live mit Oracle Spatial in Oracle AI Database 26ai.**

Das Märchen gibt die Reihenfolge der Inhalte vor. Die Konzepte bauen aufeinander auf, wie die Geschichte selbst:

| Märchen | Räumliche Frage | Spatial-Konzept |
|---|---|---|
| Hungersnot im Land | Brauchen wir ein teures GIS? | Spatial ist in jeder Oracle-Datenbank enthalten |
| Kieselsteine im Mondlicht | Wie speichere ich einen Ort? | Punkte, `SDO_GEOMETRY` |
| Brotkrumen und hungrige Vögel | Wie speichere ich einen Weg? | Linien, Toleranz, Validierung |
| Verirrt am dritten Morgen | Wo sind wir eigentlich? | Koordinatensysteme, SRID |
| Das Lebkuchenhaus auf der Lichtung | Liegt das Haus im Wald? | Polygone mit Loch, topologische Beziehungen |
| Die Hexe hat eine feine Witterung | Wer ist in der Nähe? | `SDO_WITHIN_DISTANCE`, `SDO_NN`, `SDO_DISTANCE` |
| Das Knöchlein | Wie geht das schnell und zuverlässig? | Räumlicher Index, Primär- und Sekundärfilter |
| Die weiße Ente | Wie kommen wir nach Hause und zeigen es allen? | Linie schneidet Fläche, APEX Maps |

---

## 2. Die Besetzung

| Figur | Gespielt von / steht für | Rolle im Vortrag |
|---|---|---|
| **Gretel** | Product Manager Oracle Spatial (Oracle) | Die Kluge, die die Hexe am Ende überlistet. Sie erklärt, *wie* Oracle Spatial funktioniert: `SDO_GEOMETRY`, SRIDs, Operatoren, Index. |
| **Hänsel** | Knut Göttling (enignum.ai) | Der Praktiker, der Kieselsteine sammelt und Wege legt. Er stellt die Fragen aus der Praxis, lädt Daten und zeigt die Demos. |
| **Die Hexe** | Alle typischen Fallstricke | Vertauschte Koordinaten, fehlendes SRID, ungültige Geometrien, fehlender Index. Tritt als Illustration (oder Handpuppe) mit einer roten Warnbox auf: „Die Hexe schlägt zu!“ |
| **Der Holzhacker (Vater)** | Das Ziel | Das Haus „vor einem großen Walde“, also der Ort, zu dem der Weg nach Hause führt. |
| **Die Stiefmutter** | Die Hungersnot / das knappe Budget | Wird nur in Kapitel 1 erwähnt. Kein Budget für ein extra GIS? Kein Problem. |
| **Das weiße Vöglein** | Der Wegweiser | Führt die Kinder zum Lebkuchenhaus. Leitet die Frage „Was ist in der Nähe?“ ein. |
| **Die weiße Ente** | Die Brücke | Trägt die Kinder übers große Wasser. Steht für die Karte, die die Ergebnisse zu den Anwendern bringt (APEX Maps). |
| **Rotkäppchen** (Gastauftritt) | Ein fehlerhafter Datensatz | Taucht in einer Abfrage auf, gehört aber ins falsche Märchen. Running Gag zur Datenqualität. |

**Dialog-Muster:** *Hänsel fragt (Praxis), Gretel erklärt (Konzept), Hänsel zeigt (Demo).* Das Muster wird an einigen Stellen bewusst umgedreht, damit es nicht monoton wird. In Kapitel 7 spielt zum Beispiel Hänsel den Knöchlein-Trick und Gretel löst ihn auf.

---

## 3. Der Schauplatz: die Karte des Geodatenwalds

Der Geodatenwald ist ein **fiktiver Wald im Nürnberger Reichswald**, südöstlich von Nürnberg. So spielt die Geschichte „um die Ecke“ vom Konferenzort, und das Lebkuchenhaus bekommt einen Nürnberger Bezug.

Alle Koordinaten sind zur Illustration gewählt (WGS 84, SRID 4326, Reihenfolge **Länge, Breite**):

| Objekt | Geometrie | Koordinaten (vereinfacht) | Tabelle |
|---|---|---|---|
| Haus des Holzhackers | Punkt | 11.1700 49.4250 (westlich vor dem Wald) | `ORTE` |
| Hexenhaus (Lebkuchenhaus) | Punkt (optional Polygon) | 11.2600 49.3950 (mitten auf der Lichtung) | `ORTE` |
| Kieselsteine | Punkte | Spur vom Holzhackerhaus in den Wald | `KIESELSTEINE` |
| Brotkrumen | Punkte (mit Lücken) | Zweite Spur, teils „weggepickt“ | `BROTKRUMEN` |
| Weg nach Hause | Linie | Vom Hexenhaus zum Holzhackerhaus | `WEGE` |
| Geodatenwald | Polygon mit Loch | Rechteck 11.18–11.30 / 49.38–49.43, minus Lichtung | `WALD` |
| Lichtung | Inneres Polygon (Loch) | Kreis mit 250 m Radius um das Hexenhaus | Teil von `WALD` |
| Das große Wasser | Polygon | Zwischen Hexenhaus und Holzhackerhaus | `GEWAESSER` |
| Waldbewohner | Punkte | Hänsel, Gretel, Pilzsammler, … und Rotkäppchen | `WALDBEWOHNER` |
| Bäume | ~1 Mio. Punkte (synthetisch) | Zufällig im Wald verteilt, für die Index-Demo | `BAEUME` |

Luftlinie Hexenhaus → Holzhackerhaus: rund **7,3 km**. Dieser Wert eignet sich als Kontrollergebnis für die `SDO_DISTANCE`-Demo.

**Optional:** Statt des Rechtecks können echte Waldflächen des Reichswalds aus OpenStreetMap geladen werden (z. B. Geofabrik-Extrakt Mittelfranken, Lizenz ODbL, Quellenangabe auf der Folie).

---

## 4. Die Kapitel

### Prolog – Es war einmal … (≈ 2 Min.)

**Szene:**
> *„Vor einem großen Walde wohnte ein armer Holzhacker mit seiner Frau und seinen zwei Kindern; das Bübchen hieß Hänsel und das Mädchen Gretel.“*

Beide betreten die Bühne. Die erste Folie zeigt ein aufgeschlagenes Märchenbuch, auf der rechten Seite eine leere Karte des Geodatenwalds.

**Auf der Bühne:**
- **Hänsel:** „Gretel, ich glaube, wir haben uns verlaufen.“
- **Gretel:** „Keine Sorge, Hänsel. Wir haben eine Datenbank dabei.“
- Kurze Vorstellung: Wer ist Gretel, wer ist Hänsel im echten Leben?
- **Gretel:** „Heute begleiten wir zwei Kinder durch den Wald. Jede Station beantwortet eine Frage: Wo sind wir? Wie weit ist es? Liegt das Hexenhaus im Wald oder auf der Lichtung? Und wie finden wir das schnell heraus?“

**Bild:** Titelillustration im Märchenbuch-Stil; die Karte, die im Lauf des Vortrags Schicht für Schicht wächst, startet hier leer.

**Brücke:** „Aber warum mussten die beiden überhaupt in den Wald?“

---

### Kapitel 1 – Die Hungersnot: Warum Spatial in der Datenbank? (≈ 2 Min.)

**Szene:** Im Land herrscht große Teuerung, das Brot reicht nicht. Die Stiefmutter hat einen Plan …

**Auf der Bühne:**
- **Hänsel:** „Für ein extra GIS-System war kein Geld mehr da. Server, Lizenzen, Schnittstellen, Datenabgleich …“
- **Gretel:** „Musste es auch nicht. Spatial steckt schon in der Datenbank, die ihr ohnehin betreibt.“

**Die Spatial-Lektion:**
- Räumliche Daten gehören zu den Geschäftsdaten: Kunden, Filialen, Leitungen, Grundstücke, Fahrzeuge.
- Oracle Spatial ist Teil der Oracle-Datenbank. Seit Dezember 2019 ist es ohne Zusatzlizenz in allen Editionen enthalten, ebenso in Autonomous Database und Oracle AI Database 26ai Free.
- Ein Datenmodell, ein SQL, eine Sicherheits- und Backup-Strategie: keine Kopie der Daten in ein separates GIS.
- Orientiert an offenen Standards (OGC Simple Features, ISO SQL/MM), mit Import und Export über WKT und GeoJSON.

**Bild:** Leere Brotdose oder leerer Geldbeutel neben einem Datenbank-Symbol, aus dem ein Wald wächst.

**Brücke:** „Also gehen wir in den Wald, und Hänsel hat vorgesorgt.“

---

### Kapitel 2 – Kieselsteine im Mondlicht: Punkte und `SDO_GEOMETRY` (≈ 5 Min.)

**Szene:**
> Hänsel schleicht nachts hinaus und füllt seine Taschen mit Kieselsteinen. Auf dem Weg in den Wald lässt er einen nach dem anderen fallen. *„Und als der volle Mond aufgestiegen war, … ging [er] den Kieselsteinen nach, die schimmerten wie neu geschlagene Batzen und zeigten ihnen den Weg.“*

**Auf der Bühne:**
- **Hänsel:** „Jeder Kieselstein markiert einen Ort. Wie bringe ich so einen Ort in eine Tabelle?“
- **Gretel:** „Mit einem einzigen Datentyp: `SDO_GEOMETRY`. Damit speicherst du Punkte, Linien und Flächen.“

**Die Spatial-Lektion:**
- **Die reale Welt als Vektordaten:** Punkt (Kieselstein, Haus), Linie (Weg, Bach), Fläche (Wald, See). Dazu Multi-Varianten und Collections.
- **Anatomie von `SDO_GEOMETRY`:**
  - `SDO_GTYPE`: Typ und Dimension, z. B. `2001` = 2D-Punkt, `2002` = Linie, `2003` = Polygon, `2007` = Multipolygon
  - `SDO_SRID`: das Koordinatensystem (siehe Kapitel 4)
  - `SDO_POINT`: Abkürzung für einzelne Punkte
  - `SDO_ELEM_INFO` + `SDO_ORDINATES`: Beschreibung und Koordinatenliste für Linien und Flächen
- **Drei Wege zum Punkt:** Konstruktor, Well-Known Text (WKT), GeoJSON
- **Das Mondlicht:** Erst auf der Karte werden die Kieselsteine sichtbar. Geodaten will man sehen.

**Zauberspruch (SQL):**
```sql
CREATE TABLE kieselsteine (
  nr    NUMBER PRIMARY KEY,
  geom  SDO_GEOMETRY
);

-- 1) Klassischer Konstruktor: X = Länge, Y = Breite
INSERT INTO kieselsteine VALUES (1,
  SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(11.1712, 49.4246, NULL), NULL, NULL));

-- 2) Well-Known Text
INSERT INTO kieselsteine VALUES (2,
  SDO_GEOMETRY('POINT (11.1731 49.4239)', 4326));

-- 3) GeoJSON
INSERT INTO kieselsteine VALUES (3,
  SDO_UTIL.FROM_GEOJSON('{"type":"Point","coordinates":[11.1750,49.4231]}', NULL, 4326));

-- und wieder heraus
SELECT nr, SDO_UTIL.TO_GEOJSON(geom) AS geojson FROM kieselsteine;
```

**Demo 1 (Hänsel):** Kieselsteine einfügen. Die Punkte erscheinen „im Mondlicht“ auf der Karte (APEX-Kartenseite mit Nachtkarten-Stil).

**Bild:** Nachtszene, Kieselsteine leuchten wie Münzen. Daneben die Strukturgrafik von `SDO_GEOMETRY` als Schatzkiste mit fünf Fächern.

**Brücke:** „Beim zweiten Mal war die Tür verschlossen. Keine Kieselsteine, nur ein Stück Brot …“

---

### Kapitel 3 – Brotkrumen und hungrige Vögel: Linien und Datenqualität (≈ 4 Min.)

**Szene:**
> Hänsel bröckelt sein Brot und wirft die Krumen auf den Weg. Als der Mond aufgeht, *„fanden [sie] kein Bröcklein mehr, denn die viel tausend Vögel, die im Walde und im Felde umherfliegen, die hatten sie weggepickt.“*

**Auf der Bühne:**
- **Hänsel:** „Eigentlich wollte ich keine einzelnen Punkte, sondern einen Weg.“
- **Gretel:** „Dann speichere ihn als Linie. Und der Unterschied zwischen Kieselsteinen und Brotkrumen? Die Kieselsteine waren committed.“ *(Running Gag)*

**Die Spatial-Lektion:**
- **Linien (`LINESTRING`)** sind geordnete Folgen von Stützpunkten. Die Reihenfolge ist wichtig.
- **Länge berechnen:** `SDO_GEOM.SDO_LENGTH` liefert bei SRID 4326 echte Meter auf dem Ellipsoid.
- **Toleranz:** Ab wann liegen zwei Krumen am „selben Ort“? Bei geografischen Daten wird die Toleranz in Metern angegeben, z. B. `0.05` = 5 cm.
- **Datenqualität, wenn die Vögel zugeschlagen haben:**
  - Fehlende Punkte → Lücken im Weg
  - Doppelte Punkte → ungültige Geometrie
  - `SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT` findet solche Fehler, `SDO_UTIL.RECTIFY_GEOMETRY` repariert viele davon.

**Zauberspruch (SQL):**
```sql
CREATE TABLE wege (
  name  VARCHAR2(50) PRIMARY KEY,
  geom  SDO_GEOMETRY
);

INSERT INTO wege VALUES ('Brotkrumenpfad',
  SDO_GEOMETRY('LINESTRING (11.1700 49.4250, 11.1850 49.4210, 11.2010 49.4150, 11.2150 49.4090)', 4326));

-- Wie lang war der Weg?
SELECT name, ROUND(SDO_GEOM.SDO_LENGTH(geom, 0.05, 'unit=M')) AS meter
FROM   wege;

-- Haben die Vögel Unordnung gestiftet?
SELECT name, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(geom, 0.05) AS befund
FROM   wege;
```

**Die Hexe schlägt zu (Warnbox):** In einer deutschen Session wird `11.17` per `TO_CHAR` schnell zu `11,17`. Wer WKT per String-Verkettung baut, sollte das Dezimaltrennzeichen explizit festlegen (`NLS_NUMERIC_CHARACTERS`).

**Bild:** Vögel picken eine gestrichelte Linie auf. Die Lücken sind rot markiert.

**Brücke:** „Am dritten Morgen wussten sie nicht mehr, wo sie waren …“

---

### Kapitel 4 – Verirrt! Wo sind wir? Koordinatensysteme und SRID (≈ 6 Min.)

**Szene:** Drei Tage irren die Kinder durch den Wald. Sie werden immer hungriger und kommen immer tiefer hinein.

**Auf der Bühne:**
- **Hänsel:** „Mein Handy sagt 49,4 und 11,2. Sind wir jetzt in Nürnberg?“
- **Gretel:** „Das hängt davon ab, *welche* Zahlen das sind und in welcher Reihenfolge. Koordinaten ohne Koordinatensystem sind wie ein Märchen ohne Anfang.“

**Die Spatial-Lektion:**
- **Geografisch vs. projiziert:** Länge und Breite in Grad auf dem Globus, oder Rechts- und Hochwert in Metern auf einer flachen Karte.
- **SRID ist der Personalausweis der Koordinaten:**
  - `4326`: WGS 84, GPS, Länge/Breite in Grad
  - `3857`: WGS 84 / Pseudo-Mercator, für Web-Kartenkacheln
  - `25832`: ETRS89 / UTM Zone 32N, Meter, amtliche Geodaten in Deutschland (auch in Bayern)
  - Altbestände in Gauß-Krüger (z. B. `31468`) kommen noch vor.
- **Die Hexe schlägt zu #1: Länge und Breite vertauscht.** In Oracle (und in WKT/GeoJSON) gilt **X = Länge, Y = Breite**. Mit vertauschten Werten landet das Holzhackerhaus bei Bosaso in Somalia, am Golf von Aden, gut 5.500 km vom Reichswald entfernt.
- **Die Hexe schlägt zu #2: kein SRID (`NULL`).** Dann rechnet die Datenbank kartesisch, und die Entfernung zum Hexenhaus beträgt „0,095“ … Grad? Das ist sinnlos.
- **Umrechnen:** `SDO_CS.TRANSFORM` überführt Geometrien von einem System in ein anderes.

**Zauberspruch (SQL):**
```sql
-- Richtig: X = Länge, Y = Breite
SELECT SDO_GEOMETRY('POINT (11.1700 49.4250)', 4326) FROM dual;  -- Reichswald

-- Die Hexe war da: vertauscht
SELECT SDO_GEOMETRY('POINT (49.4250 11.1700)', 4326) FROM dual;  -- Somalia

-- Vom Globus auf die Landkarte: WGS 84 → UTM 32N (Meter)
SELECT name, SDO_CS.TRANSFORM(geom, 25832) AS geom_utm
FROM   orte
WHERE  name = 'Hexenhaus';
```

**Interaktion:** „Hand hoch: Wer hat schon einmal Längen- und Breitengrad vertauscht?“ (Gretel und Hänsel heben selbst als Erste die Hand.)

**Bild:** Zweigeteilte Folie. Links der Globus mit Gradnetz, rechts eine Wanderkarte mit Meterraster. Dazu eine Weltkarte mit Pfeil vom Reichswald nach Somalia: „Falsch abgebogen!“

**Brücke:** „Da sahen sie ein schönes, schneeweißes Vöglein auf einem Ast sitzen …“

---

### Kapitel 5 – Das Lebkuchenhaus auf der Lichtung: Flächen und topologische Beziehungen (≈ 6 Min.)

**Szene:**
> Das weiße Vöglein singt so schön, dass die Kinder ihm folgen, bis zu einem Häuschen *„aus Brot gebaut und mit Kuchen gedeckt“*, die Fenster aus hellem Zucker.
> *„Knusper, knusper, Knäuschen, wer knuspert an meinem Häuschen?“ – „Der Wind, der Wind, das himmlische Kind.“*

**Auf der Bühne:**
- **Hänsel:** „Ein Lebkuchenhaus, wir sind also definitiv in Nürnberg. Aber steht es noch im Wald oder schon auf der Lichtung?“
- **Gretel:** „Dazu müssen wir erst wissen, wie ein Wald mit Lichtung in der Datenbank aussieht.“

**Die Spatial-Lektion:**
- **Polygone** bestehen aus Ringen: einem **äußeren Ring** (Waldrand) und optional **inneren Ringen**, also Löchern (die Lichtung).
- **Orientierung:** Der äußere Ring läuft gegen den Uhrzeigersinn, innere Ringe im Uhrzeigersinn. Erster und letzter Punkt sind identisch.
- **Die Lichtung gehört nicht zum Wald.** Ein Punkt auf der Lichtung liegt *nicht* im Wald-Polygon.
- **Topologische Beziehungen** (vereinfachtes 9-Intersection-Modell): `INSIDE`, `COVEREDBY`, `CONTAINS`, `COVERS`, `TOUCH`, `OVERLAPBDYINTERSECT`, `EQUAL`, `ON`, `ANYINTERACT` und `DISJOINT`.
- **Werkzeuge:**
  - Operator `SDO_RELATE` (oder die Kurzformen `SDO_INSIDE`, `SDO_ANYINTERACT` usw.) in der `WHERE`-Klausel: „Finde alle Objekte, die …“
  - Funktion `SDO_GEOM.RELATE(..., 'DETERMINE', ...)`: „Wie hängen diese zwei Objekte zusammen?“
  - `SDO_GEOM.SDO_AREA` berechnet die Fläche, `SDO_GEOM.SDO_BUFFER` erzeugt z. B. eine runde Lichtung um das Hexenhaus.

**Zauberspruch (SQL):**
```sql
CREATE TABLE wald (
  name  VARCHAR2(50) PRIMARY KEY,
  geom  SDO_GEOMETRY
);

-- Vereinfacht: Wald als Rechteck, Lichtung als rechteckiges Loch
INSERT INTO wald VALUES ('Geodatenwald', SDO_GEOMETRY(
  'POLYGON ((11.18 49.38, 11.30 49.38, 11.30 49.43, 11.18 49.43, 11.18 49.38),
            (11.25 49.39, 11.25 49.40, 11.27 49.40, 11.27 49.39, 11.25 49.39))', 4326));

-- Im Demo-Datensatz: runde Lichtung (250 m um das Hexenhaus) aus dem Wald ausstanzen
-- SDO_GEOM.SDO_DIFFERENCE(wald_rechteck,
--   SDO_GEOM.SDO_BUFFER(hexenhaus, 250, 0.05, 'unit=M'), 0.05)

-- Wie hängen Orte und Wald zusammen?
SELECT o.name,
       SDO_GEOM.RELATE(o.geom, 'DETERMINE', w.geom, 0.05) AS beziehung
FROM   orte o, wald w;
-- Hexenhaus  → DISJOINT  (auf der Lichtung!)
-- Kieselstein im Wald → INSIDE

-- Welche Orte liegen im Wald?
SELECT o.name
FROM   orte o, wald w
WHERE  SDO_INSIDE(o.geom, w.geom) = 'TRUE';
```

**Interaktion (Quiz):** „Liegt das Hexenhaus im Wald? Hand hoch für Ja!“ Danach die Auflösung: `DISJOINT`. Das Haus steht auf der Lichtung, also im Loch, und damit nicht im Wald.

**Demo 2 (Hänsel, Gretel kommentiert):** `DETERMINE` für alle Orte. Auf der Karte erscheint das Wald-Polygon mit dem Lichtungs-Loch.

**Bild:** Draufsicht auf den Wald mit Lichtung, das Lebkuchenhaus im Loch. Daneben eine Bildtafel der Beziehungen, gezeichnet mit Märchenobjekten (Haus im Wald = INSIDE, Haus am Waldrand = TOUCH, Haus auf der Lichtung = DISJOINT).

**Brücke:** „Die Alte war aber eine böse Hexe … und sie hatte eine feine Witterung.“

---

### Kapitel 6 – Die Hexe hat eine feine Witterung: Nähe und Entfernung (≈ 5 Min.)

**Szene:**
> *„Die Hexen haben rote Augen und können nicht weit sehen, aber sie haben eine feine Witterung wie die Tiere und merken's, wenn Menschen herankommen.“*

**Auf der Bühne:**
- **Gretel (mit Hexenstimme oder Handpuppe):** „Ich rieche Kinder! Wer ist im Umkreis von 500 Metern? Und wer ist mir am nächsten?“
- **Hänsel:** „Und wie weit ist es eigentlich bis nach Hause?“

**Die Spatial-Lektion:**
- **Wer ist in der Nähe?** `SDO_WITHIN_DISTANCE` findet alle Objekte innerhalb einer Entfernung.
- **Wer ist am nächsten?** `SDO_NN` (Nearest Neighbor) liefert die *n* nächsten Objekte, `SDO_NN_DISTANCE` die jeweilige Entfernung. `SDO_NN` braucht einen räumlichen Index.
- **Wie weit ist es?** `SDO_GEOM.SDO_DISTANCE` berechnet die Entfernung zwischen zwei Geometrien, bei SRID 4326 geodätisch korrekt in Metern oder Kilometern.
- **Einheiten immer angeben:** `unit=M`, `unit=KM` … Die Hexe rechnet sonst in Grad.
- **Running Gag:** In der Ergebnisliste taucht **Rotkäppchen** auf. Falsches Märchen, also ein falscher Datensatz: Datenqualität ist keine Kür.

**Zauberspruch (SQL):**
```sql
-- Wer ist im Umkreis von 500 m um das Hexenhaus?
SELECT w.name
FROM   waldbewohner w, orte h
WHERE  h.name = 'Hexenhaus'
AND    SDO_WITHIN_DISTANCE(w.geom, h.geom, 'distance=500 unit=M') = 'TRUE';

-- Wer ist der Hexe am nächsten?
SELECT w.name, ROUND(SDO_NN_DISTANCE(1)) AS meter
FROM   waldbewohner w, orte h
WHERE  h.name = 'Hexenhaus'
AND    SDO_NN(w.geom, h.geom, 'sdo_num_res=3 unit=M', 1) = 'TRUE'
ORDER  BY meter;

-- Wie weit ist es bis nach Hause?
SELECT ROUND(SDO_GEOM.SDO_DISTANCE(a.geom, b.geom, 0.05, 'unit=KM'), 1) AS km
FROM   orte a, orte b
WHERE  a.name = 'Hexenhaus'
AND    b.name = 'Haus des Holzhackers';      -- ≈ 7,3 km
```

**Hinweis für die Folie:** Kommen weitere Filter hinzu (z. B. „nur Kinder“), `sdo_batch_size` statt `sdo_num_res` verwenden und die Zeilen über `FETCH FIRST`/`ROWNUM` begrenzen. Sonst liefert `SDO_NN` unter Umständen zu wenige Treffer.

**Bild:** Hexe mit großer Nase, darum konzentrische „Geruchskreise“ (500 m, 1 km). Die Kinder als Punkte, der nächste ist hervorgehoben.

**Brücke:** „Die Hexe sperrte Hänsel in einen Stall und wollte ihn mästen. Aber sehen konnte sie ja schlecht …“

---

### Kapitel 7 – Das Knöchlein: Räumliche Indizes (≈ 6 Min.)

**Szene:**
> Jeden Morgen ruft die Hexe: *„Hänsel, streck deine Finger heraus, damit ich fühle, ob du bald fett bist.“* Hänsel streckt ihr aber ein Knöchlein hin, und die Alte mit ihren trüben Augen merkt es nicht.

**Auf der Bühne:**
- **Hänsel (hält einen Knochen hoch):** „Vier Wochen lang hat sie es nicht gemerkt!“
- **Gretel:** „Weil sie nur grob tastet und nie genau hinschaut. Genau so arbeitet ein räumlicher Index, nur dass Oracle danach *doch* genau hinschaut.“

**Die Spatial-Lektion:**
- **Ohne Index** tastet die Hexe *jeden Finger im ganzen Wald* einzeln ab, ein Full Table Scan. Die räumlichen Operatoren funktionieren zwar auch ohne Index (Ausnahme: `SDO_NN`), aber bei Millionen Bäumen wird es zäh.
- **Der R-Baum:** Jede Geometrie bekommt ein umschließendes Rechteck (MBR, Minimum Bounding Rectangle). Rechtecke werden zu größeren Rechtecken gruppiert, wie Bäume zu Waldstücken und Waldstücke zum Wald.
- **Zweistufige Abfrage:**
  1. **Primärfilter** (Index, MBR-Vergleich): schnell, aber grob. Es gibt Kandidaten, die nur *fast* passen. Das ist das Knöchlein.
  2. **Sekundärfilter** (exakte Geometrie): Hier schaut man genau hin, und der Knochen fliegt raus.
- `SDO_FILTER` nutzt **nur** den Primärfilter: schnell, aber leicht zu täuschen. `SDO_RELATE`/`SDO_ANYINTERACT` machen beides.
- **Index anlegen:** Metadaten in `USER_SDO_GEOM_METADATA` eintragen (Dimensionen, Toleranz, SRID), dann `INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2`. Das ist die empfohlene, systemverwaltete Variante seit 12.2.

**Zauberspruch (SQL):**
```sql
-- 1) Metadaten
INSERT INTO user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
VALUES ('BAEUME', 'GEOM',
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('Longitude', -180, 180, 0.05),
    SDO_DIM_ELEMENT('Latitude',   -90,  90, 0.05)),
  4326);

-- 2) Index
CREATE INDEX baeume_sidx ON baeume (geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
  PARAMETERS ('layer_gtype=POINT');

-- 3) Grob (nur Primärfilter): Bäume im Rechteck um die runde Lichtung,
--    inklusive „Knöchlein“ in den Ecken
SELECT COUNT(*) FROM baeume b, lichtung l
WHERE  SDO_FILTER(b.geom, l.geom) = 'TRUE';

-- 4) Genau (Primär- + Sekundärfilter): nur Bäume wirklich auf der Lichtung
SELECT COUNT(*) FROM baeume b, lichtung l
WHERE  SDO_ANYINTERACT(b.geom, l.geom) = 'TRUE';
```

**Demo 3 (Gretel):** Eine Million Bäume. Dieselbe Abfrage ohne und mit Index, Laufzeit und Ausführungsplan nebeneinander. Danach `SDO_FILTER` gegen `SDO_ANYINTERACT`: Die Differenz sind die Knöchlein.

**Bild:** Hexe tastet durch Gitterstäbe. Darüber liegt eine Grafik: runde Lichtung in einem Rechteck (MBR), die Bäume in den Ecken als Knochen-Icons markiert. Daneben der R-Baum als Stammbaum aus Waldstücken.

**Brücke:** „Und dann gab Gretel der Hexe einen Stoß … Die Kinder fanden Perlen und Edelsteine. Jetzt mussten sie nur noch nach Hause.“

---

### Kapitel 8 – Perlen, Edelsteine und die weiße Ente: der Weg nach Hause mit APEX Maps (≈ 4 Min.)

**Szene:**
> Nach ein paar Stunden kommen die Kinder an ein großes Wasser. *„Ich seh keinen Steg und keine Brücke.“* Aber da schwimmt eine weiße Ente: *„Entchen, Entchen, da steht Gretel und Hänsel. Kein Steg und keine Brücke, nimm uns auf deinen weißen Rücken.“*

**Auf der Bühne:**
- **Hänsel:** „Kreuzt unser Heimweg das Wasser? Das hätte ich gern *vorher* gewusst.“
- **Gretel:** „Linie gegen Fläche, eine Frage für `SDO_ANYINTERACT`. Und dann zeigen wir die ganze Geschichte auf einer Karte.“

**Die Spatial-Lektion:**
- **Topologie zwischen verschiedenen Geometrietypen:** Linie schneidet Fläche, Punkt liegt auf Linie (`ON`).
- **Die Ente bringt die Daten zu den Menschen:** APEX Maps als Karten-Region in Oracle APEX.
  - Ebenen für Punkte, Linien, Polygone und Heatmaps, direkt aus `SDO_GEOMETRY`-Spalten (oder Länge/Breite, GeoJSON)
  - Hintergrundkarten, Tooltips, Legende, Zoom auf Treffer
  - Räumliche Filter direkt in der Anwendung
  - Daten am besten in SRID 4326 liefern (ggf. `SDO_CS.TRANSFORM`)
- **Ausblick (optional, 30 Sekunden):** Echte Routenberechnung über Wegenetze mit dem **Network Data Model** von Oracle Spatial. Die Ente ist dann nicht mehr nötig.

**Zauberspruch (SQL):**
```sql
-- Kreuzt der Heimweg das große Wasser?
SELECT g.name
FROM   wege w, gewaesser g
WHERE  w.name = 'Heimweg'
AND    SDO_ANYINTERACT(w.geom, g.geom) = 'TRUE';   -- „Das große Wasser“
```

**Demo 4 (Hänsel):** Die APEX-Anwendung „Geodatenwald“. Alle Ebenen aus den Kapiteln liegen auf einer Karte: Kieselsteine, Brotkrumenpfad mit Lücken, Wald mit Lichtung, Hexenhaus, Geruchskreis, großes Wasser, Heimweg. Ein Klick aufs Hexenhaus zeigt die Entfernung nach Hause.

**Bild:** Weiße Ente trägt eine Karte (Tablet) übers Wasser. Am Ufer wartet der Vater.

**Brücke:** „Der Vater hatte keine frohe Stunde gehabt, seitdem er die Kinder im Walde gelassen hatte … Nun hatte alle Sorge ein Ende.“

---

### Epilog – … dann querien sie noch heute (≈ 2 Min.)

**Szene:** Die Kinder schütten Perlen und Edelsteine aus ihren Schürzen und Taschen.

**Die Perlen zum Mitnehmen (eine pro Kapitel):**
1. **Spatial ist schon da:** in jeder Oracle-Datenbank, ohne Zusatzlizenz.
2. **Ein Datentyp für alles:** `SDO_GEOMETRY` für Punkte, Linien und Flächen. WKT und GeoJSON rein und raus.
3. **Toleranz und Validierung:** Prüfen, bevor die Vögel kommen.
4. **Immer ein SRID setzen**, und X = Länge, Y = Breite.
5. **Löcher zählen nicht:** Die Lichtung gehört nicht zum Wald. `SDO_RELATE` und Co. beantworten „Wo liegt was?“
6. **Nähe mit Einheit:** `SDO_WITHIN_DISTANCE`, `SDO_NN`, `SDO_DISTANCE` immer mit `unit=`.
7. **Ohne Index tastet die Hexe jeden Finger ab:** `SPATIAL_INDEX_V2` anlegen.
8. **Zeigen statt erzählen:** APEX Maps bringt die Ergebnisse auf die Karte.

**Auf der Bühne (Abschluss):**
- **Gretel:** „Und wenn sie nicht gestorben sind …“
- **Hänsel:** „… dann querien sie noch heute.“
- **Gretel:** „Mein Vortrag ist aus, dort läuft eine Maus.“ *(zeigt auf die Computermaus)* „Wer sie fängt, darf eine Frage stellen!“

**Q&A (≈ 3 Min.):** Folie mit Ressourcen und QR-Code zum GitHub-Repository mit allen Skripten. Optional: Nürnberger Lebkuchen für jede Frage, also „ein Stück vom Hexenhaus“.

---

## 5. Requisiten und Running Gags

| Element | Einsatz |
|---|---|
| **„Die Kieselsteine waren committed“** | Kapitel 3, wird bei Datenverlust später wieder aufgegriffen |
| **„Die Hexe schlägt zu!“** | Rote Warnbox für jeden typischen Fehler (vertauschte Koordinaten, SRID `NULL`, ungültige Geometrie, fehlender Index, Komma statt Punkt) |
| **Rotkäppchen** | Taucht in Abfrageergebnissen auf: falscher Datensatz im falschen Märchen |
| **Die wachsende Karte** | Nach jedem Kapitel kommt eine Ebene hinzu. Die letzte Demo zeigt das komplette Bild. |
| **Zaubersprüche** | Alle SQL-Beispiele sind als „Zauberspruch“ gekennzeichnet |
| **Knochen** (Requisite, optional) | Hänsel hält in Kapitel 7 einen Kunststoffknochen hoch |
| **Kieselsteine** (Requisite, optional) | Hänsel lässt beim Auftritt ein paar Steine fallen |
| **Lebkuchen** (optional) | Nürnberger Bezug und Belohnung im Q&A |
| **Kostüm** (optional, dezent) | Gretel mit Schürze oder Kopftuch, Hänsel mit Mütze oder Hosenträgern |

---

## 6. Fakten-Check vor der Finalisierung

Diese Punkte bitte vor dem Folienbau gegen die aktuelle 26ai-Dokumentation prüfen:

- [ ] Formulierung zur Lizenzierung (Spatial ohne Zusatzlizenz in allen Editionen seit Dezember 2019, inkl. Autonomous und 26ai Free)
- [ ] Ab welchem Release Operatoren als SQL-BOOLEAN ohne `= 'TRUE'` verwendet werden können (die 26ai-Doku zeigt `SDO_NN` bereits ohne Vergleich). Für die Folien einheitlich eine Schreibweise wählen.
- [ ] Ob in 26ai für `SPATIAL_INDEX_V2` ein Eintrag in `USER_SDO_GEOM_METADATA` zwingend ist. Die Doku-Beispiele legen ihn an; im Vortrag als Best Practice zeigen.
- [ ] Fehlercodes von `VALIDATE_GEOMETRY_WITH_CONTEXT` für die Brotkrumen-Beispiele (z. B. 13356 für redundante Punkte, 13349 für sich selbst schneidende Polygone) live ausprobieren
- [ ] Aktuelle APEX-Version auf der Konferenz und deren Funktionsumfang der Map-Region
- [ ] Laufzeiten der Index-Demo vorab auf der Demo-Umgebung messen und als Backup-Screenshot sichern
- [ ] Lizenzen der Illustrationen und Kartendaten (OSM: ODbL; gemeinfreie Illustrationen)
