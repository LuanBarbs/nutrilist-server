INSERT INTO Usuario (email, nome, senha_hash, telefone, dataNascimento, sexo, tipo)
VALUES 
('ana@nutri.com', 'Ana Nutricionista', 'hash123', '11999999999', '1990-01-01', 'F', 'nutri'),
('joao@comum.com', 'João Cliente', 'hash456', '21988888888', '1995-05-05', 'M', 'comum'),
('carla@adm.com', 'Carla Admin', 'hash789', '11977777777', '1988-08-08', 'F', 'adm');

INSERT INTO AdmGerenciaNutri (id_adm, id_nutri, modificacao, data_modificacao)
VALUES 
(3, 1, 'Atualização de perfil', '2025-08-05'),
(3, 1, 'Permissão concedida', '2025-08-06'),
(3, 1, 'Bloqueio temporário', '2025-08-06');

INSERT INTO Preferencia (user_id, tipo_preferencia, observacao)
VALUES 
(2, 'sem lactose', 'Intolerante'),
(2, 'sem açúcar', 'Dieta restrita'),
(2, 'baixo sódio', 'Hipertensão');

INSERT INTO Notificacao (mensagem, tipo, data_envio, lida, user_id)
VALUES 
('Produto em promoção!', 'promocao', '2025-08-05', FALSE, 2),
('Recomendação disponível', 'recomendacao', '2025-08-05', FALSE, 2),
('Lembrete de compra', 'lembrete', '2025-08-06', TRUE, 2);

INSERT INTO Pontuacao (pontuacao_preco, pontuacao_nutri, data_registro)
VALUES 
(7, 9, '2025-08-05'),
(5, 10, '2025-08-06'),
(8, 7, '2025-08-06');

INSERT INTO ListaCompra (nome, data_criacao, user_id)
VALUES 
('Lista Semanal', '2025-08-05', 1),
('Lista Saudável', '2025-08-06', 1),
('Lista Econômica', '2025-08-06', 1);

INSERT INTO Compra (data_compra, user_id, codigo_lista, codigo_pontuacao)
VALUES 
('2025-08-05', 2, 1, 1),
('2025-08-06', 2, 2, 2),
('2025-08-06', 2, 3, 3);

INSERT INTO InfoNutricional (caloria, carboidrato, proteina, gordura, sodio)
VALUES 
(100, 10.5, 3.0, 1.0, 120.0),
(80, 8.0, 2.5, 0.5, 90.0),
(150, 20.0, 5.0, 2.0, 200.0);

INSERT INTO Produto (nome, preco_padrao, info_nutri)
VALUES 
('Leite Zero Lactose', 5.99, 1),
('Pão Integral', 3.49, 2),
('Molho Tomate', 7.25, 3);

INSERT INTO Item (preco, data_validade, quantidade, marca, produto_remetente)
VALUES 
(5.99, '2025-12-01', 1, 'A', 1),
(3.49, '2025-09-01', 1, 'B', 2),
(7.25, '2025-10-10', 1, 'C', 3);

INSERT INTO ListaItem (codigo_lista, codigo_item)
VALUES 
(1, 1),
(1, 2),
(2, 3);

INSERT INTO VitaminaMineral (nome, tipo)
VALUES 
('Vitamina C', 'vitamina'),
('Cálcio', 'mineral'),
('Ferro', 'mineral');

INSERT INTO InfoVitaminaMineral (codigo_info, codigo_vitamina_mineral, quantidade)
VALUES 
(1, 1, 30.0),
(2, 2, 40.0),
(3, 3, 25.0);

INSERT INTO HistoricoPreco (codigo_produto, data_coleta, preco)
VALUES 
(1, '2025-08-01', 5.49),
(2, '2025-08-02', 3.19),
(3, '2025-08-03', 6.99);

INSERT INTO SugestaoCompra (tipo_sugestao, motivo, data_sugestao)
VALUES 
('economica', 'Baseado no menor preço', '2025-08-05'),
('saudavel', 'Menor teor de sódio', '2025-08-06'),
('recomendado', 'Recomendação de nutricionista', '2025-08-06');

INSERT INTO SugestaoUsuario (codigo_sugestao, codigo_usuario, data_visualizacao)
VALUES 
(1, 2, '2025-08-05'),
(2, 2, '2025-08-06'),
(3, 2, '2025-08-06');

INSERT INTO SugestaoProduto (codigo_sugestao, codigo_produto)
VALUES 
(1, 2),
(2, 1),
(3, 3);

INSERT INTO Recomendacao (texto_recomendacao, user_id)
VALUES 
('Este produto é ideal para dieta low carb.', 2),
('Evite este produto se for hipertenso.', 2),
('Produto recomendado por sabor e valor nutricional.', 2);

INSERT INTO RecomendacaoNutri (codigo_recomend, nutri_id, resposta, data_resposta)
VALUES 
(1, 1, 'Recomendo esse produto para quem busca uma dieta rica em fibras.', '2025-08-01'),
(2, 1, 'Não indicado para pessoas com hipertensão devido ao alto teor de sódio.', '2025-08-02'),
(3, 1, 'Produto aprovado, balanceado e com bons índices nutricionais.', '2025-08-03');

INSERT INTO Avaliacao (texto_avaliacao, nota_avaliacao, data_avaliacao, nutri_id, codigo_produto)
VALUES 
('Produto com ótimo valor nutricional e baixo teor de sódio.', 9.5, '2025-08-01', 1, 1),
('Contém açúcar em excesso, não recomendado para diabéticos.', 4.0, '2025-08-02', 1, 2),
('Boa fonte de fibras, mas alto teor de gordura.', 6.5, '2025-08-03', 1, 3);
