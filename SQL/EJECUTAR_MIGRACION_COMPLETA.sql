-- =============================================
-- MIGRACIÓN COMPLETA: Renombrar total_reseñas a total_resenas
-- Este script soluciona el problema de encoding
-- =============================================
-- IMPORTANTE: Ejecuta este script completo en una transacción
-- Si algo falla, todo se revierte automáticamente
-- =============================================

BEGIN;

-- Paso 1: Mostrar estado actual de las columnas
SELECT 'Estado actual de las columnas:' AS info;
SELECT column_name, data_type, ordinal_position
FROM information_schema.columns
WHERE table_name = 'sitios_turisticos'
ORDER BY ordinal_position;

-- Paso 2: Agregar nueva columna con nombre sin ñ
ALTER TABLE sitios_turisticos
ADD COLUMN IF NOT EXISTS total_resenas INT DEFAULT 0 NOT NULL;

-- Paso 3: Copiar todos los datos desde la columna antigua
-- Recalculamos desde las reseñas para asegurarnos de tener datos correctos
UPDATE sitios_turisticos s
SET total_resenas = (
    SELECT COUNT(*)
    FROM reseñas r
    WHERE r.id_sitio = s.id
);

-- Paso 4: Actualizar la función del trigger para usar la nueva columna
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
            FROM reseñas
            WHERE id_sitio = sitio_id
        ),
        total_resenas = (
            SELECT COUNT(*)
            FROM reseñas
            WHERE id_sitio = sitio_id
        )
    WHERE id = sitio_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Paso 5: Verificar que los datos se copiaron correctamente
SELECT 'Verificando datos copiados:' AS info;
SELECT id, nombre, calificacion_promedio, total_resenas
FROM sitios_turisticos
LIMIT 10;

-- Paso 6: Mostrar columnas después de la migración
SELECT 'Columnas después de agregar total_resenas:' AS info;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'sitios_turisticos'
ORDER BY ordinal_position;

-- Si todo se ve bien, descomenta la siguiente línea y comenta ROLLBACK
COMMIT;
-- ROLLBACK;  -- Usa esto si algo salió mal

-- =============================================
-- NOTA IMPORTANTE:
-- Después de ejecutar este script exitosamente (COMMIT),
-- necesitarás eliminar manualmente la columna antigua con encoding problemático
-- Para esto, ejecuta el siguiente comando EN UNA NUEVA SESIÓN:
--
-- psql -U postgres -d lab1tbd
-- \d sitios_turisticos
--
-- Identifica visualmente la columna con el nombre mal codificado
-- Luego copia su nombre EXACTO y ejecuta:
-- ALTER TABLE sitios_turisticos DROP COLUMN "<nombre_exacto>";
--
-- Por ejemplo, si aparece como "total_reseÃ±as", ejecuta:
-- ALTER TABLE sitios_turisticos DROP COLUMN total_reseÃ±as;
-- (sin comillas si es posible, con comillas si tiene caracteres especiales)
-- =============================================
