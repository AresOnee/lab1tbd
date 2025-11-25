-- =============================================
-- MIGRACIÓN COMPLETA: Renombrar tabla reseñas a resenas
-- Este script soluciona el problema de encoding con la letra ñ
-- =============================================

\echo '===================================================='
\echo 'MIGRACIÓN: Renombrar tabla reseñas → resenas'
\echo '===================================================='

BEGIN;

-- Paso 1: Verificar estado actual
\echo ''
\echo 'Paso 1: Verificando estado actual...'
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE '%rese%'
ORDER BY tablename;

-- Paso 2: Renombrar la tabla
\echo ''
\echo 'Paso 2: Renombrando tabla reseñas → resenas...'
ALTER TABLE reseñas RENAME TO resenas;

-- Paso 3: Actualizar el trigger para usar el nuevo nombre de tabla
\echo ''
\echo 'Paso 3: Actualizando función del trigger...'
CREATE OR REPLACE FUNCTION actualizar_calificacion_promedio()
RETURNS TRIGGER AS $$
DECLARE
    sitio_id INT;
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        sitio_id := NEW.id_sitio;
    ELSEIF (TG_OP = 'DELETE') THEN
        sitio_id := OLD.id_sitio;
    END IF;

    UPDATE sitios_turisticos
    SET
        calificacion_promedio = (
            SELECT COALESCE(AVG(calificacion), 0.0)
            FROM resenas
            WHERE id_sitio = sitio_id
        ),
        total_resenas = (
            SELECT COUNT(*)
            FROM resenas
            WHERE id_sitio = sitio_id
        )
    WHERE id = sitio_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Paso 4: Verificar que el trigger sigue funcionando
\echo ''
\echo 'Paso 4: Verificando trigger...'
SELECT tgname, tgrelid::regclass AS table_name
FROM pg_trigger
WHERE tgname = 'trigger_actualizar_calificacion';

-- Paso 5: Verificar que la tabla se renombró correctamente
\echo ''
\echo 'Paso 5: Verificando tabla renombrada...'
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE '%rese%'
ORDER BY tablename;

-- Paso 6: Verificar datos en la tabla
\echo ''
\echo 'Paso 6: Verificando datos (primeras 5 reseñas)...'
SELECT id, id_usuario, id_sitio, calificacion
FROM resenas
LIMIT 5;

\echo ''
\echo '===================================================='
\echo 'MIGRACIÓN COMPLETADA EXITOSAMENTE'
\echo 'La tabla reseñas ahora se llama resenas'
\echo 'El trigger fue actualizado para usar resenas'
\echo '===================================================='

COMMIT;

-- Si algo falla, ejecuta ROLLBACK manualmente
-- ROLLBACK;
