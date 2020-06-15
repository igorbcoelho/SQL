CREATE OR REPLACE FUNCTION job_processar_contratos_recebimentos_mensais(
    a_estabelecimento_id uuid,
    a_mes integer,
    a_ano integer,
    a_indicereajuste uuid DEFAULT NULL::uuid)
  RETURNS void AS
$BODY$
   DECLARE VAR_GRUPOEMPRESARIAL_ID UUID;
   DECLARE VAR_DIAFIMFATURAMENTO INTEGER;
   DECLARE VAR_MSGRATEIO_ERROR TEXT; 
   DECLARE VAR_TEXTO TEXT; 
   DECLARE VAR_PODE_PROCESSAR RECORD;
   DECLARE VAR_JSON_DADOS JSON;
   DECLARE VAR_JSON_DADOS_TEMP JSON;
   DECLARE VAR_RETORNO_PROCESSAMENTO RECORD;
   DECLARE AUX_JSON_LOG JSON;
   DECLARE AUX_JS_LOG JSON;
   DECLARE AUX_MSG_ERRO TEXT;
   DECLARE CURSOR_ITENS RECORD;
        
BEGIN
   --VALIDA OS PARAMENTROS DE ENTRADA DA FUNCAO
   IF NS.ISUUIDNULL( a_estabelecimento_id ) THEN
      RAISE EXCEPTION 'ESTABELECIMENTO NÃO ENCONTRADO';
   END IF;  

   IF NOT ( ( COALESCE(a_mes, 0) > 0 ) AND ( COALESCE(a_mes, 0) <= 12 ) ) THEN
      RAISE EXCEPTION 'MES INVALIDO';
   END IF;  

   IF ( ( COALESCE(a_ano, 0) < 2019 ) ) THEN
      RAISE EXCEPTION 'ANO INVALIDO';
   END IF;  

   --RECUPERA O GRUPO EMPRESARIAL
   SELECT EMP.GRUPOEMPRESARIAL INTO VAR_GRUPOEMPRESARIAL_ID
   FROM NS.ESTABELECIMENTOS EST
   INNER JOIN NS.EMPRESAS EMP ON EMP.EMPRESA = EST.EMPRESA
   WHERE EST.ESTABELECIMENTO = a_estabelecimento_id;

   IF NS.ISUUIDNULL( VAR_GRUPOEMPRESARIAL_ID ) THEN
      RAISE EXCEPTION 'GRUPO EMPRESARIAL NÃO ENCONTRADO';
   END IF;  

   SELECT EXTRACT( DAY FROM ( NS.INC_MONTH(('01-' || a_mes || '-' || a_ano )::DATE, 1 ) - 1 ) )::INTEGER INTO VAR_DIAFIMFATURAMENTO;

   BEGIN
  
      --VERIFICA SE PODE PROCESSAR
      SELECT * 
      FROM FINANCAS._PODE_PROCESSAR_CONTRATO( 1::smallint, 2::smallint, VAR_GRUPOEMPRESARIAL_ID::UUID) AS ( MENSAGEM VARCHAR(150), PODEPROCESSAR BOOLEAN ) INTO VAR_PODE_PROCESSAR ;

      IF NOT COALESCE(VAR_PODE_PROCESSAR.PODEPROCESSAR, FALSE) THEN
        RAISE EXCEPTION '%', COALESCE(VAR_PODE_PROCESSAR.MENSAGEM, '-'); 
      END IF;  
    

      --CRIA A TABELA TEMPORARIA PARA O PROCESSAMENTO
      DROP TABLE IF EXISTS DADOS_PROCESSAR;
      CREATE TEMPORARY TABLE DADOS_PROCESSAR( id_itemcontrato UUID, descricao_itemcontrato VARCHAR, quantidade_itemcontrato INTEGER, valor_itemcontrato NUMERIC(20,8), datacobranca_itemcontrato DATE, 
                                              codigo_contrato VARCHAR, codigo_pessoa VARCHAR, nome_pessoa VARCHAR, tipovalor INTEGER, datainicio_contrato DATE, qtddiasinicio_itemcontrato INTEGER, 
                                              valorinformado_valoritemvariavel BOOLEAN, diafaturamento_itemcontrato INTEGER, observacao_valor VARCHAR, atualizadatacobranca BOOLEAN, codigo_item VARCHAR );
   
      --EXECUTA A BUSCA DOS ITENS A SEREM PROCESSADOS
      INSERT INTO DADOS_PROCESSAR 
      SELECT id_itemcontrato::UUID, 
             descricao_itemcontrato::VARCHAR, 
             quantidade_itemcontrato::INTEGER,  
             valor_itemcontrato::NUMERIC(20,8), 
             datacobranca_itemcontrato::DATE, 
             codigo_contrato::VARCHAR, 
             codigo_pessoa::VARCHAR, 
             nome_pessoa::VARCHAR, 
             tipovalor::INTEGER, 
             datainicio_contrato::DATE,
             qtddiasinicio_itemcontrato::INTEGER, 
             valorinformado_valoritemvariavel::BOOLEAN,
             diafaturamento_itemcontrato::INTEGER, 
             observacao_valor::VARCHAR, 
             atualizadatacobranca::BOOLEAN,
             codigo_item::VARCHAR 
      FROM FINANCAS.MONTAR_CONTRATOS_A_PROCESSAR( VAR_GRUPOEMPRESARIAL_ID::UUID, 1::smallint, 2::smallint, 0::integer, 0::integer, a_mes::integer, a_ano::integer, 1::integer, VAR_DIAFIMFATURAMENTO::integer, a_estabelecimento_id::text, 'S'::text)
         AS ( id_itemcontrato UUID, descricao_itemcontrato VARCHAR, quantidade_itemcontrato INTEGER, valor_itemcontrato NUMERIC(20,8), datacobranca_itemcontrato DATE, 
              codigo_contrato VARCHAR, codigo_pessoa VARCHAR, nome_pessoa VARCHAR, tipovalor INTEGER, datainicio_contrato DATE, qtddiasinicio_itemcontrato INTEGER, 
              valorinformado_valoritemvariavel BOOLEAN, diafaturamento_itemcontrato INTEGER, observacao_valor VARCHAR, atualizadatacobranca BOOLEAN, codigo_item VARCHAR )
      WHERE valor_itemcontrato > 0.00000000;


      --VERIFICA OS RATEIOS DOS ITENS DE CONTRATO
      VAR_MSGRATEIO_ERROR := '';
      FOR CURSOR_ITENS IN ( SELECT C.CODIGO, C.DESCRICAO, COALESCE(S.SERVICO, '') AS CODIGO_SERVICO, IC.CODIGO AS DESCRICAO_ITEM, IC.RATEIO
                            FROM FINANCAS.ITENSCONTRATOS IC
                            INNER JOIN FINANCAS.CONTRATOS C ON C.CONTRATO = IC.CONTRATO
                            INNER JOIN DADOS_PROCESSAR TMP ON TMP.id_itemcontrato = IC.ITEMCONTRATO 
                            LEFT JOIN SERVICOS.SERVICOS S ON S.ID = IC.SERVICO
                            WHERE IC.RATEIO IS NULL ) LOOP

         IF VAR_MSGRATEIO_ERROR = '' THEN
               VAR_MSGRATEIO_ERROR := 'ITENS DE CONTRATOS SEM RATEIOS FINANCEIROS:' ||CHR(10)|| 'CODIGOCONTRATO: ' || CURSOR_ITENS.CODIGO || ' DESCRICAOCONTRATO: ' 
                   || CURSOR_ITENS.DESCRICAO || ' CODIGOSERVICO: ' || CURSOR_ITENS.CODIGO_SERVICO || ' DESCRICAOITEMCONTRATO: ' || CURSOR_ITENS.DESCRICAO_ITEM || '.';
         ELSE
               VAR_MSGRATEIO_ERROR := VAR_MSGRATEIO_ERROR ||CHR(10)|| 'CODIGOCONTRATO: ' || CURSOR_ITENS.CODIGO || ' DESCRICAOCONTRATO: ' || CURSOR_ITENS.DESCRICAO || 
                  ' CODIGOSERVICO: ' || CURSOR_ITENS.CODIGO_SERVICO || ' DESCRICAOITEMCONTRATO: ' || CURSOR_ITENS.DESCRICAO_ITEM || '.';
         END IF;
    
      END LOOP; 
     
      IF COALESCE(VAR_MSGRATEIO_ERROR, '') <> '' THEN
         RAISE EXCEPTION '%', VAR_MSGRATEIO_ERROR; 
      END IF;


      --CRIA O JSON COM OS ITENS A PROCESSAR
      SELECT array_to_json(array_agg(ROW_TO_JSON(T))) INTO VAR_JSON_DADOS_TEMP
      FROM( SELECT id_itemcontrato AS id, atualizadatacobranca as atualizadata FROM DADOS_PROCESSAR ) AS T;  

      VAR_TEXTO := VAR_JSON_DADOS_TEMP::TEXT;
      VAR_JSON_DADOS := ( '{ "IdsItensContratos": ' || VAR_TEXTO || '}')::JSON;
  
      --REAJUSTA OS ITENS DE CONTRATOS CASO O INDICE TENHA SIDO PASSADO
      IF NOT NS.ISUUIDNULL( a_indicereajuste ) THEN
         PERFORM FINANCAS.ATUALIZAR_INDICEREAJUSTE_ITENSCONTRATOS( a_indicereajuste::uuid, 2::smallint, 0::integer, 0::integer, a_mes::integer, a_ano::integer, VAR_JSON_DADOS::text ); 
      END IF; 

     
      --FAZ A PRIMEIRA PARTE DO PROCESSAMENTO
      SELECT * FROM FINANCAS.PROCESSAR_CONTRATOS_MENSAIS_RECEBIMENTOS(VAR_GRUPOEMPRESARIAL_ID::UUID,  a_mes::integer, a_ano::integer, VAR_JSON_DADOS::text) 
         AS (ID UUID, LOG JSON, IDCOMISSAO UUID) INTO VAR_RETORNO_PROCESSAMENTO;

      AUX_JSON_LOG = VAR_RETORNO_PROCESSAMENTO.LOG;
      IF NOT (AUX_JSON_LOG IS NULL) THEN
         AUX_MSG_ERRO := '';       
         FOR AUX_JS_LOG IN ( SELECT * FROM json_array_elements((AUX_JSON_LOG->>'texto')::JSON )) LOOP
            IF AUX_MSG_ERRO = '' THEN
               AUX_MSG_ERRO := (AUX_JS_LOG->>'texto')::VARCHAR;
            ELSE
               AUX_MSG_ERRO := AUX_MSG_ERRO ||CHR(10)|| (AUX_JS_LOG->>'texto')::VARCHAR;
            END IF;
         END LOOP;

         RAISE EXCEPTION 'Erro: %', AUX_MSG_ERRO;

      END IF;
            
      -- FAZ A SEGUNDA PARTE DO PROCESSAMENTO
      PERFORM FINANCAS.EMITIR_COBRANCAS_CONTRATOS(VAR_RETORNO_PROCESSAMENTO.ID, CURRENT_DATE);
	  
	  -- MONTA A DISCRIMINAÇÃO DOS RPS E PRE GERADOS
      UPDATE NS.DF_DOCFIS DF SET DISCRIMINACAOSERVICOS = NS.MONTADISCRIMINACAO_RPS(DF.ID)
	WHERE PROCESSAMENTOCONTRATO = VAR_RETORNO_PROCESSAMENTO.ID;


   EXCEPTION
      WHEN OTHERS THEN
         RAISE EXCEPTION '%', SQLERRM;
   END;
    

   DROP TABLE IF EXISTS DADOS_PROCESSAR;

   RAISE NOTICE 'PROCESSAMENTO FEITO COM SUCESSO'; 
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;