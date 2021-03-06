DO
$RECALCULA_FLUXO$
 DECLARE CURSOR_FILA RECORD;
 DECLARE TOTAL INTEGER;
 DECLARE VAR_DATA TIMESTAMP;
BEGIN
 SELECT CURRENT_TIMESTAMP INTO VAR_DATA;
 RAISE NOTICE 'INICIO - %', VAR_DATA;
 --RAISE NOTICE 'APAGA A FILA DE PROCESSAMENTO EXISTENTE PARA RECALCULAR O FLUXO';
 TRUNCATE FINANCAS.FILAPROCESSAMENTOFLUXOCAIXA;

 --RAISE NOTICE 'COLOCA TODAS AS DATAS QUE TEM MOVIMENTAÇÃO NO FLUXO';
 PERFORM FINANCAS.FU_ADDFILAPROCESSAMENTOFLUXOCAIXA('2000-01-01'::date, '2018-12-31'::date);

 RAISE NOTICE 'PERCORRE AS DATAS PARA CALCULAR O FLUXO';
 FOR CURSOR_FILA IN ( SELECT DISTINCT DATAPROCESSAMENTO
                      FROM FINANCAS.FILAPROCESSAMENTOFLUXOCAIXA
  WHERE DATAPROCESSAMENTO IS NOT NULL  
                      ORDER BY DATAPROCESSAMENTO ) LOOP
   
   PERFORM FINANCAS.FU_CALCULARFLUXOCAIXA(CURSOR_FILA.DATAPROCESSAMENTO);
   SELECT COUNT( DISTINCT DATAPROCESSAMENTO) FROM FINANCAS.FILAPROCESSAMENTOFLUXOCAIXA INTO TOTAL;
   RAISE NOTICE 'ATUALIZANDO % - RESTANDO % DATAS.', CURSOR_FILA.DATAPROCESSAMENTO, TOTAL;
   DELETE FROM FINANCAS.FILAPROCESSAMENTOFLUXOCAIXA WHERE DATAPROCESSAMENTO = CURSOR_FILA.DATAPROCESSAMENTO;
   
 END LOOP;
END;
$RECALCULA_FLUXO$;