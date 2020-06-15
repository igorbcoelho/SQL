SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "NOME CLIENTE", 
p.email "E-MAIL CLIENTE",
p.datacadastro "DATA DE CADASTRO DO CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
v.pessoa "VENDEDOR",
M.CODIGO "MIDIA ORIGEM",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT(SE.servico))::TEXT, '{', '')::TEXT, '}', '') "SISTEMAS",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES"  
FROM ns.pessoas p
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN servicos.servicos SE ON SE.id = ic.servico
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
JOIN NS.PESSOAS V ON V.ID = P.VENDEDOR
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
LEFT JOIN CRM.MIDIASORIGEM M ON M.MIDIAORIGEM = P.MIDIAORIGEM
WHERE NOT c.cancelado
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND c.tipocontrato = 1
AND NOT ic.cancelado
AND se.geracobranca = 1
AND ic.servico 
IN ('1bfb70f7-83cf-4544-9896-095a7f1eb921', '2e4af8d7-b181-4692-8191-52d220919298', 'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', 
'fdff7347-2438-41e2-9047-1912f25051ab',  'c3894596-d89c-4e5c-b263-31f3e497eb83') 
AND NOT EXISTS (SELECT contrato FROM financas.itenscontratos 
WHERE servico NOT IN ('1bfb70f7-83cf-4544-9896-095a7f1eb921', '2e4af8d7-b181-4692-8191-52d220919298', 'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', 
'fdff7347-2438-41e2-9047-1912f25051ab',  'c3894596-d89c-4e5c-b263-31f3e497eb83')  AND contrato = c.contrato) 
GROUP BY p.pessoa, p.nome, p.email, p.datacadastro, s.descricao, v.pessoa, M.CODIGO
ORDER BY p.nome 