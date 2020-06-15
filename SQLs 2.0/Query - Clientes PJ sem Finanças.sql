SELECT DISTINCT 
p.pessoa "CÓDIGO CLIENTE", 
p.nome "NOME CLIENTE", 
p.email "E-MAIL CLIENTE",
p.datacadastro "DATA DE CADASTRO DO CLIENTE",
s.descricao "SEGMENTO DE ATUAÇÃO",
v.pessoa "VENDEDOR",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT(SE.servico))::TEXT, '{', '')::TEXT, '}', '') "SISTEMAS",
REPLACE(REPLACE(ARRAY_AGG(DISTINCT('('||t.ddd||')'||t.telefone))::TEXT, '{', '')::TEXT, '}', '') "TELEFONES",
(COALESCE(en.tipologradouro, '') ||'. '|| COALESCE(en.logradouro, '') ||' nº '|| COALESCE(en.numero, '') ||' - '|| COALESCE(en.complemento, '')) "ENDEREÇO",
en.bairro "BAIRRO",
en.cep "CEP",
en.cidade "CIDADE",
en.UF "UF" 
FROM ns.pessoas p
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN servicos.servicos SE ON SE.id = ic.servico
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
JOIN NS.PESSOAS V ON V.ID = P.VENDEDOR
LEFT JOIN ns.telefones t ON t.id_pessoa = p.id
JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0
WHERE NOT c.cancelado
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND p.qualificacao = 0
AND c.tipocontrato = 1
AND NOT ic.cancelado
AND se.geracobranca = 1
AND ic.servico 
IN (-- INTEGRATTO CONTABIL
'f60f1e73-0933-488e-a520-afb19d3756c0', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
'525205d6-55ec-49a6-9dc6-2879dd25efa9', '925b835c-41cd-4d11-bd87-08eb88630350', '29b61ca1-19e3-4bb2-8733-4eb2ef06e1b5',
'01389533-4d62-4cce-9cfe-301ebbd06855', '6dd3bca8-1383-45a7-83fe-6183241f9552',
-- PERSONA
'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2', '35ab82f0-1c37-415c-9103-d9622500e44e', 'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', 
'fdff7347-2438-41e2-9047-1912f25051ab', 'c3894596-d89c-4e5c-b263-31f3e497eb83', '1bfb70f7-83cf-4544-9896-095a7f1eb921',
'2e4af8d7-b181-4692-8191-52d220919298', '3821ba39-05ec-4174-a597-7760bf5c8fcc', '18e7ce6e-6f13-4540-9d92-692419d6f1a4',
'54b8f8f5-7722-4120-bbe2-a6989e41cc87', '2d2fbaa1-c020-409c-8af4-bb96001624a3',
-- CONTÁBIL
'4e3c0cb8-f8a6-426b-8101-7aa08266901f', '47a64e8f-e5d8-491b-bedb-01c03144aaf3', 'e0a00a6c-cad6-47b3-b1db-86ea68ec9f5c',
'a8d847b5-4a28-4db1-8e3f-d3d5b2c90c36', 'edf03ea4-83aa-461c-b721-6d1b26ae22a8', 'f860ee39-4cb7-405b-ab45-0eb7cd13711c',
'ae3644b7-342f-425d-af55-57e79aa50b10', '0c2b4635-4cba-49e7-8b1f-c57ca85a3c3d', '6abaebd4-ff30-41ba-a0c9-73b0cac5c3cc',
'e9e9398c-822d-4319-9ae1-dc432f56634d', 
-- SCRITTA
'a6bbcb89-bb3a-42b5-b37c-0aaacc0d67a9', '0eff2c5a-707e-40e2-a949-2785f7b4a359',
'6a6f2727-3654-4333-9655-7a32706275df', '410e47f6-a78c-4fa0-8e87-379e0ac7ace8', '4ae614e6-7fa7-42bf-8e31-a04511f5cb76',
'cb32ea34-248c-4ca7-ba0e-6d82d46d3c6b', '48e98c38-62b9-401f-9115-a148dd958764', 'c5fe3f6a-8a37-4191-a03e-cb7559bbb100',
'7c5cc2ed-3ddf-405a-952a-9186f96ceec6', '04ce6e8b-6425-4663-a5a8-07c7f8aaf116')
AND NOT EXISTS (SELECT contrato FROM financas.itenscontratos 
WHERE servico NOT IN (-- INTEGRATTO CONTABIL
'f60f1e73-0933-488e-a520-afb19d3756c0', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
'525205d6-55ec-49a6-9dc6-2879dd25efa9', '925b835c-41cd-4d11-bd87-08eb88630350', '29b61ca1-19e3-4bb2-8733-4eb2ef06e1b5',
'01389533-4d62-4cce-9cfe-301ebbd06855', '6dd3bca8-1383-45a7-83fe-6183241f9552',
-- PERSONA
'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2', '35ab82f0-1c37-415c-9103-d9622500e44e', 'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', 
'fdff7347-2438-41e2-9047-1912f25051ab', 'c3894596-d89c-4e5c-b263-31f3e497eb83', '1bfb70f7-83cf-4544-9896-095a7f1eb921',
'2e4af8d7-b181-4692-8191-52d220919298', '3821ba39-05ec-4174-a597-7760bf5c8fcc', '18e7ce6e-6f13-4540-9d92-692419d6f1a4',
'54b8f8f5-7722-4120-bbe2-a6989e41cc87', '2d2fbaa1-c020-409c-8af4-bb96001624a3',
-- CONTÁBIL
'4e3c0cb8-f8a6-426b-8101-7aa08266901f', '47a64e8f-e5d8-491b-bedb-01c03144aaf3', 'e0a00a6c-cad6-47b3-b1db-86ea68ec9f5c',
'a8d847b5-4a28-4db1-8e3f-d3d5b2c90c36', 'edf03ea4-83aa-461c-b721-6d1b26ae22a8', 'f860ee39-4cb7-405b-ab45-0eb7cd13711c',
'ae3644b7-342f-425d-af55-57e79aa50b10', '0c2b4635-4cba-49e7-8b1f-c57ca85a3c3d', '6abaebd4-ff30-41ba-a0c9-73b0cac5c3cc',
'e9e9398c-822d-4319-9ae1-dc432f56634d', 
-- SCRITTA
'a6bbcb89-bb3a-42b5-b37c-0aaacc0d67a9', '0eff2c5a-707e-40e2-a949-2785f7b4a359',
'6a6f2727-3654-4333-9655-7a32706275df', '410e47f6-a78c-4fa0-8e87-379e0ac7ace8', '4ae614e6-7fa7-42bf-8e31-a04511f5cb76',
'cb32ea34-248c-4ca7-ba0e-6d82d46d3c6b', '48e98c38-62b9-401f-9115-a148dd958764', 'c5fe3f6a-8a37-4191-a03e-cb7559bbb100',
'7c5cc2ed-3ddf-405a-952a-9186f96ceec6', '04ce6e8b-6425-4663-a5a8-07c7f8aaf116') AND contrato = c.contrato) 
GROUP BY p.pessoa, p.nome, p.nomefantasia, p.email, p.datacadastro, s.descricao, v.pessoa,
en.tipologradouro, en.logradouro, en.numero, en.complemento, en.bairro, en.cep, en.cidade, en.UF
ORDER BY p.nome 