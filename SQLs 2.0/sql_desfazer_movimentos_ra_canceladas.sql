DO 
$$
DECLARE 
	REG_MOV_IRREGULARES RECORD; 
BEGIN 
	FOR REG_MOV_IRREGULARES IN (SELECT * FROM estoque.itens_mov WHERE id_ra IN (SELECT ra FROM estoque.RA WHERE sinal = 0 AND status = 13 /*Cancelado*/ )) LOOP
		PERFORM estoque.processar_desprocessar_itens_mov(REG_MOV_IRREGULARES.id, true); 
	END LOOP; 

END; 
$$