﻿update NS.CONFIGURACOES SET VALOR = '0' WHERE APLICACAO = 0 AND CAMPO = 1;

UPDATE NS.USUARIOS SET GRUPODEUSUARIO = NULL;	

DELETE FROM NS.GRUPOSDEUSUARIOSACESSOS;
DELETE FROM NS.GRUPOSDEUSUARIOS;

DELETE FROM NS.ESTABELECIMENTOSCONJUNTOS;

DELETE FROM NS.CONJUNTOSVENDEDORES;
DELETE FROM NS.CONJUNTOSUNIDADES;
DELETE FROM NS.CONJUNTOSTRANSPORTADORAS;
DELETE FROM NS.CONJUNTOSTECNICOS;
DELETE FROM NS.CONJUNTOSSERVICOSDECATALOGOS;
DELETE FROM NS.CONJUNTOSSERVICOS;
DELETE FROM NS.CONJUNTOSRUBRICAS;	
DELETE FROM NS.CONJUNTOSPRODUTOS;	
DELETE FROM NS.CONJUNTOSMODELOSCONTRATOS;	
DELETE FROM NS.CONJUNTOSFORNECEDORES;	
DELETE FROM NS.CONJUNTOSFICHAS;	
DELETE FROM NS.CONJUNTOSCOMBUSTIVEIS;
DELETE FROM NS.CONJUNTOSCLIENTES;
DELETE FROM NS.CONJUNTOSCLASSIFICACOESPARTICIPANTES;
DELETE FROM NS.CONJUNTOS;

INSERT INTO NS.GRUPOSEMPRESARIAIS(CODIGO, DESCRICAO) VALUES('001', 'Grupo Empresarial 001');

INSERT INTO 
	NS.GRUPOSEMPRESARIAISCADASTROS(CADASTRO, GRUPOEMPRESARIAL)
SELECT
	CADASTRO, (SELECT GRUPOEMPRESARIAL FROM NS.GRUPOSEMPRESARIAIS WHERE CODIGO = '001')
FROM
	NS.ESTABELECIMENTOSCADASTROS;

UPDATE NS.EMPRESAS SET GRUPOEMPRESARIAL = (SELECT GRUPOEMPRESARIAL FROM NS.GRUPOSEMPRESARIAIS WHERE CODIGO = '001');

---------------------------------------- CONVERSAO PARA O NOVO MODELO DE COMPARTILHAMENTO ---------------------------------------------

-- ESTA FUNCAO IRA CRIAR UM GRUPO DE USUARIO PARA CADA USUARIO
 CREATE OR REPLACE FUNCTION PUBLIC.CONVERSAO_ETAPA_01_GRUPODEUSUARIO()
 RETURNS VOID
 LANGUAGE PLPGSQL
 VOLATILE 
 AS $BODY$
  --<<MAIN>>
 BEGIN
	/* *********************************************************
				1º PASSO
		CRIAR UM GRUPO DE USUARIO PARA CADA USUARIO
	********************************************************** */	
	--<<ESCOPO_USUARIO>>
	BEGIN
		WITH CRIARGRUPOSDEUSUARIOS AS (
			INSERT INTO NS.GRUPOSDEUSUARIOS(CODIGO, DESCRICAO)
			SELECT USU.LOGIN, USU.NOME FROM NS.USUARIOS AS USU
			RETURNING *
		)
		UPDATE NS.USUARIOS SET GRUPODEUSUARIO = GU.GRUPODEUSUARIO FROM CRIARGRUPOSDEUSUARIOS AS GU WHERE GU.CODIGO = NS.USUARIOS.LOGIN;
	END;

	/* *********************************************************
				2º PASSO
	    CONVERTER OS ACESSOS PARA AS ENTIDADES EMPRESARIAIS
	***********************************************************/
	--<<ESCOPO_ACESSO_ENTIDADE_EMPRESARIAL>>
	DECLARE T_ENTIDADE RECORD;
	BEGIN
		CREATE TEMPORARY TABLE TEMP_ACESSOS(GRUPODEUSUARIO UUID, ENTIDADEEMPRESARIAL UUID, TIPOREGISTRO INTEGER);

		-- ESTABELECIMENTO
		INSERT INTO TEMP_ACESSOS
		SELECT USU.GRUPODEUSUARIO, ENT.ESTABELECIMENTO, 2 FROM NS.USUARIOS AS USU INNER JOIN NS.ESTABELECIMENTOSACESSOSUSUARIOS AS ENT USING(USUARIO);

		-- EMPRESA
		INSERT INTO TEMP_ACESSOS
		SELECT USU.GRUPODEUSUARIO, ENT.EMPRESA, 1 FROM NS.USUARIOS AS USU INNER JOIN NS.EMPRESASACESSOSUSUARIOS AS ENT USING(USUARIO);

		-- GRUPO EMPRESARIAL
		INSERT INTO TEMP_ACESSOS
		SELECT USU.GRUPODEUSUARIO, ENT.GRUPOEMPRESARIAL, 0 FROM NS.USUARIOS AS USU INNER JOIN NS.GRUPOSEMPRESARIAISACESSOSUSUARIOS AS ENT USING(USUARIO);	

		------------------------------------------------------- CRIA OS ACESSOS PARA USUARIOS DO GRUPO MESTRE ----------------------------------------------------------------------------------
		-- ESTABELECIMENTO
		FOR T_ENTIDADE IN SELECT * FROM NS.ESTABELECIMENTOS 
		LOOP
			INSERT INTO TEMP_ACESSOS
			SELECT USU.GRUPODEUSUARIO, T_ENTIDADE.ESTABELECIMENTO, 2 FROM NS.USUARIOS AS USU INNER JOIN NS.PERFISUSUARIO AS PERF USING(PERFILUSUARIO) WHERE PERF.NOME = 'MESTRE';
		END LOOP;

		-- EMPRESA
		FOR T_ENTIDADE IN SELECT * FROM NS.EMPRESAS 
		LOOP
			INSERT INTO TEMP_ACESSOS
			SELECT USU.GRUPODEUSUARIO, T_ENTIDADE.EMPRESA, 1 FROM NS.USUARIOS AS USU INNER JOIN NS.PERFISUSUARIO AS PERF USING(PERFILUSUARIO) WHERE PERF.NOME = 'MESTRE';
		END LOOP;

		-- GRUPO EMPRESARIAL
		FOR T_ENTIDADE IN SELECT * FROM NS.GRUPOSEMPRESARIAIS
		LOOP
			INSERT INTO TEMP_ACESSOS
			SELECT USU.GRUPODEUSUARIO, T_ENTIDADE.GRUPOEMPRESARIAL, 0 FROM NS.USUARIOS AS USU INNER JOIN NS.PERFISUSUARIO AS PERF USING(PERFILUSUARIO) WHERE PERF.NOME = 'MESTRE';
		END LOOP;
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		INSERT INTO NS.GRUPOSDEUSUARIOSACESSOS(GRUPODEUSUARIO, TIPOREGISTRO, REGISTRO)
		SELECT T.GRUPODEUSUARIO, T.TIPOREGISTRO, T.ENTIDADEEMPRESARIAL
		FROM TEMP_ACESSOS AS T;

		DROP TABLE IF EXISTS TEMP_ACESSOS;
	END;
 END;
 $BODY$;

SELECT PUBLIC.CONVERSAO_ETAPA_01_GRUPODEUSUARIO();

DROP FUNCTION IF EXISTS PUBLIC.CONVERSAO_ETAPA_01_GRUPODEUSUARIO();

---------------------------------------- CONVERSAO PARA O NOVO MODELO DE COMPARTILHAMENTO ---------------------------------------------
 
-- ESTA FUNCAO IRA CRIAR OS CONJUNTOS
 CREATE OR REPLACE FUNCTION PUBLIC.CONVERSAO_ETAPA_02_CONJUNTOS()
 RETURNS VOID
 LANGUAGE PLPGSQL
 VOLATILE 
 AS $BODY$
  --<<MAIN>>

 DECLARE T_ESTABELECIMENTO RECORD;

 BEGIN
 	FOR T_ESTABELECIMENTO IN SELECT * FROM NS.ESTABELECIMENTOS
 	LOOP
 		PERFORM NS.CRIARCONJUNTOS(T_ESTABELECIMENTO.ESTABELECIMENTO);
 	END LOOP;
 END;
 $BODY$;

SELECT PUBLIC.CONVERSAO_ETAPA_02_CONJUNTOS();

DROP FUNCTION IF EXISTS PUBLIC.CONVERSAO_ETAPA_02_CONJUNTOS();

CREATE OR REPLACE FUNCTION PUBLIC.CONVERSAO_ETAPA_03_DADOS()
RETURNS VOID
LANGUAGE PLPGSQL
VOLATILE
AS $BODY$

	DECLARE VAR_IDCADASTRO_PRODUTOSERVICO UUID;
	DECLARE VAR_IDCADASTRO_PESSOA UUID;
	
	DECLARE VAR_REGISTROS_ESTABELECIMENTOS RECORD;
	
	DECLARE VAR_INDICE_CADASTRO RECORD;
	
	DECLARE VAR_NOME_TABELA VARCHAR;
	
	DECLARE VAR_IDCONJUNTO UUID;

	DECLARE VAR_TIPOCOMPARTILHAMENTO INTEGER;

	DECLARE VAR_EMPRESA RECORD;
	
BEGIN
	DROP TABLE IF EXISTS TEMP_CADASTROS;
	CREATE TEMPORARY TABLE TEMP_CADASTROS(ID UUID, CADASTRO INTEGER);
	
	-- CORRECAO DA TABELA NS.PESSOAS PARA O SCRITTA
	RAISE NOTICE 'CORRIGINDO TABELA DE PARTICIPANTES...';
	UPDATE NS.PESSOAS
	SET FICHAATIVADO = 1;
	RAISE NOTICE 'TABELA DE PARTICIPANTES OK.';
	
	-- CORRECAO DO CAMPO INATIVA NA TABELA DE EMPRESAS
	UPDATE NS.EMPRESAS SET INATIVA = FALSE WHERE INATIVA IS NULL;
	
	-- CORRECAO DA TABELA DE UNIDADES QUE O SCRITTA PERMITE DECIMAL NULL
	UPDATE ESTOQUE.UNIDADES SET DECIMAIS = 0 WHERE DECIMAIS IS NULL;	

	SELECT VALOR INTO VAR_TIPOCOMPARTILHAMENTO FROM NS.CONFIGURACOES WHERE APLICACAO = 0 AND CAMPO = 1;
	
	FOR VAR_REGISTROS_ESTABELECIMENTOS IN (SELECT * FROM NS.ESTABELECIMENTOS)
	LOOP

		SELECT * INTO VAR_EMPRESA FROM NS.EMPRESAS WHERE EMPRESA = VAR_REGISTROS_ESTABELECIMENTOS.EMPRESA;

		IF VAR_TIPOCOMPARTILHAMENTO = 0 THEN
			SELECT C.CADASTRO INTO VAR_IDCADASTRO_PRODUTOSERVICO
			FROM NS.GRUPOSEMPRESARIAISCADASTROS AS GU
			INNER JOIN NS.CADASTROS AS C USING(CADASTRO)
			WHERE C.TIPO = 2 AND GU.GRUPOEMPRESARIAL = VAR_EMPRESA.GRUPOEMPRESARIAL;
			
			SELECT C.CADASTRO INTO VAR_IDCADASTRO_PESSOA
			FROM NS.GRUPOSEMPRESARIAISCADASTROS AS GU
			INNER JOIN NS.CADASTROS AS C USING(CADASTRO)
			WHERE C.TIPO = 1 AND GU.GRUPOEMPRESARIAL = VAR_EMPRESA.GRUPOEMPRESARIAL;
		
		ELSEIF VAR_TIPOCOMPARTILHAMENTO = 1 THEN

			SELECT C.CADASTRO INTO VAR_IDCADASTRO_PRODUTOSERVICO
			FROM NS.EMPRESASCADASTROS AS EMP
			INNER JOIN NS.CADASTROS AS C USING(CADASTRO)
			WHERE C.TIPO = 2 AND EMP.EMPRESA = VAR_EMPRESA.EMPRESA;
			
			SELECT C.CADASTRO INTO VAR_IDCADASTRO_PESSOA
			FROM NS.EMPRESASCADASTROS AS EMP
			INNER JOIN NS.CADASTROS AS C USING(CADASTRO)
			WHERE C.TIPO = 1 AND EMP.EMPRESA = VAR_EMPRESA.EMPRESA;		

		ELSEIF VAR_TIPOCOMPARTILHAMENTO = 2 THEN

			SELECT C.CADASTRO INTO VAR_IDCADASTRO_PRODUTOSERVICO
			FROM NS.ESTABELECIMENTOSCADASTROS AS EST
			INNER JOIN NS.CADASTROS AS C USING(CADASTRO)
			WHERE C.TIPO = 2 AND EST.ESTABELECIMENTO = VAR_REGISTROS_ESTABELECIMENTOS.ESTABELECIMENTO;
			
			SELECT C.CADASTRO INTO VAR_IDCADASTRO_PESSOA
			FROM NS.ESTABELECIMENTOSCADASTROS AS EST
			INNER JOIN NS.CADASTROS AS C USING(CADASTRO)
			WHERE C.TIPO = 1 AND EST.ESTABELECIMENTO = VAR_REGISTROS_ESTABELECIMENTOS.ESTABELECIMENTO;
		
		END IF;
				
		RAISE NOTICE 'CONVERTENDO O ESTABELECIMENTO: %', VAR_REGISTROS_ESTABELECIMENTOS.CODIGO;
		
		FOR VAR_INDICE_CADASTRO IN (SELECT I - 1 AS CADASTRO FROM generate_series(1, array_length(enum_range(NULL::ns.tpConjuntoCadastroNomeTabela), 1)) AS I)
		LOOP
			-- VERIFICA SE O CADASTRO JA FOI CONVERTIDO 
			IF VAR_INDICE_CADASTRO.CADASTRO IN (0, 1, 2, 3, 10, 11) THEN
				IF EXISTS(SELECT * FROM TEMP_CADASTROS WHERE ID = VAR_IDCADASTRO_PRODUTOSERVICO AND CADASTRO = VAR_INDICE_CADASTRO.CADASTRO) THEN
					CONTINUE;
				END IF;
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO IN (4, 5, 6, 7, 8, 9, 12) THEN
				IF EXISTS(SELECT * FROM TEMP_CADASTROS WHERE ID = VAR_IDCADASTRO_PESSOA AND CADASTRO = VAR_INDICE_CADASTRO.CADASTRO) THEN
					CONTINUE;
				END IF;				
			END IF;	
		
			-- RECUPERA O CONJUNTO
			SELECT CONJUNTO INTO VAR_IDCONJUNTO FROM NS.ESTABELECIMENTOSCONJUNTOS WHERE ESTABELECIMENTO = VAR_REGISTROS_ESTABELECIMENTOS.ESTABELECIMENTO AND CADASTRO = VAR_INDICE_CADASTRO.CADASTRO;
			
			-- BATCH DOS REGISTROS
			IF VAR_INDICE_CADASTRO.CADASTRO = 0 THEN
				RAISE NOTICE 'CONVERTENDO PRODUTOS...';
				-- PRODUTOS
				INSERT INTO NS.CONJUNTOSPRODUTOS(REGISTRO, CONJUNTO)
				SELECT PRODUTO, VAR_IDCONJUNTO FROM ESTOQUE.PRODUTOS WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'PRODUTOS OK.';
				-- ITENS
				RAISE NOTICE 'CONVERTENDO ITENS...';
				INSERT INTO NS.CONJUNTOSPRODUTOS(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM ESTOQUE.ITENS WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'ITENS OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 1 THEN
				-- UNIDADES
				RAISE NOTICE 'CONVERTENDO UNIDADES...';
				INSERT INTO NS.CONJUNTOSUNIDADES(REGISTRO, CONJUNTO)
				SELECT UNIDADE, VAR_IDCONJUNTO FROM ESTOQUE.UNIDADES WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'UNIDADES OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 2 THEN
				-- COMBUSTIVEL
				RAISE NOTICE 'CONVERTENDO COMBUSTIVEIS...';
				INSERT INTO NS.CONJUNTOSCOMBUSTIVEIS(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM SCRITTA.CMB_COMBUSTIVEIS WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'COMBUSTIVEIS OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 3 THEN
				-- SERVICOS
				RAISE NOTICE 'CONVERTENDO SERVICOS...';
				INSERT INTO NS.CONJUNTOSSERVICOS(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM SERVICOS.SERVICOS WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'SERVICOS OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 4 THEN
				-- CLASSIFICACAO DOS PARTICIPANTES
				RAISE NOTICE 'CONVERTENDO CLASSIFICACAO DOS PARTICIPANTES...';
				INSERT INTO NS.CONJUNTOSCLASSIFICACOESPARTICIPANTES(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.CLAPES WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'CLASSIFICACAO DOS PARTICIPANTES OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 5 THEN
				-- FICHA 
				RAISE NOTICE 'CONVERTENDO FICHAS...';
				INSERT INTO NS.CONJUNTOSFICHAS(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.PESSOAS WHERE ID_GRUPO = VAR_IDCADASTRO_PESSOA AND FICHAATIVADO = 1;
				RAISE NOTICE 'FICHAS OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 6 THEN
				-- CLIENTE
				RAISE NOTICE 'CONVERTENDO CLIENTES...';
				INSERT INTO NS.CONJUNTOSCLIENTES(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.PESSOAS WHERE ID_GRUPO = VAR_IDCADASTRO_PESSOA AND CLIENTEATIVADO = 1;
				RAISE NOTICE 'CLIENTES OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 7 THEN
				-- FORNECEDOR
				RAISE NOTICE 'CONVERTENDO FORNECEDORES...';
				INSERT INTO NS.CONJUNTOSFORNECEDORES(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.PESSOAS WHERE ID_GRUPO = VAR_IDCADASTRO_PESSOA AND FORNECEDORATIVADO = 1;
				RAISE NOTICE 'FORNECEDORES OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 8 THEN
				-- TRANSPORTADORA
				RAISE NOTICE 'CONVERTENDO TRANSPORTADORAS...';
				INSERT INTO NS.CONJUNTOSTRANSPORTADORAS(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.PESSOAS WHERE ID_GRUPO = VAR_IDCADASTRO_PESSOA AND TRANSPORTADORAATIVADO = 1;
				RAISE NOTICE 'TRANSPORTADORAS OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 9 THEN
				-- VENDEDOR
				RAISE NOTICE 'CONVERTENDO VENDEDORES...';
				INSERT INTO NS.CONJUNTOSVENDEDORES(REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.PESSOAS WHERE ID_GRUPO = VAR_IDCADASTRO_PESSOA AND VENDEDORATIVADO = 1;
				RAISE NOTICE 'VENDEDORES OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 10 THEN
				-- SERVICOS DE CATALOGOS
				RAISE NOTICE 'CONVERTENDO SERVICOS DE CATALOGOS...';
				INSERT INTO NS.CONJUNTOSSERVICOSDECATALOGOS(REGISTRO, CONJUNTO)
				SELECT SERVICOCATALOGO, VAR_IDCONJUNTO FROM SERVICOS.SERVICOSCATALOGO WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'SERVICOS DE CATALOGOS OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 11 THEN
				-- MODELO DE CONTRATO
				RAISE NOTICE 'CONVERTENDO MODELOS DE CONTRATO...';
				INSERT INTO NS.CONJUNTOSMODELOSCONTRATOS(REGISTRO, CONJUNTO)
				SELECT MODELOCONTRATO, VAR_IDCONJUNTO FROM FINANCAS.MODELOSCONTRATOS WHERE ID_GRUPO = VAR_IDCADASTRO_PRODUTOSERVICO;
				RAISE NOTICE 'MODELOS DE CONTRATO OK.';
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO = 12 THEN
				-- TECNICOS
				RAISE NOTICE 'CONVERTENDO TECNICOS...';
				INSERT INTO NS.CONJUNTOSTECNICOS (REGISTRO, CONJUNTO)
				SELECT ID, VAR_IDCONJUNTO FROM NS.PESSOAS WHERE ID_GRUPO = VAR_IDCADASTRO_PESSOA AND TECNICOATIVADO = 1;
				RAISE NOTICE 'TECNICOS OK.';
			END IF;
			
			-- REGISTRA O CADASTRO CONVERTIDO
			IF VAR_INDICE_CADASTRO.CADASTRO IN (0, 1, 2, 3, 10, 11) THEN
				INSERT INTO TEMP_CADASTROS VALUES(VAR_IDCADASTRO_PRODUTOSERVICO, VAR_INDICE_CADASTRO.CADASTRO);
			ELSEIF VAR_INDICE_CADASTRO.CADASTRO IN (4, 5, 6, 7, 8, 9, 12) THEN
				INSERT INTO TEMP_CADASTROS VALUES(VAR_IDCADASTRO_PESSOA, VAR_INDICE_CADASTRO.CADASTRO);
			END IF;	
		END LOOP;
	END LOOP;

END;
$BODY$;

SELECT PUBLIC.CONVERSAO_ETAPA_03_DADOS();

DROP FUNCTION IF EXISTS PUBLIC.CONVERSAO_ETAPA_03_DADOS();
