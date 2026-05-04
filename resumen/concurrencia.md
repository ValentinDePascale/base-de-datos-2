# Control de Concurrencia en Bases de Datos

La concurrencia permite mejorar el uso del disco/CPU y reducir los tiempos de respuesta al permitir que múltiples transacciones se ejecuten simultáneamente. Sin embargo, si no se controla, puede comprometer la **consistencia** de los datos.

El **SGBD** utiliza esquemas de control de concurrencia para garantizar el **Aislamiento** (propiedad de ACID).

---

## 1. Planificación (Schedules)

Es el orden cronológico en el que se ejecutan las instrucciones de las transacciones.

*   **En Serie:** Las transacciones se ejecutan una tras otra por completo. Son seguras pero ineficientes en sistemas con muchos usuarios.
*   **Intercalada:** Las instrucciones de diferentes transacciones se mezclan para optimizar el uso de CPU.
*   **Equivalencia por Conflictos:** Una planificación es válida si el orden de sus instrucciones en conflicto es equivalente a alguna ejecución en serie.

### Problemas comunes de la concurrencia
1.  **Lectura Sucia (Dirty Read):** $T_1$ modifica un dato, $T_2$ lo lee y luego $T_1$ hace `ROLLBACK`. $T_2$ trabajó con un dato que "nunca existió".
2.  **Lectura No Repetible:** $T_1$ lee un dato, $T_2$ lo actualiza y hace `COMMIT`. $T_1$ vuelve a leer el mismo dato y encuentra un valor diferente en la misma transacción.
3.  **Actualización Perdida:** $T_1$ lee y modifica un valor, pero $T_2$ escribe encima basándose en el valor antiguo antes de que $T_1$ termine, anulando su cambio.

---

## 2. Serializabilidad y Conflictos

Dos instrucciones están en **conflicto** si pertenecen a distintas transacciones, acceden al mismo dato y al menos una de ellas es una escritura (`WRITE`).

### Grafo de Precedencia
Herramienta para detectar si una planificación es segura:
*   **Nodos:** Representan las transacciones ($T_1, T_2, ...$).
*   **Arcos:** Se dibuja una flecha $T_i \rightarrow T_j$ si $T_i$ operó sobre un dato antes que $T_j$ y hubo un conflicto.
*   **Regla de oro:** Si el grafo tiene un **ciclo** (puedes volver al inicio siguiendo las flechas), la planificación **no es serializable** y es inconsistente.

---

## 3. Métodos de Bloqueo (Enfoque Pesimista)

### Tipos de bloqueos:
*   **Modo Compartido (S - Shared):** Para lectura. Varias transacciones pueden leer el mismo dato a la vez.
*   **Modo Exclusivo (X - Exclusive):** Para escritura. Si una transacción lo tiene, nadie más puede leer ni escribir ese dato.

### Bloqueo en Dos Fases (B2F / 2PL)
1.  **Fase de Expansión:** Se solicitan bloqueos. No se permite liberar ninguno.
2.  **Punto de Bloqueo:** Momento en que se consiguen todos los bloqueos necesarios.
3.  **Fase de Contracción:** Se liberan los bloqueos. Prohibido pedir nuevos bloqueos.

> **B2F Riguroso:** Libera todos los bloqueos solo al final de la transacción (`COMMIT/ROLLBACK`). Es el más usado para evitar que otros lean datos que podrían ser revertidos.

### Gestión de Fallos
*   **Deadlock (Interbloqueo):** $T_1$ espera a $T_2$ y viceversa. El SGBD aborta una "víctima" basada en antigüedad o costo.
*   **Inanición (Starvation):** Una transacción es elegida siempre como víctima. Se soluciona aumentando su prioridad con cada reintento.

---

## 4. MVCC (Control de Concurrencia Multiversión)

Es el enfoque de **PostgreSQL** para evitar que los lectores bloqueen a los escritores.

*   **Snapshot Isolation:** Al hacer un `SELECT`, el sistema te da una "foto" de los datos tal cual estaban al inicio de la transacción.
*   **Múltiples Versiones:** En lugar de sobrescribir, el sistema crea una nueva versión del dato. Los lectores ven la versión vieja y los escritores operan sobre la nueva.
*   **Regla de oro:** Los lectores nunca bloquean a los escritores y los escritores nunca bloquean a los lectores.

### Niveles de Aislamiento
| Nivel | Descripción |
| :--- | :--- |
| **Read Uncommitted** | Permitiría lecturas sucias. **Postgres no lo permite** (lo trata como Read Committed). |
| **Read Committed** | **Por defecto.** Solo ve datos confirmados. Evita lecturas sucias. |
| **Repeatable Read** | La "foto" se congela. No ve cambios de otros aunque hagan COMMIT. |
| **Serializable** | Máximo aislamiento. Garantiza consistencia total mediante abortos si hay sospecha de conflicto. |

---

## 5. Ejemplos SQL (PostgreSQL)

### A. Uso de `FOR UPDATE` (Evitar Actualización Perdida)
```sql
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
```
### Ejemplo 2
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO auditoria_log (accion, datos)
SELECT 'REPORTE', SUM(saldo) 
FROM billetera_clientes;

COMMIT;

-- Como se debe hacer una "foto" de la suma de los saldos, se debe hacer con REPEATABLE RED, para que no se modifique el valor en el medio de la transaccion
```

### Ejemplo 3
```sql

BEGIN;

SELECT saldo
from billetera_clientes
WHERE id_cliente = 4
FOR UPDATE;

UPDATE billetera_clientes SET saldo = saldo - 10000 WHERE id_cliente = 4 AND saldo >= 10000;

COMMIT;
```