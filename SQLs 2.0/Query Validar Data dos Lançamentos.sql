
-- VERIFICA NA TABELA LANCAMENTOS
do
$$
 declare lancamentos record;
 declare dataconv timestamp;
 declare doc text;
 declare val numeric;
 declare id uuid;
begin
 begin 

   for lancamentos in (select data, documento, valor, lancamentoconta from financas.lancamentoscontas order by data) loop
     doc := lancamentos.documento;
     val := lancamentos.valor; 
     id := lancamentos.lancamentoconta;
     dataconv := lancamentos.data;

     raise notice '% - % - % - %', lancamentos.data, lancamentos.documento, lancamentos.valor, lancamentos.lancamentoconta;
   end loop; 

 exception 
 when others then
   raise exception '% - % - % - %', SQLERRM, doc, val, id;
 end;    
end;
$$;



-- VERIFICA NA TABELA DE FILADEPROCESSAMENTOFLUXOCAIXA
do
$$
 declare processamentos record;
 declare dataconv timestamp;
 declare lastup timestamp;
begin
 begin 

   for processamentos in (select dataprocessamento, lastupdate from financas.filaprocessamentofluxocaixa 
   order by dataprocessamento DESC) loop
     dataconv := processamentos.dataprocessamento;
     lastup := processamentos.lastupdate; 
     raise notice '% - %', processamentos.dataprocessamento, processamentos.lastupdate;
   end loop; 

 exception 
 when others then
   
   raise exception '% - %', SQLERRM, dataconv, lastup;
 end;    
end;
$$;