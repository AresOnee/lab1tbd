
-- CREAR TABLA DE SEGUIDORES
-- Funcionalidad de red social: usuarios pueden seguir a otros usuarios

-- Crear tabla de seguidores (relación N:M entre usuarios)
CREATE TABLE IF NOT EXISTS seguidores (
    id SERIAL PRIMARY KEY,
    id_seguidor INT NOT NULL,      -- Usuario que sigue (follower)
    id_seguido INT NOT NULL,        -- Usuario que es seguido (following)
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Claves foráneas
    FOREIGN KEY (id_seguidor) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Restricción: Un usuario no puede seguirse a sí mismo
    CHECK (id_seguidor != id_seguido),

    -- Restricción: No puede haber relaciones duplicadas
    UNIQUE (id_seguidor, id_seguido)
);

-- Crear índices para optimizar consultas
CREATE INDEX IF NOT EXISTS idx_seguidores_seguidor ON seguidores(id_seguidor);
CREATE INDEX IF NOT EXISTS idx_seguidores_seguido ON seguidores(id_seguido);

-- Comentarios para documentación
COMMENT ON TABLE seguidores IS 'Relación de seguimiento entre usuarios (funcionalidad de red social)';
COMMENT ON COLUMN seguidores.id_seguidor IS 'ID del usuario que está siguiendo (follower)';
COMMENT ON COLUMN seguidores.id_seguido IS 'ID del usuario que es seguido (following)';
COMMENT ON COLUMN seguidores.fecha_inicio IS 'Fecha y hora en que se inició el seguimiento';

-- Verificar que la tabla se creó correctamente
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'seguidores'
ORDER BY ordinal_position;

-- Mostrar las restricciones creadas
SELECT
    con.conname AS constraint_name,
    con.contype AS constraint_type,
    CASE
        WHEN con.contype = 'f' THEN 'Foreign Key'
        WHEN con.contype = 'c' THEN 'Check'
        WHEN con.contype = 'u' THEN 'Unique'
        WHEN con.contype = 'p' THEN 'Primary Key'
    END AS constraint_description
FROM pg_constraint con
JOIN pg_class rel ON rel.oid = con.conrelid
WHERE rel.relname = 'seguidores';
