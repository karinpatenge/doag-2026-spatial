-- Märchendaten: Wald, See, Lichtung, Orte, Wege und rund eine Million Bäume, alle in SRID 25832 (ganze Meter).
-- Ausführen als DOAG_SPATIAL nach 02_tabellen.sql. Dauert einige Minuten, fast nur wegen der Bäume.

drop index if exists ids1_baum;
delete from baum;
delete from ort;
delete from weg;
delete from flaeche;

-- Flächen ------------------------------------------------------------------------------------------------------------

insert into flaeche (name, geo)
  values ('Wald',
          sdo_geometry(2003, 25832, null,
                       sdo_elem_info_array(1, 1003, 1,       -- äußerer Ring: der Wald, gegen den Uhrzeigersinn
                                           35, 2003, 1,      -- innerer Ring: der See, im Uhrzeigersinn
                                           53, 2003, 1),     -- innerer Ring: die Lichtung, im Uhrzeigersinn
                       sdo_ordinate_array(
                         659400, 5481300, 660300, 5481150, 661200, 5481400, 661700, 5482000,
                         661500, 5482700, 661800, 5483400, 661300, 5484100, 660400, 5484350,
                         659500, 5484150, 658700, 5484450, 657800, 5484200, 657300, 5483500,
                         657500, 5482700, 657200, 5482000, 657800, 5481450, 658600, 5481500,
                         659400, 5481300,
                         659716, 5482831, 659680, 5482715, 659540, 5482659, 659375, 5482665,
                         659307, 5482772, 659325, 5482883, 659454, 5482962, 659607, 5482915,
                         659716, 5482831,
                         660713, 5483507, 660702, 5483382, 660578, 5483322, 660432, 5483340,
                         660385, 5483457, 660444, 5483572, 660593, 5483577, 660713, 5483507)));

-- der See als eigene Fläche: dieselben Punkte wie sein Loch im Wald, in umgekehrter Reihenfolge
insert into flaeche (name, geo)
  values ('See',
          sdo_geometry(2003, 25832, null,
                       sdo_elem_info_array(1, 1003, 1),
                       sdo_ordinate_array(
                         659716, 5482831, 659607, 5482915, 659454, 5482962, 659325, 5482883,
                         659307, 5482772, 659375, 5482665, 659540, 5482659, 659680, 5482715,
                         659716, 5482831)));

insert into flaeche (name, geo)
  values ('Lichtung',
          sdo_geometry(2003, 25832, null,
                       sdo_elem_info_array(1, 1003, 1),
                       sdo_ordinate_array(
                         660713, 5483507, 660593, 5483577, 660444, 5483572, 660385, 5483457,
                         660432, 5483340, 660578, 5483322, 660702, 5483382, 660713, 5483507)));

-- Orte ---------------------------------------------------------------------------------------------------------------

-- das Elternhaus ist ein Eckpunkt des Waldrandes
insert into ort (name, geo)
  values ('Elternhaus', sdo_geometry(2001, 25832, sdo_point_type(659400, 5481300, null), null, null));
insert into ort (name, geo)
  values ('Feuerstelle', sdo_geometry(2001, 25832, sdo_point_type(658300, 5482900, null), null, null));
-- das Hexenhaus steht auf der Lichtung, 13 m von ihrem Rand, damit im 50-m-Kreis Bäume stehen
insert into ort (name, geo)
  values ('Hexenhaus', sdo_geometry(2001, 25832, sdo_point_type(660506, 5483344, null), null, null));

-- Hänsel und Gretel auf dem letzten Stück des Irrwegs, rund 200 m vor dem Hexenhaus: die Hexe wittert sie
insert into ort (name, geo)
  values ('Hänsel', sdo_geometry(2001, 25832, sdo_point_type(660331, 5483222, null), null, null));
insert into ort (name, geo)
  values ('Gretel', sdo_geometry(2001, 25832, sdo_point_type(660362, 5483243, null), null, null));

-- die Kieselsteine vom Elternhaus (1) bis zur Feuerstelle (25); die letzten drei liegen weniger als 20 m vom Feuer
insert into ort (name, nummer, geo)
  select 'Kieselstein',
         k.nummer,
         sdo_geometry(2001, 25832, sdo_point_type(k.x, k.y, null), null, null)
    from (values (1, 659385, 5481320), (2, 659445, 5481459), (3, 659488, 5481587), (4, 659500, 5481694),
                 (5, 659473, 5481774), (6, 659404, 5481824), (7, 659295, 5481848), (8, 659158, 5481852),
                 (9, 659006, 5481846), (10, 658855, 5481841), (11, 658723, 5481848), (12, 658623, 5481878),
                 (13, 658563, 5481935), (14, 658546, 5482021), (15, 658567, 5482134), (16, 658615, 5482265),
                 (17, 658676, 5482406), (18, 658733, 5482543), (19, 658770, 5482667), (20, 658775, 5482768),
                 (21, 658738, 5482841), (22, 658659, 5482885), (23, 658283, 5482894), (24, 658296, 5482888),
                 (25, 658303, 5482895)) k (nummer, x, y);

-- Wege ---------------------------------------------------------------------------------------------------------------

-- der Irrweg beginnt an der Feuerstelle, kreuzt sich viermal selbst, meidet den See und endet am Hexenhaus
insert into weg (name, geo)
  values ('Irrweg',
          sdo_geometry(2002, 25832, null,
                       sdo_elem_info_array(1, 2, 1),
                       sdo_ordinate_array(
                         658300, 5482900, 657800, 5483300, 658250, 5483950, 658950, 5483550,
                         658150, 5483200, 657950, 5483750, 659100, 5484000, 659950, 5483650,
                         659450, 5483300, 660050, 5483950, 660300, 5483200, 660506, 5483344)));

-- der Fluchtweg führt vom Hexenhaus über den See (die Ente) zum Elternhaus
insert into weg (name, geo)
  values ('Fluchtweg',
          sdo_geometry(2002, 25832, null,
                       sdo_elem_info_array(1, 2, 1),
                       sdo_ordinate_array(
                         660506, 5483344, 660150, 5483150, 659800, 5483000, 659250, 5482600,
                         659250, 5481950, 659400, 5481300)));

commit;

-- Bäume --------------------------------------------------------------------------------------------------------------

-- Zufallspunkte im umschließenden Rechteck des Waldes, mit festem Startwert:
-- jeder Lauf liefert dieselben Bäume.
-- sdo_pointinpolygon behält nur die Punkte im Wald; See und Lichtung sind Löcher und bleiben baumfrei.
-- Von 1300 x 990 Punkten bleibt rund eine Million.
begin
  dbms_random.seed(val => 4711);
end;
/

insert into baum (geo)
  select sdo_geometry(2001, 25832, sdo_point_type(p.x, p.y, null), null, null)
    from table(sdo_pointinpolygon(cursor(select round(dbms_random.value(657200, 661800), 1) as x,
                                                round(dbms_random.value(5481150, 5484450), 1) as y
                                           from xmltable('1 to 1300') a
                                           cross join xmltable('1 to 990') b),
                                  (select f.geo from flaeche f where f.name = 'Wald'),
                                  pa_geo.toleranz())) p;

commit;

create index ids1_baum on baum(geo) indextype is mdsys.spatial_index_v2;

begin
  dbms_stats.gather_schema_stats(ownname => user);
end;
/
