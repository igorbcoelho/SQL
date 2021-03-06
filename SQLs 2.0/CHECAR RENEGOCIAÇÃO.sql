-- EXECUTAR A PRIMEIRA, SE TUDO FOR IGUAL, PEGAR O MUNICIPIO E COLOCAR NA SEGUNDA QUERY

  SELECT P.CONTRATOUNIFICADONACOBRANCA, PM.IBGE
    FROM FINANCAS.CONTRATOS C
    JOIN NS.PESSOAS P ON (P.ID = C.PARTICIPANTE)
JOIN NS.PESSOASMUNICIPIOS PM ON (C.PESSOAMUNICIPIO = PM.PESSOAMUNICIPIO)
    WHERE C.CONTRATO IN ('b17ef6b5-3049-4e83-ae2e-23fb9fc138dc', '6b3001e6-80f6-4a65-88bd-53e0b4ffbc3c');  

	
-- 	
SELECT CF.ID AS CFOP_ID, ic.GRUPOFATURAMENTO, ic.TIPOVENCIMENTO, ic.DIAVENCIMENTO, ic.ADICAOMESESVENCIMENTO, ic.TIPOCOBRANCA, ic.UNIDADENATUREZA, ic.UNIDADEINTERVALONATUREZA, ic.QUANTIDADEINTERVALONATUREZA
                        FROM FINANCAS.ITENSCONTRATOS IC
                   JOIN SERVICOS.SERVICOSCFOPS SC ON (IC.SERVICO = SC.SERVICO_ID)
                   JOIN NS.CFOP CF ON ((SC.CFOP_ID = CF.ID) AND (CF.TIPO::TEXT = '3304557'::TEXT))
                        WHERE IC.CONTRATO IN ('b17ef6b5-3049-4e83-ae2e-23fb9fc138dc', '6b3001e6-80f6-4a65-88bd-53e0b4ffbc3c') AND IC.RECORRENTE AND IC.PROCESSADO AND NOT IC.CANCELADO;