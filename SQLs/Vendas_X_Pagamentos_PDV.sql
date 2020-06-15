SELECT Vendas.sNroCupomNota AS 'Nro. do Cupom',
	   Vendas.dDataVenda AS 'Data da Venda',
	   Vendas.nValorTotal AS 'ValorTotal',
	   Vendas.nSubTotal AS 'SubTotal',
	   Vendas.nValorDesconto AS 'Desconto',
	   Vendas.nValorAcrescimo AS 'Acréscimo',
	   Pagamentos.nValorPagamento AS 'Valor Pagamento',
	   FormaPagamento.sNomePagamento AS 'Forma Pagamento'
FROM Vendas
INNER JOIN Pagamentos ON
(Vendas.iCodVenda = Pagamentos.iCodVenda)
INNER JOIN FormaPagamento ON
(Pagamentos.iCodPagamento = FormaPagamento.iPagamento)
WHERE Vendas.sStatus = 'F' AND Vendas.dDataVenda <= '12/15/2010'
ORDER BY Vendas.sNroCupomNota, Vendas.dDataVenda