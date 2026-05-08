# OPTIMIZACION + VISTAS
## La Naturaleza Declarativa de SQL

SQL es un lenguaje **declarativo**, osea el programador es el que especifica que datos quiere obtener, pero el motor de la bd, se encarga de decidir como va a obtener esos datos, osea que pasos hace para obtener los datos de la consulta.



## 1. CICLO DE VIDA DE UNA CONSULTA

El procesamiento sigue un flujo estricto para extraer datos:

*   **Analisis y Traduccion (Paraser):** Verifica que la sintaxis de la consulta este bien escrita. Luego, verifica que lo que pide la consulta tenga sentido: se fija que la tabla exista, las columanas tiene esos nombres, etc. Si todo es correcto, traduce el pedido a Algebra Relacional para que el motor entienda.
  En el medio de estas nace el Árbol de Consulta, una vez q se analiza que la consulta esta bien. 
*   **Optimizacion**: Transforma la consulta inicial en un plan para que consuma la menor cantidad de recursos. El resultado es el "Plan de Ejecucion", que basicamente es el mapa de la ruta elegida.
*   **Evualuacion (Ejecucion):** El motor lee el disco y la memoria para procesar el plan y devuelve el resultado
*   

## Fase 2: Optimización

*   **Optimizacion Logica (Heurística):** Reglas predefinidas. Aplicar filtros lo antes posible para descartar filas, proyectar las columnas necesarias y reordenar JOINS, combinando las tablas que resulten en conjuntos de datos mas pequeños.
  
### **Optimizacion Fisica (Basada en costos CBO)**:## 
El optimizador elige el que menos cuesta en terminos de hardware. En base a:

Selectividad y Cardinalidad: que porcentaje total de la tabla se devolvera y cuantos valores distintos hay en la columna

*   Alta Selectividad: 0.1% de la tabla, directo al dato
*   Baja Selectividad: 60% de la tabla.
*   Alta Cardinalidad: Valores unicos. DNI, Email, Numero de pedido (no se repiten)
*   Baja Cardinalidad: Valores repetidos. Genero, estado, provincia

Si posee baja selectividad, osea se necesita leer un gran pocentaje de la tabla, el motor ignora los indices y hace un "Full Table Scann", ya que es mas rapido que hacer muchos saltos con indices.

(`ANALYZE`) Sirve para actualizar las estadisticas de la tabla, asi el motor toma las mejores decisiones y no una en base a datos viejos 
  
  Formula: Costo ≅ (Nbloques_leídos * WIO) + (Nfilas_procesadas * WCPU)

  W representa el peso o importancia q le da el motor a cada recurso


## El Plan de Ejecución (EXPLAIN)

Es el script físico que el motor de evaluación va a seguir
*   Orden de operaciones: Q tablas se procesan primero y en que secuencia se aplican los filtros y operaciones
*   Algoritmos: La logica para resolver cada operador
*   Metodos de acceso: Leer los datos desde el almacenamiento
  
### Operadores Comunes

Acceso:
    Table Scan: Lee toda la tabla secuencialmente (Si hay indicies, es lento)
    Index Scan/Seek: Navega por la estructura del indice
Join:
    Nested Loop: Para cada fila de la Tabla A, busca en la Tabla B (eficas si es pequeño)
    Hash Join: Crea una tabla hash en memoria para cruzar los datos


Es la herramienta fundamental para analizar y corregir problemas de rendimiento en consultas reales


## Gestión y Estrategia de Índices

Los indices aceleran las lecturas SELECT, pero tiene un costo de mantenimiento, relentizando las operaciones `INSERT`, `UPDATE` Y `DELETE`

*   Indices FK: Obligatorios para que los JOINs no escaneen toda la tabla
```sql
CREATE INDEX idx_pedidos_cliente ON pedidos (id_cliente);
```
*   Indices Compuestos: Orden de columnas, primero la columna usada como filtro WHERE y luego la columna usada para el JOIN
```sql
CREATE INDEX idx_clientes_provincia_id ON clientes (provincia, id_cliente);
```
*   Indices Parciales: Indexan solo un fragmento de la tabla (registros a partir de tal fecha), lo que ahorra espacio en RAM.
```sql
CREATE INDEX idx_pedidos_desde_2026 ON pedidos (fecha) 
WHERE fecha >= '2026-01-01';
```
*   Covering Index: Permite que el motor haga un "Index-Only Scan" resolviendo consultas sin tocar los datos reales de la tabla
```sql
CREATE INDEX idx_estratégico_pedidos ON pedidos (fecha, id_cliente, importe);
```
*   SARGability: Aplicar funciones sobre una columna anula el uso de indice, por ejemplo (YEAR(fecha) = 2024). Lo correcto es usar rango (fecha >= '2024-01-01')
```sql
SELECT nombre FROM usuarios 
    WHERE fecha_alta >= '2024-01-01' AND fecha_alta <= '2024-12-31';
    ```
``` 
## VISTAS

* Vistas Estandar: Son tablas virtuales que guardan la sitnaxis de la consulta y se recalculan al llamarse. Aportan seguridad y simplifican el codigo. No mejoran velocidad
  
* Vistas Materializadas: Almacenan el resultado en el disco. Brindan respuesta instantanea. Pero requieren mantenimiento manual mediante `REFRESH MATERIALIZED VIEW`

## EJEMPLO:

### VISTAS
* Vistas Estandar:
```sql
CREATE VIEW reporte_ventas_bsas_2026 AS
SELECT c.nombre, SUM(p.importe) AS total, COUNT(p.id_pedido) AS cant_pedidos
FROM clientes C 
JOIN pedidos P ON C.id_cliente = P.id_cliente
WHERE P.fecha >= '2026-01-01' AND C.provincia = 'Buenos Aires'
GROUP BY C.nombre;


-- Ahora el programador, en vez de escribir todo el codigo, hace:
SELECT * FROM reporte_ventas_bsas_2026;
```

* Vistas Materializadas
```sql
CREATE MATERIALIZED VIEW reporte_ventas_bsas_2026 AS
SELECT c.nombre, SUM(p.importe) AS total, COUNT(p.id_pedido) AS cant_pedidos
FROM clientes C 
JOIN pedidos P ON C.id_cliente = P.id_cliente
WHERE P.fecha >= '2026-01-01' AND C.provincia = 'Buenos Aires'
GROUP BY C.nombre
WITH NO DATA; -- Crea la estructura vacía para llenarla después

-- Para que la vista vuelva a calcular y guardar los datos actualizados, debes ejecutar:

REFRESH MATERIALIZED VIEW reporte_ventas_bsas_2026;
```


## INDICES
*   Optimización Física:
   
```sql
 -- 1. Índice compuesto en clientes (Primero el filtro, luego el JOIN)
CREATE INDEX idx_clientes_prov_id ON clientes (provincia, id_cliente);

-- 2. Índice parcial de cobertura en pedidos (Solo indexa 2026 y tiene todo lo necesario)
CREATE INDEX idx_pedidos_2026_cobertura ON pedidos (fecha, id_cliente, importe) 
WHERE fecha >= '2026-01-01';


ANALYZE clientes;
ANALYZE pedidos;
```


1. La Regla de Oro: I - R - O
Para decidir el orden de las columnas dentro de un INDEX(col1, col2, col3), sigue siempre este orden de prioridad de izquierda a derecha:

I - Igualdad (=): Coloca primero las columnas que aparecen en el WHERE con un signo de igual (ej. id_sucursal = 15).

R - Rango (>, <, BETWEEN, LIKE): Luego las columnas que filtran por rangos.

O - Orden (ORDER BY): Por último, las columnas que usas para ordenar los resultados.

¿Por qué este orden? Porque el índice es como un diccionario. Si buscas "Pérez" (Igualdad) y luego nombres que empiecen con "A-M" (Rango), es fácil. Si lo haces al revés, el índice pierde efectividad.

2. La Técnica de la "Selectividad"
No todas las columnas merecen un índice. La técnica consiste en elegir columnas que filtren mucho.

Alta Selectividad (Buen índice): DNI, email, id_cliente. Tienen muchos valores distintos.