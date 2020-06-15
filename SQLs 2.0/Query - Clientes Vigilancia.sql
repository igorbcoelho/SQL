SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "RAZÃO SOCIAL",
p.nomefantasia "NOME FANTASIA", 
p.email "E-MAIL CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES",
(COALESCE(en.tipologradouro, '') ||'. '|| COALESCE(en.logradouro, '') ||' nº '|| COALESCE(en.numero, '') ||' - '|| COALESCE(en.complemento, '') ||' - '|| COALESCE(en.bairro, '') ||' - '|| COALESCE(en.cidade, '')) "ENDEREÇO",
en.UF "UF"
FROM ns.pessoas p
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN servicos.servicos SE ON SE.id = ic.servico
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0 --AND EN.ENDERECOPADRAO = 0
WHERE NOT c.cancelado 
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND c.tipocontrato = 1
AND NOT ic.cancelado
AND se.geracobranca = 1
AND S.SEGMENTOATUACAO NOT IN('24af28d1-f0e3-43b7-a19f-5cf7eab05ac0', '99fdcf46-f882-45fa-b0c2-de7d44ede8ee') 
AND (p.nome ilike '%seguranca%' or p.nome ilike '%vigilancia%' or p.nomefantasia ilike '%seguranca%' or p.nomefantasia ilike '%vigilancia%') 
GROUP BY p.pessoa, p.nome, p.nomefantasia, p.email, p.datacadastro, s.descricao, 
en.tipologradouro, en.logradouro, en.numero, en.complemento, en.bairro, en.cidade, en.UF
ORDER BY p.nome 


SELECT * FROM NS.ENDERECOS LIMIT 10
