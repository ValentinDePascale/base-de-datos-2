BEGIN;
    INSERT INTO pedidos (id_cliente, id_articulo, fecha, cantidad, importe, estado)
    VALUES(2, 392, CURRENT_DATE, 200, 27200, 'PAGADO');

    UPDATE billetera_clientes SET saldo = saldo - 27200
    WHERE id_cliente = 2;

    UPDATE articulos SET stock = stock - 200
    WHERE id_articulo = 392;

COMMIT;

SELECT *
FROM billetera_clientes
WHERE id_cliente = 2;

SELECT id_articulo, stock, precio_unitario 
FROM articulos 
WHERE id_articulo = 392;