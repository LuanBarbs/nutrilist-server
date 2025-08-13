-- Usuário Comum — Dashboard com Dados Úteis.

CREATE OR REPLACE VIEW vw_dashboard_usuario AS
	SELECT u.id, u.nome, u.email, u.tipo,
           COUNT(DISTINCT lc.codigo) as total_listas,
           COUNT(DISTINCT p.tipo_preferencia) as total_preferencias,
           COUNT(DISTINCT c.codigo) as total_compras_ultimo_mes,
           MAX(c.data_compra) as ultima_compra,
           COUNT(DISTINCT r.codigo) as total_recomendacoes
   	FROM Usuario u
   	LEFT JOIN ListaCompra lc ON (u.id = lc.user_id)
   	LEFT JOIN Preferencia p ON (u.id = p.user_id)
   	LEFT JOIN Compra c ON (
    	u.id = c.user_id AND 
       	c.data_compra >= CURRENT_DATE - INTERVAL '30 days')
   	LEFT JOIN Recomendacao r ON (u.id = r.user_id)
   	WHERE u.tipo IN ('comum', 'comum_nutri')
   	GROUP BY u.id, u.nome, u.email, u.tipo;


-- Nutricionista — Dashboard com Dados Úteis.

CREATE OR REPLACE VIEW vw_dashboard_nutricionista AS
   	SELECT u.id, u.nome, u.email,
           COUNT(DISTINCT rn.codigo_recomend) as total_respostas,
           COUNT(DISTINCT av.codigo) as total_avaliacoes,
           AVG(av.nota_avaliacao) as media_avaliacoes
   	FROM Usuario u
   	LEFT JOIN RecomendacaoNutri rn ON (u.id = rn.nutri_id)
   	LEFT JOIN Avaliacao av ON (u.id = av.nutri_id)
   	WHERE u.tipo IN ('nutri', 'comum_nutri')
   	GROUP BY u.id, u.nome, u.email;




-- Sistema de Recomendação e Adm — Análise de Produtos e Preços.

CREATE OR REPLACE VIEW vw_analise_produtos AS
	SELECT p.codigo, p.nome, p.preco_padrao, 
             hp.preco as preco_atual,
		 hp.data_coleta, inf.caloria, inf.carboidrato, 
             inf.proteina, inf.gordura, inf.sodio,
		 AVG(av.nota_avaliacao) as media_avaliacao,
		 COUNT(av.codigo) as total_avaliacoes,
		 CASE
		   WHEN hp.preco < p.preco_padrao * 0.9 THEN 'Promoção'
		   WHEN hp.preco > p.preco_padrao * 1.1 THEN 'Preço Alto'
		   ELSE 'Preço Normal'
		 END as status_preco
	FROM Produto p
	LEFT JOIN InfoNutricional inf ON (p.info_nutri = inf.codigo)
	LEFT JOIN HistoricoPreco hp ON (p.codigo = hp.codigo_produto)
	LEFT JOIN Avaliacao av ON p.codigo = av.codigo_produto
	WHERE hp.data_coleta = (SELECT MAX(data_coleta) 
					FROM HistoricoPreco
					WHERE codigo_produto = p.codigo)
	GROUP BY p.codigo, p.nome, p.preco_padrao, hp.preco, 
               hp.data_coleta, inf.caloria, inf.carboidrato, 
               inf.proteina, inf.gordura, inf.sodio;







