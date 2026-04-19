A:
BEGIN;
SELECT stock FROM articulos WHERE id_articulo = 2 FOR UPDATE;
--Se bloquea la columna stock para el articuko 2 para actualizar
UPDATE articulos SET stock = stock - 5 WHERE id_articulo = 2;
COMMIT;



B:
BEGIN;
SELECT stock FROM articulos WHERE id_articulo = 2 FOR UPDATE;

-- Como A ya bloqueo, en B da este error WARNING:  there is already a transaction in progress

-- Luego de que se haga COMMIT en A, se realiza el bloqueo del B