--COMPARA COBRANÇA ATUAL COM COBRANÇA DO MÊS PASSADO
WITH ATUAL AS (
SELECT 	P.ID,
		P.PESSOA,
		row_number() OVER (PARTITION BY P.PESSOA ORDER BY P.PESSOA, T.VALORBRUTO::NUMERIC DESC) NUM,
		T.NUMERO, 
		DF.RPS, 
		T.EMISSAO, 
		T.VENCIMENTO, 
		P.NOME, 
		T.ORIGEMTEXTO, 
		T.SITUACAO, 
		T.VALORBRUTO::NUMERIC, 
		T.ID_DOCFIS,
		E.CODIGO,
		PC.DATAPROCESSAMENTO,
        PC.PROCESSAMENTOCONTRATO,
        ds.inicioreferencia,
        ds.fimreferencia
FROM FINANCAS.TITULOS T
JOIN NS.DF_DOCFIS DF ON T.ID_DOCFIS = DF.ID
JOIN NS.DF_SERVICOS DS ON DF.ID = DS.ID_DOCFIS
JOIN NS.PESSOAS P ON T.ID_PESSOA = P.ID
JOIN NS.ESTABELECIMENTOS E ON T.ID_ESTABELECIMENTO = E.ESTABELECIMENTO
join financas.processamentoscontratos pc on pc.processamentocontrato = df.processamentocontrato
WHERE pc.mes = 07 and --ALTERAR PARA O PERÍODO ATUAL
extract(year from pc.dataprocessamento) = '2018' --ALTERAR PARA O ANO ATUAL
GROUP BY P.ID, P.PESSOA, T.NUMERO, DF.RPS, T.EMISSAO, T.VENCIMENTO, P.NOME, T.ORIGEMTEXTO, T.SITUACAO, T.VALORBRUTO::NUMERIC, T.ID_DOCFIS, E.CODIGO, PC.DATAPROCESSAMENTO, PC.PROCESSAMENTOCONTRATO, ds.inicioreferencia, ds.fimreferencia
order by P.PESSOA, t.VALORBRUTO::NUMERIC desc
), PASSADO AS (
SELECT  P2.ID,
		P2.PESSOA,
		row_number() OVER (PARTITION BY P2.PESSOA ORDER BY P2.PESSOA, T2.VALORBRUTO::NUMERIC DESC) NUM,
		T2.NUMERO, 
		DF2.RPS, 
		T2.EMISSAO, 
		T2.VENCIMENTO, 
		P2.NOME, 
		T2.ORIGEMTEXTO, 
		T2.SITUACAO, 
		T2.VALORBRUTO::NUMERIC,
		T2.ID_DOCFIS,
		E2.CODIGO,
		PC2.DATAPROCESSAMENTO,
		PC2.PROCESSAMENTOCONTRATO,
		ds2.inicioreferencia,
        ds2.fimreferencia
FROM FINANCAS.TITULOS T2
INNER JOIN NS.DF_DOCFIS DF2 ON T2.ID_DOCFIS = DF2.ID
JOIN NS.DF_SERVICOS DS2 ON DF2.ID = DS2.ID_DOCFIS
INNER JOIN NS.PESSOAS P2 ON T2.ID_PESSOA = P2.ID
INNER JOIN NS.ESTABELECIMENTOS E2 ON T2.ID_ESTABELECIMENTO = E2.ESTABELECIMENTO
inner join financas.processamentoscontratos pc2 on pc2.processamentocontrato = df2.processamentocontrato
WHERE pc2.mes = 06 and --ALTERAR PARA O PERIODO PASSADO
extract(year from pc2.dataprocessamento) = '2018' --ALTERAR PARA O ANO ATUAL
GROUP BY P2.ID, P2.PESSOA, T2.NUMERO, DF2.RPS, T2.EMISSAO, T2.VENCIMENTO, P2.NOME, T2.ORIGEMTEXTO, T2.SITUACAO, T2.VALORBRUTO::NUMERIC, T2.ID_DOCFIS, E2.CODIGO, PC2.DATAPROCESSAMENTO, PC2.PROCESSAMENTOCONTRATO, ds2.inicioreferencia, ds2.fimreferencia
order by P2.PESSOA, t2.VALORBRUTO::NUMERIC desc
)SELECT  A.NUMERO "Número", 
		A.RPS "RPS", 
		A.EMISSAO::date "Emissão", 
		A.VENCIMENTO::date "Vencimento", 
		A.INICIOREFERENCIA,
        A.FIMREFERENCIA,
		A.NOME "Cliente", 
		A.ORIGEMTEXTO "Origem", 
		case when A.SITUACAO = 0 then 'Aberto' 
			 when A.SITUACAO = 1 then 'Quitado' 
			 when A.SITUACAO = 2 then 'Em Débito' 
			 when A.SITUACAO = 3 then 'Cancelado' 
			 when A.SITUACAO = 7 then 'Suspenso' 
		end "Situação", 
		A.VALORBRUTO::real "Valor",  
		A.CODIGO "Estabelecimento",
		A.DATAPROCESSAMENTO::TIMESTAMP "Data de Processamento",
		P.NUMERO "Número 2", 
		P.RPS "RPS 2", 
		P.EMISSAO::date "Emissão 2", 
		P.VENCIMENTO::date "Vencimento 2",
		P.INICIOREFERENCIA,
        P.FIMREFERENCIA,
		P.NOME "Cliente 2", 
		P.ORIGEMTEXTO "Origem 2", 
		case when P.SITUACAO = 0 then 'Aberto' 
			 when P.SITUACAO = 1 then 'Quitado' 
			 when P.SITUACAO = 2 then 'Em Débito' 
			 when P.SITUACAO = 3 then 'Cancelado' 
			 when P.SITUACAO = 7 then 'Suspenso' 
		end "Situação 2", 
		P.VALORBRUTO::real "Valor 2",  
		P.CODIGO "Estabelecimento 2",
		P.DATAPROCESSAMENTO::TIMESTAMP "Data de Processamento 2",
		CASE WHEN P.PESSOA IN (SELECT A.PESSOA FROM ATUAL) THEN 'CLIENTE OK'
			WHEN A.PESSOA IN (SELECT P.PESSOA FROM PASSADO) THEN 'CLIENTE OK'
			WHEN P.PESSOA IN (SELECT P.PESSOA FROM FINANCAS.ITENSCONTRATOS IC 
													JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
													JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
												  WHERE C.PERFILCONTRATO = 'S' AND
												  		C.TIPOCONTRATO = 1 AND
												  		IC.RECORRENTE AND
												  		IC.CANCELADO = FALSE AND
												  		IC.PROCESSADO AND
												  		IC.TIPOSUSPENSAO = 2) THEN 'COBRANÇA SUSPENSA'
			WHEN (case when p.pessoa is null then a.pessoa else p.pessoa end) IN 
								(SELECT P.PESSOA FROM FINANCAS.ITENSCONTRATOS IC
													JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
													JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
												  WHERE C.PERFILCONTRATO = 'S' AND
												  		C.TIPOCONTRATO = 1 AND
												  		IC.RECORRENTE AND
												  		IC.CANCELADO = FALSE AND
												  		IC.PROCESSADO AND
												  		IC.QUANTIDADEINTERVALONATUREZA = 12) THEN 'COBRANÇA ANUAL'
			WHEN P.PESSOA NOT IN (SELECT P.PESSOA FROM FINANCAS.ITENSCONTRATOS IC
													JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
													JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
												  WHERE C.PERFILCONTRATO = 'S' AND
												  		C.TIPOCONTRATO = 1 AND
												  		IC.RECORRENTE AND
												  		IC.CANCELADO = FALSE AND
												  		IC.PROCESSADO) THEN 'CANCELADO'
			WHEN A.PESSOA NOT IN (SELECT P.PESSOA FROM FINANCAS.ITENSCONTRATOS IC
													JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
													JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
													JOIN NS.DF_SERVICOS DS ON DS.ITEMCONTRATO = IC.ITEMCONTRATO
												  WHERE C.PERFILCONTRATO = 'S' AND
														C.TIPOCONTRATO = 1 AND
														IC.RECORRENTE AND
														IC.CANCELADO = FALSE AND
														IC.PROCESSADO AND
														DS.VENCIMENTO > (CURRENT_DATE - 180) 
									GROUP BY P.PESSOA, IC.ITEMCONTRATO
									HAVING COUNT(IC.ITEMCONTRATO) > 1) THEN 'PRIMEIRA COBRANÇA'
			ELSE 'VERIFICAR'
	  END "Verificação",
	  CASE WHEN A.VALORBRUTO = P.VALORBRUTO THEN 'VALOR OK'
	  		WHEN (A.VALORBRUTO > P.VALORBRUTO) AND (A.PESSOA IN (SELECT P.PESSOA FROM FINANCAS.ITENSCONTRATOS IC
	  																JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
	  																JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
	  																JOIN ATUAL A ON A.PESSOA = P.PESSOA
	  																	WHERE TO_CHAR(IC.DATAPROXIMOREAJUSTE, 'MM') = TO_CHAR(A.VENCIMENTO, 'MM'))) THEN 'VALOR COM REAJUSTE'
	  		WHEN A.PESSOA NOT IN (SELECT P.PESSOA FROM FINANCAS.ITENSCONTRATOS IC
                                   JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
                                   JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
                                   JOIN NS.DF_SERVICOS DS ON DS.ITEMCONTRATO = IC.ITEMCONTRATO
                                   WHERE C.PERFILCONTRATO = 'S' AND
                                         C.TIPOCONTRATO = 1 AND
                                         IC.RECORRENTE AND
                                         IC.CANCELADO = FALSE AND
                                         IC.PROCESSADO AND
                                         DS.VENCIMENTO > (CURRENT_DATE - 180) 
                                   GROUP BY P.PESSOA, IC.ITEMCONTRATO
                                   HAVING COUNT(IC.ITEMCONTRATO) > 1) 
            THEN 'PRIMEIRA COBRANÇA'
	  		WHEN A.ID IN (WITH AA AS (SELECT COUNT(A.ID) NUM, A.ID FROM NS.DF_SERVICOS DS
                                       JOIN ATUAL A ON A.ID_DOCFIS = DS.ID_DOCFIS
                                       GROUP BY A.ID), 
                               PP AS (SELECT COUNT(P.ID) NUM, P.ID FROM NS.DF_SERVICOS DS
                                       JOIN PASSADO P ON P.ID_DOCFIS = DS.ID_DOCFIS
                                       GROUP BY P.ID) 
                          SELECT AA.ID FROM AA
                          JOIN PP ON PP.ID = AA.ID
                          WHERE AA.NUM > PP.NUM)
            THEN 'SERVIÇO ADICIONADO'   
	  			  		WHEN A.ID IN (WITH AA AS (SELECT COUNT(A.ID) NUM, A.ID FROM NS.DF_SERVICOS DS
                                       JOIN ATUAL A ON A.ID_DOCFIS = DS.ID_DOCFIS
                                       GROUP BY A.ID), 
                               PP AS (SELECT COUNT(P.ID) NUM, P.ID FROM NS.DF_SERVICOS DS
                                       JOIN PASSADO P ON P.ID_DOCFIS = DS.ID_DOCFIS
                                       GROUP BY P.ID) 
                          SELECT AA.ID FROM AA
                          JOIN PP ON PP.ID = AA.ID
                          WHERE AA.NUM < PP.NUM)
            THEN 'SERVIÇO RETIRADO' 
	  		ELSE 'VERIFICAR'
	  END "Validar Valor"
FROM ATUAL A
FULL OUTER JOIN PASSADO P ON A.ID = P.ID AND A.NUM = P.NUM