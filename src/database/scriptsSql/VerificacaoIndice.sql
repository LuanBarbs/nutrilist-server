-- População de dados de teste
-- 1. Usuario (10.000)
INSERT INTO usuario (email, nome, senha_hash, telefone, datanascimento, sexo, tipo)
SELECT 
    'user' || gs::text || '@email.com',
    'Usuário ' || gs::text,
    md5(random()::text),
    LPAD((trunc(random()*99999999))::text, 8, '0'),
    date '1970-01-01' + (random() * 18250)::int,
    CASE WHEN random() < 0.5 THEN 'M' ELSE 'F' END,
    (ARRAY['comum','adm','nutri','comum_nutri'])[1 + floor(random()*4)]
FROM generate_series(1, 10000) gs;

-- 2. InfoNutricional (50.000)
INSERT INTO infonutricional (codigo, caloria, carboidrato, proteina, gordura, sodio)
SELECT 
    gs,
    (random()*9)::int,
    (random()*9)::numeric(5,2),
    (random()*9)::numeric(5,2),
    (random()*9)::numeric(5,2),
    (random()*9)::int
FROM generate_series(1, 50000) gs;

-- 3. Produto (50.000) referenciando InfoNutricional
INSERT INTO produto (codigo, nome, preco_padrao, info_nutri)
SELECT 
    gs,
    'Produto ' || gs::text,
    (random()*100)::numeric(6,2),
    gs
FROM generate_series(1, 50000) gs;

-- 4. Item (100.000) referenciado Produto
INSERT INTO item (codigo, preco, data_validade, quantidade, produto_remetente)
SELECT 
    gs,
    (random()*100)::numeric(6,2),
    CURRENT_DATE + ((random()*365)::int),
    (1 + random()*50)::int,
    1 + floor(random()*50000)::int
FROM generate_series(1, 100000) gs;

-- 5. ListaCompra (25.000) referenciando Usuario
INSERT INTO listacompra (codigo, nome, data_criacao, user_id)
SELECT 
    gs,
    'Lista ' || gs::text,
    CURRENT_DATE - ((random()*365)::int),
    1 + floor(random()*10000)::int
FROM generate_series(1, 25000) gs;

-- 6. Compra (200.000) referenciado Usuario e ListaCompra
INSERT INTO compra (codigo, data_compra, user_id, codigo_lista, codigo_pontuacao)
SELECT 
    gs,
    CURRENT_DATE - ((random()*365)::int),
    1 + floor(random()*10000)::int,
    1 + floor(random()*25000)::int,
    NULL
FROM generate_series(1, 200000) gs;

-- 7. Avaliacao (75.000) referenciado Usuario (nutricionista) e Produto
INSERT INTO avaliacao (codigo, texto_avalicao, nota_avaliacao, data_avaliacao, nutri_id, codigo_produto)
SELECT 
    gs,
    'Avaliação ' || gs::text || ' do produto',
    (random()*5)::numeric(2,1),
    CURRENT_DATE - ((random()*365)::int),
    1 + floor(random()*10000)::int,
    1 + floor(random()*50000)::int
FROM generate_series(1, 75000) gs;

-- 8. HistoricoPreco (150.000) referenciado Produto
INSERT INTO historicopreco (codigo_produto, data_coleta, preco)
SELECT 
    ((gs - 1) % 50000) + 1, 
    CURRENT_DATE - (((gs - 1) / 50000) % 730),
    (random()*100)::numeric(6,2)
FROM generate_series(1, 150000) gs;
