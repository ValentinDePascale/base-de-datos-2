BEGIN;
    UPDATE billetera_clientes SET saldo = saldo - 1000
    WHERE id_cliente = 1;

    UPDATE articulos SET stock = stock - 5
    WHERE id_articulo = 9;

    INSERT INTO pedidos (id_cliente, id_articulo, fecha, cantidad, importe, estado)
    VALUES(1, 9, CURRENT_DATE, 5, 1000, 'PAGADO');

COMMIT;

SELECT id_articulo, stock, precio_unitario 
FROM articulos 
WHERE id_articulo = 9;