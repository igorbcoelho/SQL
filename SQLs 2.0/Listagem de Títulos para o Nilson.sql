SELECT DISTINCT T.NUMERO, DF.RPS, T.EMISSAO, P.PESSOA, P.NOME, 
CASE
                WHEN t.origem = 0 THEN 'Manutenção'::text
                WHEN t.origem = 1 THEN 'Pedido'::text
                WHEN t.origem = 2 THEN 'RPS'::text
                WHEN t.origem = 3 THEN 'Contrato'::text
                WHEN t.origem = 4 THEN 'Scritta'::text
                WHEN t.origem = 5 THEN 'Nota Fiscal Serviço'::text
                WHEN t.origem = 6 THEN 'Nota Fiscal Eletrônica'::text
                WHEN t.origem = 7 THEN 'Lançamento Fiscal'::text
                WHEN t.origem = 8 THEN 'Documentos'::text
                WHEN t.origem = 9 THEN 'Nota Serviços Publicos'::text
                WHEN t.origem = 10 THEN 'Nota Prestação Serviços'::text
                WHEN t.origem = 11 THEN 'Conhecimento Transporte'::text
                WHEN t.origem = 12 THEN 'GR ICMS'::text
                WHEN t.origem = 13 THEN 'GR ISS'::text
                WHEN t.origem = 14 THEN 'GNRE'::text
                WHEN t.origem = 15 THEN 'DARF'::text
                WHEN t.origem = 16 THEN 'GPS'::text
                WHEN t.origem = 17 THEN 'Outros Documentos'::text
                WHEN t.origem = 18 THEN 'Folha Persona'::text
                WHEN t.origem = 19 THEN 'Pagamento Persona'::text
                WHEN t.origem = 20 THEN 'Guia Persona'::text
                WHEN t.origem = 21 THEN 'Nota Controller'::text
                WHEN t.origem = 22 THEN 'Importação'::text
                WHEN t.origem = 23 THEN 'Previsão'::text
                WHEN t.origem = 24 THEN 'Fatura'::text
                ELSE NULL::text
            END ORIGEM,
EN.UF, REPLACE((T.VALOR)::TEXT, '.', ',') "VALOR", T.VENCIMENTO, E.CODIGO, FP.DESCRICAO,
CASE
            WHEN t.situacao = 0 THEN 'Aberto'::text
            WHEN t.situacao = 1 THEN 'Quitado'::text
            WHEN t.situacao = 2 THEN 'Em Débito'::text
            WHEN t.situacao = 3 THEN 'Cancelado'::text
            WHEN t.situacao = 4 THEN 'Protestado'::text
            WHEN t.situacao = 5 THEN 'Estornado'::text
            WHEN t.situacao = 6 THEN 'Agendado'::text
            ELSE NULL::text
        END::character varying AS "Situação do Título"
FROM FINANCAS.TITULOS T
JOIN NS.ESTABELECIMENTOS E ON E.ESTABELECIMENTO = T.ID_ESTABELECIMENTO
JOIN NS.PESSOAS P ON P.ID = T.ID_PESSOA
JOIN NS.ENDERECOS EN ON EN.ID_PESSOA = P.ID AND EN.TIPOENDERECO = 0
LEFT JOIN NS.DF_DOCFIS DF ON DF.ID = T.ID_DOCFIS
JOIN NS.FORMASPAGAMENTOS FP ON FP.FORMAPAGAMENTO = T.ID_FORMAPAGAMENTO
WHERE T.SINAL = 0
AND T.EMISSAO = '2018-12-11'
AND T.VENCIMENTO BETWEEN '2019-01-01' AND '2019-01-31'
AND T.SITUACAO = 0 
ORDER BY E.CODIGO, T.EMISSAO, T.NUMERO, T.VENCIMENTO
