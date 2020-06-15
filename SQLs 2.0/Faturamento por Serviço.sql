 SELECT fat."Identificador Documento",
    fat."Identificador Documento Rateado",
    fat."Identificador Estabelecimento",
    fat."Estabelecimento",
    fat."Nome do Estabelecimento",
    fat."Origem do Documento",
    fat."Número Documento",
    fat."Data de Emissão",
    fat."Identificador Cliente",
    fat."Cliente",
    fat."Nome do Cliente",
    fat."Documento do Cliente",
    fat."Valor Documento",
    fat."Tipo do Documento",
    fat."Identificador Operação",
    fat."Código da Operação",
    fat."Descrição da Operação",
    date_part('Month'::text, fat."Data de Emissão")::integer AS "Mês",
    date_part('Year'::text, fat."Data de Emissão")::integer AS "Ano",
        CASE
            WHEN fat."Tipo do Documento" = 'Nota Fiscal de Mercadoria (NF-e)'::text THEN i.especificacao
            ELSE s.descricao
        END AS "Item",
        CASE
            WHEN fat."Tipo do Documento" = 'Nota Fiscal de Mercadoria (NF-e)'::text THEN i.valor
            WHEN fat."Tipo do Documento" = 'Nota Fiscal de Serviço (NFS-e)'::text THEN s.valor
            ELSE fat."Valor Documento"
        END AS "Item - Valor"
   FROM nsview.vw_faturamento fat
     LEFT JOIN ns.df_itens i ON fat."Identificador Documento" = i.id_docfis
     LEFT JOIN ns.df_servicos s ON fat."Identificador Documento" = s.id_docfis
     WHERE fat."Data de Emissão" BETWEEN '2018-10-01' AND '2018-10-10' 
  ORDER BY fat."Data de Emissão", fat."Identificador Documento";
