# Repaso General de Bases de Datos

## SGBD (Sistema de Gestión de Base de Datos)
Es el software que permite la creación, gestión y administración de bases de datos.

## Formas Normales (Normalización)
El objetivo de la normalización es evitar la redundancia de datos y proteger la integridad de la información.

* **1FN (Primera Forma Normal):**
    * Atributos con valores únicos (atómicos).
    * Cada celda contiene un solo valor.
    * Cada fila es única.
    * No hay columnas que repitan el mismo concepto.
* **2FN (Segunda Forma Normal):**
    * Cumple con la 1FN.
    * Uso de **Claves Primarias**.
    * Tablas separadas para conjuntos de datos que se aplican a múltiples registros.
    * Relación entre tablas mediante claves foráneas.
* **3FN (Tercera Forma Normal):**
    * Cumple con la 2FN.
    * Elimina la **dependencia transitiva**: un atributo no clave no debe depender de otro atributo no clave. Todos los atributos deben depender únicamente de la clave primaria.

## SQL (Structured Query Language)

### Estructura de Consulta
* **SELECT:** Define las columnas a mostrar.
* **FROM:** Define la tabla de origen.
* **WHERE:** Filtra filas según condiciones.
* **GROUP BY:** Agrupa filas que tienen los mismos valores.
* **HAVING:** Filtra grupos (similar al WHERE pero para funciones de agregado).
* **ORDER BY:** Ordena el resultado (ASC/DESC).
* **LIMIT:** Restringe el número de registros devueltos.

### Joins
Permiten combinar registros de dos o más tablas.
* **LEFT JOIN:** Devuelve todos los registros de la tabla izquierda y los coincidentes de la derecha.
* **RIGHT JOIN:** Devuelve todos los registros de la tabla derecha y los coincidentes de la izquierda.

---

## Objetos de la Base de Datos

### TRIGGERS (Disparadores)
Consultas que se ejecutan automáticamente dependiendo de una acción (INSERT, UPDATE, DELETE) sin intervención del usuario.

**Ejemplo:**
```sql
DELIMITER //
CREATE TRIGGER tr_auditoria_precio
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    -- 'OLD' accede al valor anterior, 'NEW' al valor actualizado
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios (producto_id, precio_viejo, precio_nuevo, fecha)
        VALUES (OLD.id, OLD.precio, NEW.precio, NOW());
    END IF;
END;
//
DELIMITER ;
```

### PROCEDURE (Procedimientos Almacenados)
Conjunto de instrucciones SQL guardadas que pueden ser reutilizadas.

**Ejemplo:**
```sql
SQL
CREATE PROCEDURE sp_BuscarProductosPorPrecio
    @PrecioMaximo DECIMAL(10,2) -- Parámetro de entrada
AS
BEGIN
    -- Instrucciones a ejecutar
    SELECT NombreProducto, Precio
    FROM Productos
    WHERE Precio <= @PrecioMaximo
    ORDER BY Precio;
END;
GO

-- Ejecutar el procedimiento
EXEC sp_BuscarProductosPorPrecio @PrecioMaximo = 50.00;
```