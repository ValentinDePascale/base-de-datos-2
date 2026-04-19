A:
BEGIN;

SELECT *
from articulos
WHERE id_articulo = 15
FOR UPDATE;

UPDATE articulos SET stock = stock - 1 WHERE id_articulo = 15 AND stock > 0;
COMMIT;






B:
BEGIN;
SELECT *
from articulos
WHERE id_articulo = 15
FOR UPDATE;

-- El usuario A bloquea el articulo 15, por lo que el usuario B no puede acceder a él hasta que el usuario A libere el bloqueo.