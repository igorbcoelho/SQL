VERIFICA E EXIBE OS PRODUTOS COM CÓDIGO DE BARRAS REPETIDOS
============================================================

SELECT * FROM PRODUTO WHERE sReferencia in (
select sReferencia from Produto
GROUP BY sReferencia
HAVING COUNT(sReferencia) > 1)
ORDER BY sReferencia





SELECT * FROM PRODUTO WHERE srefcontroll in (
select srefcontroll from Produto
GROUP BY srefcontroll
HAVING COUNT(srefcontroll) > 1)
ORDER BY srefcontroll