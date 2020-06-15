--script para localizar triggers no banco e a coluna tgrelid é o codigo da tabela ou o OID da tabela

select * from pg_trigger where tgname = 'nome_da_trigger';

