BEGIN;
    UPDATE articulos SET stock = stock - 1
    WHERE id_articulo = 5;
COMMIT;

-- La pestaña 2 queda en Loop, xq al no haber finalizado la transacción en la 1. 

-- Al hacer el COMMIT, se libera el bloqueo y la pestaña 2 puede continuar con su consulta.

-- Finalmente, en la pestaña 2 muestra violates check constraint, xq el stock no puede ser negativo.