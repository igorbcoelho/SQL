SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "RAZÃO SOCIAL",
p.nomefantasia "NOME FANTASIA", 
p.email "E-MAIL CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
v.pessoa "VENDEDOR",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES",
(COALESCE(en.tipologradouro, '') ||'. '|| COALESCE(en.logradouro, '') ||' nº '|| COALESCE(en.numero, '') ||' - '|| COALESCE(en.complemento, '')) "ENDEREÇO",
en.bairro "BAIRRO",
en.cep "CEP",
en.cidade "CIDADE",
en.UF "UF"
FROM ns.pessoas p
LEFT JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
LEFT JOIN NS.PESSOAS V ON V.ID = P.VENDEDOR
JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0 
WHERE p.clienteativado = 1
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND p.qualificacao = 0
AND LENGTH(EN.CEP) > 1
AND p.ID NOT IN
(SELECT participante FROM financas.contratos
WHERE NOT cancelado AND tipocontrato = 1)
GROUP BY p.pessoa, p.nome, p.nomefantasia, p.email, p.datacadastro, s.descricao, v.pessoa,
en.tipologradouro, en.logradouro, en.numero, en.complemento, en.bairro, en.cep, en.cidade, en.UF
ORDER BY p.nome 


