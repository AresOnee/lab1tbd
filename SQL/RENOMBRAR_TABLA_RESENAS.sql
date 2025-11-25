-- =============================================
-- Renombrar tabla reseñas a resenas
-- Para evitar problemas de encoding con la ñ
-- =============================================

BEGIN;

-- Paso 1: Ver las tablas actuales
SELECT 'Tablas actuales:' AS info;
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE '%rese%'
ORDER BY tablename;

-- Paso 2: Renombrar la tabla
-- Nota: Si esto falla con "no existe la relación",
-- necesitaremos usar el nombre exacto que PostgreSQL tiene almacenado
ALTER TABLE reseñas RENAME TO resenas;

-- Paso 3: Verificar que se renombró correctamente
SELECT 'Tablas después del rename:' AS info;
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE '%rese%'
ORDER BY tablename;

-- Paso 4: Verificar que el trigger sigue funcionando
SELECT 'Verificando trigger:' AS info;
SELECT tgname, tgrelid::regclass AS table_name
FROM pg_trigger
WHERE tgname = 'trigger_actualizar_calificacion';

-- Si todo está bien, hace COMMIT
COMMIT;
-- Si hay errores, ejecuta ROLLBACK
-- ROLLBACK;
