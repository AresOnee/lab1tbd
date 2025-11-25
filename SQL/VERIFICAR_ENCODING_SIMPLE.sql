-- =============================================
-- SOLUCIÓN SIMPLE: Verificar encoding y recrear tabla
-- =============================================

-- Paso 1: Ver el encoding de la base de datos
SELECT 'Encoding de la base de datos:' AS info;
SHOW SERVER_ENCODING;
SHOW CLIENT_ENCODING;

-- Paso 2: Ver qué nombre tiene realmente la tabla
SELECT 'Tablas actuales con rese:' AS info;
SELECT
    tablename,
    encode(tablename::bytea, 'hex') as hex_name,
    length(tablename) as name_length
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE '%rese%';

-- Paso 3: Contar datos actuales (para verificar antes de borrar)
SELECT 'Conteo de datos actuales:' AS info;
SELECT COUNT(*) as total_resenas FROM reseñas;

-- Paso 4: Hacer backup de los datos
CREATE TABLE IF NOT EXISTS backup_resenas_temp AS
SELECT * FROM reseñas;

SELECT 'Backup creado con' AS info, COUNT(*) as registros FROM backup_resenas_temp;

-- ESTE SCRIPT SOLO VERIFICA
-- NO EJECUTA CAMBIOS DESTRUCTIVOS AÚN
