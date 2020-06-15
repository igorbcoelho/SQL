
-- Mostra lista de ativos
SELECT *
FROM pg_stat_activity
ORDER BY usename;

-- Conta lista de ativos
SELECT count(distinct usename) as "Número de usuários ativos"
FROM pg_stat_activity;

-- Mata 1 a 1 os processos ativo
SELECT pg_terminate_backend(*pid*)
FROM pg_stat_activity
WHERE datname = 'integratto2_novo';

-- Remove todos os usuários do banco, exceto o usuário postgres
DO
$$
  DECLARE USUARIO RECORD;
BEGIN
  FOR USUARIO IN ( SELECT *
		   FROM pg_stat_activity
		   WHERE usename <> 'postgres' ) LOOP

    PERFORM pg_terminate_backend(USUARIO.pid)
    FROM pg_stat_activity
    WHERE datname = 'integratto2_novo';

  END LOOP;
END;
$$