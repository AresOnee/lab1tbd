-- =============================================
-- Crear/Recrear función buscar_sitios_cercanos
-- NOTA: La función original ya existe y funciona bien.
-- Este script NO debe ejecutarse a menos que quieras sobrescribirla.
-- =============================================

-- COMENTADO: No eliminar la función original que ya funciona
-- DROP FUNCTION IF EXISTS buscar_sitios_cercanos(double precision, double precision, integer);

-- Verificar que la función existe
SELECT 'Verificando función existente:' AS mensaje;
SELECT
    p.proname AS funcion,
    pg_get_function_arguments(p.oid) AS parametros
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'buscar_sitios_cercanos'
  AND n.nspname = 'public';

-- Probar la función existente
SELECT 'Probando función existente (Santiago Centro, 5km):' AS prueba;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 5000);

SELECT 'Probando función existente (Santiago Centro, 10km):' AS prueba;
SELECT * FROM buscar_sitios_cercanos(-70.6693, -33.4489, 10000);
