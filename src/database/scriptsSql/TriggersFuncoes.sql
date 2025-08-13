-- Controle de Limite de Listas de Compras (RN02).
CREATE OR REPLACE FUNCTION fn_controle_limite_listas()
RETURNS TRIGGER AS $$
DECLARE
    total_listas INTEGER;
BEGIN
	-- Conta quantas listas o usuário já possui
	SELECT COUNT(*) INTO total_listas
    	FROM ListaCompra
    	WHERE user_id = NEW.user_id;

	-- Se já tem 10 listas, impede a criação de nova
	IF total_listas >= 10 THEN
      		RAISE EXCEPTION 'Usuário alcançou o limite de 10 listas';
    	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER 1 para controle de limite de listas
CREATE TRIGGER tr_controle_limite_listas
	BEFORE INSERT ON ListaCompra
	FOR EACH ROW
	EXECUTE FUNCTION fn_controle_limite_listas();

-- Controle de Pontuação Única (RN08).
CREATE OR REPLACE FUNCTION fn_controle_pontuacao_unica()
RETURNS TRIGGER AS $$
BEGIN
	-- Verifica se já existe pontuação para esta compra
	IF EXISTS (
        	SELECT 1 FROM Compra 
        	WHERE codigo = NEW.codigo 
        	AND codigo_pontuacao IS NOT NULL
    	) THEN
        	RAISE EXCEPTION 'Esta compra já foi pontuada';
    	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER 3 para controle de pontuação única
CREATE TRIGGER tr_controle_pontuacao_unica
    	BEFORE UPDATE ON Compra
    	FOR EACH ROW
    	EXECUTE FUNCTION fn_controle_pontuacao_unica();

-- Controle de Histórico de Compras (RN09).
CREATE OR REPLACE FUNCTION fn_controle_historico_compras()
RETURNS TRIGGER AS $$
DECLARE
    	total_compras INTEGER;
    	compra_mais_antiga INTEGER;
BEGIN
	-- Conta total de compras do usuário
    	SELECT COUNT(*) INTO total_compras
    	FROM Compra
    	WHERE user_id = NEW.user_id;
	
	-- Se excedeu 100 compras, remove a mais antiga
    	IF total_compras > 100 THEN
        	SELECT codigo INTO compra_mais_antiga
        	FROM Compra
        	WHERE user_id = NEW.user_id
        	ORDER BY data_compra ASC
        	LIMIT 1;
        
        	-- Remove a compra mais antiga
        	DELETE FROM Compra WHERE codigo = compra_mais_antiga;
    	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER 4 para controle de histórico de compras
CREATE TRIGGER tr_controle_historico_compras
    	AFTER INSERT ON Compra
    	FOR EACH ROW
    	EXECUTE FUNCTION fn_controle_historico_compras();