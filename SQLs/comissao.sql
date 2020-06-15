update cwtitulo set
 comissao = (select comissao from cwnotfis where (cwtitulo.documento = cwnotfis.nota))
where
 cwtitulo.origem = 1 /* nf saída */
 and
 cwtitulo.documento in (select nota from cwnotfis)

update cwnotfis set
 tipocomissao = 1 /*fixa*/
