BEGIN;
    UPDATE articulo SET precio_unitario = precio_unitario * 1.20
    WHERE categoria = 'Tecnología';


COMMIT;

SELECT *
FROM articulos
WHERE categoria = 'Tecnología';