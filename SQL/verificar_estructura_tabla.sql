-- =============================================
-- Verificar estructura de tabla sitios_turisticos
-- =============================================

-- Ver todas las columnas de la tabla
SELECT column_name, data_type, udt_name
FROM information_schema.columns
WHERE table_name = 'sitios_turisticos'
ORDER BY ordinal_position;
