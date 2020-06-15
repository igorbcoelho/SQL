SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "RAZÃO SOCIAL",
p.nomefantasia "NOME FANTASIA", 
p.email "E-MAIL CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES",
(COALESCE(en.tipologradouro, '') ||'. '|| COALESCE(en.logradouro, '') ||' nº '|| COALESCE(en.numero, '') ||' - '|| COALESCE(en.complemento, '') ||' - '|| COALESCE(en.bairro, '')) "ENDEREÇO",
en.cidade "CIDADE",
en.UF "UF"
FROM ns.pessoas p
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN servicos.servicos SE ON SE.id = ic.servico
LEFT JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0 --AND EN.ENDERECOPADRAO = 0
WHERE NOT c.cancelado 
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND c.tipocontrato = 1
--AND NOT ic.cancelado
--AND se.geracobranca = 1
AND (en.cidade = 'Cabo Frio' or en.cidade = 'Macaé')
GROUP BY p.pessoa, p.nome, p.nomefantasia, p.email, p.datacadastro, s.descricao,
en.tipologradouro, en.logradouro, en.numero, en.complemento, en.bairro, en.cidade, en.cidade, en.UF
ORDER BY p.nome 


