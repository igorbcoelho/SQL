SELECT Produto.sDescricao AS 'Nome do Produto',
       Produto.sRefControll AS 'Cód. Controller', 
       Produto.sReferencia AS 'Cód. Barras',
	   ItemVenda.nQuantidade AS 'Quantidade',
       ItemVenda.nValorTotal AS 'Total do Produto',
       Vendas.sNroCupomNota AS 'Nro. do Cupom',
	   Vendas.dDataVenda AS 'Data da Venda'
FROM Produto
INNER JOIN ItemVenda ON
(Produto.idProduto = ItemVenda.iProduto)
INNER JOIN Vendas ON
(ItemVenda.iCodVenda = Vendas.iCodVenda)
WHERE ItemVenda.sStatus = 'R'
ORDER BY Vendas.dDataVenda, Produto.idProduto

