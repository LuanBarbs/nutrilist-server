CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    senha_hash VARCHAR(64) NOT NULL,
    telefone VARCHAR(20),
    dataNascimento DATE,
    sexo CHAR(1), 
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('comum', 'adm', 'nutri', 'comum_nutri'))
);

CREATE TABLE AdmGerenciaNutri (
    id SERIAL PRIMARY KEY,
    id_adm INT,
    id_nutri INT,
    modificacao VARCHAR(100),
    data_modificacao DATE NOT NULL,
    FOREIGN KEY (id_adm) REFERENCES Usuario(id),
    FOREIGN KEY (id_nutri) REFERENCES Usuario(id)
);

CREATE TABLE Preferencia (
    user_id INT,
    tipo_preferencia VARCHAR(30) NOT NULL CHECK (tipo_preferencia IN ('marcar', 'sem lactose', 'baixo sódio', 'sem glúten', 'sem açúcar')),
    observacao VARCHAR(140),
    PRIMARY KEY (user_id, tipo_preferencia),
    FOREIGN KEY (user_id) REFERENCES Usuario(id)
);

CREATE TABLE Notificacao (
    codigo SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('promocao', 'recomendacao', 'lembrete')),
    data_envio DATE NOT NULL,
    lida BOOLEAN DEFAULT FALSE,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Usuario(id)
);

CREATE TABLE Pontuacao (
    codigo_pontuacao SERIAL PRIMARY KEY,
    pontuacao_preco INT,
    pontuacao_nutri INT,
    data_registro DATE NOT NULL
);

CREATE TABLE ListaCompra (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Usuario(id) 
);

CREATE TABLE Compra (
    codigo SERIAL PRIMARY KEY,
    data_compra DATE NOT NULL,
    user_id INT NOT NULL,
    codigo_lista INT,
    codigo_pontuacao INT,
    FOREIGN KEY (user_id) REFERENCES Usuario(id),
    FOREIGN KEY (codigo_lista) REFERENCES ListaCompra(codigo),
    FOREIGN KEY (codigo_pontuacao) REFERENCES Pontuacao(codigo_pontuacao)
);

CREATE TABLE InfoNutricional (
    codigo SERIAL PRIMARY KEY,
    caloria INT,
    carboidrato DECIMAL(5,2),
    proteina DECIMAL(5,2),
    gordura DECIMAL(5,2),
    sodio DECIMAL(5,2)
);


CREATE TABLE Produto (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco_padrao DECIMAL(10,2),
    info_nutri INT,
    FOREIGN KEY (info_nutri) REFERENCES InfoNutricional(codigo)
);

CREATE TABLE Item (
    codigo SERIAL PRIMARY KEY,
    preco DECIMAL(10,2),
    data_validade DATE,
    quantidade INT,
    marca VARCHAR(50),
    produto_remetente INT,
    FOREIGN KEY (produto_remetente) REFERENCES Produto(codigo)
);

CREATE TABLE ListaItem (
    codigo_lista INT,
    codigo_item INT,
    PRIMARY KEY (codigo_lista, codigo_item),
    FOREIGN KEY (codigo_lista) REFERENCES ListaCompra(codigo),
    FOREIGN KEY (codigo_item) REFERENCES Item(codigo)
);

CREATE TABLE VitaminaMineral (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('vitamina', 'mineral'))
);

CREATE TABLE InfoVitaminaMineral (
    codigo_info INT,
    codigo_vitamina_mineral INT,
    quantidade DECIMAL(5,2),
    PRIMARY KEY (codigo_info, codigo_vitamina_mineral),
    FOREIGN KEY (codigo_info) REFERENCES InfoNutricional(codigo),
    FOREIGN KEY (codigo_vitamina_mineral) REFERENCES VitaminaMineral(codigo)
);

CREATE TABLE HistoricoPreco (
    codigo_produto INT,
    data_coleta DATE,
    preco DECIMAL(10,2),
    PRIMARY KEY (codigo_produto, data_coleta),
    FOREIGN KEY (codigo_produto) REFERENCES Produto(codigo)
);
CREATE TABLE SugestaoCompra (
    codigo SERIAL PRIMARY KEY,
    tipo_sugestao VARCHAR(20) NOT NULL CHECK (tipo_sugestao IN ('economica', 'saudavel', 'preferencia', 'recomendado')),
    motivo TEXT,
    data_sugestao DATE NOT NULL
);

CREATE TABLE SugestaoUsuario (
    codigo_sugestao INT,
    codigo_usuario INT,
    data_visualizacao DATE,
    PRIMARY KEY (codigo_sugestao, codigo_usuario),
    FOREIGN KEY (codigo_sugestao) REFERENCES SugestaoCompra(codigo),
    FOREIGN KEY (codigo_usuario) REFERENCES Usuario(id)
);

CREATE TABLE SugestaoProduto (
    codigo_sugestao INT,
    codigo_produto INT,
    PRIMARY KEY (codigo_sugestao, codigo_produto),
    FOREIGN KEY (codigo_sugestao) REFERENCES SugestaoCompra(codigo),
    FOREIGN KEY (codigo_produto) REFERENCES Produto(codigo)
);

CREATE TABLE Recomendacao (
    codigo SERIAL PRIMARY KEY,
    texto_recomendacao TEXT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Usuario(id)
);

CREATE TABLE RecomendacaoNutri (
    codigo_recomend SERIAL PRIMARY KEY,
    nutri_id INT,
    resposta TEXT,
    data_resposta DATE,
    FOREIGN KEY (codigo_recomend) REFERENCES Recomendacao(codigo),
    FOREIGN KEY (nutri_id) REFERENCES Usuario(id)
);

CREATE TABLE Avaliacao (
    codigo SERIAL PRIMARY KEY,
    texto_avaliacao TEXT,
    nota_avaliacao DECIMAL(3,1) CHECK (nota_avaliacao >= 0 AND nota_avaliacao <= 10),
    data_avaliacao DATE,
    nutri_id INT,
    codigo_produto INT,
    FOREIGN KEY (nutri_id) REFERENCES Usuario(id),
    FOREIGN KEY (codigo_produto) REFERENCES Produto(codigo)
);
