WITH pessoas AS (
	SELECT DISTINCT ON (p.nome)
		p.nome nomecliente,
		p.cnpj cnpjcliente,
		p.email emailcliente,
		s.descricao descricaosegmentoatuacao,
		COALESCE(neg.cliente_totalfuncionarios,0) quantidadedefuncionarios,
		cont.nome contatocliente,
		cont.email emailcontatocliente,
		cont.cargo cargocontatocliente,
		(tel.ddd||'-'||tel.telefone) telefonecontatocliente,
		p.id identificador,
		p.segmentoatuacao segmentoatuacao
	FROM ns.pessoas p
	JOIN financas.contratos co ON co.participante = p.id
	LEFT JOIN crm.segmentosatuacao s ON s.segmentoatuacao = p.segmentoatuacao
	LEFT JOIN ns.contatos cont ON cont.id_pessoa = p.id
	LEFT JOIN ns.telefones tel ON tel.id_pessoa = p.id
	LEFT JOIN crm.negocios neg ON neg.id_cliente = p.id
	WHERE co.cancelado IS FALSE
	AND p.clienteativado = 1
	ORDER BY p.nome, cont.nome NULLS LAST
)
SELECT
	p.nomecliente AS "Cliente",
	p.cnpjcliente "Documento",
	p.emailcliente "E-mail",
	p.descricaosegmentoatuacao "Segmento Atuação",
	p.quantidadedefuncionarios as "Quantidade de Funcionários",
	SUM(CASE WHEN ic.recorrente = TRUE THEN ic.valor*ic.quantidade ELSE 0.00 END) as "Total Recorrente",
	SUM(CASE WHEN ic.recorrente = FALSE THEN ic.valor*ic.quantidade ELSE 0.00 END) as "Total Não Recorrente",
	array_agg(ser.descricao) as "Serviços",
	p.contatocliente "Contato",
	p.emailcontatocliente "E-mail do Contato",
	p.cargocontatocliente "Cargo do Contato",
	p.telefonecontatocliente "Telefone do contato"
FROM pessoas p
JOIN financas.contratos co ON co.participante = p.identificador
JOIN financas.itenscontratos ic ON ic.contrato = co.contrato and ic.valor > 0
JOIN servicos.servicos ser ON ser.id = ic.servico
WHERE ((ic.cancelado AND ic.recorrente = FALSE) OR (NOT ic.cancelado)) AND
(ser.servico ILIKE 'mERP-%' OR ser.servico ILIKE 'MSQL-%' OR ser.servico ILIKE 'SQL-%' OR ser.servico ILIKE 'ERP-%')
GROUP BY p.nomecliente, p.cnpjcliente, p.emailcliente, p.descricaosegmentoatuacao, p.quantidadedefuncionarios, p.contatocliente, p.emailcontatocliente, p.cargocontatocliente, p.telefonecontatocliente
ORDER BY p.nomecliente


select DISTINCT ON (p.nome) p.nome as "Cliente", p.cnpj, p.email, s.descricao as "Segmento Atuação", neg.cliente_totalfuncionarios as "Quantidade de Funcionários" ,
SUM(ic.valor*ic.quantidade) as "Total Recorrente", (icnr.valor*icnr.quantidade) as "Total Não Recorrente",
array_agg(ser.descricao) as "Serviços", cont.nome as "Contato", cont.email as "email do Contato", cont.cargo as "Cargo", (tel.ddd||'-'||tel.telefone) as Telefone,
(case co.cancelado when false then 'Ativo' else 'Cancelado' end) as "Situação do Cliente"
from ns.pessoas p
LEFT JOIN crm.segmentosatuacao s ON s.segmentoatuacao = p.segmentoatuacao
LEFT JOIN ns.contatos cont ON cont.id_pessoa = p.id
LEFT JOIN ns.telefones tel ON tel.id_pessoa = p.id
JOIN financas.contratos co ON co.participante = p.id 
JOIN financas.itenscontratos ic ON ic.contrato = co.contrato and ic.recorrente and ic.valor > 0
LEFT JOIN financas.itenscontratos icnr ON icnr.contrato = co.contrato and not icnr.recorrente and icnr.valor > 0
JOIN servicos.servicos ser ON ser.id = ic.servico
LEFT JOIN crm.negocios neg ON neg.id_cliente = p.id
WHERE co.cancelado is false and p.clienteativado = 1 and not ic.cancelado and
(ser.servico ilike 'mERP-%' or ser.servico ilike 'MSQL-%')
GROUP BY p.nome, p.cnpj, p.email, s.descricao, cont.nome, cont.email, cont.cargo, (tel.ddd||'-'||tel.telefone), co.cancelado, neg.cliente_totalfuncionarios,
ic.valor, ic.quantidade, icnr.valor, icnr.quantidade
ORDER BY p.nome


/*
SELECT * FROM ns.contatos  


select * from ns.pessoas limit 100
select * from crm.segmentosatuacao
select * from ns.contatos
select * from financas.itenscontratos limit 100
select * from servicos.servicos where servico ilike 'MSQL-%' limit 1000
select * from ns.telefones where contato is not null

'{"Licença Uso ERP Estoque","Licença Uso ERP Serviços","Licença Uso ERP Finanças","Licença Uso ERP Estoque","Licença Uso ERP Serviços","Licença Uso ERP Finanças","Licença Uso ERP Estoque","Licença Uso ERP Serviços","Licença Uso ERP Finanças"}'
*/