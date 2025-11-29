-- -----------------------------------------------------
-- Limpieza (opcional, pero útil para re-ejecutar el script)
-- Se eliminan en orden inverso a la creación para evitar errores de FK.
-- -----------------------------------------------------
DROP TABLE IF EXISTS lista_sitios CASCADE;
DROP TABLE IF EXISTS listas_personalizadas CASCADE;
DROP TABLE IF EXISTS fotografias CASCADE;
DROP TABLE IF EXISTS reseñas CASCADE;
DROP TABLE IF EXISTS sitios_turisticos CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- -----------------------------------------------------
-- Habilitar extensión PostGIS (Requerido para Consulta #3)
-- -----------------------------------------------------
-- Necesitamos esta extensión para usar el tipo 'geography' y funciones
-- como ST_DWithin() para calcular distancias en metros.
CREATE EXTENSION IF NOT EXISTS postgis;

-- -----------------------------------------------------
-- Tabla 1: usuarios
-- Almacena la información de los usuarios de la red social.
-- -----------------------------------------------------
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    biografia TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Tabla 2: sitios_turisticos
-- Almacena la información de los lugares de interés.
-- -----------------------------------------------------
CREATE TABLE sitios_turisticos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50),

    -- Usamos GEOGRAPHY(POINT, 4326) de PostGIS.
    -- Almacena (Longitud, Latitud) en el estándar WGS 84 (SRID 4326).
    -- Esto es esencial para la consulta de proximidad (#3).
    coordenadas GEOGRAPHY(POINT, 4326),

    -- Ciudad donde se encuentra el sitio (Requerido para Consulta #5)
    ciudad VARCHAR(100),

    -- Estas columnas serán actualizadas por el trigger (Requisito #6)
    calificacion_promedio DECIMAL(3, 2) DEFAULT 0.0,
    total_reseñas INT DEFAULT 0
);

-- -----------------------------------------------------
-- Tabla 3: reseñas
-- Almacena las reseñas y calificaciones de los usuarios sobre los sitios.
-- -----------------------------------------------------
CREATE TABLE reseñas (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_sitio INT NOT NULL,
    contenido TEXT,
    
    -- Restricción CHECK para asegurar que la calificación esté entre 1 y 5
    calificacion INT NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Definición de Claves Foráneas
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL, -- Si se borra el usuario, la reseña queda anónima o se borra? (aquí la dejamos)
    FOREIGN KEY (id_sitio) REFERENCES sitios_turisticos(id) ON DELETE CASCADE -- Si se borra el sitio, se borran sus reseñas.
);

-- -----------------------------------------------------
-- Tabla 4: fotografias
-- Almacena los enlaces a las fotos subidas por los usuarios.
-- -----------------------------------------------------
CREATE TABLE fotografias (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_sitio INT NOT NULL,
    url VARCHAR(512) NOT NULL, -- 512 caracteres para URLs largas
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL, -- Si se borra el usuario, la foto queda
    FOREIGN KEY (id_sitio) REFERENCES sitios_turisticos(id) ON DELETE CASCADE -- Si se borra el sitio, se borran sus fotos.
);

-- -----------------------------------------------------
-- Tabla 5: listas_personalizadas
-- Almacena las listas creadas por los usuarios (ej: 'Mis favoritos').
-- -----------------------------------------------------
CREATE TABLE listas_personalizadas (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE -- Si se borra el usuario, se borran sus listas.
);

-- -----------------------------------------------------
-- Tabla 6: lista_sitios (Tabla de Unión / Pivote)
-- Vincula sitios_turisticos con listas_personalizadas (Relación N:M).
-- -----------------------------------------------------
CREATE TABLE lista_sitios (
    id_lista INT NOT NULL,
    id_sitio INT NOT NULL,
    
    -- Claves foráneas con ON DELETE CASCADE
    -- Si se borra una lista o un sitio, se elimina la entrada en esta tabla.
    FOREIGN KEY (id_lista) REFERENCES listas_personalizadas(id) ON DELETE CASCADE,
    FOREIGN KEY (id_sitio) REFERENCES sitios_turisticos(id) ON DELETE CASCADE,
    
    -- Clave primaria compuesta para evitar duplicados
    PRIMARY KEY (id_lista, id_sitio)
);

-- ================================================================================================
-- Requisito #6: Trigger para Calificación Promedio
-- ================================================================================================
-- Este trigger actualizará automáticamente la calificación promedio y el total de reseñas

-- -----------------------------------------------------
-- 1. CREACIÓN DE LA FUNCIÓN DEL TRIGGER
-- Esta función se ejecutará cada vez que el trigger sea disparado.
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION actualizar_calificacion_promedio()
RETURNS TRIGGER AS $$
DECLARE
    -- Declaramos una variable para almacenar el ID del sitio afectado
    sitio_id INT;
BEGIN
    -- Determinamos el ID del sitio afectado
    -- Si es un INSERT o UPDATE, usamos el nuevo ID (NEW)
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        sitio_id := NEW.id_sitio;
    -- Si es un DELETE, usamos el ID antiguo (OLD)
    ELSEIF (TG_OP = 'DELETE') THEN
        sitio_id := OLD.id_sitio;
    END IF;

    -- Actualizamos la tabla 'sitios_turisticos'
    UPDATE sitios_turisticos
    SET 
        -- Usamos COALESCE para manejar el caso de que no haya reseñas (devuelve 0.0 en lugar de NULL)
        calificacion_promedio = (
            SELECT COALESCE(AVG(calificacion), 0.0) 
            FROM reseñas 
            WHERE id_sitio = sitio_id
        ),
        total_reseñas = (
            SELECT COUNT(*) 
            FROM reseñas 
            WHERE id_sitio = sitio_id
        )
    WHERE id = sitio_id;

    -- Devolvemos NEW para INSERT/UPDATE, o OLD para DELETE. 
    -- Para un trigger 'AFTER', 'NULL' también es una opción válida y a veces más limpia.
    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- 2. ASIGNACIÓN DEL TRIGGER A LA TABLA
-- Este trigger llamará a la función 'actualizar_calificacion_promedio'
-- DESPUÉS de cualquier INSERT, UPDATE o DELETE en la tabla 'reseñas'.
-- -----------------------------------------------------
CREATE TRIGGER trigger_actualizar_calificacion
AFTER INSERT OR UPDATE OR DELETE ON reseñas
FOR EACH ROW -- Se ejecuta una vez por cada fila afectada
EXECUTE FUNCTION actualizar_calificacion_promedio();


-- ================================================================================================
-- Requisito #9: Vista Materializada - Resumen de Contribuciones
-- ================================================================================================

-- -----------------------------------------------------
-- 1. CREACIÓN DE LA VISTA MATERIALIZADA
-- Almacena los conteos totales de contribuciones por usuario.
-- -----------------------------------------------------
CREATE MATERIALIZED VIEW resumen_contribuciones_usuario AS
SELECT 
    u.id AS id_usuario,
    u.nombre,
    
    -- Usamos subconsultas escalares para contar las contribuciones
    -- de cada usuario en las tablas correspondientes.
    (SELECT COUNT(*) FROM reseñas r WHERE r.id_usuario = u.id) AS total_reseñas,
    (SELECT COUNT(*) FROM fotografias f WHERE f.id_usuario = u.id) AS total_fotos,
    (SELECT COUNT(*) FROM listas_personalizadas l WHERE l.id_usuario = u.id) AS total_listas
FROM 
    usuarios u
-- (Opcional) Podemos incluir WITH DATA o WITH NO DATA. Por defecto es WITH DATA.
WITH DATA;

-- -----------------------------------------------------
-- 2. CREACIÓN DEL ÍNDICE ÚNICO
-- ESTE ÍNDICE ES OBLIGATORIO para poder usar 'REFRESH... CONCURRENTLY'.
-- Sin él, PostgreSQL no puede actualizar la vista sin bloquearla.
-- -----------------------------------------------------
CREATE UNIQUE INDEX idx_resumen_contribuciones_usuario_id
ON resumen_contribuciones_usuario(id_usuario);

-- -----------------------------------------------------
-- Fin del Script de la Vista Materializada
-- -----------------------------------------------------

-- =============================================
-- Requisito: Creación de Índices
-- Optimización de consultas comunes.
-- =============================================

-- Índice para acelerar la búsqueda de reseñas por sitio y por usuario
CREATE INDEX idx_reseñas_id_sitio ON reseñas(id_sitio);
CREATE INDEX idx_reseñas_id_usuario ON reseñas(id_usuario);

-- Índice para acelerar la búsqueda de fotos por sitio y por usuario
CREATE INDEX idx_fotografias_id_sitio ON fotografias(id_sitio);
CREATE INDEX idx_fotografias_id_usuario ON fotografias(id_usuario);

-- Índice para filtrar sitios por tipo (ej. 'Parque', 'Museo')
CREATE INDEX idx_sitios_tipo ON sitios_turisticos(tipo);

-- FUNDAMENTAL: Índice GIST para consultas geoespaciales (PostGIS)
-- Este índice es el que permite que las búsquedas por ubicación
-- (como la consulta #3) sean extremadamente rápidas.
CREATE INDEX idx_sitios_coordenadas ON sitios_turisticos USING GIST (coordenadas);

-- -----------------------------------------------------
-- Fin del Script de Índices
-- -----------------------------------------------------

-- =============================================
-- Requisito: Procedimiento Almacenado
-- Encapsula la lógica de "búsqueda de sitios cercanos".
-- =============================================

CREATE OR REPLACE FUNCTION buscar_sitios_cercanos(
    user_long DOUBLE PRECISION,
    user_lat DOUBLE PRECISION,
    radio_metros INT
)
-- Devuelve un conjunto de filas que coinciden con la estructura de la tabla 'sitios_turisticos'
RETURNS SETOF sitios_turisticos AS $$
BEGIN
    -- Usamos RETURN QUERY para devolver los resultados de un SELECT
    RETURN QUERY
    SELECT *
    FROM sitios_turisticos
    WHERE 
        -- ST_DWithin es la función de PostGIS para "Distance Within" (Dentro de la Distancia)
        -- Es la forma más eficiente de encontrar puntos dentro de un radio.
        -- 1. sitio.coordenadas: Columna 'geography' de la tabla.
        -- 2. ST_MakePoint(user_long, user_lat): Creamos un punto con la entrada del usuario.
        -- 3. ::geography: Convertimos (cast) ese punto a tipo 'geography' para comparar.
        -- 4. radio_metros: La distancia de búsqueda.
        ST_DWithin(
            coordenadas,
            ST_MakePoint(user_long, user_lat)::geography,
            radio_metros
        );
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Fin del Script de Procedimiento Almacenado
-- -----------------------------------------------------

