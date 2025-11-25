-- =============================================
-- Actualizar el trigger para usar total_resenas
-- en lugar de total_reseñas
-- =============================================

-- Recrear la función del trigger con el nuevo nombre de columna
CREATE OR REPLACE FUNCTION actualizar_calificacion_promedio()
RETURNS TRIGGER AS $$
DECLARE
    sitio_id INT;
BEGIN
    -- Determinamos el ID del sitio afectado
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        sitio_id := NEW.id_sitio;
    ELSEIF (TG_OP = 'DELETE') THEN
        sitio_id := OLD.id_sitio;
    END IF;

    -- Actualizamos la tabla 'sitios_turisticos' usando total_resenas
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

-- El trigger ya existe, no necesitamos recrearlo
-- Solo actualizamos la función
