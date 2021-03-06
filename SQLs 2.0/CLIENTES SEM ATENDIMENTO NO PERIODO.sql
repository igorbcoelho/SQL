﻿-- CLIENTES ATIVOS
WITH CLIENTES AS (SELECT P.ID 
FROM FINANCAS.ITENSCONTRATOS IC
JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
JOIN SERVICOS.SERVICOS SE ON SE.ID = IC.SERVICO
WHERE C.TIPOCONTRATO = 1
AND P.BLOQUEADO = FALSE
AND IC.CANCELADO = FALSE
AND IC.PROCESSADO = TRUE
AND IC.VALOR > 0
AND IC.RECORRENTE = TRUE
AND P.ID NOT IN ( -- CLIENTES ATENDIDOS NO PERÍODO
SELECT P.ID
FROM NS.FOLLOWUPS F
JOIN NS.PESSOAS P ON F.PARTICIPANTE = P.ID AND P.CLIENTEATIVADO = 1
JOIN NS.USUARIOS U ON F.USUARIO = U.USUARIO AND U.DEPARTAMENTO = '19eb0727-a506-4efa-ac77-5b75999b04f5' 
WHERE P.BLOQUEADO = FALSE
AND F.DATA BETWEEN (NOW()::DATE -90) AND NOW()::DATE
GROUP BY P.ID)
GROUP BY P.ID)
SELECT P.PESSOA "CÓDIGO",P.NOME "RAZÃO SOCIAL", REPLACE(SUM((IC.VALOR*IC.QUANTIDADE)::NUMERIC(15,2))::TEXT, '.', ',') "TOTAL MANUTENÇÃO", 
S.DESCRICAO "SEGMENTO", EN.UF "UF", R.NOME "REPRESENTANTE"
FROM FINANCAS.ITENSCONTRATOS IC
JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
JOIN CLIENTES A ON A.ID = P.ID
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0
LEFT JOIN NS.PESSOAS R ON R.ID = P.REPRESENTANTE_TECNICO 
WHERE C.TIPOCONTRATO = 1
AND P.BLOQUEADO = FALSE
AND C.CANCELADO = FALSE
AND IC.CANCELADO = FALSE
AND IC.TIPOSUSPENSAO = 0
AND IC.PROCESSADO = TRUE
AND IC.VALOR > 0
AND C.PERFILCONTRATO = 'S'::CHARACTER
AND IC.RECORRENTE = TRUE
GROUP BY P.ID, S.DESCRICAO, EN.UF, R.NOME
ORDER BY SUM(IC.VALOR*IC.QUANTIDADE)::NUMERIC DESC




SELECT * FROM FINANCAS.ITENSCONTRATOS
WHERE CONTRATO IN (
SELECT CONTRATO FROM FINANCAS.CONTRATOS WHERE PARTICIPANTE = (SELECT ID FROM NS.PESSOAS WHERE PESSOA = '21015'))


-- CLIENTES COM ATENDIMENTOS - NEGAR NA CONSULTA
SELECT P.PESSOA, P.NOME
FROM NS.FOLLOWUPS F
JOIN NS.PESSOAS P ON F.PARTICIPANTE = P.ID AND P.CLIENTEATIVADO = 1
JOIN NS.USUARIOS U ON F.USUARIO = U.USUARIO AND U.DEPARTAMENTO = '19eb0727-a506-4efa-ac77-5b75999b04f5' 
WHERE F.DATA BETWEEN '2018-01-01' AND '2018-03-31'
GROUP BY P.PESSOA, P.NOME
ORDER BY COUNT(PESSOA) DESC
