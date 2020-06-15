alter table estoque.produtoslotesmovimentacoes alter column itens_mov drop not null;

drop function if exists estoque.zerar_saldo_dos_lotes(date, varchar[], varchar[]);
drop function if exists estoque.zerar_saldo_dos_lotes(date, varchar[]);
drop function if exists estoque.zerar_saldo_dos_lotes(date, varchar[], boolean);

create or replace function estoque.zerar_saldo_dos_lotes(
	a_data date,
	a_familia varchar[] default null,
    a_zerar_produtos boolean default false
)
returns void
language plpgsql
as 
$$

	declare _produto record;
	declare _lote record;
	declare _local_de_estoque record;
    declare _estabelecimento record;

	declare _saldo_atual numeric;	
    declare _quantidade numeric;

    declare _slot record;

    declare _op_entrada record;
    declare _op_saida record;
    declare _op record;
													  
begin
    select * into _op_saida from estoque.operacoes where codigo = 'AJUSTESAIDA';
    select * into _op_entrada from estoque.operacoes where codigo = 'AJUSTEENTRADA';

    for _produto in (
        select p.produto as id, p.codigo, i.id as id_item
        from estoque.itens as i
        join estoque.produtos as p on (p.produto = i.produto)
        left join estoque.familias as f on (f.familia = p.familia)
        where (
            case 
                when a_familia is null then true
                else f.codigo = any (a_familia)
            end
        )
        order by p.codigo
    )
    loop
        -- Passo 1 - Zerar os produtoso
        if (a_zerar_produtos) then
            for _local_de_estoque in (
                select localdeestoque as id, codigo, estabelecimento
                from estoque.locaisdeestoques 
                order by codigo
            )
            loop
                for _slot in (
                    select slot as codigo
                    from estoque.saldoslocaisdeestoques 
                    where item = _produto.id_item
                    group by slot
                    order by slot                    
                )
                loop
                    -- Pega o saldo atual do Lote no SLOT
                    select coalesce(saldo, 0) as saldo 
                    into _saldo_atual 
                    from estoque.saldoslocaisdeestoques 
                    where (item, slot) = (_produto.id_item, _slot.codigo) 
                        and data = (
                            select max(data)
                            from estoque.saldoslocaisdeestoques
                            where (item, slot) = (_produto.id_item, _slot.codigo) 
                                and data <= a_data
                        );

                    _saldo_atual = coalesce(_saldo_atual, 0);

                    if (_saldo_atual = 0) then
                        continue;
                    end if;

                    raise notice 'Produto % - Local de Estoque: % - Slot - % - Saldo: %', _produto.codigo, _local_de_estoque.codigo, _slot.codigo, _saldo_atual;

                    if (_saldo_atual > 0) then
                        _op = _op_saida;
                    else
                        _op = _op_entrada;
                    end if;

                    -- Cria o movimento para zerar e reprocessa o saldo do lote
                    insert into estoque.itens_mov(
                        data,
                        sinal,
                        numero,
                        historico,
                        quantidade,
                        id_estabelecimento,
                        localdeestoque,
                        slot,
                        afeta_customedio_ajuste,
                        zerar_saldo,
                        id_item,
                        operacao_id,
                        operacao_codigo,
                        operacao_descricao
                    )
                    values (
                        a_data,
                        (case when (_saldo_atual) > 0 then 0 else 1 end),
                        'ZERAR',
                        'Movimento para zerar saldo de estoque',
                        _saldo_atual,
                        _local_de_estoque.estabelecimento,
                        _local_de_estoque.id,
                        _slot.codigo,
                        true,
                        true,
                        _produto.id_item,
                        _op.operacao,
                        _op.codigo,
                        _op.descricao
                    );
                end loop;
            end loop;
        end if;

        -- Passo 2 - Itera os Lotes do Produto													  
        for _lote in (
            select produtolote as id, codigo
            from estoque.produtoslotes 
            where produto = _produto.id
            order by codigo
        )
        loop
            delete from estoque.produtoslotesmovimentacoes where itens_mov is null and produtolote = _lote.id;
            delete from estoque.saldoslotes where data = a_data and produtolote = _lote.id;

            -- Passo 3 - Itera os Slots que possuem movimentos neste Lote
            for _slot in (
                select slot as codigo
                from estoque.saldoslotes 
                where produtolote = _lote.id
                group by slot
                order by slot                    
            )
            loop
                -- Pega o saldo atual do Lote no SLOT
                select coalesce(saldo, 0) as saldo 
                into _saldo_atual 
                from estoque.saldoslotes 
                where (produtolote, slot) = (_lote.id, _slot.codigo) 
                    and data = (
                        select max(data)
                        from estoque.saldoslotes
                        where (produtolote, slot) = (_lote.id, _slot.codigo) 
                            and data <= a_data
                    );

                _saldo_atual = coalesce(_saldo_atual, 0);

                if (_saldo_atual = 0) then
                    continue;
                elseif (_saldo_atual > 0) then
                    _quantidade = _saldo_atual;
                else
                    _quantidade = _saldo_atual * (-1);
                end if;

                raise notice 'Produto % - Lote: % - Slot - % - Saldo: %', _produto.codigo, _lote.codigo, _slot.codigo, _saldo_atual;

                -- Cria o movimento para zerar e reprocessa o saldo do lote
                perform estoque.processar_itens_mov_lotes(null, _lote.id, _quantidade);
                perform estoque.processar_saldo_lote(
                    _produto.id_item,
                    _lote.id,
                    a_data,
                    _quantidade::numeric(27, 3),
                    0.00,
                    _slot.codigo,
                    (case when (_saldo_atual) >= 0 then false else true end)
                );
            end loop;
        end loop;
    end loop;

    if (a_zerar_produtos) then
        for _estabelecimento in (
            select estabelecimento as id
            from ns.estabelecimentos
        )
        loop
            perform estoque.refazer_saldos(
                _estabelecimento.id::uuid, 
                (a_data - 1)::date
            );    
        end loop;
    end if;
end
$$;

--TO_DO: PARA EXECUTAR A FUNÇÃO, BASTA EXECUTAR O CÓDIGO ABAIXO. ATENÇÃO NOS COMENTÁRIOS DOS PARÂMETROS
do
$$
begin
	perform estoque.zerar_saldo_dos_lotes(
        '29/01/2019'::date, -- INFORME A DATA NA QUAL SERÁ ZERADO OS SALDOS
        null, -- INFORME O ARRAY DE FAMILIAS DE PRODUTOS (OPCIONAL). EXEMPLO: NULL  OU   ARRAY['FAMILIA_1', 'FAMILIA_2']::VARCHAR[]
        true -- INFORME SE DESEJA ZERAR TAMBEM OS PRODUTOS
    );
end
$$;