-- SCRIPT AJUSTE DE NUMERAÇÃO DE TÍTULOS DO CLIENTE NARA ROOSLER

-- PRIMEIRO SCRIPT
DO
$$
DECLARE REGISTRO RECORD;
DECLARE VAR_NUMERO BIGINT;
BEGIN
VAR_NUMERO := 1;
FOR REGISTRO IN ( SELECT ID 
FROM FINANCAS.TITULOS 
WHERE NUMERO >= 'GNRNY1' 
AND ID_ESTABELECIMENTO = 'df82a320-fd92-40c5-a015-ea6b9fcef9c4' 
AND SINAL = 0 
ORDER BY NUMERO ) LOOP
UPDATE FINANCAS.TITULOS SET NUMERO = ('NOVO'||VAR_NUMERO::VARCHAR)::VARCHAR WHERE ID = REGISTRO.ID;
VAR_NUMERO := VAR_NUMERO + 1;
END LOOP; 
END;
$$;

-- SEGUNDO SCRIPT
DO
$$
DECLARE REGISTRO RECORD;
DECLARE VAR_NUMERO BIGINT;
BEGIN
VAR_NUMERO := 1;
FOR REGISTRO IN ( SELECT ID 
FROM FINANCAS.TITULOS 
WHERE NUMERO >= 'NOVO1' 
AND ID_ESTABELECIMENTO = 'df82a320-fd92-40c5-a015-ea6b9fcef9c4' 
AND SINAL = 0 
ORDER BY NUMERO ) LOOP
UPDATE FINANCAS.TITULOS SET NUMERO = ('GNRNY'||VAR_NUMERO::VARCHAR)::VARCHAR WHERE ID = REGISTRO.ID;
VAR_NUMERO := VAR_NUMERO + 1;
END LOOP; 
END;
$$;

-- INSERIR ZEROS A ESQUERDA NO NÚMERO
UPDATE FINANCAS.TITULOS 
SET NUMERO = SUBSTRING(NUMERO FROM 1 FOR 5) || '00' || SUBSTRING(NUMERO FROM 6 FOR 6)
WHERE NUMERO BETWEEN 'GNRNY1' AND 'GNRNY9';

UPDATE FINANCAS.TITULOS 
SET NUMERO = SUBSTRING(NUMERO FROM 1 FOR 5) || '0' || SUBSTRING(NUMERO FROM 6 FOR 7)
WHERE NUMERO BETWEEN 'GNRNY10' AND 'GNRNY99';