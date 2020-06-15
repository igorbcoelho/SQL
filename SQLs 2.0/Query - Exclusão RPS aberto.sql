do
$rps$
declare
  reg_rps record;
  type_rps servicos.trps_v3;
begin
  for reg_rps in (select * from ns.df_docfis
                  where tipo = 153 
                    and numero::integer between 12611 and 12679
                    and statusrps = 0
                    and lancamento >= '2017-04-19')
  loop
    type_rps.id := reg_rps.id;
    perform servicos.api_rps_v3_exclusao(type_rps);
  end loop;
end;
$rps$;