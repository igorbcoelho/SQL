SELECT  n.nspname, p.proname, p.prosrc
FROM    pg_catalog.pg_namespace n
JOIN    pg_catalog.pg_proc p
ON      p.pronamespace = n.oid
WHERE   p.prosrc ilike '%palavra%' 