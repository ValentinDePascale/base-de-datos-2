REVOKE rol_gerente FROM gerente_ana;

DROP OWNED BY gerente_ana;

DROP ROLE gerente_ana;

-- No se permite eliminar el rol gerente_ana sin antes eliminar sus permisos par que no queden datos referentes al rol sin eliminar