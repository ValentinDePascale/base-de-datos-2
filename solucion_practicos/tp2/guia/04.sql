A:
BEGIN;
UPDATE articulos SET stock = stock - 1 WHERE id_articulo = 1;

UPDATE articulos SET stock = stock - 1 WHERE id_articulo = 2;

commit;
B:
BEGIN;
UPDATE articulos SET stock = stock - 1 WHERE id_articulo = 2;

UPDATE articulos SET stock = stock - 1 WHERE id_articulo = 1;


-- misma tabla distintos id no hay problema

-- ERROR:  deadlock detected, como detecta q hay un interbloqueo, se elimina una automaticamente