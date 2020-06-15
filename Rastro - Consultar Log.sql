CREATE OR REPLACE FUNCTION public.resultadorastro (campos text, condicao text)
RETURNS VOID AS
$BODY$
DECLARE
tabelas RECORD;
BEGIN

DROP TABLE IF EXISTS lograstros;

EXECUTE 'CREATE TEMP TABLE lograstros AS SELECT ' || campos || ' FROM ns.rastros WHERE ' || condicao;

FOR tabelas IN (SELECT tablename FROM pg_tables WHERE schemaname = 'log') LOOP

EXECUTE ' INSERT INTO lograstros SELECT ' || campos || ' FROM log.' || tabelas.tablename || ' WHERE ' || condicao;

END LOOP;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

SELECT public.resultadorastro ('*', 'schema || ''.'' || tabela = ''ns.pessoas'' AND (oldvalue->>''id'' IN (''5fe8a1c2-dc4b-4278-bc9c-27e85c8bb78b'') OR newvalue->>''id'' IN (''5fe8a1c2-dc4b-4278-bc9c-27e85c8bb78b'')');

DROP FUNCTION public.resultadorastro (text,text);

--COPY (SELECT * FROM lograstros) TO '/storage/rastro_df_servicos.csv' WITH CSV HEADER DELIMITER ';' ENCODING 'WIN1252'