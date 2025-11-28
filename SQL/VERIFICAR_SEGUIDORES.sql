-- =============================================
-- VERIFICAR DATOS DE SEGUIDORES
-- =============================================
-- Este script verifica que los datos de seguidores
-- se cargaron correctamente en la base de datos
-- =============================================

-- =============================================
-- 1. CONTAR RELACIONES DE SEGUIMIENTO
-- =============================================

SELECT 'Total de relaciones de seguimiento:' AS descripcion, COUNT(*) AS total
FROM seguidores;

-- =============================================
-- 2. VER TODAS LAS RELACIONES
-- =============================================

SELECT
    s.id,
    u1.nombre AS seguidor,
    u2.nombre AS seguido,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u1 ON s.id_seguidor = u1.id
JOIN usuarios u2 ON s.id_seguido = u2.id
ORDER BY s.fecha_inicio DESC;

-- =============================================
-- 3. ESTADISTICAS POR USUARIO
-- =============================================

SELECT
    u.id,
    u.nombre,
    (SELECT COUNT(*) FROM seguidores WHERE id_seguido = u.id) AS total_seguidores,
    (SELECT COUNT(*) FROM seguidores WHERE id_seguidor = u.id) AS total_siguiendo
FROM usuarios u
ORDER BY total_seguidores DESC;

-- =============================================
-- 4. USUARIOS MAS POPULARES (más seguidores)
-- =============================================

SELECT
    u.nombre,
    u.email,
    COUNT(s.id) AS total_seguidores
FROM usuarios u
LEFT JOIN seguidores s ON u.id = s.id_seguido
GROUP BY u.id, u.nombre, u.email
ORDER BY total_seguidores DESC
LIMIT 5;

-- =============================================
-- 5. USUARIOS MAS ACTIVOS (siguen a más personas)
-- =============================================

SELECT
    u.nombre,
    u.email,
    COUNT(s.id) AS total_siguiendo
FROM usuarios u
LEFT JOIN seguidores s ON u.id = s.id_seguidor
GROUP BY u.id, u.nombre, u.email
ORDER BY total_siguiendo DESC
LIMIT 5;

-- =============================================
-- 6. SEGUIDORES DE ANA GARCIA (ID 1)
-- =============================================

SELECT
    'Seguidores de Ana Garcia:' AS descripcion;

SELECT
    u.nombre AS seguidor,
    u.email,
    u.biografia,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u ON s.id_seguidor = u.id
WHERE s.id_seguido = 1
ORDER BY s.fecha_inicio DESC;

-- =============================================
-- 7. A QUIEN SIGUE ANA GARCIA (ID 1)
-- =============================================

SELECT
    'Ana Garcia sigue a:' AS descripcion;

SELECT
    u.nombre AS seguido,
    u.email,
    u.biografia,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u ON s.id_seguido = u.id
WHERE s.id_seguidor = 1
ORDER BY s.fecha_inicio DESC;

-- =============================================
-- 8. SEGUIDORES DE ELENA FERNANDEZ (ID 5)
-- =============================================

SELECT
    'Seguidores de Elena Fernandez:' AS descripcion;

SELECT
    u.nombre AS seguidor,
    u.email,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u ON s.id_seguidor = u.id
WHERE s.id_seguido = 5
ORDER BY s.fecha_inicio DESC;

-- =============================================
-- 9. RELACIONES MUTUAS (se siguen mutuamente)
-- =============================================

SELECT
    'Relaciones mutuas (se siguen mutuamente):' AS descripcion;

SELECT
    u1.nombre AS usuario1,
    u2.nombre AS usuario2
FROM seguidores s1
JOIN seguidores s2 ON s1.id_seguidor = s2.id_seguido
                   AND s1.id_seguido = s2.id_seguidor
JOIN usuarios u1 ON s1.id_seguidor = u1.id
JOIN usuarios u2 ON s1.id_seguido = u2.id
WHERE s1.id_seguidor < s1.id_seguido  -- Evitar duplicados
ORDER BY u1.nombre;

-- =============================================
-- 10. VERIFICAR INTEGRIDAD
-- =============================================

-- Verificar que no hay usuarios siguiendose a si mismos
SELECT
    'Usuarios siguiendose a si mismos (debe ser 0):' AS descripcion,
    COUNT(*) AS total
FROM seguidores
WHERE id_seguidor = id_seguido;

-- Verificar que no hay relaciones duplicadas
SELECT
    'Relaciones duplicadas (debe ser 0):' AS descripcion,
    COUNT(*) - COUNT(DISTINCT (id_seguidor, id_seguido)) AS duplicados
FROM seguidores;

-- =============================================
-- 11. GRAFO DE SEGUIMIENTO (para visualizacion)
-- =============================================

SELECT
    'Grafo de seguimiento (formato: Seguidor -> Seguido):' AS descripcion;

SELECT
    CONCAT(u1.nombre, ' -> ', u2.nombre) AS relacion,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u1 ON s.id_seguidor = u1.id
JOIN usuarios u2 ON s.id_seguido = u2.id
ORDER BY u1.nombre, u2.nombre;

-- =============================================
-- FIN DEL SCRIPT DE VERIFICACION
-- =============================================

-- Resumen final
SELECT
    'RESUMEN FINAL' AS '';

SELECT
    'Total usuarios:' AS metrica,
    COUNT(*) AS valor
FROM usuarios
UNION ALL
SELECT
    'Total relaciones seguimiento:',
    COUNT(*)
FROM seguidores
UNION ALL
SELECT
    'Promedio seguidores por usuario:',
    ROUND(AVG(seguidores_count), 2)
FROM (
    SELECT COUNT(*) AS seguidores_count
    FROM seguidores
    GROUP BY id_seguido
) subq
UNION ALL
SELECT
    'Promedio siguiendo por usuario:',
    ROUND(AVG(siguiendo_count), 2)
FROM (
    SELECT COUNT(*) AS siguiendo_count
    FROM seguidores
    GROUP BY id_seguidor
) subq;
