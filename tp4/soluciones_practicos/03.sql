REVOKE ALL PRIVILEGES ON pedidos FROM rol_vendedor;

GRANT SELECT, INSERT ON pedidos TO rol_vendedor;

GRANT UPDATE (estado) ON pedidos TO rol_vendedor;

-- CHECK comprueba que el valor que se ingrese no sea negativo
-- El control de accesso solo permite UPDATE en esa cloumna