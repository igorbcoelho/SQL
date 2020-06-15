
delete from scritta.lf_servicos
where id_lanfis = (select id from scritta.lf_lanfis
                  where id_docfis = :ID_DOCFIS);
                  
delete from financas.titulosreceberporvendedores
where tituloreceber in (select id from financas.titulos where id_docfis = :ID_DOCFIS);

delete from financas.titulos
where id_docfis = :ID_DOCFIS;

delete from ns.df_parcelas
where id_pagamento in (select * from ns.df_pagamentos
                      where id_docfis = :ID_DOCFIS);

delete from ns.df_pagamentos
where id_docfis = :ID_DOCFIS;
                           
delete from ns.df_servicos
where id_docfis = :ID_DOCFIS;

delete from servicos.vendedoresrps
where id_docfis = :ID_DOCFIS;
delete from financas.documentosrateados
where documentorateado = (select documentorateado from ns.df_docfis
                         where id = :ID_DOCFIS);

delete from servicos.lotesrpssporrpss where id_docfis = :ID_DOCFIS);
delete from ns.df_docfis where id = :ID_DOCFIS;