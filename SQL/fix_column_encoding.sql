-- =============================================
-- Script para corregir el problema de codificación
-- de la columna total_reseñas en sitios_turisticos
-- =============================================

-- Opción 1: Renombrar usando la columna por posición
-- Primero, verificamos qué columnas existen
SELECT column_name, ordinal_position, data_type
FROM information_schema.columns
WHERE table_name = 'sitios_turisticos'
ORDER BY ordinal_position;

-- Opción 2: Renombrar la columna usando ALTER TABLE con el nombre exacto que PostgreSQL tiene
-- Nota: Copia el nombre exacto de la columna del output anterior y úsalo aquí
-- ALTER TABLE sitios_turisticos RENAME COLUMN <nombre_exacto_de_la_columna> TO total_resenas;

-- Opción 3: Método más robusto - Crear nueva columna, copiar datos, eliminar antigua
BEGIN;

-- 1. Agregar nueva columna con nombre ASCII
ALTER TABLE sitios_turisticos ADD COLUMN IF NOT EXISTS total_resenas INT DEFAULT 0;

-- 2. Copiar datos de la columna antigua a la nueva
-- Usamos un UPDATE que copia el valor de la columna en la posición correcta
UPDATE sitios_turisticos
SET total_resenas = (
    SELECT CASE
        WHEN column_name LIKE '%rese%' AND data_type = 'integer'
        THEN CAST(
            (SELECT to_jsonb(t) ->> column_name
             FROM sitios_turisticos t
             WHERE t.id = sitios_turisticos.id) AS INTEGER
        )
        ELSE 0
    END
    FROM information_schema.columns
    WHERE table_name = 'sitios_turisticos'
      AND ordinal_position = 6  -- La columna total_reseñas está en posición 6
    LIMIT 1
);

-- 3. Eliminar la columna antigua (esto eliminará automáticamente cualquier dependencia)
-- Necesitarás identificar el nombre exacto desde el query anterior
-- ALTER TABLE sitios_turisticos DROP COLUMN <nombre_exacto>;

-- Por ahora no hacemos COMMIT, solo mostramos el resultado
SELECT id, nombre, total_resenas FROM sitios_turisticos LIMIT 5;

ROLLBACK;  -- Cambia a COMMIT cuando estés seguro

