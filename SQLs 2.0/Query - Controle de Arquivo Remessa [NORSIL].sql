SELECT 
B.DATAGERACAO "Data Geração Remessa", T.NUMERO, B.NOME_BANCO, B.CODIGO_CONTA, 
B.NOME_CLIENTE, T.EMISSAO, T.VENCIMENTO, E.NOMEFANTASIA "Estabelecimento",
CASE 
WHEN T.ENVIADOREMESSACOBRANCA = TRUE THEN 'Sim' ELSE 'Não' END "Remessa Gerada",
CASE 
WHEN B.SITUACAO IS NULL THEN 'Não Enviado'
WHEN B.SITUACAO = 0 THEN 'Enviado'
WHEN B.SITUACAO = 1 THEN 'Liquidado'
WHEN B.SITUACAO = 2 THEN 'Retirado da Cobrança'
WHEN B.SITUACAO = 3 THEN 'Entrada Confirmada'
WHEN B.SITUACAO = 4 THEN 'Rejeitado'
WHEN B.SITUACAO = 5 THEN 'Retirado da Cobrança/Liquidado'
ELSE 'Analisar' END "Situação Remessa"
FROM FINANCAS.TITULOS T 
LEFT JOIN FINANCAS.BOLETOSBANCARIOS B ON B.ID_TITULO = T.ID 
JOIN NS.ESTABELECIMENTOS E ON E.ESTABELECIMENTO = T.ID_ESTABELECIMENTO
WHERE T.SINAL = 0 
AND T.NUMERO ILIKE '552266.%'
ORDER BY B.DATAGERACAO, T.NUMERO
/*
A CLIENTE PRECISA DOS SEGUINTES CAMPOS:

Data de Geração/Envio
Banco
Conta
Data Emissão Título
Nome do Cliente
Número do Título
Valor do Título
Data de Vencimento

* Totalizador para Quantidade de Boletos e Soma dos valores dos boletos


OS FILTROS DEVEM SER POR:
Empresa
Período (da geração do arquivo)
Conta (precisa incluir mais de uma)

*/