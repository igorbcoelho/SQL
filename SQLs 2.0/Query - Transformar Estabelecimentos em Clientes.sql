-- TRANSFORMAR ESTABELECIMENTOS EM PARTICIPANTES
-- DEVERÁ SER GERADO UM CSV E DEPOIS IMPORTADO NO NSJIMPORTADOR
SELECT 
codigo, 
(raizcnpj||ordemcnpj)::TEXT as CNPJ, 
nomefantasia as razaosocial,
nomefantasia,
'01/01/2018'::DATE as datacadastro,
email,
site,
CASE 
WHEN tiposimples IS NULL THEN '0'::INTEGER
ELSE TIPOSIMPLES::INTEGER END AS TIPOSIMPLES, 
inscricaoestadual, 
inscricaomunicipal, 
tipologradouro, 
logradouro, 
numero, 
complemento,
bairro, 
cep, 
ufcaixapostal as UF,
'1058'::TEXT as pais,
cidade as municipio,
ibge as codigomunicipio, 
''::TEXT as referencia,
''::TEXT as ddi1,
dddtel as ddd1, 
telefone as telefone1, 
''::TEXT as ramal1,
CASE 
WHEN telefone is null THEN ''
ELSE '1' END as tipo1,
''::TEXT as ddi2,
''::TEXT as ddd2, 
''::TEXT as telefone2, 
''::TEXT as ramal2,
'' as tipo2,
''::TEXT as ddi3,
''::TEXT as ddd3, 
''::TEXT as telefone3, 
''::TEXT as ramal3,
'' as tipo3,
nomecontato as nomecontato1,
''::TEXT as sobrenomecontato1, 
emailcontato as emailcontato1,
CASE 
WHEN nomecontato is null THEN ''::TEXT
ELSE 'M'::TEXT END as sexo1,
''::TEXT as nomecontato2,
''::TEXT as sobrenomecontato2, 
''::TEXT as emailcontato2,
''::TEXT as sexo2,
''::TEXT as nomecontato3,
''::TEXT as sobrenomecontato3, 
''::TEXT as emailcontato3,
''::TEXT as sexo3
FROM ns.estabelecimentos;
