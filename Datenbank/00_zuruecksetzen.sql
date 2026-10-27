-- Setzt das Demo-Schema DOAG_SPATIAL zurück: beendet offene Sitzungen und löscht den Benutzer samt allen Objekten.
-- Ausführen als SYS in FREEPDB1. Danach der Reihe nach: 01_benutzer.sql, pa_geo.pck, 02_tabellen.sql,
-- 03_maerchendaten.sql, 06_pruefung.sql.

begin
  for lSitzung in (select sid, serial#
                     from v$session
                     where username = upper('doag_spatial')) loop
    execute immediate 'alter system kill session ''' || lSitzung.sid || ',' || lSitzung.serial# || ''' immediate';
  end loop;
end;
/

drop user if exists doag_spatial cascade;
