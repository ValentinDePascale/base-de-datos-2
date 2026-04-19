--. 01
-- La "sobredosis" de CREATE INDEX es perjudicial para el rendimiento de las consultas INSERT/UPDATE/DELETE, ya que hace q estas sean mas lentas xq se les debe de cargar el indice cada vez q se modifica la tabla.


--. 02
EXPLAIN ANALYZE
INSERT INTO pedidos (id_cliente, id_articulo, id_sucursal,
fecha, cantidad, importe, estado)
VALUES
(1, 1, 1, CURRENT_DATE, 1, 1000.00, 'PAGADO'),
(2, 2, 2, CURRENT_DATE, 1, 2000.00, 'PAGADO'),
(3, 3, 3, CURRENT_DATE, 1, 3000.00, 'PAGADO'),
(4, 4, 4, CURRENT_DATE, 1, 4000.00, 'PAGADO'),
(5, 5, 5, CURRENT_DATE, 1, 5000.00, 'PAGADO');

-- tado 41.075 ms


-- 03
DROP INDEX IF EXISTS idx_pedidos_1;
DROP INDEX IF EXISTS idx_pedidos_2;
DROP INDEX IF EXISTS idx_pedidos_3;
DROP INDEX IF EXISTS idx_pedidos_4;
DROP INDEX IF EXISTS idx_pedidos_5;
DROP INDEX IF EXISTS idx_pedidos_6; 