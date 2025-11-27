-- =============================================
-- Agregar coordenadas a sitios que no las tienen
-- o corregir coordenadas mal configuradas
-- =============================================

-- Verificar primero cuántos sitios hay sin coordenadas
SELECT 'Sitios sin coordenadas:' AS info, COUNT(*) FROM sitios_turisticos WHERE coordenadas IS NULL;

-- Actualizar sitios conocidos de Santiago con coordenadas reales
-- Solo si no tienen coordenadas o están en NULL

-- Museo Nacional de Bellas Artes
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6346, -33.4366), 4326)
WHERE LOWER(nombre) LIKE '%museo%bellas artes%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Parque Forestal
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6405, -33.4372), 4326)
WHERE LOWER(nombre) LIKE '%parque forestal%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Cerro San Cristóbal
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6344, -33.4259), 4326)
WHERE LOWER(nombre) LIKE '%cerro%cristobal%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- La Chascona (Museo Pablo Neruda)
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6341, -33.4269), 4326)
WHERE LOWER(nombre) LIKE '%chascona%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Teatro Municipal
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6504, -33.4377), 4326)
WHERE LOWER(nombre) LIKE '%teatro municipal%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Plaza de Armas
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6506, -33.4372), 4326)
WHERE LOWER(nombre) LIKE '%plaza%armas%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Restaurante Bocanáriz (ejemplo)
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6406, -33.4264), 4326)
WHERE LOWER(nombre) LIKE '%bocanariz%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Mercado Central
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6524, -33.4362), 4326)
WHERE LOWER(nombre) LIKE '%mercado central%'
  AND (coordenadas IS NULL OR ST_X(coordenadas) = 0 OR ST_Y(coordenadas) = 0);

-- Para sitios que aún no tienen coordenadas, asignar Santiago Centro por defecto
UPDATE sitios_turisticos
SET coordenadas = ST_SetSRID(ST_MakePoint(-70.6693, -33.4489), 4326)
WHERE coordenadas IS NULL;

-- Verificar resultados
SELECT 'Sitios después de actualización:' AS info;
SELECT
    id,
    nombre,
    tipo,
    ST_Y(coordenadas) AS latitud,
    ST_X(coordenadas) AS longitud
FROM sitios_turisticos
ORDER BY id;

-- Probar búsqueda cercana nuevamente
SELECT 'Prueba de búsqueda (Santiago Centro, 5km):' AS prueba;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 5000);
