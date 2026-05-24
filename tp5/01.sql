ALTER TABLE articulos DROP CONSTRAINT articulos_precio_unitario_check;

UPDATE articulos SET precio_unitario = 0;

SELECT * FROM articulos;

TRUNCATE TABLE articulos RESTART IDENTITY CASCADE;


-- Si la base pesara 500gb, lo mas logico seria hacer un backup fisico (pg_basebackup) y no un backup logico (pg_dump), ya que el logico es mas lento y consume mas recursos.
-- El RTO, es el tiempo maximo q el negocio puede estar sin servicio. Si se hace un backup logico, el proceso tomaria horas o dias para levantar la base, lo q no es aceptable para un negocio.
-- En cambio, el bku fisico, al ser una copia bit a bit de los archivos binarios, la velocidad va a depender del disco, pero en general es mucho mas rapido que el logico, lo q permite reducir el RTO a minutos o incluso segundos.