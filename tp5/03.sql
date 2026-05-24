-- La modificación estructural obligatoria es que la columna de particionamiento forme parte de la clave primaria
-- Osea que al crear la PK, esta debe de ser compuesta. Quedaria asi: PK = (id_cliente, id_provincia)

-- Si, al hacer esto se rompe la 3FN, produciendose Denormalización, pero gana performance en sistemas masivos.
-- Esto se produce ya que se estan duplicando datos, ya que cada cliente se repetira en cada provincia, pero evitas hacer JOINS.

