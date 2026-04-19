EXPLAIN ANALYZE
SELECT id_pedido, id_articulo, fecha, cantidad
FROM pedidos
WHERE id_sucursal = 15 AND estado = 'PENDIENTE'
ORDER BY fecha ASC;


-- 01

CREATE INDEX idx_pedidos_sucursal_estado_fecha ON pedidos (id_sucursal, estado, fecha ASC);

-- 02

-- Tardo 55.697ms. El motor utilizo Bitmap index scan sobre el nuevo índice para filtrar los pedidos por sucursal y estado, y luego ordenó los resultados por fecha de manera eficiente.