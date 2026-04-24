CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE contacto (
	id_contacto INT PRIMARY KEY,
	telefono_emergencia_cifrado BYTEA,
	pin_entrega_hash TEXT
);

INSERT INTO contacto(id_contacto, telefono_emergencia_cifrado, pin_entrega_hash)
VALUES (1, pgp_sym_encrypt('555-0199', 'secreto_empresa'), crypt('4092', gen_salt('bf'))	
);

SELECT pin_entrega_hash = crypt('pin_ingresado', pin_entrega_hash)
FROM contacto;

SELECT pgp_sym_decrypt(telefono_emergencia_cifrado, 'secreto_empresa')
FROM contacto
WHERE id_contacto = 1;


-- No, el empleado no podria acceder a los telefonos ya que estan cifrados de forma simetrica. 
-- Este, no posee la clave secreto_empresa

-- No, tampoco podra saber que pin usaba cada cliente, ya que no hay una manera de desencriptar el crypt