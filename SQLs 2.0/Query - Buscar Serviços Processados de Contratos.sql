﻿-- BUSCAR ITENS PROCESSADOS DE CONTRATOS

SELECT C.CODIGO, DS.VENCIMENTO, DS.INICIOREFERENCIA, DS.FIMREFERENCIA, P.DATAPROCESSAMENTO, DS.ID 
FROM NS.DF_SERVICOS DS 
INNER JOIN FINANCAS.ITENSCONTRATOS IC ON (DS.ITEMCONTRATO = IC.ITEMCONTRATO) 
INNER JOIN FINANCAS.CONTRATOS C ON (C.CONTRATO = IC.CONTRATO)
INNER JOIN FINANCAS.PROCESSAMENTOSCONTRATOS P ON (DS.PROCESSAMENTOCONTRATO = P.PROCESSAMENTOCONTRATO)
WHERE C.CODIGO = '2015-9723'
AND VENCIMENTO = '19/03/2017'
AND DATAPROCESSAMENTO IS NOT NULL
ORDER BY DS.VENCIMENTO DESC