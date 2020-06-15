SELECT Vendedores.NomeVendedor AS 'Nome do Vendedor',
	   SUM(Vendas.nSubTotal) AS 'Total Vendido',
	   SUM(Vendas.nValorDesconto) AS 'Total de Desconto',
	  (SUM(Vendas.nSubTotal) - SUM(Vendas.nValorDesconto)) AS 'Valor Liquido'
FROM Vendas
INNER JOIN Vendedores ON
(Vendas.iCodVendedor = Vendedores.idVendedor)
WHERE  (Vendas.dDataVenda >= '01/01/2011')
       AND (Vendas.dDataVenda <= '01/31/2011') 
       AND (Vendas.sStatus = 'F')
GROUP BY Vendedores.NomeVendedor
ORDER BY Vendedores.NomeVendedor