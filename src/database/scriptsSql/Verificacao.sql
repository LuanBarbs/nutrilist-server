-- Deve falhar: valor 'fantasma' não permitido pelo CHECK em tipo
INSERT INTO Usuario (email, nome, senha_hash, telefone, dataNascimento, sexo, tipo)
VALUES ('x@email.com', 'Usuário Inválido', 'hash', '000000000', '2000-01-01', 'F', 'fantasma');

-- Deve falhar: tipo 'urgente' não está entre os valores aceitos
INSERT INTO Notificacao (mensagem, tipo, data_envio, lida, user_id)
VALUES ('Teste', 'urgente', CURRENT_DATE, FALSE, 999);

-- Deve falhar: email duplicado
INSERT INTO Usuario (email, nome, senha_hash, telefone, dataNascimento, sexo, tipo)
VALUES ('ana@nutri.com', 'Outra Ana', 'hash999', '11333333333', '1992-02-02', 'F', 'nutri');

-- Deve falhar: tipo_sugestao 'inovadora' não aceito
INSERT INTO SugestaoCompra (tipo_sugestao, motivo, data_sugestao)
VALUES ('inovadora', 'Tipo inválido', CURRENT_DATE);

-- Deve falhar: nome NÃO pode ser NULL
INSERT INTO ListaCompra (nome, data_criacao, user_id)
VALUES (NULL, CURRENT_DATE, 1);

-- Deve falhar: data inválida, preço inválido (espera DECIMAL)
INSERT INTO HistoricoPreco (codigo_produto, data_coleta, preco)
VALUES (1, 'ontem', 'vinte');


-- Deve falhar: nota maior que 10
INSERT INTO Avaliacao (texto_avaliacao, nota_avaliacao, data_avaliacao, nutri_id, codigo_produto)
VALUES ('Nota inválida', 12.0, '2025-08-10', 1, 1);

-- Deve falhar: produto 1 é referenciado em Avaliacao
DELETE FROM Produto WHERE codigo = 1;

-- Deve falhar: chave já existente (1, 1)
INSERT INTO ListaItem (codigo_lista, codigo_item)
VALUES (1, 1);

-- Deve falhar: usuário 2 tem compras e notificações associadas
DELETE FROM Usuario WHERE id = 2;

-- Deve falhar: tipo_sugestao 'desconhecido' não é permitido
INSERT INTO SugestaoCompra (tipo_sugestao, motivo, data_sugestao)
VALUES ('desconhecido', 'Teste de tipo inválido', '2025-08-10');

-- Deve falhar: recomendação código 99 não existe
INSERT INTO RecomendacaoNutri (codigo_recomend, nutri_id, resposta, data_resposta)
VALUES (99, 1, 'Recomendação inválida', '2025-08-10');

-- Deve falhar: produto 999 não existe
INSERT INTO SugestaoProduto (codigo_sugestao, codigo_produto)
VALUES (20, 999);

-- Deve falhar: usuário 1 está referenciado em várias tabelas (avaliação, recomendação, compra, etc.)
DELETE FROM Usuario WHERE id = 1;
