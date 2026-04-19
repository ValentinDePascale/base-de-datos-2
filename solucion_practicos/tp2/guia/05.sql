BEGIN;
UPDATE billetera_clientes SET saldo = saldo - 500000 WHERE
id_cliente = 2;
SELECT * FROM clientes;


-- cuando es un error, lo correcto es terminarla con ROLLBACK;