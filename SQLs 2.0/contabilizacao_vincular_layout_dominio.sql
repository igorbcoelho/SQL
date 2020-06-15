delete from contabilizacao.arquivoslayoutempresas;

insert into contabilizacao.arquivoslayoutempresas(arquivolayout, empresa)
select al.arquivolayout ,
       e.empresa
from contabilizacao.arquivoslayout al
cross join ns.empresas e 
where al.descricao ilike 'Dominio Sistemas';