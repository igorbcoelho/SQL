select * from contas where 
(reduzido between "000001" and "000006" ) and
(reduzido not between "000004" and "000004")

OU

select * from contas where 
(reduzido between "000001" and "000006" ) and
(reduzido <> "000004" )


