-- 1: Teste do Limite de Listas (Função 1)

-- Insere usuário de teste
INSERT INTO Usuario (email, nome, senha_hash, telefone,     dataNascimento, sexo, tipo) 
VALUES ('teste@email.com', 'Usuário Teste', 'senha123', '11999999999', '1990-01-01', 'M', 'comum');

-- Tenta criar mais de 10 listas para o mesmo usuário
DO $$
DECLARE
    	i INTEGER;
    	user_id INTEGER;
BEGIN
	-- Obtém o ID do usuário criado
	SELECT id INTO user_id FROM Usuario WHERE email = 'teste@email.com';
	
	-- Cria 10 listas (tem que funcionar)
	FOR i IN 1..10 LOOP
        	INSERT INTO ListaCompra (nome, data_criacao, user_id) 
        	VALUES ('Lista ' || i, CURRENT_DATE, user_id);
    	END LOOP;

	-- Tenta criar a 11 lista (não pode funcionar)
	BEGIN
        	INSERT INTO ListaCompra (nome, data_criacao, user_id) 
        	VALUES ('Lista 11', CURRENT_DATE, user_id);
        	RAISE NOTICE 'ERRO: Deveria ter falhado na 11 lista';
    	EXCEPTION
        	WHEN OTHERS THEN
            		RAISE NOTICE 'SUCESSO: A trigger impediu criação da 11 lista: %', SQLERRM;
    	END;
END $$;


-- 2: teste da pontuação única (Função 2)

-- Cria usuario de testes
INSERT INTO Usuario (email, nome, senha_hash, telefone, dataNascimento, sexo, tipo) 
VALUES ('teste3@email.com', 'Usuário Teste 3', 'hash789', '11777777777', '1990-01-01', 'M', 'comum');

-- Cria pontuações de teste
INSERT INTO Pontuacao 
(pontuacao_preco, pontuacao_nutri, data_registro) 
VALUES (8, 9, CURRENT_DATE);
INSERT INTO Pontuacao 
(pontuacao_preco, pontuacao_nutri, data_registro)
VALUES (7, 8, CURRENT_DATE);

-- Cria lista de teste
INSERT INTO ListaCompra (nome, data_criacao, user_id) 
SELECT 'Lista Histórico', CURRENT_DATE, id FROM Usuario WHERE email = 'teste3@email.com';

DO $$
DECLARE
v_user_id INTEGER;
    	lista_id INTEGER;
    	pontuacao_id INTEGER;
    	compra_id INTEGER;
BEGIN
	-- Obtém os ids necessarios
SELECT id INTO v_user_id FROM Usuario WHERE email = 'teste3@email.com';
    	SELECT codigo INTO lista_id FROM ListaCompra lc WHERE lc.user_id = v_user_id;
    	SELECT codigo_pontuacao INTO pontuacao_id FROM Pontuacao ORDER BY codigo_pontuacao DESC LIMIT 1;

	-- Cria uma compra sem pontuação
    	INSERT INTO Compra (data_compra, user_id, codigo_lista) 
    	VALUES (CURRENT_DATE, v_user_id, lista_id)
    	RETURNING codigo INTO compra_id;

	-- Atualiza a compra com uma pontuação (deve funcionar)
	UPDATE Compra SET codigo_pontuacao = pontuacao_id WHERE codigo = compra_id;

	-- Tenta atualizar a compra com uma nova pontuação (deve falhar)
	BEGIN
        UPDATE Compra SET codigo_pontuacao = pontuacao_id + 1 WHERE codigo = compra_id;
        RAISE NOTICE 'ERRO: Deveria ter falhado na segunda pontuação';
    	EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'SUCESSO: A trigger impediu a segunda pontuação: %', SQLERRM;
    END;
END $$;


-- 3: teste do histórico de compras (Função 3)
DO $$
DECLARE
v_user_id INTEGER;
    	lista_id INTEGER;
    	pontuacao_id INTEGER;
    	i INTEGER;
BEGIN
	-- Obtém os ids
SELECT id INTO v_user_id FROM Usuario WHERE email = 'teste3@email.com';
    	SELECT codigo INTO lista_id FROM ListaCompra WHERE user_id = v_user_id;
    	SELECT codigo_pontuacao INTO pontuacao_id FROM Pontuacao LIMIT 1;

	-- Cria 101 compras para testar o limite de 100
	FOR i IN 1..101 LOOP
		INSERT INTO Compra (data_compra, user_id, codigo_lista, codigo_pontuacao)
		VALUES (CURRENT_DATE - (i || 'days')::INTERVAL, v_user_id, lista_id, pontuacao_id);
	END LOOP;
	
	-- Verifica se o total de compras foi limitado a 100
	RAISE NOTICE 'Total de compras após a insercao: %',
		(SELECT COUNT(*) FROM Compra WHERE user_id = v_user_id);
END $$;

-- Limpeza dos dados de teste
DELETE FROM Compra 
WHERE user_id IN (
SELECT id FROM Usuario WHERE email LIKE 'teste%@email.com'
);

DELETE FROM ListaItem 
WHERE codigo_lista IN (
SELECT codigo FROM ListaCompra WHERE user_id IN (
SELECT id FROM Usuario WHERE email LIKE 'teste%@email.com')
);

DELETE FROM ListaCompra 
WHERE user_id IN (
SELECT id FROM Usuario WHERE email LIKE 'teste%@email.com');

DELETE FROM Usuario WHERE email LIKE 'teste%@email.com';
