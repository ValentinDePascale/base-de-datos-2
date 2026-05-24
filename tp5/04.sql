ALTER TABLE pedidos RENAME TO pedidos_old;

CREATE TABLE pedidos (
    id_pedido bigint NOT NULL,
    id_cliente bigint NOT NULL,
    id_articulo bigint NOT NULL,
    id_sucursal integer NOT NULL,
    fecha date NOT NULL,
    cantidad integer NOT NULL,
    importe numeric(14,2) NOT NULL, -- Ajustá la precisión/escala si difiere en el tipo completo
    estado character varying(50) NOT NULL, -- O el largo que tenga configurado tu varchar
    PRIMARY KEY (id_pedido, fecha)
) PARTITION BY RANGE (fecha);

DROP TABLE pedidos;


CREATE TABLE pedidos_antiguos PARTITION OF pedidos
    FOR VALUES FROM ('2000-01-01') TO ('2026-01-01');

CREATE TABLE pedidos_2026_q1 PARTITION OF pedidos
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');

CREATE TABLE pedidos_2026_q2 PARTITION OF pedidos
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');

CREATE TABLE pedidos_futuros PARTITION OF pedidos
    FOR VALUES FROM ('2026-07-01') TO ('2030-01-01');

INSERT INTO pedidos (id_pedido, id_cliente, id_articulo, id_sucursal, fecha, cantidad, importe, estado)
SELECT id_pedido, id_cliente, id_articulo, id_sucursal, fecha, cantidad, importe, estado 
FROM pedidos_old;


EXPLAIN ANALYZE SELECT * FROM pedidos WHERE fecha = '2026-02-15';
EXPLAIN ANALYZE SELECT * FROM pedidos_old WHERE fecha = '2026-02-15';


-- Si, se observa el fenómeno de Partition Pruning. Nos damos cuenta, xq el motor ejecutó un Bitmap Heap Scan y un Bitmap Index Scan a la partición hija llamada pedidos_2026_q1
-- (pedidos_2026_q1_pkey), las demas tablas creadas, no figuran.