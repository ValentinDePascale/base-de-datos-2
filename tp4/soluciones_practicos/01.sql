CREATE ROLE rol_gerente;
CREATE USER gerente_ana WITH PASSWORD 'Directorio2026';
GRANT rol_gerente TO gerente_ana;

CREATE VIEW v_reporte_ingresos_sucursal AS
SELECT s.nombre, SUM(p.importe) AS total_importes
FROM sucursales s
JOIN pedidos p ON s.id_sucursal = p.id_sucursal
GROUP BY s.nombre;

CREATE VIEW v_capital_invertido_categoria AS
SELECT categoria, SUM(stock * precio_unitario) AS total_invertido
FROM articulos
GROUP BY categoria;

CREATE VIEW v_metricas_pedidos AS
SELECT estado, COUNT(cantidad) AS cantidad
FROM pedidos
GROUP BY estado;

GRANT SELECT ON v_reporte_ingresos_sucursal, v_capital_invertido_categoria, v_metricas_pedidos TO rol_gerente;

SET ROLE gerente_ana;

-- desde gerente_ana no tenemos los permisos
SELECT * FROM pedidos;

-- desde gerente_ana si se puede acceder
SELECT * FROM v_reporte_ingresos_sucursal;

-- La combinacion de Vistas y RBAC permite aplicar el principio de privilegio mínimo, el cual dice,
-- que cada usuario debe tener acceso únicamente a la información y operaciones estrictamente necesarias para cumplir su función, y nada más.
-- De esta manera, lo datos estan seguros y un usuario no accede a informacion directa sino a una copia