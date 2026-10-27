-- Prüft die Anforderungen an die Märchendaten. In jeder Zeile muss die Spalte ok 'ja' zeigen.
-- Ausführen als DOAG_SPATIAL nach 03_maerchendaten.sql. Nur lesend.

with g as (
  select (select geo from flaeche where name = 'Wald') as wald,
         (select geo from flaeche where name = 'See') as see,
         (select geo from flaeche where name = 'Lichtung') as lichtung,
         (select geo from ort where name = 'Elternhaus') as elternhaus,
         (select geo from ort where name = 'Feuerstelle') as feuerstelle,
         (select geo from ort where name = 'Hexenhaus') as hexenhaus,
         (select geo from weg where name = 'Irrweg') as irrweg,
         (select geo from weg where name = 'Fluchtweg') as fluchtweg,
         (select sdo_geometry('LINESTRING (' || listagg(s.geo.sdo_point.x || ' ' || s.geo.sdo_point.y, ', ')
                                                  within group (order by s.nummer) || ')', 25832)
            from ort s
            where s.name = 'Kieselstein') as kieselweg,
         pa_geo.toleranz() as tol),
     stein as (
  select s.nummer,
         sdo_geom.sdo_distance(s.geo, f.geo, pa_geo.toleranz()) as meter
    from ort s
    cross join ort f
    where s.name = 'Kieselstein'
      and f.name = 'Feuerstelle'),
     pruefung as (
  select 1 as nr,
         'Wald gültig, Größe in Hektar' as anforderung,
         sdo_geom.validate_geometry_with_context(g.wald, g.tol) || ', '
           || round(sdo_geom.sdo_area(g.wald, g.tol, 'unit=HECTARE')) as ist,
         case when sdo_geom.validate_geometry_with_context(g.wald, g.tol) = 'TRUE' then 'ja' else 'nein' end as ok
    from g
  union all
  select 2,
         'Elternhaus liegt auf dem Waldrand (ON)',
         sdo_geom.relate(g.elternhaus, 'determine', g.wald, g.tol),
         case when sdo_geom.relate(g.elternhaus, 'determine', g.wald, g.tol) = 'ON' then 'ja' else 'nein' end
    from g
  union all
  select 3,
         'See gültig',
         sdo_geom.validate_geometry_with_context(g.see, g.tol),
         case when sdo_geom.validate_geometry_with_context(g.see, g.tol) = 'TRUE' then 'ja' else 'nein' end
    from g
  union all
  select 4,
         'Zentroid des Waldes liegt im See (INSIDE)',
         sdo_geom.relate(sdo_geom.sdo_centroid(g.wald, g.tol), 'determine', g.see, g.tol),
         case when sdo_geom.relate(sdo_geom.sdo_centroid(g.wald, g.tol), 'determine', g.see, g.tol) = 'INSIDE'
              then 'ja' else 'nein' end
    from g
  union all
  select 5,
         'Lichtung gültig',
         sdo_geom.validate_geometry_with_context(g.lichtung, g.tol),
         case when sdo_geom.validate_geometry_with_context(g.lichtung, g.tol) = 'TRUE' then 'ja' else 'nein' end
    from g
  union all
  select 6,
         'Hexenhaus auf der Lichtung (INSIDE), nicht im Wald (DISJOINT)',
         sdo_geom.relate(g.hexenhaus, 'determine', g.lichtung, g.tol) || ', '
           || sdo_geom.relate(g.hexenhaus, 'determine', g.wald, g.tol),
         case when sdo_geom.relate(g.hexenhaus, 'determine', g.lichtung, g.tol) = 'INSIDE'
               and sdo_geom.relate(g.hexenhaus, 'determine', g.wald, g.tol) = 'DISJOINT'
              then 'ja' else 'nein' end
    from g
  union all
  select 7,
         'Feuerstelle im Wald, 1500 bis 2000 m vom Elternhaus',
         sdo_geom.relate(g.feuerstelle, 'determine', g.wald, g.tol) || ', '
           || round(sdo_geom.sdo_distance(g.feuerstelle, g.elternhaus, g.tol)) || ' m',
         case when sdo_geom.relate(g.feuerstelle, 'determine', g.wald, g.tol) = 'INSIDE'
               and sdo_geom.sdo_distance(g.feuerstelle, g.elternhaus, g.tol) between 1500 and 2000
              then 'ja' else 'nein' end
    from g
  union all
  select 8,
         '25 Kieselsteine, Weg mehr als 1,33-mal so lang wie die Luftlinie',
         (select count(*) from stein) || ' Steine, Faktor '
           || round(sdo_geom.sdo_length(g.kieselweg, g.tol)
                    / sdo_geom.sdo_distance(g.feuerstelle, g.elternhaus, g.tol), 2),
         case when (select count(*) from stein) = 25
               and sdo_geom.sdo_length(g.kieselweg, g.tol)
                   > 1.33 * sdo_geom.sdo_distance(g.feuerstelle, g.elternhaus, g.tol)
              then 'ja' else 'nein' end
    from g
  union all
  select 9,
         'Genau ein nächster Stein, drei Steine im 20-m-Kreis',
         (select count(*) from stein where meter = (select min(meter) from stein)) || ' nächster, '
           || (select count(*) from stein where meter <= 20) || ' im 20-m-Kreis',
         case when (select count(*) from stein where meter = (select min(meter) from stein)) = 1
               and (select count(*) from stein where meter <= 20) = 3
              then 'ja' else 'nein' end
    from g
  union all
  select 10,
         'Irrweg gültig, meidet den See, endet am Hexenhaus',
         sdo_geom.validate_geometry_with_context(g.irrweg, g.tol) || ', '
           || sdo_geom.relate(g.irrweg, 'determine', g.see, g.tol) || ', Ende '
           || e.x || ' ' || e.y,
         case when sdo_geom.validate_geometry_with_context(g.irrweg, g.tol) = 'TRUE'
               and sdo_geom.relate(g.irrweg, 'determine', g.see, g.tol) = 'DISJOINT'
               and e.x = g.hexenhaus.sdo_point.x
               and e.y = g.hexenhaus.sdo_point.y
              then 'ja' else 'nein' end
    from g
    cross join lateral (select v.x, v.y
                          from table(sdo_util.getvertices(g.irrweg)) v
                          order by v.id desc
                          fetch first 1 row only) e
  union all
  select 11,
         'Fluchtweg über den See: 200 bis 400 m über Wasser',
         round(sdo_geom.sdo_length(sdo_geom.sdo_intersection(g.fluchtweg, g.see, g.tol), g.tol)) || ' m',
         case when sdo_geom.sdo_length(sdo_geom.sdo_intersection(g.fluchtweg, g.see, g.tol), g.tol) between 200 and 400
              then 'ja' else 'nein' end
    from g
  union all
  select 12,
         'Rund 100 000 Bäume, einige Dutzend im 50-m-Kreis ums Hexenhaus',
         (select count(*) from baum) || ' Bäume, '
           || (select count(*)
                 from baum b
                 cross join ort h
                 where h.name = 'Hexenhaus'
                   and sdo_within_distance(b.geo, h.geo, 'distance=50') = 'TRUE') || ' im 50-m-Kreis',
         case when (select count(*) from baum) between 90000 and 110000
               and (select count(*)
                      from baum b
                      cross join ort h
                      where h.name = 'Hexenhaus'
                        and sdo_within_distance(b.geo, h.geo, 'distance=50') = 'TRUE') between 10 and 100
              then 'ja' else 'nein' end
    from g)
select nr,
       anforderung,
       ist,
       ok
  from pruefung
  order by nr;
