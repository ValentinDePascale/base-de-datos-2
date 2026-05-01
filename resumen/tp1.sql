/* 
Reglas de negocio
● Los posibles estados de los pedidos son: ‘PENDIENTE’, ‘PAGADO’, ‘CANCELADO’
● Cuando un cliente realiza un pedido sin pagarlo, el sistema debe registrar el pedido
con estado ‘PENDIENTE’ y descontar inmediatamente la cantidad solicitada del
stock del artículo.
● El sistema jamás debe permitir que el stock quede en negativo.
● Un cliente puede realizar un pedido y pagarlo usando su saldo a favor. En este caso
el estado del pedido queda en ‘PAGADO’.
● Por ley de protección de datos, un cliente puede solicitar que se elimine su cuenta.
En ese caso se deben eliminar los pedidos asociados para que no queden
“huerfanos”.

*/

-- Ejercicio 1
BEGIN;
    UPDATE clientes
    SET saldo = saldo - 1000;
    WHERE id_cliente = 1;

    UPDATE articulos
    SET stock = stock - 5;
    WHERE id_articulo = 9;

    INSERT INTO pedidos (id_cliente, id_articulo, cantidad, estado)
    VALUES (1, 9, 5, 'PAGADO')
COMMIT;

-- Ejercicio 2
BEGIN;
    UPDATE billetera_cliente
    SET  saldo = saldo - 84324;
    WHERE id_cliente = 7;

    UPDATE articulos
    SET stock = stock - 4;
    WHERE id_articulo = 3;

    insert INTO pedidos (id_cliente, id_articulo, fecha, cantidad, importe, estado)
    VALUES(7, 3, CURRENT_DATE, 4, 80722.40, 'PAGADO');
COMMIT;
ROLLBACK;

-- Ejercicio 3
BEGIN;
    UPDATE articulos
    SET stock = stock - 200;
    WHERE id_articulo = 392;

    UPDATE billetera_cliente
    SET saldo = saldo - 20000;
    WHERE id_cliente = 2;

    INSERT INTO pedidos (id_cliente, id_articulo, fecha, cantidad, importe, estado)
    VALUES (2, 392, CURRENT_DATE, 200, 20000, 'PAGADO');
COMMIT;

-- Ejercicio 4
BEGIN;
    DELETE FROM pedidos
    WHERE id_cliente = 5;

    DELETE FROM billetera_cliente
    WHERE id_cliente = 5;

    DELETE FROM clientes
    WHERE id_cliente = 5;
COMMIT;

-- Ejercicio 5
BEGIN;
    UPDATE articulos
    SET precio_unitario = precio_unitario * 1.20
    WHERE categoria = 'Electronica';
COMMIT;

-- Ejercicio 6
    UPDATE articulo
    SET stock = 1
    WHERE id_articulo = 5;

BEGIN;
    UPDATE arituculos
    SET stock = stock - 1
    WHERE id_articulo = 5;

-- Si otro usuario quiere comprar el mismo articulo, el sistema se queda en loop
-- esperando a q el usuario 1 termine de realizar su compra (transaccion)


