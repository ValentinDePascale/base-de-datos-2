BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO auditoria_log (accion, datos)
SELECT 'REPORTE', SUM(saldo) 
FROM billetera_clientes;

COMMIT;

-- Como se debe hacer una "foto" de la suma de los saldos, se debe hacer con REPEATABLE RED, para que no se modifique el valor en el medio de la transaccion.