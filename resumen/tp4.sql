CREATE ROLE rol_gerente;

CREATE USER gerente_ana WITH PASSWORD 'Directorio2026';

CREATE VIEW v_reporte_ingresos_sucursal AS
SELECT nombre_sucursal, SUM(importe) AS ingresos_totales
FROM pedidos
JOIN sucursales ON pedidos.id_sucursal = sucursales.id_sucursal
GROUP BY nombre_sucursal;


SELECT c.nombre, p.fecha, p.importe
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN provincias pr ON c.id_provincia = pr.id_provincia
WHERE pr.nombre = 'Santa Fe' AND (EXTRACT(YEAR FROM p.fecha) = 2024
OR EXTRACT(YEAR FROM p.fecha) = 2025);

SELECT c.nombre, p.fecha, p.importe
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN provincias pr ON c.id_provincia = pr.id_provincia
WHERE pr.nombre = 'Santa Fe' AND p.fecha >= '2024-01-01' AND p.fecha < '2025-12-31';

CREATE INDEX idx_pedidos_fecha ON pedidos (fecha);