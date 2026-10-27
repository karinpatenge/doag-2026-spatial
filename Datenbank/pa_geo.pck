create or replace package pa_geo is
  -- Toleranz in Metern für alle Spatial-Funktionen
  cToleranz constant number := 0.05;

  function toleranz return number deterministic;
end;
/
create or replace package body pa_geo is

  ----------------------------------------------------------------------------------------------------------------------
  function toleranz return number deterministic is
  begin
    return cToleranz;
  end;

end;
/
