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
AND S.SEGMENTOATUACAO IN ('48ff60d3-3c6c-4c8e-983c-9ee69244c6e7', '24af28d1-f0e3-43b7-a19f-5cf7eab05ac0', 
'04e0c728-abc1-4d03-b1dd-9a916cca0a8e', '3ebffbec-70ca-4341-baa1-fc2eefaf79de', '3fd4757a-e72d-4037-8faf-d92cc90bc4d1')
/*
AND ic.servico 
IN ('3821ba39-05ec-4174-a597-7760bf5c8fcc', '1bfb70f7-83cf-4544-9896-095a7f1eb921', '2e4af8d7-b181-4692-8191-52d220919298', '2d2fbaa1-c020-409c-8af4-bb96001624a3',
'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', '35ab82f0-1c37-415c-9103-d9622500e44e', '54b8f8f5-7722-4120-bbe2-a6989e41cc87', 'fdff7347-2438-41e2-9047-1912f25051ab',
'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2', '18e7ce6e-6f13-4540-9d92-692419d6f1a4', 'c3894596-d89c-4e5c-b263-31f3e497eb83')
AND NOT EXISTS (SELECT contrato FROM financas.itenscontratos 
WHERE servico NOT IN ('3821ba39-05ec-4174-a597-7760bf5c8fcc', '1bfb70f7-83cf-4544-9896-095a7f1eb921', '2e4af8d7-b181-4692-8191-52d220919298', '2d2fbaa1-c020-409c-8af4-bb96001624a3',
'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', '35ab82f0-1c37-415c-9103-d9622500e44e', '54b8f8f5-7722-4120-bbe2-a6989e41cc87', 'fdff7347-2438-41e2-9047-1912f25051ab',
'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2', '18e7ce6e-6f13-4540-9d92-692419d6f1a4', 'c3894596-d89c-4e5c-b263-31f3e497eb83') AND contrato = c.contrato) 
*/
GROUP BY p.pessoa, p.nome, p.email, p.datacadastro, s.descricao, v.pessoa, M.CODIGO
ORDER BY p.nome 