-- =============================================
-- Script para verificar datos de sitios y función de búsqueda cercanos
-- =============================================

-- 1. Ver cuántos sitios hay en la base de datos
SELECT 'Total de sitios turísticos:' AS info, COUNT(*) AS total FROM sitios_turisticos;

-- 2. Ver los primeros 5 sitios con sus coordenadas
SELECT id, nombre, tipo,
       ST_Y(coordenadas) AS latitud,
       ST_X(coordenadas) AS longitud
FROM sitios_turisticos
LIMIT 5;

-- 3. Verificar si existe la función buscar_sitios_cercanos
SELECT 'Verificando función buscar_sitios_cercanos:' AS info;
SELECT p.proname AS nombre_funcion,
       pg_get_function_arguments(p.oid) AS argumentos
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'buscar_sitios_cercanos'
  AND n.nspname = 'public';

-- 4. Probar la búsqueda cercana con Santiago Centro
-- Coordenadas: Latitud -33.4489, Longitud -70.6693
SELECT 'Probando búsqueda en Santiago Centro (radio 5000m):' AS info;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 5000);

-- 5. Probar búsqueda con radio más grande (10km)
SELECT 'Probando búsqueda en Santiago Centro (radio 10000m):' AS info;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 10000);

-- 6. Ver distribución de sitios por tipo
SELECT tipo, COUNT(*) AS cantidad
FROM sitios_turisticos
GROUP BY tipo
ORDER BY cantidad DESC;
