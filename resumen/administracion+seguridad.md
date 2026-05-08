# SEGURIDAD

## Conceptos Fundamentales:

*   **Confidencialidad**: Evita que personas no autonizadas ingresen a la bd
*   **Integridad**: Garantiza que la informacion no sea borrada o modificada
*   **Disponibilidad**: Garantiza que los datos sean accesibles a los usuarios legitimos lo autorizen
  
Estos controles, se ejercen mediante: autenticacion, autorizacion y auditoria. Esto debe seguir el **Principio de Privilegio Minimo**:
dar a cada usuario unicamente los permisos estrictamente necesarios para su trabajo, no mas.

## Gestión de Privilegios y Usuarios

El administrador de la Base de Datos, debe ser responable de crear cuentas y asignar o retirar permisos mediante roles. `GRANT` y `REVOKE`

#### Ejemplo Crear ROL:

```sql
-- 1. Crear un usuario real (persona) que puede conectarse a la base de datos.
CREATE USER juan WITH PASSWORD 'clave_segura';

-- 2. Crear un rol (que funciona como un grupo de permisos lógicos).
CREATE ROLE vendedor;

-- 3. Asignar el rol al usuario para que herede sus permisos.
GRANT vendedor TO juan;
```
#### Ejemplo Eliminar ROL (por completo):

```sql
-- Le sacamos los permisos de rol_gerente a gerente_ana
REVOKE rol_gerente FROM gerente_ana;

-- Eliminamos todos los objetos creados por ana y revoca todos los permisos dados sobre otros objetos
DROP OWNED BY gerente_ana;

-- Borra el usuario, si fuera este fuera dueño de alguna tabla o privilegio, no dejaria borrarlo.
DROP ROLE gerente_ana;
```

### Nivel de Privilegios

*   **Nivel de Cuenta**: Permiten crear o borrar estructuras
*   **Nivel de Objeto**: Permiten manipular los datos dentro de una tabla, basicamente deciden exactamente qué columnas o tablas puede tocar un usuario
#### Ejemplo Nivel Objeto:
```sql
-- Permitir que el rol 'consulta' solo pueda ver el DNI y el nombre en la tabla Clientes, pero no otros datos sensibles.
GRANT SELECT (dni, nombre) ON Clientes TO consulta;

-- Permitir que el 'cajero1' solo pueda actualizar la columna 'saldo' de la tabla Cuentas.
GRANT UPDATE (saldo) ON Cuentas TO cajero1;

-- Permitir que el 'cajero2' pueda insertar nuevas cuentas, pero solo tocando las columnas numero_cuenta y saldo.
GRANT INSERT (numero_cuenta, saldo) ON Cuentas TO cajero2;

-- Permitir que el 'admin_banco' pueda borrar registros completos de la tabla Movimientos.
GRANT DELETE ON Movimientos TO admin_banco;
```

*   **Delegacion**: Un usuario puede recibir el poder de transferir sus permisos a otros si se le otorga la clausula `WITH GRANT OPTION`. Al revocar un permiso, se puede usar `CASCADE` para borrar tmb los permisos que ese usuario habia delegado, o `RESTRICT` para evitar que los elimine si afecta a terceros.
*   
```sql
-- El dueño de la tabla Cuentas (o el que tiene esos permisos), le permite al rol operativo, poder hacer INSERTS y UPDATES, y tmb puede ejecutar este mismo comando para darle esos permisos a un usuariox
GRANT INSERT, SELECT ON Cuentas TO operativo WITH GRANT OPTION;
```

Borrar todos los permisos en la tabla pedidos del rol_vendedor

```sql
REVOKE ALL ON pedidos FROM rol_vendedor;
```

## Modelos de Control de Acceso

Existen tres modelos teoticos principales para decidir quien entra a que dato.

1. **DAC (Control de Accesso Discrecional)**: El usuario propietario de la tabla es el dueño absoluto y decide quien le da permiso mediante una "Matriz de Acesso".

El problema con esta es, que si el dueño es descuidado, la seguirdad falla y es muy dificil de administrar, especialmente en empresas grandes.

2. **RBAC (Control de Acceso Basado en Roles)**: Se crean roles con permisos y se le asignan estos a los distintos empleados o usuarios de la BD. Permite crear jerarquias y reduce el trabajo administrativo.
   
3. **MAC (Control de Acceso Obligatorio / Seguridad Multinivel)**: Tipico en sistemas militares. Los datos y usuarios se clasifican por niveles. 
   No Read Up: Los usuarios no pueden leer datos de nivel superior
   No Write Down: Un usuario no puede escribir o copiar datos en un nivel inferior.

## Riesgos Avanzados y Protección

### El Problema de la Inferencia

Es cuando alguien deduce un dato de la base de datos mediante consultas permitidas. Se soluciona ocultando resultados de poblaciones pequeñas o agregando "ruido estadístico"

### Auditoría

Guardar en un reigstro Log quien, que y cuando hizo los cambios. Se puede implementar con Triggers, que cada vez que haya un INSERT, UPDATE Y DELETE, guarde una tabla con los datos. O tambien, mediante extensiones, por ejemplo pgAudit, que registra a nivel motor y no pueden ser cambiadas. 

### Cifrado
Transforma datos legibles en texto ilegible.
*   Simétrico: Usa la misma clave para cifrar y descifrar(rápido, usado con pgp_sym_encrypt en Postgres).
*   Asimetrico :Usa una clave pública para cifrar y una   privada para descifrar (más lento pero más seguro).
*   Funciones Hash: Son de un solo sentido (no se pueden descifrar). Se usan para verificar contraseñas.
`gen_salt('bf')`, genera claves aleatorias y las mezcla con el dato q estamos queriendo cifrar, esta se ve mas o menos asi: $2a$06$R.D/E218h91j...<resto del hash>
 
La SGBD, para darse cuenta si el dato q se incripto es el correcto, la funcion crypy, comprueba con q salt alteatorio se mezclo la primera vez, entonces si el dato de crypt mezclado con el primer salt es identico al dato ya encriptado, significa que es el mismo y dara true
```sql
SELECT (pin_entrega_hash = crypt('4092', pin_entrega_hash)) AS pin_correcto
FROM datos_importantes
WHERE id_cliente = 1
```

### SQL Injection
Cuando un atacante aprovecha un formulario web para inyectar codigo malicioso (Ej. DROP TABLE usuarios).

La solucion es usar **Consultas Parametrizadas** Esto divide el proceso en dos, primero la BD compila la estructura SQL con espacios vacios ?, y luego recibe los datos. Como la estructura esta cerrada, cualquier intento de inyectar sera tratado simplemente como texto.