﻿-- LISTAR CLIENTES COM CONTRATOS ATIVOS
SELECT PESSOA, NOME 
FROM NS.PESSOAS
WHERE ID IN(
SELECT DISTINCT P.ID 
FROM NS.PESSOAS P
JOIN FINANCAS.CONTRATOS C ON C.PARTICIPANTE = P.ID
JOIN FINANCAS.ITENSCONTRATOS IC ON IC.CONTRATO = C.CONTRATO
--INNER JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
--INNER JOIN SERVICOS.SERVICOS SE ON SE.ID = IC.SERVICO
--INNER JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0
WHERE C.TIPOCONTRATO = 1
AND IC.CANCELADO = FALSE
AND IC.PROCESSADO = TRUE
--AND IC.VALOR > 0
AND C.PERFILCONTRATO = 'S'::CHARACTER
AND IC.RECORRENTE = TRUE
AND IC.UNIDADENATUREZA = 2
AND IC.UNIDADEINTERVALONATUREZA = 2
--AND (SE.SERVICO = 'MPW' OR SE.SERVICO = 'MSQL-PERSONA')
--AND SE.SERVICO NOT IN ('MCT', 'MET', 'MCW', 'MZW', 'MST', 'MCW2', 'MET2', 'MCMN', 'MCMRNFCE', 'MCMR', 'MMW')
--AND EN.UF = 'RJ'
--AND S.CODIGO IN ('ATA', 'CEX', 'COF', 'COM', 'GEM', 'IBE', 'IGR', 'IND', 'MET', 'REV', 'VAR')
GROUP BY P.ID
) 
ORDER BY NOME