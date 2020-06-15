
-- EXCLUIR AS BAIXAS DO BORDERÔ ELETRÔNICO

-- EXCLUIR BAIXAS DOS TITULOS
DELETE FROM FINANCAS.BAIXAS 
WHERE ID IN ('c500b7a8-6533-4f8c-a474-e4bc9fd4a1a8', '5ed84812-f19b-4db5-a9c6-328b44ac7b35');

-- EXCLUIR LANÇAMENTOS EM CONTAS
DELETE FROM FINANCAS.LANCAMENTOSCONTAS
WHERE LANCAMENTOCONTA IN ('2a71844a-cc05-4d10-a102-a471865d754b', 'd0b10dd8-9faf-4ad9-a21a-097263317080');

-- MUDAR OS TÍTULOS PARA ABERTO
UPDATE FINANCAS.TITULOS
SET SITUACAO = 0, SITUACAOTEXTO = 'Aberto'
WHERE NUMERO IN ('201705FO008', '201705FO009');

-- MUDAR A SITUAÇÃO DOS ITENS DOS BORDEROS
UPDATE FINANCAS.ITENSBORDEROSELETRONICOS
SET SITUACAO = 2
WHERE BORDEROELETRONICO = (SELECT BORDEROELETRONICO FROM FINANCAS.BORDEROSELETRONICOS WHERE NUMERO = '49');

-- MUDAR O BORDERÔ PARA EM PROCESSAMENTO
UPDATE FINANCAS.BORDEROSELETRONICOS
SET SITUACAO = 1
WHERE NUMERO = '49';
