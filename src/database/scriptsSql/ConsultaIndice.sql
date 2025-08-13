-- Consulta 1
SELECT nome, email, total_compras_ultimo_mes, ultima_compra
FROM vw_dashboard_usuario
WHERE total_compras_ultimo_mes > 0
ORDER BY total_compras_ultimo_mes DESC
LIMIT 50;

-- Consulta 2
SELECT id, nome, total_listas, total_preferencias
FROM vw_dashboard_usuario
WHERE total_preferencias > 3
  AND total_listas >= 10
ORDER BY total_listas DESC;

-- Consulta 3
SELECT tipo, COUNT(total_recomendacoes) AS total_recs
FROM vw_dashboard_usuario
GROUP BY tipo
ORDER BY total_recs DESC;

-- Consulta 4
SELECT nome, preco_atual, media_avaliacao, status_preco
FROM vw_analise_produtos
WHERE status_preco = 'Promoção'
  AND media_avaliacao >= 8
ORDER BY media_avaliacao DESC
LIMIT 100;

-- Consulta 5
SELECT p.codigo, p.nome,
       MAX(hp.preco) - MIN(hp.preco) AS variacao_preco
FROM Produto p
JOIN HistoricoPreco hp ON hp.codigo_produto = p.codigo
WHERE hp.data_coleta >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY p.codigo, p.nome
ORDER BY variacao_preco DESC
LIMIT 50;

-- Consulta 6
SELECT nome, preco_atual, preco_padrao, sodio, status_preco
FROM vw_analise_produtos
WHERE status_preco = 'Preço Alto'
  AND sodio > 500
ORDER BY sodio DESC
LIMIT 100;

-- Consulta 7
SELECT 
    u.id,
    u.nome,
    DATE_TRUNC('month', c.data_compra) AS mes,
    COUNT(DISTINCT c.codigo) AS total_compras,
    SUM(it.preco * it.quantidade) AS gasto_total,
    AVG(it.preco) AS preco_medio_item
FROM Compra c
JOIN Usuario u ON u.id = c.user_id
JOIN ListaCompra lc ON lc.codigo = c.codigo_lista
JOIN ListaItem li ON li.codigo_lista = lc.codigo
JOIN Item it ON it.codigo = li.codigo_item
JOIN Produto p ON p.codigo = it.produto_remetente
LEFT JOIN InfoNutricional inf ON inf.codigo = p.info_nutri
WHERE c.data_compra >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY u.id, u.nome, DATE_TRUNC('month', c.data_compra)
HAVING COUNT(DISTINCT c.codigo) >= 3
ORDER BY mes DESC, gasto_total DESC
LIMIT 100;

-- Consulta 8
SELECT 
    p.codigo AS codigo_produto,
    p.nome AS nome_produto,
    COUNT(DISTINCT c.user_id) AS total_usuarios,
    COUNT(DISTINCT c.codigo) AS total_compras,
    SUM(it.quantidade) AS quantidade_total,
    ROUND(SUM(it.preco * it.quantidade) / COUNT(DISTINCT c.codigo), 2) AS ticket_medio,
    (SELECT hp.preco 
     FROM HistoricoPreco hp
     WHERE hp.codigo_produto = p.codigo
     ORDER BY hp.data_coleta DESC
     LIMIT 1) AS preco_mais_recente
FROM Compra c
JOIN Usuario u ON u.id = c.user_id
JOIN ListaCompra lc ON lc.codigo = c.codigo_lista
JOIN ListaItem li ON li.codigo_lista = lc.codigo
JOIN Item it ON it.codigo = li.codigo_item
JOIN Produto p ON p.codigo = it.produto_remetente
WHERE u.tipo = 'comum_nutri'
  AND c.data_compra >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY p.codigo, p.nome
HAVING COUNT(DISTINCT c.user_id) >= 10
ORDER BY total_usuarios DESC, total_compras DESC
LIMIT 50;