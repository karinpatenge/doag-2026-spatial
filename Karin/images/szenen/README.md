# Szenenbilder – Hänsel und Gretel im Geodatenwald

**Inhalt:** Ein Bild pro Szene aus dem Storybook (Prolog, Kapitel 1–8, Epilog)\
**Format:** 8:9, entspricht einer Spalte einer zweispaltigen 16:9-Folie\
**PNG:** 1920 × 2160 px, transparenter Hintergrund (für PowerPoint/Keynote)\
**SVG:** Vektorversion, 960 × 1080 px Nenngröße, transparenter Hintergrund, verlustfrei skalierbar\
**Herkunft:** Eigene Vektorillustrationen, programmatisch erstellt. Keine Fremdbilder, Vorlagen oder Clipart.\
**Quellcode:** `scripts/illustrationen/` (Python + Playwright), Bilder lassen sich damit anpassen und neu erzeugen\
**Stand:** 26.10.2026 – Entwurf v0.1

## Bildliste

| Datei | Szene | Folie (Präsentationsstruktur) | Spatial-Bezug im Bild |
|---|---|---|---|
| `00_prolog_es_war_einmal` | Prolog: Pop-up-Märchenbuch, Gretel und Hänsel winken | 1/3 | Mini-Karte mit Polygon, Pfad und Pin |
| `01_hungersnot_spatial_ist_schon_da` | Kapitel 1: Holzhackerhaus, leerer Brotkorb, Datenbank mit Wald | 5 | Wald wächst aus der Datenbank |
| `02_kieselsteine_im_mondlicht` | Kapitel 2: Nachtszene, leuchtende Kieselsteine | 7 | Kieselsteine = Punkte, Label `POINT (11.17 49.42)` |
| `03_brotkrumen_und_hungrige_voegel` | Kapitel 3: Brotkrumenspur, Vögel picken | 12 | Krumen als Linie, Datenlücken rot markiert |
| `04_verirrt_wo_sind_wir` | Kapitel 4: Wegweiser mit SRIDs | 15 | Gretel mit Globus (geografisch), Hänsel mit Karte (projiziert) |
| `05_lebkuchenhaus_auf_der_lichtung` | Kapitel 5: Lebkuchenhaus, weißes Vöglein | 20 | Wald als Polygon (äußerer Ring), Lichtung als Loch (innerer Ring, rot) |
| `06_die_feine_witterung_der_hexe` | Kapitel 6: Hexe schnuppert, Rotkäppchen als Gast | 25 | Distanzringe (Buffer), Personen als Punkte |
| `07_das_knoechlein` | Kapitel 7: Hänsel im Stall reicht den Knochen | 29 | Gitter des Stalls, Knochen mit gestricheltem MBR |
| `08_die_weisse_ente` | Kapitel 8: Ente trägt Hänsel übers Wasser, Vater winkt | 34 | Heimweg (Linie) schneidet Gewässer (Fläche), Schnittpunkte markiert |
| `09_epilog_perlen_und_edelsteine` | Epilog: Schätze und „dort läuft eine Maus“ | 37/39 | Computermaus mit Kabelschwanz |

## Farben

**Waldgrün:** `#2F5D3A`\
**Lebkuchen:** `#8B5A2B`\
**Mondlicht:** `#C9D6E3`\
**Papier:** `#F7F1E3`\
**Hexenrot / Oracle-Rot:** `#C74634`

## Neu erzeugen

```bash
cd scripts/illustrationen
python3 scenes.py svg            # SVGs schreiben
python3 render.py png svg/*.svg  # einpassen und PNGs (2x) rendern
```
