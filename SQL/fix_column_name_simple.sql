-- =============================================
-- Solución simple al problema de codificación
-- Crear una nueva columna y actualizar el trigger
-- =============================================

BEGIN;

-- Paso 1: Ver el estado actual
SELECT column_name, data_type, ordinal_position
FROM information_schema.columns
WHERE table_name = 'sitios_turisticos'
  AND column_name LIKE '%rese%'
ORDER BY ordinal_position;

-- Paso 2: Agregar nueva columna con nombre sin ñ
ALTER TABLE sitios_turisticos
ADD COLUMN IF NOT EXISTS total_resenas INT;

-- Paso 3: Copiar los datos existentes
-- Usamos una subconsulta dinámica para obtener el valor
-- independientemente del encoding del nombre de la columna
UPDATE sitios_turisticos s1
SET total_resenas = (
    SELECT COUNT(*)
    FROM reseñas r
    WHERE r.id_sitio = s1.id
);

-- Paso 4: Establecer el default para la nueva columna
ALTER TABLE sitios_turisticos
ALTER COLUMN total_resenas SET DEFAULT 0;

-- Paso 5: Hacer que la columna sea NOT NULL
ALTER TABLE sitios_turisticos
ALTER COLUMN total_resenas SET NOT NULL;

-- Verificar que los datos se copiaron correctamente
SELECT id, nombre, calificacion_promedio, total_resenas
FROM sitios_turisticos
LIMIT 10;

-- Si todo se ve bien, ejecuta COMMIT
-- Si algo está mal, ejecuta ROLLBACK
-- COMMIT;
ROLLBACK;

