-- TRANSFORMAR RPS EMITIDO EM NFSE
do
$rps$
declare
  reg_rps record;
begin
  for reg_rps in (select * from ns.df_docfis
                  where lancamento >= '2017-04-17'
                    and tipo = 153
                    and statusrps = 4)
  loop
    update ns.df_docfis set
      situacao = 2,
      tipo = 5,
      modelo = 'NES',
         numero = lpad(reg_rps.numero::text, 9, '0')
    where id = reg_rps.id;
  end loop;

  for reg_rps in (select * from ns.df_docfis
                  where numero = '12486'
                    and tipo = 5
                    and situacao = 2)
  loop
    perform servicos.gerarlancamentofiscalnfse(reg_rps.id);
  end loop;
end;
$rps$; 


-- TRANSFORMAR RPS ENVIADO EM NFSE
do
$rps$
declare
  reg_rps record;
begin
  for reg_rps in (select * from ns.df_docfis
                  where numero = '12486'
                    and tipo = 153
                    and statusrps = 3)
  loop
    update ns.df_docfis set
      situacao = 2,
      tipo = 5,
      modelo = 'NES',
      statusrps = 4,
      numero = lpad(reg_rps.numero::text, 9, '0')
    where id = reg_rps.id;
  end loop;

  for reg_rps in (select * from ns.df_docfis
                  where numero = '12486'
                    and tipo = 5
                    and situacao = 2)
  loop
    perform servicos.gerarlancamentofiscalnfse(reg_rps.id);
  end loop;
end;
$rps$;