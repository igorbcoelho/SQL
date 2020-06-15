@echo off

set PGUSER=postgres
set PGPASSWORD=postgres
set BACKUP_FILE="c:\backup\postgres\backup-nasajon-%Date%.backup"


for /f "tokens=1,2,3,4 delims=/ " %%a in ('DATE /T') do set Date=%%a-%%b-%%c
C:\Arquiv~1\Postgr~1\9.3\bin\pg_dump.exe -i -h localhost -p 5432 -U postgres -F c -b -o -v -f %BACKUP_FILE% integratto2


pause


:fim
ECHO Backup Concluído !