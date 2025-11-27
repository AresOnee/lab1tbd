-- =============================================
-- DIAGNÓSTICO COMPLETO: Búsqueda de Sitios Cercanos
-- =============================================

-- PASO 1: Verificar cuántos sitios hay
SELECT '1. Total de sitios:' AS paso;
SELECT COUNT(*) AS total_sitios FROM sitios_turisticos;

-- PASO 2: Ver sitios con sus coordenadas (raw)
SELECT '2. Sitios con coordenadas (primeros 5):' AS paso;
SELECT
    id,
    nombre,
    tipo,
    coordenadas,
    ST_AsText(coordenadas) AS coordenadas_texto,
    ST_Y(coordenadas) AS latitud,
    ST_X(coordenadas) AS longitud
FROM sitios_turisticos
LIMIT 5;

-- PASO 3: Verificar si hay sitios con coordenadas NULL
SELECT '3. Sitios sin coordenadas:' AS paso;
SELECT COUNT(*) AS sitios_sin_coordenadas
FROM sitios_turisticos
WHERE coordenadas IS NULL;

-- PASO 4: Verificar si existe la función
SELECT '4. Verificando función buscar_sitios_cercanos:' AS paso;
SELECT
    p.proname AS funcion,
    pg_get_function_arguments(p.oid) AS parametros,
    pg_get_functiondef(p.oid) AS definicion
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'buscar_sitios_cercanos'
  AND n.nspname = 'public';

-- PASO 5: Probar directamente la función (si existe)
-- Coordenadas de Santiago Centro: lng=-70.6693, lat=-33.4489
SELECT '5. Prueba directa de búsqueda (Santiago Centro, 5km):' AS paso;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 5000);

-- PASO 6: Probar con radio muy grande (50km)
SELECT '6. Prueba con radio grande (50km):' AS paso;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 50000);

-- PASO 7: Calcular distancia manualmente a todos los sitios
SELECT '7. Distancia manual desde Santiago Centro a todos los sitios:' AS paso;
SELECT
    id,
    nombre,
    ST_Y(coordenadas) AS latitud,
    ST_X(coordenadas) AS longitud,
    ST_Distance(
        coordenadas,
        ST_SetSRID(ST_MakePoint(-70.6693, -33.4489), 4326)
    ) AS distancia_grados,
    ST_Distance(
        ST_Transform(coordenadas, 3857),
        ST_Transform(ST_SetSRID(ST_MakePoint(-70.6693, -33.4489), 4326), 3857)
    ) AS distancia_metros
FROM sitios_turisticos
WHERE coordenadas IS NOT NULL
ORDER BY distancia_metros
LIMIT 10;

-- PASO 8: Ver el rango de coordenadas de los sitios
SELECT '8. Rango de coordenadas de sitios:' AS paso;
SELECT
    MIN(ST_Y(coordenadas)) AS lat_min,
    MAX(ST_Y(coordenadas)) AS lat_max,
    MIN(ST_X(coordenadas)) AS lng_min,
    MAX(ST_X(coordenadas)) AS lng_max
FROM sitios_turisticos
WHERE coordenadas IS NOT NULL;
