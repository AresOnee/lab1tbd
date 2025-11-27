-- Script para verificar y actualizar coordenadas de sitios

-- 1. Ver coordenadas actuales del Teatro y Restaurante
SELECT
    nombre,
    tipo,
    ST_Y(coordenadas::geometry) as latitud,
    ST_X(coordenadas::geometry) as longitud
FROM sitios_turisticos
WHERE tipo IN ('Teatro', 'Restaurante')
ORDER BY tipo;

-- 2. Calcular distancia entre Teatro y Restaurante
SELECT
    t.nombre as teatro,
    r.nombre as restaurante,
    ST_Distance(t.coordenadas, r.coordenadas) as distancia_metros
FROM sitios_turisticos t
CROSS JOIN sitios_turisticos r
WHERE t.tipo = 'Teatro' AND r.tipo = 'Restaurante';

-- 3. Si necesitas actualizar las coordenadas para que estén más cerca (< 100m),
-- descomenta y ejecuta las siguientes líneas:

-- -- Poner el restaurante Bocanáriz cerca del Teatro Municipal (aprox 80m)
-- UPDATE sitios_turisticos
-- SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6506, -33.4372), 4326)::geography
-- WHERE nombre LIKE '%Bocan%';

-- -- Verificar nueva distancia
-- SELECT
--     ST_Distance(
--         (SELECT coordenadas FROM sitios_turisticos WHERE tipo = 'Teatro'),
--         (SELECT coordenadas FROM sitios_turisticos WHERE tipo = 'Restaurante')
--     ) as distancia_metros;
