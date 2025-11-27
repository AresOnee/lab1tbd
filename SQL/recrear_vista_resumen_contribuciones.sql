-- =============================================
-- Recrear vista materializada resumen_contribuciones_usuario
-- Para usar el nombre correcto de tabla 'resenas' (sin ñ)
-- Y nombres de columnas sin tildes para evitar problemas de encoding
-- =============================================

-- Eliminar la vista materializada antigua
DROP MATERIALIZED VIEW IF EXISTS resumen_contribuciones_usuario;

-- Crear la vista materializada con nombres sin tildes
CREATE MATERIALIZED VIEW resumen_contribuciones_usuario AS
SELECT
    u.id AS id_usuario,
    u.nombre,

    -- Usamos subconsultas escalares para contar las contribuciones
    -- Nombres sin tildes para evitar problemas de encoding
    (SELECT COUNT(*) FROM resenas r WHERE r.id_usuario = u.id) AS total_resenas,
    (SELECT COUNT(*) FROM fotografias f WHERE f.id_usuario = u.id) AS total_fotos,
    (SELECT COUNT(*) FROM listas_personalizadas l WHERE l.id_usuario = u.id) AS total_listas
FROM
    usuarios u
WITH DATA;

-- Verificar que se creó correctamente
SELECT 'Vista materializada recreada correctamente' AS mensaje;
SELECT * FROM resumen_contribuciones_usuario LIMIT 5;
