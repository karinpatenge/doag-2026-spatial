@echo off
rem Startet einen lokalen Webserver für die Folien und öffnet sie im Browser.
rem Als Datei geöffnet, schickt der Browser die Herkunft "null", und ORDS lehnt die Abrufe mit 403 ab.
rem Über http://localhost:8765 erlaubt ORDS den Zugriff. Den Webserver beendet man durch Schließen seines Fensters.

cd /d "%~dp0"
start "Folien-Webserver" /min python -m http.server 8765 --bind 127.0.0.1
timeout /t 2 /nobreak >nul
start "" http://localhost:8765/Folien.html
