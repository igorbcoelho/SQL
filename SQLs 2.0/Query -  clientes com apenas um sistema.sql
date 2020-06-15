select
DISTINCT p.pessoa as cliente,
p.nome, coalesce(e.tipologradouro, '') || ''|| coalesce(e.logradouro, '') || ',' ||coalesce(e.numero, '') || ' - '||coalesce(e.complemento, '') as endereco,
e.bairro,
e.cep,
m.nome,
e.uf,
p.email,
ARRAY_AGG('('||t.ddd||')'||t.telefone)
FROM ns.pessoas p
JOIN ns.enderecos e ON e.id_pessoa = p.id
JOIN ns.municipios m ON m.ibge = e.ibge
JOIN ns.telefones t ON t.id_pessoa = p.id
JOIN financas.contratos c ON c.participante = p.id
JOIN financas.itenscontratos ic ON ic.contrato = c.contrato
WHERE e.tipoendereco = 0 
AND t.tptelefone = 0
AND not c.cancelado
AND c.tipocontrato = 1
AND e.bairro in ('LEBLON', 'Leblon', 'COPACABANA', 'Copacabana', 'IPANEMA', 'Ipanema', 'LAGOA', 'Lagoa', 'Laranjeiras', 'LARANJEIRAS',
'Humaitá', 'HUMAITÁ','HUMAITA','Humaita', 'BOTAFOGO', 'Botafogo', 'CENTRO', 'Centro', 'TIJUCA', 'Tijuca')
AND m.IBGE in ('3303302','3304557') 
AND ic.servico in ('525205d6-55ec-49a6-9dc6-2879dd25efa9','100e19cd-d782-4d56-874d-191b6558dca7',
'967137ae-fe0e-43d2-9b77-50e6a2423903','a26aedfc-9365-4b0c-b292-e77838aa30c3',
'd1b848ba-562f-47ac-93fc-693ce57f7405','20dd3c15-e873-4587-aa7e-d92dfb01f7bb',
'01389533-4d62-4cce-9cfe-301ebbd06855','29b61ca1-19e3-4bb2-8733-4eb2ef06e1b5',
'f1b1a314-fc65-4968-8391-d1fea534e231','f60f1e73-0933-488e-a520-afb19d3756c0',
'748d905d-c1f6-4edc-9748-fc0091112027','399c30fa-6536-4734-9845-68a3f0c9ffa9',
'cd3b9d8e-7090-4f12-8c44-37ce74b26c26','9b2784c1-b96a-41f9-a6eb-f7527a1aabdd',
'ce5b79c1-e73a-478c-bb83-8577f64e90d5','6dd3bca8-1383-45a7-83fe-6183241f9552',
'925b835c-41cd-4d11-bd87-08eb88630350','1abef4ea-b4cb-492b-a8d8-79c2bff2a2c7',
'd92acf22-6507-4810-9022-5517e40ab8a0','68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
'8b8298e8-a52a-4e16-b57d-c7c8adf47c6f','c962618d-5626-459c-9529-830d562df930',
'4203bfdc-48aa-4f75-b973-bfe8d6426d53')
AND not ic.cancelado
AND NOT EXISTS (SELECT contrato FROM financas.itenscontratos WHERE servico NOT IN ('525205d6-55ec-49a6-9dc6-2879dd25efa9','100e19cd-d782-4d56-874d-191b6558dca7',
'967137ae-fe0e-43d2-9b77-50e6a2423903','a26aedfc-9365-4b0c-b292-e77838aa30c3',
'd1b848ba-562f-47ac-93fc-693ce57f7405','20dd3c15-e873-4587-aa7e-d92dfb01f7bb',
'01389533-4d62-4cce-9cfe-301ebbd06855','29b61ca1-19e3-4bb2-8733-4eb2ef06e1b5',
'f1b1a314-fc65-4968-8391-d1fea534e231','f60f1e73-0933-488e-a520-afb19d3756c0',
'748d905d-c1f6-4edc-9748-fc0091112027','399c30fa-6536-4734-9845-68a3f0c9ffa9',
'cd3b9d8e-7090-4f12-8c44-37ce74b26c26','9b2784c1-b96a-41f9-a6eb-f7527a1aabdd',
'ce5b79c1-e73a-478c-bb83-8577f64e90d5','6dd3bca8-1383-45a7-83fe-6183241f9552',
'925b835c-41cd-4d11-bd87-08eb88630350','1abef4ea-b4cb-492b-a8d8-79c2bff2a2c7',
'd92acf22-6507-4810-9022-5517e40ab8a0','68a7171c-bb7b-4e2e-bfb2-086ed66704e5',
'8b8298e8-a52a-4e16-b57d-c7c8adf47c6f','c962618d-5626-459c-9529-830d562df930',
'4203bfdc-48aa-4f75-b973-bfe8d6426d53') AND contrato = c.contrato)
GROUP BY p.pessoa,p.nome,e.tipologradouro,e.logradouro,e.numero,e.complemento,e.bairro,e.cep,m.nome,e.uf,p.email
order by p.nome --limit 10

--select id, * from servicos.servicos where servico ilike '%integrattocont%'
--select * from ns.municipios where nome in ('Niterói', 'Rio de Janeiro')
--select * from ns.enderecos limit 10
