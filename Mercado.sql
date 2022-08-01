CREATE TYPE TAMANHO AS ENUM('Mini_mercado', 'Super_mercado', 'Hiper_mercado');
CREATE TYPE GENERO AS ENUM('Masculino', 'Feminino', 'Outros');
CREATE TYPE CATEGORIA_PRODUTO AS ENUM('Limpeza', 'Frutas', 'Bebidas', 'Doces', 'Basicos', 'Higiene', 'Outros');

CREATE TABLE loja(
	id SERIAL PRIMARY KEY,
	endereco VARCHAR(255) NOT NULL,
	tamanho TAMANHO NOT NULL,
	cpf_proprietario VARCHAR(11)
);

CREATE TABLE funcionario(
	id SERIAL PRIMARY KEY,
	cpf VARCHAR(11) UNIQUE NOT NULL,
	nome VARCHAR(50) NOT NULL,
	endereco VARCHAR(255) NOT NULL,
	salario_base DECIMAL NOT NULL,
	setor VARCHAR(50) NOT NULL,
	cargo VARCHAR(50) NOT NULL,
	id_loja INTEGER NOT NULL REFERENCES loja(id)
);

CREATE TABLE cliente(
	id SERIAL PRIMARY KEY,
	cpf VARCHAR(11) UNIQUE NOT NULL,
	nome VARCHAR(50) NOT NULL,
	endereco VARCHAR(255) NULL,
	genero GENERO NOT NULL
);

CREATE TABLE produto(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria CATEGORIA_PRODUTO NOT NULL,
	preco_unitario DECIMAL NOT NULL CHECK (preco_unitario > 0),
	marca VARCHAR(50)
);

CREATE TABLE venda(
	id SERIAL PRIMARY KEY,
	data DATE NOT NULL,
	id_loja INTEGER NOT NULL REFERENCES loja(id),
	id_cliente INTEGER NULL REFERENCES cliente(id),
	id_funcionario INTEGER NOT NULL REFERENCES funcionario(id)
);

CREATE TABLE produtos_venda(
	id SERIAL PRIMARY KEY,
	id_venda INTEGER NOT NULL REFERENCES venda(id),
	id_produto INTEGER NOT NULL REFERENCES produto(id),
	qtd INTEGER NOT NULL CHECK (qtd > 0)
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Importando dados tabela loja
COPY public.loja (id, endereco, tamanho, cpf_proprietario) 
FROM 'C:/Users/Public/Documents/Dados/Loja.csv' 
DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

-- Importando dados para tabela funcionario
COPY public.funcionario (id, cpf, nome, endereco, salario_base, setor, cargo, id_loja) 
FROM 'C:/Users/Public/Documents/Dados/Funcionarios.csv' 
DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

-- Importando dados para tabela cliente
COPY public.cliente (id, cpf, nome, endereco, genero) 
FROM 'C:/Users/Public/Documents/Dados/Clientes.csv' 
DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

-- Importando dados para tabela produto
COPY public.produto (id, nome, categoria, preco_unitario, marca) 
FROM 'C:/Users/Public/Documents/Dados/Produtos.csv' 
DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

-- Importando dados para tabela venda
COPY public.venda (id, data, id_loja, id_cliente, id_funcionario) 
FROM 'C:/Users/Public/Documents/Dados/Vendas.csv' 
DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';

-- Importando dados para tabela produtos_venda
COPY public.produtos_venda (id, id_venda, id_produto, qtd) 
FROM 'C:/Users/Public/Documents/Dados/Produtos_venda.csv' 
DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '''';
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Alterando a posição das sequências que definem as chaves das tabelas (PK's)
SELECT setval('public.cliente_id_seq', 60, true);
SELECT setval('public.funcionario_id_seq', 40, true);
SELECT setval('public.loja_id_seq', 5, true);
SELECT setval('public.produto_id_seq', 95, true);
SELECT setval('public.produtos_venda_id_seq', 98573, true);
SELECT setval('public.venda_id_seq', 3172, true);

-- Criando VIEW's importantes.
CREATE VIEW valor_das_vendas AS
SELECT venda.id AS "venda",
	   SUM(produtos_venda.qtd * produto.preco_unitario) AS "valor_venda"
FROM venda
INNER JOIN produtos_venda ON produtos_venda.id_venda = venda.id
INNER JOIN produto ON produtos_venda.id_produto = produto.id
GROUP BY "venda";

CREATE VIEW resumo_vendas AS
SELECT venda.id AS "id_venda",
	   venda.data,
	   loja.id AS "id_loja",
	   loja.tamanho AS "tamanho_loja",
	   funcionario.nome AS "nome_atendente",
	   cliente.cpf AS "cpf_cliente",
	   cliente.genero AS "gerero_cliente",
	   valor_das_vendas.valor_venda AS "valor"
FROM venda
INNER JOIN loja ON venda.id_loja = loja.id
INNER JOIN funcionario ON venda.id_funcionario = funcionario.id
 LEFT JOIN cliente ON venda.id_cliente = cliente.id
INNER JOIN valor_das_vendas ON venda.id = valor_das_vendas.venda;

CREATE VIEW produtos_vendidos AS
SELECT * FROM produtos_venda;

CREATE VIEW produtos AS
SELECT * FROM produto;