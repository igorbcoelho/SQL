﻿WITH CLIENTES AS (SELECT P.ID 
FROM FINANCAS.ITENSCONTRATOS IC
INNER JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
INNER JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
INNER JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
INNER JOIN SERVICOS.SERVICOS SE ON SE.ID = IC.SERVICO
INNER JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0
WHERE C.TIPOCONTRATO = 1
AND IC.CANCELADO = FALSE
AND IC.PROCESSADO = TRUE
AND IC.VALOR > 0
AND C.PERFILCONTRATO = 'S'::CHARACTER
AND IC.RECORRENTE = TRUE
AND IC.UNIDADENATUREZA = 2
AND IC.UNIDADEINTERVALONATUREZA = 2
AND SE.SERVICO = 'MARN'
GROUP BY P.ID
)
SELECT P.PESSOA "CÓDIGO",P.NOME "RAZÃO SOCIAL", P.CNPJ "CNPJ/CPF", EN.UF "UF", S.DESCRICAO "SEGMENTO",
ARRAY_AGG(SE.DESCRICAO) "SISTEMAS"
FROM FINANCAS.ITENSCONTRATOS IC
INNER JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
INNER JOIN NS.PESSOAS P ON P.ID = C.PARTICIPANTE
INNER JOIN CLIENTES A ON A.ID = P.ID
INNER JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
INNER JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0
INNER JOIN SERVICOS.SERVICOS SE ON SE.ID = IC.SERVICO
WHERE C.TIPOCONTRATO = 1
AND IC.CANCELADO = FALSE
AND IC.PROCESSADO = TRUE
AND IC.VALOR > 0
AND C.PERFILCONTRATO = 'S'::CHARACTER
AND IC.RECORRENTE = TRUE
AND IC.UNIDADENATUREZA = 2
AND IC.UNIDADEINTERVALONATUREZA = 2
--AND IC.SERVICO = '8230ee82-9449-422e-bcab-77f3658fef4f'
GROUP BY P.ID, S.DESCRICAO, EN.UF
ORDER BY P.NOME
