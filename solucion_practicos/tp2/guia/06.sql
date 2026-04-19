A:
BEGIN;
SELECT precio_unitario FROM articulos WHERE id_articulo = 1;
--Un aforma de solucionarlo
SELECT precio_unitario FROM articulos WHERE id_articulo = 1 FOR SHARE; 
-- Hasta q no haya commit o rollnack, otras trasnaccion no van a poder modificar el articulo
COMMIT;
-- El problema es q si algun otro usuario hace una transaccion se nos cambia el valor en el medio

--MVCC
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT precio_unitario FROM articulos WHERE id_articulo = 1;

UPDATE articulos SET precio_unitario = precio_unitario + 200 WHERE
id_articulo = 1;

-- ERROR:  could not serialize access due to concurrent update  SQL state: 40001. No deja modificar algo que ya esta modificado por otra transaccion 
-- no es serealizable 
B:

BEGIN;
UPDATE articulos SET precio_unitario = precio_unitario + 5000 WHERE
id_articulo = 1;

-- En el caso del FOR SHARE, como se entera q hay otra transaccion bloquando el dato, la transaccion B queda en loop
COMMIT;

