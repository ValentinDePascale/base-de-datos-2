BEGIN;
    INSERT INTO pedidos (id_cliente, id_articulo, fecha, cantidad, importe, estado)
    VALUES(7, 3, CURRENT_DATE, 4, 80722.40, 'PAGADO');

    UPDATE billetera_clientes SET saldo = saldo - 80722.40
    WHERE id_cliente = 7;

    UPDATE articulos SET stock = stock - 4
    WHERE id_articulo = 3;


COMMIT;


-- La transaccion no se realizo xq el cliente no tenia suficiente saldo para realizar la compra. Por lo tanto, el stock del articulo 3 no se actualizo y el pedido no se registro en la tabla pedidos.
-- CHECK es la restriccion que se encarga de validar que el saldo del cliente sea mayor o igual al importe del pedido antes de realizar la transaccion.
-- Se libera con ROLLBACK;

