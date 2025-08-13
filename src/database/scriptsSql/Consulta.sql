-- Consulta 1: Produtos com mais de 100 calorias

SELECT P.codigo, P.nome, P.marca
FROM Produto AS P
JOIN InfoNutricional AS I
  ON P.info_nutri = I.codigo
WHERE I.caloria > 100;




-- Consulta 2:  Recomendações de cada nutricionista

SELECT RN.*, U.nome AS nome_nutri
FROM RecomendacaoNutri AS RN
JOIN Usuario AS U
  ON RN.nutri_id = U.id
WHERE U.tipo IN ('nutri','comum_nutri');




-- Consulta 3:  Listar todos os produtos ordenados por preço padrão decrescente

SELECT codigo, nome, preco_padrao
FROM Produto
ORDER BY preco_padrao DESC;




-- Consulta 4: Produtos que foram tanto sugeridos quanto avaliados

SELECT P.codigo, P.nome, P.marca
FROM Produto P
WHERE P.codigo IN (
    SELECT codigo_produto
    FROM SugestaoProduto
    INTERSECT
    SELECT codigo_produto
    FROM Avaliacao  
);




-- Consulta 5: Exibir compras que foram feitas e por quais usuários

SELECT C.codigo AS compra, U.nome AS comprador, C.data_compra
FROM Compra C
INNER JOIN Usuario U
  ON C.user_id = U.id;




-- Consulta 6: Exibir todas combinações de produtos e categorias de preferência

SELECT P.codigo AS produto, PR.tipo_preferencia
FROM Produto AS P
CROSS JOIN Preferencia AS PR;




-- Consulta 7: Listar todos os produtos e, caso exista, o preço de oferta em Item

SELECT P.codigo, P.nome, I.preco AS preco_oferta
FROM Produto P
LEFT JOIN Item I
  ON I.produto_remetente = P.codigo
ORDER BY P.codigo;




-- Consulta 8: Itens que estão com preço de oferta abaixo do preço padrão do produto

SELECT P.codigo, P.nome, P.marca
FROM Item AS I
JOIN Produto AS P
  ON I.produto_remetente = P.codigo
WHERE I.preco < P.preco_padrao;




-- Consulta 9: Itens foram adicionados às listas mas não foram comprados

SELECT DISTINCT P.codigo, P.nome, P.marca
FROM ListaItem LI
JOIN Item I ON LI.codigo_item = I.codigo
JOIN Produto P ON I.produto_remetente = P.codigo
WHERE LI.codigo_item NOT IN (
    SELECT LI2.codigo_item
    FROM ListaItem LI2
    JOIN ListaCompra LC ON LI2.codigo_lista = LC.codigo
    JOIN Compra C ON LC.codigo = C.codigo_lista  
);




-- Consulta 10: Encontrar a caloria máxima entre todos os produtos

SELECT MAX(I.caloria) AS caloria_maxima
FROM InfoNutricional I;




-- Consulta 11: Mostrar sugestões economias e sugestões saudáveis 

SELECT *
FROM SugestaoCompra
WHERE tipo_sugestao = 'economica'
UNION SELECT *
FROM SugestaoCompra
WHERE tipo_sugestao = 'saudavel';




-- Consulta 12: Produtos avaliados por todos os nutricionista

SELECT P.codigo, P.nome, P.Marca
FROM Produto P
WHERE P.codigo IN (
    SELECT A.codigo_produto
    FROM Avaliacao A
    GROUP BY A.codigo_produto
    HAVING COUNT(DISTINCT A.nutri_id) = (
        SELECT COUNT(*) 
        FROM Usuario 
        WHERE tipo IN ('nutri','comum_nutri')   )
);




-- Consulta 13: Combinações possíveis de itens e categorias de sugestão existem

SELECT I.codigo AS item, SC.tipo_sugestao
FROM Item AS I
CROSS JOIN SugestaoCompra AS SC;





-- Consulta 14: Encontrar o preço mínimo padrão entre todos os produtos

SELECT MIN(P.preco_padrao) AS preco_minimo
FROM Produto P;




-- Consulta 15: Calcular a média de avaliação por produto

SELECT P.codigo, P.nome,
       AVG(A.nota_avaliacao) AS media_nota
FROM Avaliacao A
JOIN Produto P ON A.codigo_produto = P.codigo
GROUP BY P.codigo, P.nome;




-- Consulta 16: Somar as calorias totais de cada lista de compras

SELECT 
  L.codigo   AS lista, 
  L.nome     AS nome_lista,
  SUM(N.caloria) AS total_calorias
FROM ListaCompra L
JOIN ListaItem LI 
  ON L.codigo = LI.codigo_lista
JOIN Item It 
  ON LI.codigo_item = It.codigo
JOIN InfoNutricional N 
  ON It.produto_remetente = N.codigo
GROUP BY L.codigo, L.nome;




-- Consulta 17: Listar usuários que nunca fizeram qualquer avaliação

SELECT U.id, U.nome
FROM Usuario U
WHERE NOT EXISTS (
    SELECT 1
    FROM Avaliacao A
    WHERE A.nutri_id = U.id  
);




-- Consulta 18: Listar usuários que têm pelo menos uma recomendação respondida

SELECT U.id, U.nome
FROM Usuario U
WHERE EXISTS (
    SELECT 1
    FROM RecomendacaoNutri RN
    WHERE RN.nutri_id = U.id  
);



