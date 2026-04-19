BEGIN;

SELECT saldo
from billetera_clientes
WHERE id_cliente = 4
FOR UPDATE;

UPDATE billetera_clientes SET saldo = saldo - 10000 WHERE id_cliente = 4 AND saldo >= 10000;

COMMIT;

