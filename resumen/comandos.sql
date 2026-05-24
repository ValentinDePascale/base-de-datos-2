BEGIN;

COMMIT/ROLLBACK;

SELECT ... FROM ... FOR UPDATE/FOR SHARE; (B2F)


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; (MVCC)

EXPLAIN ANALYZE

CREATE INDEX:

-- Indices FK, Para acelerar los JOIN y para que los DELETE no causen un escaneo completo en la tabla hija al verificar la integridad.
CREATE INDEX idx_pedidos_usuario_id ON pedidos (usuario_id);


-- Indices Compuestos Si tu consulta tiene un filtro de igualdad (=) y uno de rango (>, <, BETWEEN), la columna de igualdad siempre debe ir primero en el índice.
CREATE INDEX idx_nombre_apellido ON personas (apellido, nombre);

-- Funciona para: WHERE apellido = 'Pérez'
-- Funciona para: WHERE apellido = 'Pérez' AND nombre = 'Juan'
-- NO funciona para: WHERE nombre = 'Juan'

-- Indices Parciales
CREATE INDEX idx_pedidos_pendientes 
ON pedidos (fecha_creacion) 
WHERE procesado IS FALSE;

-- El índice será minúsculo porque ignora todos los pedidos ya terminados.

CREATE INDEX idx_pedidos_sucursal_estado_fecha ON pedidos (id_sucursal, estado, fecha ASC);


VIEWS

-- Vistas

CREATE VIEW vista_recaudacion_sucursal AS

EXPLAIN ANALYZE SELECT * FROM vista_recaudacion_sucursal;

-- Eliminar vistas

DROP VIEW vista_recaudacion_sucursal;

-- Vistas Materializadas

CREATE MATERIALIZED VIEW vista_recaudacion_sucursal_mat AS

SELECT * FROM mv_recaudacion_sucursal;

REFRESH MATERIALIZED VIEW mv_recaudacion_sucursal;

-- USERS

-- 1. Crear un usuario real (persona) que puede conectarse a la base de datos.
CREATE USER juan WITH PASSWORD 'clave_segura';

-- 2. Crear un rol (que funciona como un grupo de permisos lógicos).
CREATE ROLE vendedor;

-- 3. Asignar el rol al usuario para que herede sus permisos.
GRANT vendedor TO juan;

-- Eliminar rol
-- Le sacamos los permisos de rol_gerente a gerente_ana
REVOKE rol_gerente FROM gerente_ana;

-- Eliminamos todos los objetos creados por ana y revoca todos los permisos dados sobre otros objetos
DROP OWNED BY gerente_ana;

-- Borra el usuario, si fuera este fuera dueño de alguna tabla o privilegio, no dejaria borrarlo.
DROP ROLE gerente_ana;

REVOKE ALL PRIVILEGES ON pedidos FROM rol_vendedor;

-- PERMISOS

-- Permitir que el rol 'consulta' solo pueda ver el DNI y el nombre en la tabla Clientes, pero no otros datos sensibles.
GRANT SELECT (dni, nombre) ON Clientes TO consulta;

-- Permitir que el 'cajero1' solo pueda actualizar la columna 'saldo' de la tabla Cuentas.
GRANT UPDATE (saldo) ON Cuentas TO cajero1;

-- Permitir que el 'cajero2' pueda insertar nuevas cuentas, pero solo tocando las columnas numero_cuenta y saldo.
GRANT INSERT (numero_cuenta, saldo) ON Cuentas TO cajero2;

-- Permitir que el 'admin_banco' pueda borrar registros completos de la tabla Movimientos.
GRANT DELETE ON Movimientos TO admin_banco;

GRANT SELECT ON vista TO rol;


-- ENCRIPTADO

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

