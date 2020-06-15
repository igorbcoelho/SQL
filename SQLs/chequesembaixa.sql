select 
  cwcheque.conta, cwcheque.documento, cwcheque.data, cwcheque.valor, cwtitulo.numero, cwtitulo.valor
from 
 cwcheque
 inner join cwTitChe On ( cwCheque.datahora  = cwtitche.cheque)
 inner join cwtitulo on (cwtitche.titulo = cwtitulo.titulo)
 left outer join cwmovime on (cwmovime.titulo = cwtitulo.titulo)
where
 cwcheque.situacao <> 0
 and
 cwmovime.datahora is null

order by
 cwcheque.conta, cwcheque.documento,
