1. [CHECKPOINT]
2. <T1, START>
3. <T1, UPDATE, billetera_clientes, id=1, viejo_saldo=500, nuevo_saldo=200>
4. <T2, START>
5. <T1, COMMIT>
6. <T2, UPDATE, pedidos, id_pedido=15, estado_viejo='PENDIENTE',
estado_nuevo='PAGADO'>
7. --- CORTE DE ENERGÍA ---


-- La transaccion que entra en fase de REDO es T1, ya que es la unica q logro hacer un COMMIT antes del corte de energia
-- En cambio, T2, entra en fase de UNDO, ya que no logro hacer un COMMIT y sus cambios no se deben ver reflejados.

-- El valor exacto que asegura la BD es el nuevo_saldo del cliente 1 (200).

-- En la columna del estado del pedido 15, quedara el estado viejo PENDIENTE.