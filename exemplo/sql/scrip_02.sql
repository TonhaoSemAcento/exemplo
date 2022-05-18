SELECT cliente_pais, 
       AVG(pedido_valor) AS media_pedido_valor, 
       MIN(pedido_valor) AS minimo_pedido_valor, 
       SUM(pedido_valor) total_pedido_valor
FROM pedidos
GROUP BY cliente_pais;


SELECT cliente_pais, cliente_nome ,pedido_valor,
       AVG(pedido_valor) AS media_pedido_valor, 
       MIN(pedido_valor) AS minimo_pedido_valor, 
       SUM(pedido_valor) total_pedido_valor
FROM [dbo].[]
GROUP BY CustomeOrdersrcity;

SELECT cliente_pais, 
       AVG(pedido_valor) OVER(PARTITION BY cliente_pais) AS media_pedido_valor, 
       MIN(pedido_valor) OVER(
	   BY cliente_pais) AS minimo_pedido_valor, 
       SUM(pedido_valor) OVER(PARTITION BY cliente_pais) total_pedido_valor
FROM pedidos;

SELECT cliente_pais, 
       cliente_nome, 
       pedido_valor, 
       AVG(pedido_valor) OVER(PARTITION BY cliente_pais) AS media_pedido_valor, 
       MIN(pedido_valor) OVER(PARTITION BY cliente_pais) AS minimo_pedido_valor, 
       SUM(pedido_valor) OVER(PARTITION BY cliente_pais) total_pedido_valor
FROM pedidos;

SELECT cliente_pais, 
       cliente_nome, 
       pedido_valor, 
       COUNT(OrderID) OVER(PARTITION BY cliente_pais) AS quantidade_pedidos, 
       AVG(pedido_valor) OVER(PARTITION BY cliente_pais) AS media_pedido_valor, 
       MIN(pedido_valor) OVER(PARTITION BY cliente_pais) AS minimo_pedido_valor, 
       SUM(pedido_valor) OVER(PARTITION BY cliente_pais) total_pedido_valor
FROM pedidos;

SELECT cliente_pais, 
       cliente_nome, 
       ROW_NUMBER() OVER(PARTITION BY cliente_pais
       ORDER BY pedido_valor DESC) AS "Numero Linha", 
       pedido_valor, 
       COUNT(OrderID) OVER(PARTITION BY cliente_pais) AS quantidade_pedidos, 
       AVG(pedido_valor) OVER(PARTITION BY cliente_pais) AS media_pedido_valor, 
       MIN(pedido_valor) OVER(PARTITION BY cliente_pais) AS minimo_pedido_valor, 
       SUM(pedido_valor) OVER(PARTITION BY cliente_pais) total_pedido_valor
FROM pedidos;