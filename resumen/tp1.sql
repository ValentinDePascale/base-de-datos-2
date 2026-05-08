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

-- ejercicio 1

BEGIN;
UPDATE articulos SET stock = stock - 1 AND stock > 0;

INSERT INTO pedidos (id)



COMMIT;