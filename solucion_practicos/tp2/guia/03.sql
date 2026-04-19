A:
BEGIN;
SELECT * FROM clientes WHERE id_cliente = 3 FOR SHARE;

UPDATE clientes SET nombre = 'Modificado' WHERE id_cliente = 3;

B:
BEGIN;
SELECT * FROM clientes WHERE id_cliente = 3 FOR SHARE;
COMMIT;
-- Como es for shere en cualquiera de las dos se puede

-- La sesion B realiza bloqueo, hasta q no se haga COMMIT o ROLLBACK aca no va a terminar 