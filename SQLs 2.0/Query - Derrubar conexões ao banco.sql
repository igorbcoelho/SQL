
-- DERRUBAR CONEXÕES ATIVAS NA BASE DE DADOS
SELECT pg_terminate_backend(pg_stat_activity.pid) 
FROM pg_stat_activity 
WHERE pg_stat_activity.datname = 'NOME_DA_BASE_DADOSi' 
AND pid <> pg_backend_pid();