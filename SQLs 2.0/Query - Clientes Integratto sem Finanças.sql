SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "NOME CLIENTE", 
p.email "E-MAIL CLIENTE",
p.datacadastro "DATA DE CADASTRO DO CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
v.pessoa "VENDEDOR",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT(SE.servico))::TEXT, '{', '')::TEXT, '}', '') "SISTEMAS",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES"  
FROM ns.pessoas p
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN servicos.servicos SE ON SE.id = ic.servico
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
JOIN NS.PESSOAS V ON V.ID = P.VENDEDOR
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
WHERE NOT c.cancelado
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND c.tipocontrato = 1
AND NOT ic.cancelado
AND se.geracobranca = 1
AND ic.servico 
IN (-- PERSONA SQL
'3821ba39-05ec-4174-a597-7760bf5c8fcc', '1bfb70f7-83cf-4544-9896-095a7f1eb921', '2e4af8d7-b181-4692-8191-52d220919298',
'2d2fbaa1-c020-409c-8af4-bb96001624a3', 'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', '35ab82f0-1c37-415c-9103-d9622500e44e', 
'54b8f8f5-7722-4120-bbe2-a6989e41cc87', 'fdff7347-2438-41e2-9047-1912f25051ab', 'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2',
'18e7ce6e-6f13-4540-9d92-692419d6f1a4', 'c3894596-d89c-4e5c-b263-31f3e497eb83',
-- PERSONA GOLD
'2983ec75-0e2e-4b3c-aa37-e3ad47a2acbc', '89f6f824-75c0-4019-a1b7-03ecf8733343', 'f9376407-913a-4dd9-b9c6-e53c343718ac',
'2983ec75-0e2e-4b3c-aa37-e3ad47a2acbc', '1a42c96e-88dd-4aad-84ea-4a7533a2477f', 'e41a2676-ec3b-4d2a-b584-33b3fd28c8d7',
'9634daa2-a4ae-46b3-a6ec-445594a2f0ad', '0602986a-05ad-4943-9e64-eb2b80d07858', '2520f160-8947-4d98-ae94-5db43843c3de',
'78aa8a37-9c43-4c38-8877-43be207cd49f', '1f0cda32-34e3-46de-8c22-c46673e26577', '9b040ca0-dee7-4504-943a-befea65db8a0',
'2ef89558-522b-49b0-8356-6e98265940a7', 'deef90e8-4fcb-45d3-8948-ab465769e196', '4554b890-d24d-4ff5-9409-6cc286c4510d',
'ff38d7b3-b5af-4e8f-9ded-86c462645653', 'b7721829-cc25-4f5e-93ef-bb673ee6c786', 'f58f7f14-a53e-4862-85d7-375d70e4b8f5',
'c6e7a002-b6e7-491a-a520-69c3af324550', '6952b94a-3533-4a9e-af79-6caf76e72b9d', '70613b85-88bc-4ff3-8761-df3ff9daea0b',
'210ef4be-cf09-4d65-adc8-b2a67b491a5e', 'a80f1171-8caa-407c-8758-1418c5cde50e',
-- CONTÁBIL SQL
'4e3c0cb8-f8a6-426b-8101-7aa08266901f', '47a64e8f-e5d8-491b-bedb-01c03144aaf3', 'a8d847b5-4a28-4db1-8e3f-d3d5b2c90c36',
'b37bc6d8-d223-415b-9ce8-367a404b972b', 'edf03ea4-83aa-461c-b721-6d1b26ae22a8', 'f860ee39-4cb7-405b-ab45-0eb7cd13711c',
'ae3644b7-342f-425d-af55-57e79aa50b10', '0c2b4635-4cba-49e7-8b1f-c57ca85a3c3d', '6abaebd4-ff30-41ba-a0c9-73b0cac5c3cc',
'e9e9398c-822d-4319-9ae1-dc432f56634d',
-- CONTÁBIL GOLD
'dabb57be-6871-4d3f-8825-20ee550551c0', 'ee0fa5ba-c812-4c71-8d27-31767e023dda', 'bf7c6b64-25dd-4bd3-86d4-b5ea74c3a9d5',
'1c2a7f51-ba53-4664-bcfa-d304f3635870', '1aa34466-aaec-4926-b86f-d94fc954e2e4', '88f18005-c55c-42c1-8401-dc6c565bdc3b',
'a8f126c9-1a9f-442a-a56e-60a4f4b622fe',
-- SCRITTA SQL
'a6bbcb89-bb3a-42b5-b37c-0aaacc0d67a9', '0eff2c5a-707e-40e2-a949-2785f7b4a359', '6a6f2727-3654-4333-9655-7a32706275df',
'410e47f6-a78c-4fa0-8e87-379e0ac7ace8', '4ae614e6-7fa7-42bf-8e31-a04511f5cb76', 'cb32ea34-248c-4ca7-ba0e-6d82d46d3c6b',
'48e98c38-62b9-401f-9115-a148dd958764', 'f34c8cd6-fc2a-44ed-a00c-8d7f7fb013ff', 'c5fe3f6a-8a37-4191-a03e-cb7559bbb100',
'7c5cc2ed-3ddf-405a-952a-9186f96ceec6', '04ce6e8b-6425-4663-a5a8-07c7f8aaf116',
-- SCRITTA GOLD
'832ec8db-79b4-496f-ba82-f79185f3312a', 'cf8bb2dd-527e-4435-a5b6-b98066be6380', '570397a9-d876-45a8-9f11-61d37aa33989',
'60867498-2ee8-4159-8704-8c093c9120f1', '9c9c2008-97b0-4e32-ad82-3de9a5ba71a1', '6e47b208-bef2-40a3-b215-076589227c51',
-- INTEGRATTOCONT SQL
'100e19cd-d782-4d56-874d-191b6558dca7', 'a26aedfc-9365-4b0c-b292-e77838aa30c3', '01389533-4d62-4cce-9cfe-301ebbd06855',
'29b61ca1-19e3-4bb2-8733-4eb2ef06e1b5', 'f1b1a314-fc65-4968-8391-d1fea534e231', 'f60f1e73-0933-488e-a520-afb19d3756c0', 
'ce5b79c1-e73a-478c-bb83-8577f64e90d5', '925b835c-41cd-4d11-bd87-08eb88630350', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
-- INTEGRATTO CONT GOLD
'a8d6ba1e-b014-404b-add3-caa4a61fd76b', '113a6579-8cd7-40ca-9fa1-1b4a363b57e8', '78dafad9-cad7-43b5-a6be-f40c4f6fefb7',
'f2ca0e9b-93c4-48c3-bbb8-fc9b22988705', '63974a77-b488-4fc2-8a50-8fd941cefab8', 'fce645c2-5743-429a-a26d-57f9810387fc',
'833bcb21-23e0-4b82-9ccf-8502245ae89b', 'bfcaf0fb-86fe-4d51-bfb8-f0d84afbbb40')
AND NOT EXISTS (SELECT contrato FROM financas.itenscontratos 
WHERE servico NOT IN (-- PERSONA SQL
'3821ba39-05ec-4174-a597-7760bf5c8fcc', '1bfb70f7-83cf-4544-9896-095a7f1eb921', '2e4af8d7-b181-4692-8191-52d220919298',
'2d2fbaa1-c020-409c-8af4-bb96001624a3', 'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', '35ab82f0-1c37-415c-9103-d9622500e44e', 
'54b8f8f5-7722-4120-bbe2-a6989e41cc87', 'fdff7347-2438-41e2-9047-1912f25051ab', 'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2',
'18e7ce6e-6f13-4540-9d92-692419d6f1a4', 'c3894596-d89c-4e5c-b263-31f3e497eb83',
-- PERSONA GOLD
'2983ec75-0e2e-4b3c-aa37-e3ad47a2acbc', '89f6f824-75c0-4019-a1b7-03ecf8733343', 'f9376407-913a-4dd9-b9c6-e53c343718ac',
'2983ec75-0e2e-4b3c-aa37-e3ad47a2acbc', '1a42c96e-88dd-4aad-84ea-4a7533a2477f', 'e41a2676-ec3b-4d2a-b584-33b3fd28c8d7',
'9634daa2-a4ae-46b3-a6ec-445594a2f0ad', '0602986a-05ad-4943-9e64-eb2b80d07858', '2520f160-8947-4d98-ae94-5db43843c3de',
'78aa8a37-9c43-4c38-8877-43be207cd49f', '1f0cda32-34e3-46de-8c22-c46673e26577', '9b040ca0-dee7-4504-943a-befea65db8a0',
'2ef89558-522b-49b0-8356-6e98265940a7', 'deef90e8-4fcb-45d3-8948-ab465769e196', '4554b890-d24d-4ff5-9409-6cc286c4510d',
'ff38d7b3-b5af-4e8f-9ded-86c462645653', 'b7721829-cc25-4f5e-93ef-bb673ee6c786', 'f58f7f14-a53e-4862-85d7-375d70e4b8f5',
'c6e7a002-b6e7-491a-a520-69c3af324550', '6952b94a-3533-4a9e-af79-6caf76e72b9d', '70613b85-88bc-4ff3-8761-df3ff9daea0b',
'210ef4be-cf09-4d65-adc8-b2a67b491a5e', 'a80f1171-8caa-407c-8758-1418c5cde50e',
-- CONTÁBIL SQL
'4e3c0cb8-f8a6-426b-8101-7aa08266901f', '47a64e8f-e5d8-491b-bedb-01c03144aaf3', 'a8d847b5-4a28-4db1-8e3f-d3d5b2c90c36',
'b37bc6d8-d223-415b-9ce8-367a404b972b', 'edf03ea4-83aa-461c-b721-6d1b26ae22a8', 'f860ee39-4cb7-405b-ab45-0eb7cd13711c',
'ae3644b7-342f-425d-af55-57e79aa50b10', '0c2b4635-4cba-49e7-8b1f-c57ca85a3c3d', '6abaebd4-ff30-41ba-a0c9-73b0cac5c3cc',
'e9e9398c-822d-4319-9ae1-dc432f56634d',
-- CONTÁBIL GOLD
'dabb57be-6871-4d3f-8825-20ee550551c0', 'ee0fa5ba-c812-4c71-8d27-31767e023dda', 'bf7c6b64-25dd-4bd3-86d4-b5ea74c3a9d5',
'1c2a7f51-ba53-4664-bcfa-d304f3635870', '1aa34466-aaec-4926-b86f-d94fc954e2e4', '88f18005-c55c-42c1-8401-dc6c565bdc3b',
'a8f126c9-1a9f-442a-a56e-60a4f4b622fe',
-- SCRITTA SQL
'a6bbcb89-bb3a-42b5-b37c-0aaacc0d67a9', '0eff2c5a-707e-40e2-a949-2785f7b4a359', '6a6f2727-3654-4333-9655-7a32706275df',
'410e47f6-a78c-4fa0-8e87-379e0ac7ace8', '4ae614e6-7fa7-42bf-8e31-a04511f5cb76', 'cb32ea34-248c-4ca7-ba0e-6d82d46d3c6b',
'48e98c38-62b9-401f-9115-a148dd958764', 'f34c8cd6-fc2a-44ed-a00c-8d7f7fb013ff', 'c5fe3f6a-8a37-4191-a03e-cb7559bbb100',
'7c5cc2ed-3ddf-405a-952a-9186f96ceec6', '04ce6e8b-6425-4663-a5a8-07c7f8aaf116',
-- SCRITTA GOLD
'832ec8db-79b4-496f-ba82-f79185f3312a', 'cf8bb2dd-527e-4435-a5b6-b98066be6380', '570397a9-d876-45a8-9f11-61d37aa33989',
'60867498-2ee8-4159-8704-8c093c9120f1', '9c9c2008-97b0-4e32-ad82-3de9a5ba71a1', '6e47b208-bef2-40a3-b215-076589227c51',
-- INTEGRATTOCONT SQL
'100e19cd-d782-4d56-874d-191b6558dca7', 'a26aedfc-9365-4b0c-b292-e77838aa30c3', '01389533-4d62-4cce-9cfe-301ebbd06855',
'29b61ca1-19e3-4bb2-8733-4eb2ef06e1b5', 'f1b1a314-fc65-4968-8391-d1fea534e231', 'f60f1e73-0933-488e-a520-afb19d3756c0', 
'ce5b79c1-e73a-478c-bb83-8577f64e90d5', '925b835c-41cd-4d11-bd87-08eb88630350', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
-- INTEGRATTO CONT GOLD
'a8d6ba1e-b014-404b-add3-caa4a61fd76b', '113a6579-8cd7-40ca-9fa1-1b4a363b57e8', '78dafad9-cad7-43b5-a6be-f40c4f6fefb7',
'f2ca0e9b-93c4-48c3-bbb8-fc9b22988705', '63974a77-b488-4fc2-8a50-8fd941cefab8', 'fce645c2-5743-429a-a26d-57f9810387fc',
'833bcb21-23e0-4b82-9ccf-8502245ae89b', 'bfcaf0fb-86fe-4d51-bfb8-f0d84afbbb40'
) AND contrato = c.contrato) 
GROUP BY p.pessoa, p.nome, p.email, p.datacadastro, s.descricao, v.pessoa
ORDER BY p.nome 