-- =============================================
-- Datos de Prueba (Laboratorio 1)
-- =============================================

-- 1. Usuarios
-- La contraseña para todos es 'password123'
-- Hash BCrypt VÁLIDO Y VERIFICADO (generado con BCrypt strength 10): $2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2
INSERT INTO usuarios (nombre, email, contrasena_hash, biografia) VALUES
('Ana García', 'ana@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Viajera y fotógrafa. Amante de los museos.'),
('Bruno Díaz', 'bruno@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Entusiasta de la gastronomía. Siempre buscando el mejor restaurante.'),
('Carla Soto', 'carla@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Exploradora urbana. Me encantan los parques y las vistas.');

-- 2. Sitios Turísticos (con coordenadas de Santiago)
-- NOTA: Para la Consulta #5, añadimos la columna 'ciudad'
ALTER TABLE sitios_turisticos ADD COLUMN IF NOT EXISTS ciudad VARCHAR(100);

INSERT INTO sitios_turisticos (nombre, descripcion, tipo, coordenadas, ciudad) VALUES
('Cerro San Cristóbal', 'El gran parque urbano de Santiago, con vistas panorámicas.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6300, -33.4168), 4326), 'Santiago'),
('Museo Nacional de Bellas Artes', 'Principal museo de arte de Chile.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6418, -33.4350), 4326), 'Santiago'),
('Bocanáriz', 'Bar de vinos con excelente gastronomía.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6353, -33.4385), 4326), 'Santiago'),
('Teatro Municipal de Santiago', 'El centro cultural más antiguo del país.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6477, -33.4398), 4326), 'Santiago'),
('La Moneda', 'Palacio de gobierno, un hito histórico.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6538, -33.4426), 4326), 'Santiago');

-- 3. Reseñas (El trigger actualizará los promedios automáticamente)
-- Ana (ID 1)
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion) VALUES
(1, 1, '¡La vista es increíble! Vale la pena subir.', 5),
(1, 2, 'Colección impresionante. Un imperdible.', 5),
(1, 5, 'Mucha historia. El centro cultural es muy bueno.', 4);

-- Bruno (ID 2)
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion) VALUES
(2, 3, 'La mejor selección de vinos que he visto. La comida es perfecta.', 5),
(2, 1, 'Muy cansador subir, pero bonito.', 3),
(2, 4, 'La acústica es maravillosa. Fui a ver una ópera.', 5);

-- Carla (ID 3)
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion) VALUES
(3, 1, 'Perfecto para un picnic el fin de semana. El teleférico es genial.', 5),
(3, 2, 'El edificio es hermoso. Me gustó la exposición temporal.', 4),
(3, 3, 'Es caro, pero la experiencia lo vale. El sommelier sabía mucho.', 4);

-- 4. Fotografías
INSERT INTO fotografias (id_usuario, id_sitio, url) VALUES
(1, 1, 'https://example.com/foto_san_cristobal.jpg'),
(3, 1, 'https://example.com/vista_santiago.jpg'),
(1, 2, 'https://example.com/fachada_bellas_artes.jpg'),
(2, 3, 'https://example.com/copa_vino_bocanariz.jpg');

-- 5. Listas Personalizadas y sus sitios
-- Ana (ID 1) crea una lista
INSERT INTO listas_personalizadas (id_usuario, nombre) VALUES
(1, 'Imperdibles de Santiago');

-- (Asumimos que la lista 'Imperdibles de Santiago' tiene ID 1)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(1, 1), -- Añade Cerro San Cristóbal
(1, 2), -- Añade Bellas Artes
(1, 5); -- Añade La Moneda

-- Bruno (ID 2) crea una lista
INSERT INTO listas_personalizadas (id_usuario, nombre) VALUES
(2, 'Tour Gastronómico');

-- (Asumimos que la lista 'Tour Gastronómico' tiene ID 2)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(2, 3); -- Añade Bocanáriz

-- Refrescamos la vista materializada para que incluya los conteos
REFRESH MATERIALIZED VIEW resumen_contribuciones_usuario;