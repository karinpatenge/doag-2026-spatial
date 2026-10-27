-- Legt den Demo-Benutzer DOAG_SPATIAL an.
-- Ausführen als SYS in FREEPDB1. Das Kennwort fragt das Skript beim Ausführen ab.

create user doag_spatial identified by "&kennwort_doag_spatial"
  default tablespace users
  quota unlimited on users;

grant db_developer_role to doag_spatial;

-- der Spatial Index braucht diese Rechte direkt, nicht nur über eine Rolle
grant create table, create sequence to doag_spatial;
