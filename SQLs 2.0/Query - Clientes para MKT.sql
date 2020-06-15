SELECT DISTINCT p.pessoa as cliente, p.nome, p.email, V.PESSOA, REPLACE(REPLACE(ARRAY_AGG(DISTINCT(SE.servico))::TEXT, '{', '')::TEXT, '}', '')
FROM ns.pessoas p
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
JOIN servicos.servicos SE ON SE.id = ic.servico
JOIN CRM.SEGMENTOSATUACAO S ON P.SEGMENTOATUACAO = S.SEGMENTOATUACAO
JOIN NS.PESSOAS V ON V.ID = P.VENDEDOR
WHERE NOT c.cancelado
AND p.representantetecnicoativado = 0
AND p.representantecomercialativado = 0
AND c.tipocontrato = 1
AND NOT ic.cancelado
AND S.CODIGO = 'CTB'
AND se.geracobranca = 1
AND ic.servico 
IN ('c9425824-263a-477c-8188-afe5f4b44e55', '98ddc3a5-c279-4d86-8d5e-841accffc07c', '40cf8ce7-7da0-45cd-b66c-b1347782dab1', '100e19cd-d782-4d56-874d-191b6558dca7',
'967137ae-fe0e-43d2-9b77-50e6a2423903', '115f4738-55a3-4bb2-bdc8-c4a2a8b511e4', '4e3c0cb8-f8a6-426b-8101-7aa08266901f', '20dd3c15-e873-4587-aa7e-d92dfb01f7bb',
'01389533-4d62-4cce-9cfe-301ebbd06855', 'a8d847b5-4a28-4db1-8e3f-d3d5b2c90c36', 'f60f1e73-0933-488e-a520-afb19d3756c0', '14847aae-280a-467a-b32b-49652c5ad87c',
'b37bc6d8-d223-415b-9ce8-367a404b972b', 'edf03ea4-83aa-461c-b721-6d1b26ae22a8', '399c30fa-6536-4734-9845-68a3f0c9ffa9', '525205d6-55ec-49a6-9dc6-2879dd25efa9',
'f860ee39-4cb7-405b-ab45-0eb7cd13711c', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', 'ae3644b7-342f-425d-af55-57e79aa50b10', '6dd3bca8-1383-45a7-83fe-6183241f9552',
'925b835c-41cd-4d11-bd87-08eb88630350', '1abef4ea-b4cb-492b-a8d8-79c2bff2a2c7', '0c2b4635-4cba-49e7-8b1f-c57ca85a3c3d', 'd92acf22-6507-4810-9022-5517e40ab8a0',
'e9e9398c-822d-4319-9ae1-dc432f56634d', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5', '8b8298e8-a52a-4e16-b57d-c7c8adf47c6f', 'a6bbcb89-bb3a-42b5-b37c-0aaacc0d67a9',
'6a6f2727-3654-4333-9655-7a32706275df', '20dd3c15-e873-4587-aa7e-d92dfb01f7bb', '410e47f6-a78c-4fa0-8e87-379e0ac7ace8', '4ae614e6-7fa7-42bf-8e31-a04511f5cb76',
'cb32ea34-248c-4ca7-ba0e-6d82d46d3c6b', 'f60f1e73-0933-488e-a520-afb19d3756c0', 'f34c8cd6-fc2a-44ed-a00c-8d7f7fb013ff', '525205d6-55ec-49a6-9dc6-2879dd25efa9',
'9b2784c1-b96a-41f9-a6eb-f7527a1aabdd', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', 'd92acf22-6507-4810-9022-5517e40ab8a0', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
'c5fe3f6a-8a37-4191-a03e-cb7559bbb100', '7c5cc2ed-3ddf-405a-952a-9186f96ceec6', '04ce6e8b-6425-4663-a5a8-07c7f8aaf116', '3821ba39-05ec-4174-a597-7760bf5c8fcc',
'1bfb70f7-83cf-4544-9896-095a7f1eb921', '20dd3c15-e873-4587-aa7e-d92dfb01f7bb', '2d2fbaa1-c020-409c-8af4-bb96001624a3', 'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2',
'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', 'f60f1e73-0933-488e-a520-afb19d3756c0', '54b8f8f5-7722-4120-bbe2-a6989e41cc87', '525205d6-55ec-49a6-9dc6-2879dd25efa9',
'fdff7347-2438-41e2-9047-1912f25051ab', '9b2784c1-b96a-41f9-a6eb-f7527a1aabdd', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', 'd92acf22-6507-4810-9022-5517e40ab8a0',
'18e7ce6e-6f13-4540-9d92-692419d6f1a4', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5', 'c3894596-d89c-4e5c-b263-31f3e497eb83', 'f59627db-2acc-4b9f-aba4-36abfe8aa77b',
'9dd205fd-0433-42a5-9fc9-b873b271c153', '92ff21a6-6d04-48f2-ac0e-9ed48e000e90', '64152f02-7cfd-48c2-8fe9-45eca01dafb3', 'ce09d429-c795-464e-8a43-3e501235704a',
'c41c0f3e-c221-4096-9ceb-9cb384609820', 'ada082b5-3d29-483c-b752-7c2edeee0c7d')
AND NOT EXISTS (SELECT contrato FROM financas.itenscontratos 
WHERE servico NOT IN ('c9425824-263a-477c-8188-afe5f4b44e55', '98ddc3a5-c279-4d86-8d5e-841accffc07c', '40cf8ce7-7da0-45cd-b66c-b1347782dab1', '100e19cd-d782-4d56-874d-191b6558dca7',
'967137ae-fe0e-43d2-9b77-50e6a2423903', '115f4738-55a3-4bb2-bdc8-c4a2a8b511e4', '4e3c0cb8-f8a6-426b-8101-7aa08266901f', '20dd3c15-e873-4587-aa7e-d92dfb01f7bb',
'01389533-4d62-4cce-9cfe-301ebbd06855', 'a8d847b5-4a28-4db1-8e3f-d3d5b2c90c36', 'f60f1e73-0933-488e-a520-afb19d3756c0', '14847aae-280a-467a-b32b-49652c5ad87c',
'b37bc6d8-d223-415b-9ce8-367a404b972b', 'edf03ea4-83aa-461c-b721-6d1b26ae22a8', '399c30fa-6536-4734-9845-68a3f0c9ffa9', '525205d6-55ec-49a6-9dc6-2879dd25efa9',
'f860ee39-4cb7-405b-ab45-0eb7cd13711c', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', 'ae3644b7-342f-425d-af55-57e79aa50b10', '6dd3bca8-1383-45a7-83fe-6183241f9552',
'925b835c-41cd-4d11-bd87-08eb88630350', '1abef4ea-b4cb-492b-a8d8-79c2bff2a2c7', '0c2b4635-4cba-49e7-8b1f-c57ca85a3c3d', 'd92acf22-6507-4810-9022-5517e40ab8a0',
'e9e9398c-822d-4319-9ae1-dc432f56634d', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5', '8b8298e8-a52a-4e16-b57d-c7c8adf47c6f', 'a6bbcb89-bb3a-42b5-b37c-0aaacc0d67a9',
'6a6f2727-3654-4333-9655-7a32706275df', '20dd3c15-e873-4587-aa7e-d92dfb01f7bb', '410e47f6-a78c-4fa0-8e87-379e0ac7ace8', '4ae614e6-7fa7-42bf-8e31-a04511f5cb76',
'cb32ea34-248c-4ca7-ba0e-6d82d46d3c6b', 'f60f1e73-0933-488e-a520-afb19d3756c0', 'f34c8cd6-fc2a-44ed-a00c-8d7f7fb013ff', '525205d6-55ec-49a6-9dc6-2879dd25efa9',
'9b2784c1-b96a-41f9-a6eb-f7527a1aabdd', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', 'd92acf22-6507-4810-9022-5517e40ab8a0', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
'c5fe3f6a-8a37-4191-a03e-cb7559bbb100', '7c5cc2ed-3ddf-405a-952a-9186f96ceec6', '04ce6e8b-6425-4663-a5a8-07c7f8aaf116', '3821ba39-05ec-4174-a597-7760bf5c8fcc',
'1bfb70f7-83cf-4544-9896-095a7f1eb921', '20dd3c15-e873-4587-aa7e-d92dfb01f7bb', '2d2fbaa1-c020-409c-8af4-bb96001624a3', 'f4688afb-4394-4b4c-8e67-8b9ce8e70fb2',
'b9c9d1e1-1a7e-4aa8-a5d6-c12f4718d0ad', 'f60f1e73-0933-488e-a520-afb19d3756c0', '54b8f8f5-7722-4120-bbe2-a6989e41cc87', '525205d6-55ec-49a6-9dc6-2879dd25efa9',
'fdff7347-2438-41e2-9047-1912f25051ab', '9b2784c1-b96a-41f9-a6eb-f7527a1aabdd', 'ce5b79c1-e73a-478c-bb83-8577f64e90d5', 'd92acf22-6507-4810-9022-5517e40ab8a0',
'18e7ce6e-6f13-4540-9d92-692419d6f1a4', '68a7171c-bb7b-4e2e-bfb2-086ed66704e5', 'c3894596-d89c-4e5c-b263-31f3e497eb83', 'f59627db-2acc-4b9f-aba4-36abfe8aa77b',
'9dd205fd-0433-42a5-9fc9-b873b271c153', '92ff21a6-6d04-48f2-ac0e-9ed48e000e90', '64152f02-7cfd-48c2-8fe9-45eca01dafb3', 'ce09d429-c795-464e-8a43-3e501235704a',
'c41c0f3e-c221-4096-9ceb-9cb384609820', 'ada082b5-3d29-483c-b752-7c2edeee0c7d') AND contrato = c.contrato)
GROUP BY p.pessoa, p.nome, p.email, V.PESSOA 
order by p.nome

