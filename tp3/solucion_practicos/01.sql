--. 01
EXPLAIN ANALYZE
SELECT c.nombre, p.fecha, p.importe
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN provincias pr ON c.id_provincia = pr.id_provincia
WHERE pr.nombre = 'Santa Fe' AND (EXTRACT(YEAR FROM p.fecha) = 2024
OR EXTRACT(YEAR FROM p.fecha) = 2025);

-- Tardo 2262,563 ms. Seq Scan masivo sobre pedidos, Hash Joins al conectar las tablas.

--. 02
SELECT c.nombre, p.fecha, p.importe
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN provincias pr ON c.id_provincia = pr.id_provincia
WHERE pr.nombre = 'Santa Fe' 
AND p.fecha >= '2024-01-01' 
AND p.fecha <= '2025-12-31';

--. 03

CREATE INDEX idx_pedidos_fecha ON pedidos (fecha);

--. 04

-- Tardo 1957.544 ms. El tiempo fue menor ya que el índice permitió filtrar los pedidos por fecha de manera más eficiente, reduciendo la cantidad de registros a escanear.