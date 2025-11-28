
-- Consultas del Enunciado Laboratorio 1

-- Consulta 1: Cálculo de Calificación Promedio y Conteo de Reseñas por tipo.
SELECT
    tipo,
    AVG(calificacion_promedio) AS calificacion_promedio_general,
    SUM(total_resenas) AS total_resenas_general
FROM
    sitios_turisticos
GROUP BY
    tipo;

-- Consulta 2: Identificación de los 5 Reseñadores Más Activos (últimos 6 meses).
WITH ReseñasRecientes AS (
    SELECT 
        id_usuario, 
        COUNT(*) AS conteo_reseñas
    FROM 
        reseñas
    WHERE 
        fecha >= (CURRENT_TIMESTAMP - INTERVAL '6 months')
    GROUP BY 
        id_usuario
)
SELECT 
    u.nombre, 
    rr.conteo_reseñas
FROM 
    ReseñasRecientes rr
JOIN 
    usuarios u ON rr.id_usuario = u.id
ORDER BY 
    rr.conteo_reseñas DESC,
LIMIT 5;

-- Consulta 3: Análisis de Proximidad (Restaurantes a < 100m de un Teatro).
SELECT 
    t.nombre AS nombre_teatro,
    r.nombre AS nombre_restaurante,
    ST_Distance(t.coordenadas, r.coordenadas) AS distancia_en_metros
FROM 
    sitios_turisticos t
JOIN 
    sitios_turisticos r ON ST_DWithin(t.coordenadas, r.coordenadas, 100) -- 100 metros
WHERE 
    t.tipo = 'Teatro' 
    AND r.tipo = 'Restaurante'
    AND t.id != r.id; -- Asegurarse de no comparar un sitio consigo mismo

-- Consulta 4: Detección de Sitios con Valoraciones Inusuales (Promedio > 4.5, < 10 reseñas).
SELECT
    nombre,
    calificacion_promedio,
    total_resenas
FROM
    sitios_turisticos
WHERE
    calificacion_promedio > 4.5
    AND total_resenas < 10;

-- Consulta 5: Análisis de Popularidad por Región.

SELECT
    ciudad,
    SUM(total_resenas) AS total_resenas_por_ciudad
FROM
    sitios_turisticos
WHERE
    ciudad IS NOT NULL
GROUP BY
    ciudad
ORDER BY
    total_resenas_por_ciudad DESC;

-- Consulta 6: Actualización Masiva de Calificaciones (Trigger).
-- Esta consulta está implementada como un TRIGGER en 'tablitas.sql'.
-- (trigger_actualizar_calificacion y funcion actualizar_calificacion_promedio)
-- No se ejecuta una consulta, solo se verifica su existencia:
SELECT tgname 
FROM pg_trigger 
WHERE tgname = 'trigger_actualizar_calificacion';


-- Consulta 7: Listado de Sitios con Pocas Contribuciones (Sin reseñas o fotos en 3 meses).
WITH UltimasContribuciones AS (
    -- Unimos las fechas de las últimas reseñas y fotos por sitio
    SELECT 
        id_sitio, 
        MAX(fecha) AS ultima_fecha
    FROM (
        SELECT id_sitio, fecha FROM reseñas
        UNION ALL
        SELECT id_sitio, fecha FROM fotografias
    ) AS contribuciones
    GROUP BY id_sitio
)
SELECT 
    s.nombre,
    s.tipo,
    uc.ultima_fecha AS fecha_ultima_contribucion
FROM 
    sitios_turisticos s
LEFT JOIN 
    UltimasContribuciones uc ON s.id = uc.id_sitio
WHERE 
    uc.ultima_fecha IS NULL -- Nunca ha tenido contribuciones
    OR uc.ultima_fecha < (CURRENT_TIMESTAMP - INTERVAL '3 months'); -- Última contribución fue hace más de 3 meses

-- Consulta 8: Análisis de Contenido de Reseñas (3 más largas de usuarios con prom. > 4.0).
WITH PromedioUsuario AS (
    -- Obtenemos el promedio de calificación de cada usuario
    SELECT 
        id_usuario, 
        AVG(calificacion) AS promedio_calificacion
    FROM 
        reseñas
    GROUP BY 
        id_usuario
    HAVING 
        AVG(calificacion) > 4.0
)
SELECT 
    u.nombre AS nombre_usuario,
    s.nombre AS nombre_sitio,
    r.contenido,
    LENGTH(r.contenido) AS longitud_reseña
FROM 
    reseñas r
JOIN 
    usuarios u ON r.id_usuario = u.id
JOIN 
    sitios_turisticos s ON r.id_sitio = s.id
JOIN 
    PromedioUsuario pu ON r.id_usuario = pu.id_usuario -- Filtramos solo por usuarios con prom > 4.0
ORDER BY 
    longitud_reseña DESC
LIMIT 3;

-- Consulta 9: Resumen de Contribuciones por Usuario (Vista Materializada).
-- Esta consulta está implementada como una VISTA MATERIALIZADA en 'tablitas.sql'.
-- (resumen_contribuciones_usuario)
-- Para usarla, simplemente la seleccionamos:
SELECT * FROM resumen_contribuciones_usuario;

-- Para refrescarla (si se añaden nuevos usuarios, por ejemplo):
-- REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;