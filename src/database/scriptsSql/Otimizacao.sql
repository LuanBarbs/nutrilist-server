-- I1: usuários por email (login)
CREATE INDEX idx_usuario_email ON Usuario(email);

-- I2: usuários por tipo (filtro adm)
CREATE INDEX idx_usuario_tipo ON Usuario(tipo);

-- I3: listas de compras por usuários
CREATE INDEX idx_lista_usuario ON ListaCompra(user_id);

-- I4: itens por produto referente
CREATE INDEX idx_item_produto_remetente ON Item(produto_remetente);

-- I5: compras por usuários
CREATE INDEX idx_compra_usuario ON Compra(user_id);

-- I6: histórico de preços por produto e data
CREATE INDEX idx_historico_preco_produto_data ON HistoricoPreco(codigo_produto, data_coleta DESC);

-- I7: preferências por usuário
CREATE INDEX idx_preferencia_usuario ON Preferencia(user_id);

-- I8: produto por informação nutricional
CREATE INDEX idx_produto_info_nutri ON Produto(info_nutri);

-- I9: avaliação por produto
CREATE INDEX idx_avaliacao_produto ON Avaliacao(codigo_produto);

-- I10: usuário por tipo
CREATE INDEX idx_usuario_tipo_id ON Usuario(tipo, id);

-- I11: compra por usuario e data
CREATE INDEX idx_compra_user_data ON Compra(user_id, data_compra DESC);

-- I12: recomendação por usuario
CREATE INDEX idx_recomendacao_user ON Recomendacao(user_id);

-- I13: histórico por produto e data
CREATE INDEX idx_historico_prod_data ON HistoricoPreco(codigo_produto, data_coleta DESC);