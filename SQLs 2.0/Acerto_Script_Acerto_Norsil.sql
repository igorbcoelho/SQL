CREATE OR REPLACE FUNCTION conversor.fun_juncao_pessoas_ex(a_codigo_exclusao uuid, a_codigo_juncao uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
  i_quantidade INTEGER;
  i_cliente INTEGER;
  i_fornecedor INTEGER;
  i_transportadora INTEGER;
  i_vendedor INTEGER;
  
  s_tabela text;   
  s_tabela_municipio text; 
  
  uuid_municipio uuid; 
  
  r_view_fk RECORD;  
  r_tabela_municipio RECORD;  
  r_view_fk_municipio RECORD;  
BEGIN
  IF (a_codigo_exclusao IS NULL) OR (a_codigo_juncao IS NULL) THEN
    RETURN TRUE;
  END IF;

  SELECT
    COALESCE (clienteativado, 0),
    COALESCE (fornecedorativado, 0),
	COALESCE (transportadoraativado, 0),
	COALESCE (vendedorativado, 0)
  INTO
    i_cliente,
    i_fornecedor,
    i_transportadora,
    i_vendedor
  FROM
    ns.pessoas
  WHERE
    id = a_codigo_juncao;
	
  FOR r_view_fk IN (SELECT * FROM conversor.view_fk) LOOP   
    s_tabela = (r_view_fk.origem_schema ||'.'|| r_view_fk.origem_table);     
    
    IF (s_tabela = 'ns.enderecos') THEN
      EXECUTE 'DELETE FROM ' || s_tabela || ' WHERE ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_exclusao::text || ''''; 
    ELSIF (s_tabela = 'ns.pessoasmunicipios') THEN
           
      FOR r_tabela_municipio IN EXECUTE 'SELECT pessoamunicipio, ibge, pessoa, lastupdate FROM ns.pessoasmunicipios WHERE pessoa = ' || '''' || a_codigo_exclusao::text || '''' LOOP
	  
        EXECUTE 'SELECT COUNT(*) AS Quantidade FROM ns.pessoasmunicipios WHERE pessoa = ' || '''' || a_codigo_juncao::text || '''' || ' AND ibge = ' || '''' || r_tabela_municipio.ibge || '''' INTO i_quantidade;
        
        IF i_quantidade = 0 THEN                 
          INSERT INTO ns.pessoasmunicipios(ibge, pessoa) VALUES (r_tabela_municipio.ibge, a_codigo_juncao);
        END IF;
        
        EXECUTE 'SELECT pessoamunicipio FROM ns.pessoasmunicipios WHERE pessoa = ' || '''' || a_codigo_juncao::text || '''' || ' AND ibge = ' || '''' || r_tabela_municipio.ibge || '''' INTO uuid_municipio;
        
        FOR r_view_fk_municipio IN (SELECT * FROM conversor.view_fk_municipio)
        LOOP
          s_tabela_municipio = (r_view_fk_municipio.origem_schema ||'.'|| r_view_fk_municipio.origem_table);                   
  
          EXECUTE 'UPDATE ' || s_tabela_municipio || ' SET ' || r_view_fk_municipio.origem_coluna || ' = ' || '''' || uuid_municipio::text || '''' || ' WHERE ' || r_view_fk_municipio.origem_coluna || ' = ' || '''' || r_tabela_municipio.pessoamunicipio::text || '''';
        END LOOP;
      
        EXECUTE 'DELETE FROM ns.pessoasmunicipios WHERE ibge = ' || '''' || r_tabela_municipio.ibge || '''' || ' AND pessoa = ' || '''' || a_codigo_exclusao::text || '''';
      END LOOP;
    ELSIF (s_tabela = 'ns.df_docfis') THEN
      EXECUTE 'UPDATE ' || s_tabela || ' SET ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_juncao || '''' || ' , reconstruirxml = true WHERE ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_exclusao::text || '''';          
    ELSIF (s_tabela = 'persona.historicosgpspessoas') THEN
      EXECUTE 'WITH campos AS (SELECT ano, mes FROM persona.historicosgpspessoas WHERE pessoa = '''||a_codigo_exclusao||''') DELETE FROM persona.historicosgpspessoas WHERE pessoa = '''||a_codigo_juncao||''' AND ano IN (SELECT ano FROM campos) AND mes IN (SELECT mes FROM campos)';
      EXECUTE 'UPDATE ' || s_tabela || ' SET ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_juncao || '''' || ' WHERE ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_exclusao::text || '''';
	ELSIF (s_tabela = 'estoque.precos_praticados') THEN	
		EXECUTE 'UPDATE ' || s_tabela || ' T SET ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_juncao || '''' || ' WHERE ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_exclusao::text || ''''||
		' AND NOT EXISTS (SELECT * FROM ' || s_tabela || ' TT WHERE tt.item = t.item AND tt.estabelecimento = t.estabelecimento AND tt.operacao = t.operacao AND tt.pessoa = '|| '''' || a_codigo_juncao || '''' ||')';
		EXECUTE ' DELETE FROM ' || s_tabela || ' WHERE ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_exclusao::text || '''';
    ELSE
      EXECUTE 'UPDATE ' || s_tabela || ' SET ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_juncao || '''' || ' WHERE ' || r_view_fk.origem_coluna || ' = ' || '''' || a_codigo_exclusao::text || '''';                  
    END IF;
  END LOOP;
  
  UPDATE ns.df_docfis SET xml_docengine = replace(xml_docengine, a_codigo_exclusao::text, a_codigo_juncao::text), reconstruirxml = FALSE WHERE reconstruirxml;

  UPDATE ns.df_docfis SET id_destinatario = a_codigo_juncao WHERE id_destinatario = a_codigo_exclusao;
  BEGIN
    UPDATE ns.df_docfis SET id_emitente = a_codigo_juncao WHERE id_emitente = a_codigo_exclusao;
  EXCEPTION WHEN others THEN
    UPDATE ns.df_docfis SET id_emitente = NULL WHERE id_emitente = a_codigo_exclusao;
  END;
  
  IF i_cliente = 0 THEN
    SELECT clienteativado INTO i_cliente FROM ns.pessoas WHERE id = a_codigo_exclusao;
  END IF;
  
  IF i_fornecedor = 0 THEN
    SELECT fornecedorativado INTO i_fornecedor FROM ns.pessoas WHERE id = a_codigo_exclusao;
  END IF;
  
  IF i_transportadora = 0 THEN
    SELECT transportadoraativado INTO i_transportadora FROM ns.pessoas WHERE id = a_codigo_exclusao;
  END IF;
  
  IF i_vendedor = 0 THEN
    SELECT vendedorativado INTO i_vendedor FROM ns.pessoas WHERE id = a_codigo_exclusao;
  END IF;
  
  UPDATE
    ns.pessoas
  SET
    clienteativado        = i_cliente,
    fornecedorativado     = i_fornecedor,
    transportadoraativado = i_transportadora,
    vendedorativado       = i_vendedor
  WHERE id = a_codigo_juncao; 
  
  DELETE FROM ns.pessoas WHERE id = a_codigo_exclusao;
  
  RETURN TRUE;
END;

$function$
;
