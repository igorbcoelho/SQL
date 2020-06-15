CREATE INDEX idx_financas_titulos_paginacao_datacompetencia
  ON financas.titulos
  USING btree
  (datacompetencia, lastupdate, id);

CREATE INDEX idx_financas_titulos_paginacao_emissao
  ON financas.titulos
  USING btree
  (emissao, lastupdate, id);

CREATE INDEX idx_financas_titulos_paginacao_numero
  ON financas.titulos
  USING btree
  (numero COLLATE pg_catalog."default", lastupdate, id);

CREATE INDEX idx_financas_titulos_paginacao_origem
  ON financas.titulos
  USING btree
  (origem, lastupdate, id);

CREATE INDEX idx_financas_titulos_paginacao_situacao
  ON financas.titulos
  USING btree
  (situacao, lastupdate, id);
  
CREATE INDEX idx_financas_titulos_paginacao_valorbruto
  ON financas.titulos
  USING btree
  (valorbruto, lastupdate, id);

CREATE INDEX idx_financas_titulos_paginacao_vencimento
  ON financas.titulos
  USING btree
  (vencimento, lastupdate, id);