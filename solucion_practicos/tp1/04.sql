BEGIN;
    DELETE FROM pedidos
    WHERE id_cliente = 5;

    DELETE FROM billetera_clientes
    WHERE id_cliente = 5;

    DELETE FROM clientes
    WHERE id_cliente = 5;
COMMIT;

