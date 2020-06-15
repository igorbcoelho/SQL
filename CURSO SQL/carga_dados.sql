-- INCLUSÃO DE CLIENTES
INSERT INTO CLIENTES (codcliente, nome, documento, endereco, bairro, cidade, uf, cep)
VALUES (2, 'Pedro Teixeira', '22222222222', 'Travessa Costa e Silva, 124', 'Centro', 'Barueri', 'SP', '20003-009');

INSERT INTO CLIENTES (codcliente, nome, documento, endereco, bairro, cidade, uf, cep)
VALUES (3, 'Ana Souza', '33333333333', 'Av. da Américas, 800', 'Barra', 'Rio de Janeiro', 'RJ', '20003-009');

INSERT INTO CLIENTES (codcliente, nome, documento, endereco, bairro, cidade, uf, cep)
VALUES (4, 'Camila Silva', '44444444444', 'Rua do Mercado, 75', 'Zona Leste', 'São Paulo', 'SP', '20003-009');

INSERT INTO CLIENTES (codcliente, nome, documento, endereco, bairro, cidade, uf, cep)
VALUES (5, 'Mario Torres', '55555555555', 'Av. Beira Mar, 1000', 'Vento Norte', 'Vitória', 'ES', '20003-009');

INSERT INTO CLIENTES (codcliente, nome, documento, endereco, bairro, cidade, uf, cep)
VALUES (99, 'Eduardo Silva', '66666666666', 'Rua da Gentileza, 23', 'Charitas', 'Niteroi', 'RJ', '20003-009');


-- INCLUSÃO DE PEDIDOS
INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10002, 2, '2018-11-30', 120.50);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10003, 4, '2018-11-30', 350);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10004, 3, '2018-11-30', 272.75);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10005, 3, '2018-11-30', 412);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10006, 1, '2018-11-30', 223.25);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10007, 2, '2018-11-30', 312.65);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10008, 2, '2018-12-01', 110);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10009, 1, '2018-12-01', 175.20);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10010, 4, '2018-12-01', 237.40);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10011, 3, '2018-12-02', 444.50);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10012, 1, '2018-12-02', 123.50);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10013, 2, '2018-12-03', 80.75);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10014, 4, '2018-12-04', 400);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10015, 1, '2018-12-05', 350);

INSERT INTO PEDIDOS (codpedido, codcliente, datapedido, valor)
VALUES (10016, 5, '2018-12-05', 275.50);
