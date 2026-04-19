B:W
BEGIN;
UPDATE billetera_clientes SET saldo = saldo + 1000 WHERE
id_cliente = 1;

-- La transaccion de la A tiene un bloqueo en billetera_cliebtes id_cliente = 1. No va a haber efecto hasta q no se haga commit o rollback



A:
BEGIN;
UPDATE billetera_clientes SET saldo = saldo - 500 WHERE
id_cliente = 1;

COMMIT;