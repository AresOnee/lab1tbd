-- Diagnóstico para estadísticas

-- 1. Ver todos los tipos de sitios que existen
SELECT DISTINCT tipo, COUNT(*) as cantidad
FROM sitios_turisticos
GROUP BY tipo
ORDER BY cantidad DESC;

-- 2. Ver si hay teatros y restaurantes
SELECT tipo, nombre
FROM sitios_turisticos
WHERE tipo IN ('Teatro', 'Restaurante')
ORDER BY tipo, nombre;

-- 3. Verificar fechas de contribuciones recientes
SELECT
    'Reseñas' as tipo,
    MAX(fecha) as fecha_mas_reciente,
    MIN(fecha) as fecha_mas_antigua,
    COUNT(*) as total
FROM resenas
UNION ALL
SELECT
    'Fotografías' as tipo,
    MAX(fecha) as fecha_mas_reciente,
    MIN(fecha) as fecha_mas_antigua,
    COUNT(*) as total
FROM fotografias;

-- 4. Ver contenido de reseñas (para verificar encoding)
SELECT
    u.nombre as usuario,
    s.nombre as sitio,
    r.contenido,
    LENGTH(r.contenido) as longitud
FROM resenas r
JOIN usuarios u ON r.id_usuario = u.id
JOIN sitios_turisticos s ON r.id_sitio = s.id
ORDER BY longitud DESC
LIMIT 5;
