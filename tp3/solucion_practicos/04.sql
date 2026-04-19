CREATE VIEW vista_recaudacion_sucursal AS
SELECT s.nombre AS sucursal, a.categoria, SUM(p.importe) AS total_recaudado
FROM pedidos p
JOIN sucursales s ON p.id_sucursal = s.id_sucursal
JOIN articulos a ON p.id_articulo = a.id_articulo
GROUP BY s.nombre, a.categoria;

-- Prueba de rendimiento
EXPLAIN ANALYZE SELECT * FROM vista_recaudacion_sucursal;

-- Tardo 5472.094 ms. No, unia vista no mejora el rendimiento de la consulta, ya que es básicamente una consulta predefinida que se ejecuta cada vez que se accede a ella, y no almacena resultados intermedios.

    DROP VIEW vista_recaudacion_sucursal;
--.02
CREATE MATERIALIZED VIEW vista_recaudacion_sucursal_mat AS
SELECT s.nombre AS sucursal, a.categoria, SUM(p.importe) AS total_recaudado
FROM pedidos p
JOIN sucursales s ON p.id_sucursal = s.id_sucursal
JOIN articulos a ON p.id_articulo = a.id_articulo
GROUP BY s.nombre, a.categoria;

--03

EXPLAIN ANALYZE SELECT * FROM mv_recaudacion_sucursal;

-- TARDO 0.057 ms, el tiempo fue significativamente menor ya que la vista materializada almacena los resultados de la consulta, lo que permite un acceso mucho más rápido a los datos precomputados en lugar de ejecutar la consulta completa cada vez.

--04

REFRESH MATERIALIZED VIEW mv_recaudacion_sucursal;