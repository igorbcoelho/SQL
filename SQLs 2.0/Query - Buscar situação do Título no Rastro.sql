-- BUSCAR TÍTULO NO BANCO
SELECT NUMERO, SITUACAO, SITUACAOTEXTO, CONTA
FROM FINANCAS.TITULOS 
WHERE NUMERO ILIKE 'HN SOLUTIONS 2017.06'

ID = 'ef8b5078-a2ae-4025-9057-726c88d19209'

-- BUSCAR NA TABELA RASTRO E NA LOG.RASTROS
SELECT (oldvalue->>'situacao') situacao_old, (newvalue->>'situacao') situacao_new, *
--FROM NS.RASTROS WHERE tabela = 'titulos'  
FROM log.rastros_2017_09_06_19_07_53 WHERE tabela = 'titulos' 
and COALESCE((newvalue->>'numero'),(oldvalue->>'numero'))::TEXT IN ('HN SOLUTIONS 2017.06')

-- BUSCAR NO LOGRASTRO -- RASTROS ARQUIVADOS

-- CRIAR TABELA TEMPORARIA
CREATE TEMPORARY TABLE LOGSRASTROS(
VALOR_ANTIGO VARCHAR (1000),
VALOR_NOVO VARCHAR (1000),
DATA DATE,
USUARIO VARCHAR(60),
OPERACAO VARCHAR(20));

ALTER TABLE LOGSRASTROS
  OWNER TO group_nasajon;
-- DROP TABLE LOGSRASTROS


-- BUSCA NAS DIVERSAS TABELA DE LOG E INSERE NA LOGSRASTROS
DO
$$
DECLARE
	r RECORD;
BEGIN

	FOR r IN (SELECT table_schema, table_name FROM information_schema.tables WHERE table_catalog = 'ramo' AND table_schema = 'log' order by table_name DESC) LOOP


		EXECUTE 'INSERT INTO LOGSRASTROS SELECT (oldvalue->>''datacompetencia'') VALOR_ANTIGO, (newvalue->>''datacompetencia'') VALOR_NOVO, DATA, USUARIO, OPERACAO FROM ' || r.table_schema || '.' || r.table_name ||
		' WHERE tabela = ''titulos'' and COALESCE((newvalue->>''numero''),(oldvalue->>''numero''))::TEXT IN (''TESTE2018'')';

	END LOOP;


END
$$;

-- BUSCA NO RASTRO E INCLUI NA LOGSRASTROS
INSERT INTO LOGSRASTROS SELECT (oldvalue->>'datacompetencia') VALOR_ANTIGO, (newvalue->>'datacompetencia') VALOR_NOVO, DATA, USUARIO, OPERACAO 
FROM NS.RASTROS
WHERE tabela = 'titulos' and COALESCE((newvalue->>'numero'),(oldvalue->>'numero'))::TEXT IN ('TESTE2018');

-- EXIBINDO O CONTEÚDO DA TABELA AGRUPADA
SELECT * FROM LOGSRASTROS


