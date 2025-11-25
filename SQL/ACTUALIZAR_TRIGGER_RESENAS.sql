-- =============================================
-- Actualizar el trigger para usar la tabla resenas
-- (en lugar de reseñas con ñ)
-- =============================================

-- Recrear la función del trigger con el nuevo nombre de tabla
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

    -- Actualizamos la tabla 'sitios_turisticos' usando la tabla resenas (sin ñ)
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

-- El trigger ya existe y apunta a la tabla resenas (después del rename)
-- Solo necesitamos recrear la función
