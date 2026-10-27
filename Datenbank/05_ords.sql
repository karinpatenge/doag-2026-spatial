-- ORDS-Modul „folien“: liefert alle Live-Daten der Folien unter http://localhost:8080/ords/doag_spatial/folien/...
-- Ausführen als DOAG_SPATIAL nach 03_maerchendaten.sql. Wiederholbar: define_module ersetzt das Modul samt Endpunkten.
-- Die Abfragen sind dieselben wie auf den Folien; Kartenendpunkte liefern je Zeile name und wkt (SRID 25832).

begin
  ords.enable_schema(p_enabled => true,
                     p_schema => upper('doag_spatial'),
                     p_url_mapping_type => 'BASE_PATH',
                     p_url_mapping_pattern => 'doag_spatial',
                     p_auto_rest_auth => false);
  commit;
end;
/

declare
  -- legt einen GET-Endpunkt an, der das Ergebnis der Abfrage als JSON-Sammlung ohne Seitenaufteilung liefert
  --   pMuster        - Pfad des Endpunkts unterhalb von /folien/
  --   pBeschreibung  - Kommentar für Vorlage und Handler
  --   pAbfrage       - SQL-Abfrage des Endpunkts
  procedure endpunkt(pMuster varchar2, pBeschreibung varchar2, pAbfrage varchar2) is
  begin
    ords.define_template(p_module_name => 'folien',
                         p_pattern => pMuster,
                         p_comments => pBeschreibung);
    ords.define_handler(p_module_name => 'folien',
                        p_pattern => pMuster,
                        p_method => 'GET',
                        p_source_type => ords.source_type_collection_feed,
                        p_items_per_page => 0,
                        p_source => pAbfrage,
                        p_comments => pBeschreibung);
  end;
begin
  ords.define_module(p_module_name => 'folien',
                     p_base_path => '/folien/',
                     p_items_per_page => 0,
                     p_status => 'PUBLISHED',
                     p_comments => 'Live-Daten für die Folien „Hänsel und Gretel im Geodatenwald“');

  -- Kapitel 2: Kieselsteine im Mondlicht (Punkte) ---------------------------------------------------------------------
  endpunkt('uebersicht', 'Gesamtkarte: Flächen, Wege und Orte ohne Kieselsteine', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, w.weg_id, w.name, w.geo.get_wkt()
          from weg w
        union all
        select 3, o.ort_id, o.name, o.geo.get_wkt()
          from ort o
          where o.name <> 'Kieselstein')
  order by ebene, reihenfolge]');

  -- die wachsende Karte in der Szenenleiste jedes Kapitels: alles, die Folie wählt die Ebenen aus
  endpunkt('karte', 'Wachsende Karte: alle Flächen, Wege und Orte', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, w.weg_id, w.name, w.geo.get_wkt()
          from weg w
        union all
        select 2, 0, 'Heimweg',
               sdo_geometry('LINESTRING (' || listagg(s.geo.sdo_point.x || ' ' || s.geo.sdo_point.y, ', ')
                                                within group (order by s.nummer) || ')', 25832).get_wkt()
          from ort s
          where s.name = 'Kieselstein'
        union all
        select 3, o.ort_id, o.name, o.geo.get_wkt()
          from ort o)
  order by ebene, reihenfolge]');

  endpunkt('elternhaus', 'Aufbau des Punktes Elternhaus', q'[
select o.geo.sdo_gtype as gtype,
       o.geo.sdo_srid as srid,
       o.geo.sdo_point.x as x,
       o.geo.sdo_point.y as y
  from ort o
  where o.name = 'Elternhaus']');

  -- Kapitel 2: Austauschformate ---------------------------------------------------------------------------------------
  endpunkt('elternhaus-formate', 'Elternhaus als WKT und GeoJSON', q'[
select o.geo.get_wkt() as wkt,
       sdo_util.to_geojson(sdo_cs.transform(o.geo, 4326)) as geojson
  from ort o
  where o.name = 'Elternhaus']');

  -- Kapitel 3: Wo liegt das Elternhaus? (Koordinatensysteme) ----------------------------------------------------------
  endpunkt('koordinatensysteme', 'Anzahl der Koordinatensysteme je Art', q'[
select coord_ref_sys_kind as art, count(*) as anzahl
  from mdsys.sdo_coord_ref_sys
  group by coord_ref_sys_kind
  order by anzahl desc]');

  -- Kapitel 3: ein Haus, drei Zahlenpaare -----------------------------------------------------------------------------
  endpunkt('elternhaus-srid', 'Elternhaus in drei Koordinatensystemen', q'[
select s.srid,
       sdo_cs.transform(o.geo, s.srid).get_wkt() as wkt
  from ort o
  cross join (select column_value as srid
                from table(sys.odcinumberlist(25832, 4326, 3857))) s
  where o.name = 'Elternhaus']');

  -- Kapitel 3: Weltkarten ---------------------------------------------------------------------------------------------
  -- Web-Mercator reicht nur bis 85 Grad Breite: dafür werden die Länder in Plate Carrée (32662) abgeschnitten
  endpunkt('weltkarte', 'Länder und Kreise mit 500 km Radius in der Projektion :srid', q'[
select x.name,
       x.geo.get_wkt() as wkt
  from (select l.name,
               case when to_number(:srid) = 3857
                    then sdo_cs.transform(sdo_geom.sdo_intersection(sdo_cs.transform(l.geo, 32662),
                                                                    sdo_geometry(2003, 32662, null,
                                                                                 sdo_elem_info_array(1, 1003, 3),
                                                                                 sdo_ordinate_array(-20037508, -9462157,
                                                                                                    20037508, 9462157)),
                                                                    pa_geo.toleranz()),
                                          3857)
                    else sdo_cs.transform(l.geo, to_number(:srid))
               end as geo
          from land l
        union all
        select 'Kreis',
               sdo_cs.transform(sdo_geom.sdo_buffer(sdo_geometry(2001, 4326, sdo_point_type(k.laenge, k.breite, null),
                                                                 null, null),
                                                    500000, pa_geo.toleranz(), 'unit=M arc_tolerance=1000'),
                                to_number(:srid))
          from (select l.column_value as laenge,
                       b.column_value as breite
                  from table(sys.odcinumberlist(-150, -90, -30, 30, 90, 150)) l
                  cross join table(sys.odcinumberlist(-60, -30, 0, 30, 60)) b) k) x]');

  -- Kapitel 3: Kreisflächen -------------------------------------------------------------------------------------------
  endpunkt('kreisflaechen', 'Echte und projizierte Fläche eines Kreises mit 500 km Radius', q'[
with projektion as (select c.srid,
                           c.cs_name as name
                      from mdsys.cs_srs c
                     where c.srid in (3857, 212992, 1009801)),
     kreis as (select column_value as breite,
                      sdo_geom.sdo_buffer(sdo_geometry(2001, 4326, sdo_point_type(11, column_value, null), null, null),
                                          500000, pa_geo.toleranz(), 'unit=M arc_tolerance=1000') as geo
                 from table(sys.odcinumberlist(0, 49, 70)))
select p.srid,
       p.name,
       k.breite,
       round(sdo_geom.sdo_area(k.geo, pa_geo.toleranz(), 'unit=SQ_KM')) as echte_qkm,
       round(sdo_geom.sdo_area(sdo_cs.transform(k.geo, p.srid), pa_geo.toleranz()) / 1e6) as karten_qkm,
       round(100 * (sdo_geom.sdo_area(sdo_cs.transform(k.geo, p.srid), pa_geo.toleranz()) / 1e6
                    / sdo_geom.sdo_area(k.geo, pa_geo.toleranz(), 'unit=SQ_KM') - 1), 1) as abweichung_prozent
  from projektion p
  cross join kreis k
  order by p.srid, k.breite]');

  -- Kapitel 4: Die Feuerstelle (Abstand) ------------------------------------------------------------------------------
  endpunkt('abstand', 'Abstand Elternhaus – Feuerstelle in vier Varianten', q'[
select sdo_geom.sdo_distance(sdo_geometry(2001, null, sdo_cs.transform(h.geo, 4326).sdo_point, null, null),
                             sdo_geometry(2001, null, sdo_cs.transform(f.geo, 4326).sdo_point, null, null),
                             pa_geo.toleranz()) as ohne_srid_grad,
       sdo_geom.sdo_distance(sdo_cs.transform(h.geo, 4326), sdo_cs.transform(f.geo, 4326),
                             pa_geo.toleranz(), 'unit=M') as wgs84_m,
       sdo_geom.sdo_distance(sdo_cs.transform(h.geo, 3857), sdo_cs.transform(f.geo, 3857),
                             pa_geo.toleranz()) as web_mercator_m,
       sdo_geom.sdo_distance(h.geo, f.geo, pa_geo.toleranz()) as utm_32n_m
  from ort h
  cross join ort f
  where h.name = 'Elternhaus'
    and f.name = 'Feuerstelle']');

  -- Kapitel 4: nächster Kieselstein -----------------------------------------------------------------------------------
  endpunkt('kieselsteine', 'Kieselsteine an der Feuerstelle: der nächste und die im Umkreis von 20 m', q'[
select s.name,
       s.nummer,
       case when s.meter = min(s.meter) over () then 'naechster'
            when s.meter <= 20 then 'im_umkreis'
       end as zustand,
       s.wkt
  from (select o.name,
               o.nummer,
               o.geo.get_wkt() as wkt,
               sdo_geom.sdo_distance(o.geo, f.geo, pa_geo.toleranz()) as meter
          from ort o
          cross join ort f
          where o.name = 'Kieselstein'
            and f.name = 'Feuerstelle') s
union all
select o.name,
       null,
       null,
       o.geo.get_wkt()
  from ort o
  where o.name = 'Feuerstelle']');

  -- Kapitel 5: Brotkrumen und Irrweg (Linien) -------------------------------------------------------------------------
  endpunkt('heimweg-laenge', 'Länge des Heimwegs aus Kieselsteinen und Luftlinie', q'[
with heimweg as (
  select sdo_geometry('LINESTRING (' || listagg(s.geo.sdo_point.x || ' ' || s.geo.sdo_point.y, ', ')
                                          within group (order by s.nummer) || ')', 25832) as geo
    from ort s
    where s.name = 'Kieselstein')
select round(sdo_geom.sdo_length(w.geo, pa_geo.toleranz())) as weg_meter
  from heimweg w]');

  endpunkt('heimweg-luftlinie', 'Luftlinie vom ersten zum letzten Kieselstein', q'[
select round(sdo_geom.sdo_distance(a.geo, b.geo, pa_geo.toleranz())) as luftlinie_meter
  from ort a
  cross join ort b
  where a.name = 'Kieselstein'
    and a.nummer = 1
    and b.name = 'Kieselstein'
    and b.nummer = 25]');

  endpunkt('heimweg-karte', 'Karte: Heimweg aus Kieselsteinen', q'[
select name,
       nummer,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, null as nummer, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, 0, 'Heimweg', null,
               sdo_geometry('LINESTRING (' || listagg(s.geo.sdo_point.x || ' ' || s.geo.sdo_point.y, ', ')
                                                within group (order by s.nummer) || ')', 25832).get_wkt()
          from ort s
          where s.name = 'Kieselstein'
        union all
        select 3, o.ort_id, o.name, o.nummer, o.geo.get_wkt()
          from ort o
          where o.name in ('Kieselstein', 'Feuerstelle', 'Elternhaus'))
  order by ebene, reihenfolge]');

  -- Kapitel 5: Irrweg -------------------------------------------------------------------------------------------------
  endpunkt('irrweg-pruefung', 'Gültigkeit und Länge des Irrwegs', q'[
select sdo_geom.validate_geometry_with_context(w.geo, pa_geo.toleranz()) as gueltig,
       round(sdo_geom.sdo_length(w.geo, pa_geo.toleranz())) as meter
  from weg w
  where w.name = 'Irrweg']');

  endpunkt('irrweg-karte', 'Karte: Irrweg von der Feuerstelle zum Hexenhaus', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, w.weg_id, w.name, w.geo.get_wkt()
          from weg w
          where w.name = 'Irrweg'
        union all
        select 3, o.ort_id, o.name, o.geo.get_wkt()
          from ort o
          where o.name in ('Feuerstelle', 'Hexenhaus'))
  order by ebene, reihenfolge]');

  -- Kapitel 6: Das Lebkuchenhaus auf der Lichtung (Polygone) ----------------------------------------------------------
  endpunkt('wald-karte', 'Karte: Wald, See, Lichtung und Hexenhaus', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, o.ort_id, o.name, o.geo.get_wkt()
          from ort o
          where o.name = 'Hexenhaus')
  order by ebene, reihenfolge]');

  -- Kapitel 6: Prüfen -------------------------------------------------------------------------------------------------
  endpunkt('pruefung', 'Gültigkeit von Wald, Acht und falsch gedrehtem Ring', q'[
select 'Wald' as beispiel,
       sdo_geom.validate_geometry_with_context(f.geo, pa_geo.toleranz()) as ergebnis
  from flaeche f
  where f.name = 'Wald'
union all
select 'Acht',
       sdo_geom.validate_geometry_with_context(
         sdo_geometry(2003, null, null, sdo_elem_info_array(1, 1003, 1),
                      sdo_ordinate_array(0, 0, 4, 4, 4, 0, 0, 4, 0, 0)), pa_geo.toleranz())
union all
select 'Falsch gedreht',
       sdo_geom.validate_geometry_with_context(
         sdo_geometry(2003, null, null, sdo_elem_info_array(1, 1003, 1),
                      sdo_ordinate_array(6, 0, 6, 4, 10, 4, 10, 0, 6, 0)), pa_geo.toleranz())]');

  -- Kapitel 6: Reparieren ---------------------------------------------------------------------------------------------
  endpunkt('reparatur', 'Acht und falsch gedrehter Ring vor und nach rectify_geometry', q'[
select b.name,
       b.geo.sdo_gtype as gtype_vorher,
       sdo_util.rectify_geometry(b.geo, pa_geo.toleranz()).sdo_gtype as gtype_nachher,
       sdo_util.rectify_geometry(b.geo, pa_geo.toleranz()).get_wkt() as wkt
  from (select 'Acht' as name,
               sdo_geometry(2003, null, null, sdo_elem_info_array(1, 1003, 1),
                            sdo_ordinate_array(0, 0, 4, 4, 4, 0, 0, 4, 0, 0)) as geo
        union all
        select 'Falsch gedreht',
               sdo_geometry(2003, null, null, sdo_elem_info_array(1, 1003, 1),
                            sdo_ordinate_array(6, 0, 6, 4, 10, 4, 10, 0, 6, 0))) b]');

  -- Kapitel 7: Größe und Mitte ----------------------------------------------------------------------------------------
  endpunkt('wald-mitte', 'Größe des Waldes, Lage von Zentroid und Innenpunkt', q'[
select round(sdo_geom.sdo_area(f.geo, pa_geo.toleranz(), 'unit=HECTARE')) as hektar,
       sdo_geom.relate(sdo_geom.sdo_centroid(f.geo, pa_geo.toleranz()), 'determine',
                       f.geo, pa_geo.toleranz()) as zentroid,
       sdo_geom.relate(sdo_util.interior_point(f.geo, pa_geo.toleranz()), 'determine',
                       f.geo, pa_geo.toleranz()) as innenpunkt
  from flaeche f
  where f.name = 'Wald']');

  endpunkt('wald-mitte-karte', 'Karte: Zentroid und Innenpunkt des Waldes', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, 1, 'Zentroid', sdo_geom.sdo_centroid(f.geo, pa_geo.toleranz()).get_wkt()
          from flaeche f
          where f.name = 'Wald'
        union all
        select 2, 2, 'Innenpunkt', sdo_util.interior_point(f.geo, pa_geo.toleranz()).get_wkt()
          from flaeche f
          where f.name = 'Wald')
  order by ebene, reihenfolge]');

  -- Kapitel 7: Liegt das Hexenhaus im Wald? (Lagebeziehungen) ---------------------------------------------------------
  endpunkt('lagebeziehungen', 'Lagebeziehungen von Elternhaus und Hexenhaus zu Wald und Lichtung', q'[
select o.name,
       sdo_geom.relate(o.geo, 'determine', f.geo, pa_geo.toleranz()) as beziehung,
       sdo_geom.relate(o.geo, 'anyinteract', f.geo, pa_geo.toleranz()) as anyinteract,
       f.name as flaeche
  from ort o
  cross join flaeche f
  where o.name in ('Elternhaus', 'Hexenhaus')
    and f.name in ('Wald', 'Lichtung')]');

  -- Kapitel 9: Die weiße Ente -----------------------------------------------------------------------------------------
  endpunkt('ente', 'Länge des Fluchtwegs über dem See', q'[
select round(sdo_geom.sdo_length(sdo_geom.sdo_intersection(w.geo, s.geo, pa_geo.toleranz()),
                                 pa_geo.toleranz())) as meter_ueber_wasser
  from weg w
  cross join flaeche s
  where w.name = 'Fluchtweg'
    and s.name = 'See']');

  endpunkt('ente-karte', 'Karte: Fluchtweg mit dem Stück über dem See', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
        union all
        select 2, w.weg_id, w.name, w.geo.get_wkt()
          from weg w
          where w.name = 'Fluchtweg'
        union all
        select 3, 0, 'Ente', sdo_geom.sdo_intersection(w.geo, s.geo, pa_geo.toleranz()).get_wkt()
          from weg w
          cross join flaeche s
          where w.name = 'Fluchtweg'
            and s.name = 'See'
        union all
        select 4, o.ort_id, o.name, o.geo.get_wkt()
          from ort o
          where o.name in ('Hexenhaus', 'Elternhaus'))
  order by ebene, reihenfolge]');

  -- Kapitel 8: Eine Million Bäume (Spatial Index) ---------------------------------------------------------------------
  endpunkt('baeume-funktion', 'Bäume im Umkreis von 50 m ums Hexenhaus, mit der Funktion (ohne Index)', q'[
select count(*) as baeume
  from baum b
  cross join ort h
  where h.name = 'Hexenhaus'
    and sdo_geom.sdo_distance(b.geo, h.geo, pa_geo.toleranz()) <= 50]');

  endpunkt('baeume-index', 'Bäume im Umkreis von 50 m ums Hexenhaus, mit dem Operator (über den Index)', q'[
select count(*) as baeume
  from baum b
  cross join ort h
  where h.name = 'Hexenhaus'
    and sdo_within_distance(b.geo, h.geo, 'distance=50') = 'TRUE']');

  endpunkt('baeume-karte', 'Karte: die Bäume im Umkreis von 50 m ums Hexenhaus', q'[
select name,
       wkt
  from (select 1 as ebene, f.flaeche_id as reihenfolge, f.name, f.geo.get_wkt() as wkt
          from flaeche f
          where f.name in ('Wald', 'Lichtung')
        union all
        select 2, b.baum_id, 'Baum', b.geo.get_wkt()
          from baum b
          cross join ort h
          where h.name = 'Hexenhaus'
            and sdo_within_distance(b.geo, h.geo, 'distance=50') = 'TRUE'
        union all
        select 3, o.ort_id, o.name, o.geo.get_wkt()
          from ort o
          where o.name = 'Hexenhaus')
  order by ebene, reihenfolge]');

  -- Kapitel 3: Die Hexe schlägt zu - Länge und Breite vertauscht ------------------------------------------------------
  endpunkt('hexe-somalia', 'Elternhaus mit richtiger und vertauschter Länge und Breite', q'[
with e as (select sdo_cs.transform(o.geo, 4326) as geo
             from ort o
             where o.name = 'Elternhaus'),
     v as (select r.geo as richtig,
                  sdo_geometry(2001, 4326, sdo_point_type(r.geo.sdo_point.y, r.geo.sdo_point.x, null), null, null)
                    as vertauscht
             from e r)
select 'richtig' as variante,
       round(p.richtig.sdo_point.x, 4) as x_laenge,
       round(p.richtig.sdo_point.y, 4) as y_breite,
       null as km_vom_elternhaus
  from v p
union all
select 'vertauscht',
       round(p.vertauscht.sdo_point.x, 4),
       round(p.vertauscht.sdo_point.y, 4),
       round(sdo_geom.sdo_distance(p.richtig, p.vertauscht, pa_geo.toleranz(), 'unit=KM'))
  from v p]');

  -- Kapitel 8: Witterung und Knöchlein --------------------------------------------------------------------------------
  endpunkt('witterung', 'Wen wittert die Hexe im Umkreis von 300 m?', q'[
select o.name,
       round(sdo_geom.sdo_distance(o.geo, h.geo, pa_geo.toleranz())) as meter
  from ort o
  cross join ort h
  where h.name = 'Hexenhaus'
    and o.name <> 'Hexenhaus'
    and sdo_within_distance(o.geo, h.geo, 'distance=300') = 'TRUE'
  order by meter]');

  endpunkt('knoechlein', 'Bäume auf der Lichtung: nur Primärfilter gegen exakt', q'[
select (select count(*)
          from baum b
          cross join flaeche l
          where l.name = 'Lichtung'
            and sdo_filter(b.geo, l.geo) = 'TRUE') as nur_primaerfilter,
       (select count(*)
          from baum b
          cross join flaeche l
          where l.name = 'Lichtung'
            and sdo_anyinteract(b.geo, l.geo) = 'TRUE') as mit_sekundaerfilter]');

  endpunkt('knoechlein-karte', 'Karte: Lichtung, ihr umschließendes Rechteck und die Knöchlein', q'[
select name,
       zustand,
       wkt
  from (select 1 as ebene, 0 as reihenfolge, f.name, null as zustand, f.geo.get_wkt() as wkt
          from flaeche f
          where f.name = 'Lichtung'
        union all
        select 2, 0, 'Rechteck', null, sdo_geom.sdo_mbr(f.geo).get_wkt()
          from flaeche f
          where f.name = 'Lichtung'
        union all
        select 3, b.baum_id, 'Baum',
               case when sdo_geom.relate(b.geo, 'anyinteract', l.geo, pa_geo.toleranz()) = 'TRUE'
                    then null
                    else 'knoechlein'
               end,
               b.geo.get_wkt()
          from baum b
          cross join flaeche l
          where l.name = 'Lichtung'
            and sdo_filter(b.geo, l.geo) = 'TRUE')
  order by ebene, reihenfolge]');

  -- Ausführungsplan der Abfrage mit Index; explain plan geht in PL/SQL nur dynamisch
  ords.define_template(p_module_name => 'folien',
                       p_pattern => 'baeume-plan',
                       p_comments => 'Ausführungsplan der Baumabfrage mit dem Operator');
  ords.define_handler(p_module_name => 'folien',
                      p_pattern => 'baeume-plan',
                      p_method => 'GET',
                      p_source_type => ords.source_type_plsql,
                      p_comments => 'Ausführungsplan der Baumabfrage mit dem Operator',
                      p_source => q'[
declare
  lJson clob;
begin
  delete from plan_table
    where statement_id = 'baeume';
  execute immediate q'~explain plan set statement_id = 'baeume' for
select count(*) as baeume
  from baum b
  cross join ort h
  where h.name = 'Hexenhaus'
    and sdo_within_distance(b.geo, h.geo, 'distance=50') = 'TRUE'~';
  select json_object('items' value json_arrayagg(json_object('planzeile' value plan_table_output) returning clob)
                     returning clob)
    into lJson
    from table(dbms_xplan.display(table_name => 'PLAN_TABLE', statement_id => 'baeume', format => 'basic'));
  owa_util.mime_header('application/json', true);
  htp.p(lJson);
end;]');

  -- Ausführungsplan derselben Frage mit der Funktion, ohne Index
  ords.define_template(p_module_name => 'folien',
                       p_pattern => 'baeume-plan-funktion',
                       p_comments => 'Ausführungsplan der Baumabfrage mit der Funktion');
  ords.define_handler(p_module_name => 'folien',
                      p_pattern => 'baeume-plan-funktion',
                      p_method => 'GET',
                      p_source_type => ords.source_type_plsql,
                      p_comments => 'Ausführungsplan der Baumabfrage mit der Funktion',
                      p_source => q'[
declare
  lJson clob;
begin
  delete from plan_table
    where statement_id = 'baeume-funktion';
  execute immediate q'~explain plan set statement_id = 'baeume-funktion' for
select count(*) as baeume
  from baum b
  cross join ort h
  where h.name = 'Hexenhaus'
    and sdo_geom.sdo_distance(b.geo, h.geo, pa_geo.toleranz()) <= 50~';
  select json_object('items' value json_arrayagg(json_object('planzeile' value plan_table_output) returning clob)
                     returning clob)
    into lJson
    from table(dbms_xplan.display(table_name => 'PLAN_TABLE', statement_id => 'baeume-funktion',
                                  format => 'basic'));
  owa_util.mime_header('application/json', true);
  htp.p(lJson);
end;]');

  commit;
end;
/
