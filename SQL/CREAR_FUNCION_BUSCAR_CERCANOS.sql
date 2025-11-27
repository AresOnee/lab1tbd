-- =============================================
-- Crear/Recrear función buscar_sitios_cercanos
-- =============================================

-- Eliminar la función si existe
DROP FUNCTION IF EXISTS buscar_sitios_cercanos(double precision, double precision, integer);

-- Crear la función
CREATE OR REPLACE FUNCTION buscar_sitios_cercanos(
    p_longitud DOUBLE PRECISION,
    p_latitud DOUBLE PRECISION,
    p_radio_metros INTEGER
)
RETURNS TABLE (
    id INT,
    nombre VARCHAR,
    descripcion TEXT,
    tipo VARCHAR,
    direccion VARCHAR,
    latitud DOUBLE PRECISION,
    longitud DOUBLE PRECISION,
    calificacion_promedio DOUBLE PRECISION,
    total_resenas INT,
    distancia_metros DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.id,
        s.nombre,
        s.descripcion,
        s.tipo,
        s.direccion,
        ST_Y(s.coordenadas) AS latitud,
        ST_X(s.coordenadas) AS longitud,
        s.calificacion_promedio,
        s.total_resenas,
        ST_Distance(
            ST_Transform(s.coordenadas, 3857),
            ST_Transform(ST_SetSRID(ST_MakePoint(p_longitud, p_latitud), 4326), 3857)
        ) AS distancia_metros
    FROM
        sitios_turisticos s
    WHERE
        s.coordenadas IS NOT NULL
        AND ST_DWithin(
            ST_Transform(s.coordenadas, 3857),
            ST_Transform(ST_SetSRID(ST_MakePoint(p_longitud, p_latitud), 4326), 3857),
            p_radio_metros
        )
    ORDER BY
        distancia_metros ASC;
END;
$$ LANGUAGE plpgsql;

-- Verificar que se creó correctamente
SELECT 'Función creada exitosamente' AS mensaje;

-- Probar la función
SELECT 'Probando con Santiago Centro (radio 5km):' AS prueba;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 5000);
