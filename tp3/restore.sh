#!/bin/bash
set -e

echo "========================================="
echo "Restaurando backup binario..."
echo "========================================="

# pg_restore usa las credenciales y el nombre de BD que configuraste en el compose.yaml
pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" --no-owner --no-privileges -1 /tmp/dump.backup

echo "========================================="
echo "Backup restaurado exitosamente."
echo "========================================="