-- =============================================
-- SCRIPT DE PRUEBA - CONSULTAS 5 Y 6
-- =============================================
-- Este script verifica que las Consultas #5 y #6 del enunciado
-- estén correctamente implementadas y funcionando.
-- =============================================

\echo '============================================='
\echo 'CONSULTA #5: Análisis de Popularidad por Región'
\echo '============================================='
\echo ''
\echo 'Descripción: Calcula la cantidad total de reseñas por cada región/ciudad'
\echo 'Muestra: Nombre de la ciudad y total de reseñas, ordenado de mayor a menor'
\echo ''

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

\echo ''
\echo '============================================='
\echo 'CONSULTA #6: Trigger de Actualización de Calificaciones'
\echo '============================================='
\echo ''
\echo 'Paso 1: Verificar que el trigger existe'
\echo '---------------------------------------'

SELECT
    tgname AS nombre_trigger,
    tgenabled AS estado
FROM pg_trigger
WHERE tgname = 'trigger_actualizar_calificacion';

\echo ''
\echo 'Paso 2: Ver calificación actual de un sitio (antes de insertar reseña)'
\echo '---------------------------------------'

SELECT
    nombre,
    calificacion_promedio,
    total_resenas
FROM sitios_turisticos
WHERE nombre = 'Cerro San Cristobal';

\echo ''
\echo 'Paso 3: Insertar una nueva reseña (el trigger se ejecutará automáticamente)'
\echo '---------------------------------------'

-- Insertar una reseña de prueba
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha)
VALUES (
    1,
    (SELECT id FROM sitios_turisticos WHERE nombre = 'Cerro San Cristobal'),
    'Excelente lugar para visitar! Vista increible de Santiago.',
    5,
    CURRENT_TIMESTAMP
);

\echo 'Reseña insertada exitosamente.'
\echo ''
\echo 'Paso 4: Verificar que la calificación se actualizó automáticamente'
\echo '---------------------------------------'

SELECT
    nombre,
    calificacion_promedio,
    total_resenas
FROM sitios_turisticos
WHERE nombre = 'Cerro San Cristobal';

\echo ''
\echo '============================================='
\echo 'RESULTADO ESPERADO:'
\echo '- Consulta #5: Debe mostrar ciudades con sus totales de reseñas'
\echo '- Consulta #6: calificacion_promedio y total_resenas deben haber'
\echo '  aumentado automáticamente después del INSERT'
\echo '============================================='
\echo ''
