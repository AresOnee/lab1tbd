# Documentación de Base de Datos
## Mapa Colaborativo de Sitios Turísticos

**Laboratorio 1 - Taller de Base de Datos**
**Grupo 5**

---

## Tabla de Contenidos
1. [Descripción General](#descripción-general)
2. [Diagrama Entidad-Relación](#diagrama-entidad-relación)
3. [Esquema de Tablas](#esquema-de-tablas)
4. [Triggers](#triggers)
5. [Procedimientos Almacenados](#procedimientos-almacenados)
6. [Vistas Materializadas](#vistas-materializadas)
7. [Índices](#índices)
8. [Consultas SQL Requeridas](#consultas-sql-requeridas)

---

## Descripción General

La base de datos está diseñada para soportar una red social colaborativa de sitios turísticos, donde los usuarios pueden:
- Descubrir y compartir lugares de interés
- Calificar y reseñar sitios turísticos
- Subir fotografías de los lugares
- Crear listas personalizadas de sitios
- Seguir a otros usuarios
- Realizar búsquedas geoespaciales

**Sistema Gestor:** PostgreSQL 14+ con extensión PostGIS
**Normalización:** Tercera Forma Normal (3FN)
**Características especiales:** Datos geoespaciales, triggers automáticos, vistas materializadas

---

## Diagrama Entidad-Relación

```
┌──────────────┐         ┌────────────────────┐         ┌──────────────┐
│   usuarios   │────────<│    seguidores      │>────────│   usuarios   │
│              │ 1     N │                    │ N     1 │              │
│ • id (PK)    │         │ • id (PK)          │         │ (mismo)      │
│ • nombre     │         │ • id_seguidor (FK) │         │              │
│ • email      │         │ • id_seguido (FK)  │         │              │
│ • contraseña │         │ • fecha_inicio     │         │              │
│ • biografia  │         └────────────────────┘         │              │
└──────┬───────┘                                         │              │
       │ 1                                               │              │
       │                                                 │              │
       │ N                                               │              │
┌──────┴─────────────────┐                               │              │
│  listas_personalizadas │                               │              │
│                        │                               │              │
│ • id (PK)              │                               │              │
│ • id_usuario (FK)      │                               │              │
│ • nombre               │                               │              │
│ • fecha_creacion       │                               │              │
└──────┬─────────────────┘                               │              │
       │ N                                               │              │
       │                                                 │              │
       │        ┌──────────────┐                         │              │
       └───────<│ lista_sitios │>────────┐               │              │
              N │              │ N       │               │              │
                │ • id_lista   │         │ 1             │              │
                │ • id_sitio   │         │               │              │
                └──────────────┘         │               │              │
                                         │               │              │
                              ┌──────────┴───────────┐   │              │
                              │ sitios_turisticos    │   │              │
                              │                      │   │              │
                              │ • id (PK)            │   │              │
                              │ • nombre             │   │              │
                              │ • descripcion        │   │              │
                              │ • tipo               │   │              │
                              │ • coordenadas (GEOG) │   │              │
                              │ • calificacion_prom  │   │              │
                              │ • total_reseñas      │   │              │
                              └──────────┬───────────┘   │              │
                                         │ 1             │              │
                                         │               │              │
                   ┌─────────────────────┼───────────────┼──────────────┤
                   │ N                   │ N             │ 1            │
                   │                     │               │              │
          ┌────────┴────────┐   ┌────────┴────────┐     │              │
          │   fotografias   │   │    reseñas      │     │              │
          │                 │   │                 │     │              │
          │ • id (PK)       │   │ • id (PK)       │     │              │
          │ • id_usuario(FK)│   │ • id_usuario(FK)│─────┘              │
          │ • id_sitio (FK) │   │ • id_sitio (FK) │                    │
          │ • url           │   │ • contenido     │                    │
          │ • fecha         │   │ • calificacion  │                    │
          └─────────────────┘   │ • fecha         │                    │
                   │            └─────────────────┘                    │
                   │ N                   │ N                           │
                   └─────────────────────┴─────────────────────────────┘
                                         1
```

**Relaciones:**
- **usuarios ↔ usuarios** (N:M): Sistema de seguimiento mediante tabla `seguidores`
- **usuarios → listas_personalizadas** (1:N): Un usuario puede crear múltiples listas
- **listas ↔ sitios** (N:M): Relación mediante tabla pivote `lista_sitios`
- **sitios → reseñas** (1:N): Un sitio puede tener múltiples reseñas
- **sitios → fotografias** (1:N): Un sitio puede tener múltiples fotos
- **usuarios → reseñas** (1:N): Un usuario puede escribir múltiples reseñas
- **usuarios → fotografias** (1:N): Un usuario puede subir múltiples fotos

---

## Esquema de Tablas

### 1. usuarios
Almacena información de los usuarios registrados en la plataforma.

```sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    biografia TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Columnas:**
- `id`: Identificador único del usuario (clave primaria)
- `nombre`: Nombre completo del usuario
- `email`: Correo electrónico (único, usado para login)
- `contrasena_hash`: Contraseña hasheada con BCrypt ($2a$10$...)
- `biografia`: Descripción personal opcional
- `fecha_registro`: Fecha de creación de la cuenta

**Constraints:**
- `PRIMARY KEY (id)`
- `UNIQUE (email)` - No permite emails duplicados

---

### 2. sitios_turisticos
Almacena lugares de interés turístico con datos geoespaciales.

```sql
CREATE TABLE sitios_turisticos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50),
    coordenadas GEOGRAPHY(POINT, 4326),
    calificacion_promedio DECIMAL(3, 2) DEFAULT 0.0,
    total_reseñas INT DEFAULT 0
);
```

**Columnas:**
- `id`: Identificador único del sitio
- `nombre`: Nombre del lugar (ej: "Teatro Municipal")
- `descripcion`: Descripción detallada del sitio
- `tipo`: Categoría (ej: 'Parque', 'Museo', 'Restaurante', 'Teatro')
- `coordenadas`: Punto geográfico (longitud, latitud) en formato WGS 84
- `calificacion_promedio`: Calificación calculada automáticamente por trigger
- `total_reseñas`: Contador actualizado automáticamente por trigger

**Tipo Especial:**
- `GEOGRAPHY(POINT, 4326)`: Tipo de PostGIS para coordenadas geoespaciales
  - SRID 4326 = Sistema WGS 84 (usado por GPS)
  - Permite cálculos de distancia en metros
  - Formato: `ST_MakePoint(longitud, latitud)`

---

### 3. reseñas
Almacena reseñas y calificaciones de usuarios sobre sitios.

```sql
CREATE TABLE reseñas (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_sitio INT NOT NULL,
    contenido TEXT,
    calificacion INT NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL,
    FOREIGN KEY (id_sitio) REFERENCES sitios_turisticos(id) ON DELETE CASCADE
);
```

**Columnas:**
- `id`: Identificador único de la reseña
- `id_usuario`: Referencia al usuario que escribió la reseña
- `id_sitio`: Referencia al sitio reseñado
- `contenido`: Texto de la reseña
- `calificacion`: Valoración de 1 a 5 estrellas
- `fecha`: Fecha de publicación

**Constraints:**
- `CHECK (calificacion >= 1 AND calificacion <= 5)` - Validación de rango
- `ON DELETE SET NULL` para usuario - Preserva reseña aunque usuario se elimine
- `ON DELETE CASCADE` para sitio - Elimina reseñas si se elimina el sitio

---

### 4. fotografias
Almacena URLs de fotografías subidas por usuarios.

```sql
CREATE TABLE fotografias (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_sitio INT NOT NULL,
    url VARCHAR(512) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL,
    FOREIGN KEY (id_sitio) REFERENCES sitios_turisticos(id) ON DELETE CASCADE
);
```

**Columnas:**
- `id`: Identificador único de la fotografía
- `id_usuario`: Usuario que subió la foto
- `id_sitio`: Sitio fotografiado
- `url`: URL de la imagen (512 caracteres para URLs largas)
- `fecha`: Fecha de publicación

**Nota:** Se almacena URL en lugar del archivo binario por eficiencia. En producción, las imágenes se subirían a un servicio CDN (ej: AWS S3, Cloudinary).

---

### 5. listas_personalizadas
Listas de sitios creadas por usuarios (ej: "Lugares para visitar en 2024").

```sql
CREATE TABLE listas_personalizadas (
    id SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);
```

**Columnas:**
- `id`: Identificador único de la lista
- `id_usuario`: Propietario de la lista
- `nombre`: Título de la lista
- `fecha_creacion`: Fecha de creación

---

### 6. lista_sitios (Tabla Pivote)
Relación N:M entre listas y sitios turísticos.

```sql
CREATE TABLE lista_sitios (
    id_lista INT NOT NULL,
    id_sitio INT NOT NULL,

    FOREIGN KEY (id_lista) REFERENCES listas_personalizadas(id) ON DELETE CASCADE,
    FOREIGN KEY (id_sitio) REFERENCES sitios_turisticos(id) ON DELETE CASCADE,

    PRIMARY KEY (id_lista, id_sitio)
);
```

**Clave Primaria Compuesta:** `(id_lista, id_sitio)` previene duplicados.

---

### 7. seguidores (Funcionalidad Extra)
Sistema de seguimiento entre usuarios (red social).

```sql
CREATE TABLE seguidores (
    id SERIAL PRIMARY KEY,
    id_seguidor INT NOT NULL,  -- Usuario que sigue (follower)
    id_seguido INT NOT NULL,   -- Usuario seguido (following)
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_seguidor) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES usuarios(id) ON DELETE CASCADE,

    CHECK (id_seguidor != id_seguido),
    UNIQUE (id_seguidor, id_seguido)
);
```

**Constraints Especiales:**
- `CHECK (id_seguidor != id_seguido)` - Evita que un usuario se siga a sí mismo
- `UNIQUE (id_seguidor, id_seguido)` - Previene seguir dos veces al mismo usuario

---

## Triggers

### trigger_actualizar_calificacion
**Propósito:** Mantener actualizadas automáticamente las columnas `calificacion_promedio` y `total_reseñas` en la tabla `sitios_turisticos` cada vez que se inserta, actualiza o elimina una reseña.

**Archivo:** `SQL/tablitas.sql:168-171`

```sql
CREATE TRIGGER trigger_actualizar_calificacion
AFTER INSERT OR UPDATE OR DELETE ON reseñas
FOR EACH ROW
EXECUTE FUNCTION actualizar_calificacion_promedio();
```

**Función asociada:**
```sql
CREATE OR REPLACE FUNCTION actualizar_calificacion_promedio()
RETURNS TRIGGER AS $$
DECLARE
    sitio_id INT;
BEGIN
    -- Determinar el sitio afectado
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        sitio_id := NEW.id_sitio;
    ELSIF (TG_OP = 'DELETE') THEN
        sitio_id := OLD.id_sitio;
    END IF;

    -- Actualizar calificación promedio y contador
    UPDATE sitios_turisticos
    SET
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

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

**Ejemplo de uso:**
```sql
-- Insertar reseña
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion)
VALUES (1, 5, 'Excelente lugar', 5);

-- El trigger se ejecuta automáticamente y actualiza:
-- sitios_turisticos.calificacion_promedio (recalcula AVG)
-- sitios_turisticos.total_reseñas (incrementa en 1)
```

**Ventajas:**
- ✅ Consistencia automática de datos
- ✅ Evita necesidad de recalcular en cada consulta
- ✅ Mejora rendimiento de lecturas (datos pre-calculados)

---

## Procedimientos Almacenados

### buscar_sitios_cercanos()
**Propósito:** Encapsular la lógica de búsqueda geoespacial de sitios turísticos dentro de un radio específico desde una ubicación.

**Archivo:** `SQL/tablitas.sql:239-264`

```sql
CREATE OR REPLACE FUNCTION buscar_sitios_cercanos(
    user_long DOUBLE PRECISION,  -- Longitud del usuario
    user_lat DOUBLE PRECISION,   -- Latitud del usuario
    radio_metros INT             -- Radio de búsqueda en metros
)
RETURNS SETOF sitios_turisticos AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM sitios_turisticos
    WHERE
        ST_DWithin(
            coordenadas,
            ST_MakePoint(user_long, user_lat)::geography,
            radio_metros
        );
END;
$$ LANGUAGE plpgsql;
```

**Parámetros:**
- `user_long`: Longitud del punto de referencia (-180 a 180)
- `user_lat`: Latitud del punto de referencia (-90 a 90)
- `radio_metros`: Distancia máxima en metros

**Ejemplo de uso:**
```sql
-- Buscar sitios a menos de 500m de las coordenadas de Plaza de Armas
SELECT * FROM buscar_sitios_cercanos(-70.6483, -33.4372, 500);
```

**Funciones PostGIS utilizadas:**
- `ST_MakePoint(long, lat)`: Crea un punto geométrico
- `::geography`: Convierte a tipo geography para cálculos en metros
- `ST_DWithin(geog1, geog2, distancia)`: Verifica si dos puntos están dentro de una distancia

**Ventajas:**
- ✅ Encapsula lógica compleja de PostGIS
- ✅ Reutilizable desde backend
- ✅ Utiliza índice GIST para rendimiento óptimo

---

## Vistas Materializadas

### resumen_contribuciones_usuario
**Propósito:** Pre-calcular y almacenar el total de contribuciones (reseñas, fotos, listas) por cada usuario para mejorar el rendimiento de los perfiles.

**Archivo:** `SQL/tablitas.sql:182-203`

```sql
CREATE MATERIALIZED VIEW resumen_contribuciones_usuario AS
SELECT
    u.id AS id_usuario,
    u.nombre,
    (SELECT COUNT(*) FROM reseñas r WHERE r.id_usuario = u.id) AS total_reseñas,
    (SELECT COUNT(*) FROM fotografias f WHERE f.id_usuario = u.id) AS total_fotos,
    (SELECT COUNT(*) FROM listas_personalizadas l WHERE l.id_usuario = u.id) AS total_listas
FROM
    usuarios u
WITH DATA;

-- Índice único OBLIGATORIO para REFRESH CONCURRENTLY
CREATE UNIQUE INDEX idx_resumen_contribuciones_usuario_id
ON resumen_contribuciones_usuario(id_usuario);
```

**Columnas:**
- `id_usuario`: ID del usuario
- `nombre`: Nombre del usuario
- `total_reseñas`: Cantidad de reseñas escritas
- `total_fotos`: Cantidad de fotos subidas
- `total_listas`: Cantidad de listas creadas

**Uso en aplicación:**
```sql
-- Consulta rápida de estadísticas (no recalcula, lee datos pre-procesados)
SELECT * FROM resumen_contribuciones_usuario WHERE id_usuario = 5;
```

**Actualización:**
```sql
-- Refrescar vista de forma concurrente (sin bloquear lecturas)
REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;
```

**Ventajas:**
- ✅ Consultas extremadamente rápidas (datos pre-calculados)
- ✅ Reduce carga en tablas base
- ✅ `CONCURRENTLY` permite actualizaciones sin downtime
- ✅ Ideal para perfiles de usuario que se consultan frecuentemente

**Cuándo refrescar:**
- Periódicamente (cron job cada hora/día)
- Después de operaciones batch de usuarios
- Bajo demanda desde administración

---

## Índices

Los índices mejoran drásticamente el rendimiento de las consultas más comunes del sistema.

### Índices en reseñas
```sql
CREATE INDEX idx_reseñas_id_sitio ON reseñas(id_sitio);
CREATE INDEX idx_reseñas_id_usuario ON reseñas(id_usuario);
```

**Propósito:**
- Acelerar búsqueda de reseñas por sitio: `WHERE id_sitio = X`
- Acelerar búsqueda de reseñas por usuario: `WHERE id_usuario = Y`

**Consultas optimizadas:**
```sql
-- Ambas consultas usan índices B-Tree
SELECT * FROM reseñas WHERE id_sitio = 10;
SELECT * FROM reseñas WHERE id_usuario = 5;
```

---

### Índices en fotografias
```sql
CREATE INDEX idx_fotografias_id_sitio ON fotografias(id_sitio);
CREATE INDEX idx_fotografias_id_usuario ON fotografias(id_usuario);
```

**Propósito:** Mismo que reseñas, para consultas frecuentes de fotos.

---

### Índice en tipo de sitio
```sql
CREATE INDEX idx_sitios_tipo ON sitios_turisticos(tipo);
```

**Propósito:** Filtrado rápido por categoría.

**Consultas optimizadas:**
```sql
SELECT * FROM sitios_turisticos WHERE tipo = 'Museo';
SELECT * FROM sitios_turisticos WHERE tipo = 'Restaurante';
```

---

### Índice Geoespacial (GIST)
```sql
CREATE INDEX idx_sitios_coordenadas ON sitios_turisticos USING GIST (coordenadas);
```

**Propósito:** **Índice más crítico del sistema**. Permite búsquedas geoespaciales extremadamente rápidas.

**Tipo:** GIST (Generalized Search Tree) - Especializado para datos geométricos.

**Consultas optimizadas:**
```sql
-- Búsqueda de proximidad (usa el índice GIST)
SELECT * FROM sitios_turisticos
WHERE ST_DWithin(coordenadas, ST_MakePoint(-70.6483, -33.4372)::geography, 1000);
```

**Rendimiento:**
- Sin índice: Escaneo completo de tabla O(n)
- Con índice GIST: Búsqueda espacial O(log n)

---

### Índices en seguidores
```sql
CREATE INDEX idx_seguidores_seguidor ON seguidores(id_seguidor);
CREATE INDEX idx_seguidores_seguido ON seguidores(id_seguido);
```

**Propósito:**
- Buscar quiénes sigo: `WHERE id_seguidor = X`
- Buscar quiénes me siguen: `WHERE id_seguido = Y`

---

## Consultas SQL Requeridas

Todas las consultas están implementadas en `SQL/consultas_enunciado.sql`.

### Consulta 1: Calificación Promedio y Conteo por Tipo
```sql
SELECT
    tipo,
    AVG(calificacion_promedio) AS calificacion_promedio_general,
    SUM(total_resenas) AS total_resenas_general
FROM
    sitios_turisticos
GROUP BY
    tipo;
```

**Resultado esperado:**
```
tipo        | calificacion_promedio_general | total_resenas_general
------------|------------------------------|----------------------
Parque      | 4.32                         | 15
Museo       | 4.65                         | 22
Restaurante | 4.18                         | 18
```

---

### Consulta 2: Top 5 Reseñadores Activos (6 meses)
```sql
WITH ReseñasRecientes AS (
    SELECT
        id_usuario,
        COUNT(*) AS conteo_reseñas
    FROM
        reseñas
    WHERE
        fecha >= (CURRENT_TIMESTAMP - INTERVAL '6 months')
    GROUP BY
        id_usuario
)
SELECT
    u.nombre,
    rr.conteo_reseñas
FROM
    ReseñasRecientes rr
JOIN
    usuarios u ON rr.id_usuario = u.id
ORDER BY
    rr.conteo_reseñas DESC
LIMIT 5;
```

**Usa:** CTE (Common Table Expression) para estructurar la consulta.

---

### Consulta 3: Restaurantes a <100m de Teatros
```sql
SELECT
    t.nombre AS nombre_teatro,
    r.nombre AS nombre_restaurante,
    ST_Distance(t.coordenadas, r.coordenadas) AS distancia_en_metros
FROM
    sitios_turisticos t
JOIN
    sitios_turisticos r ON ST_DWithin(t.coordenadas, r.coordenadas, 100)
WHERE
    t.tipo = 'Teatro'
    AND r.tipo = 'Restaurante'
    AND t.id != r.id;
```

**Funciones PostGIS:**
- `ST_DWithin()`: Filtro de proximidad (usa índice GIST)
- `ST_Distance()`: Calcula distancia exacta en metros

---

### Consulta 4: Sitios con Calificación >4.5 y <10 Reseñas
```sql
SELECT
    nombre,
    calificacion_promedio,
    total_resenas
FROM
    sitios_turisticos
WHERE
    calificacion_promedio > 4.5
    AND total_resenas < 10;
```

**Propósito:** Detectar "joyas ocultas" con alta calificación pero pocas reseñas.

---

### Consulta 5: Reseñas por Región
```sql
SELECT
    ciudad,
    SUM(total_resenas) AS total_resenas_por_ciudad
FROM
    sitios_turisticos
WHERE
    ciudad IS NOT NULL
GROUP BY
    ciudad
ORDER BY
    total_resenas_por_ciudad DESC;
```

**Nota:** Requiere columna `ciudad` agregada al esquema.

---

### Consulta 6: Trigger de Actualización
Implementado como trigger (ver sección Triggers arriba).

```sql
-- Verificar existencia del trigger
SELECT tgname
FROM pg_trigger
WHERE tgname = 'trigger_actualizar_calificacion';
```

---

### Consulta 7: Sitios sin Contribuciones (3 meses)
```sql
WITH UltimasContribuciones AS (
    SELECT
        id_sitio,
        MAX(fecha) AS ultima_fecha
    FROM (
        SELECT id_sitio, fecha FROM reseñas
        UNION ALL
        SELECT id_sitio, fecha FROM fotografias
    ) AS contribuciones
    GROUP BY id_sitio
)
SELECT
    s.nombre,
    s.tipo,
    uc.ultima_fecha AS fecha_ultima_contribucion
FROM
    sitios_turisticos s
LEFT JOIN
    UltimasContribuciones uc ON s.id = uc.id_sitio
WHERE
    uc.ultima_fecha IS NULL
    OR uc.ultima_fecha < (CURRENT_TIMESTAMP - INTERVAL '3 months');
```

**Técnica:** `UNION ALL` para combinar fechas de múltiples tablas.

---

### Consulta 8: 3 Reseñas Más Largas de Usuarios con Promedio >4.0
```sql
WITH PromedioUsuario AS (
    SELECT
        id_usuario,
        AVG(calificacion) AS promedio_calificacion
    FROM
        reseñas
    GROUP BY
        id_usuario
    HAVING
        AVG(calificacion) > 4.0
)
SELECT
    u.nombre AS nombre_usuario,
    s.nombre AS nombre_sitio,
    r.contenido,
    LENGTH(r.contenido) AS longitud_reseña
FROM
    reseñas r
JOIN usuarios u ON r.id_usuario = u.id
JOIN sitios_turisticos s ON r.id_sitio = s.id
JOIN PromedioUsuario pu ON r.id_usuario = pu.id_usuario
ORDER BY
    longitud_reseña DESC
LIMIT 3;
```

---

### Consulta 9: Vista Materializada Resumen
```sql
SELECT * FROM resumen_contribuciones_usuario;

-- Refrescar datos
REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;
```

---

## Decisiones de Diseño

### 1. PostGIS para Datos Geoespaciales
**Decisión:** Usar tipo `GEOGRAPHY(POINT, 4326)` en lugar de `DECIMAL` para coordenadas.

**Justificación:**
- Cálculos de distancia precisos en metros
- Índices espaciales (GIST) para búsquedas eficientes
- Funciones especializadas (`ST_DWithin`, `ST_Distance`)

**Alternativa rechazada:** Almacenar latitud/longitud como DECIMAL y calcular distancias con fórmula de Haversine (menos eficiente, sin índices espaciales).

---

### 2. ON DELETE CASCADE vs SET NULL
**Decisión:**
- Sitios → Reseñas/Fotos: `ON DELETE CASCADE`
- Usuarios → Reseñas/Fotos: `ON DELETE SET NULL`

**Justificación:**
- Si un sitio se elimina, sus reseñas/fotos pierden sentido → CASCADE
- Si un usuario se elimina, preservar historial de reseñas → SET NULL

---

### 3. Trigger vs Cálculo On-Demand
**Decisión:** Usar trigger para mantener `calificacion_promedio` actualizado.

**Justificación:**
- Perfiles de uso: 90% lecturas, 10% escrituras
- Cálculo `AVG()` en cada consulta es costoso
- Trade-off: Pequeño overhead en escritura para gran mejora en lectura

---

### 4. Vista Materializada para Estadísticas
**Decisión:** Pre-calcular contribuciones por usuario en vista materializada.

**Justificación:**
- Perfiles de usuario se consultan frecuentemente
- Evita 3 subconsultas `COUNT()` en cada perfil
- `REFRESH CONCURRENTLY` permite actualizaciones sin bloqueos

---

## Scripts de Mantenimiento

### Recrear Base de Datos Completa
```bash
# Desde directorio raíz del proyecto
psql -U postgres -d lab1tbd -f SQL/tablitas.sql
psql -U postgres -d lab1tbd -f SQL/crear_tabla_seguidores.sql
psql -U postgres -d lab1tbd -f SQL/CARGAR_DATOS_WINDOWS.sql
```

### Refrescar Vista Materializada
```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;
```

### Verificar Estado de Índices
```sql
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename, indexname;
```

### Verificar Triggers Activos
```sql
SELECT
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM
    information_schema.triggers
WHERE
    trigger_schema = 'public';
```

---

## Resumen Técnico

**Tablas:** 7 (usuarios, sitios_turisticos, reseñas, fotografias, listas_personalizadas, lista_sitios, seguidores)
**Triggers:** 1 (actualización automática de calificaciones)
**Procedimientos:** 1 (búsqueda geoespacial)
**Vistas Materializadas:** 1 (resumen contribuciones)
**Índices:** 9 (B-Tree: 8, GIST: 1)
**Extensiones:** PostGIS
**Normalización:** 3FN
**Integridad:** Foreign keys con ON DELETE CASCADE/SET NULL

---

**Fecha de última actualización:** 2025-01-28
**Versión:** 1.0
