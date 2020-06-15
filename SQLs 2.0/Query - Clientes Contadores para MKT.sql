SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "NOME CLIENTE", 
p.email "E-MAIL CLIENTE",
p.datacadastro "DATA DE CADASTRO DO CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
v.pessoa "VENDEDOR",
--c.datainicial "DATA CONTRATO",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES"  
FROM ns.pessoas p
JOIN ns.enderecos e ON e.id_pessoa = p.id
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO 
JOIN NS.PESSOAS V ON V.ID = P.VENDEDOR
WHERE NOT c.cancelado
AND c.tipocontrato = 1
AND NOT ic.cancelado
AND S.CODIGO = 'CTB'
AND c.datainicial <= '2019-06-30'
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
--AND t.tptelefone = 0
GROUP BY p.pessoa, p.nome, p.email, p.datacadastro, s.descricao, v.pessoa  --, c.datainicial
ORDER BY p.nome 
