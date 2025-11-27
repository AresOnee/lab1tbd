-- =============================================
-- DATOS DE PRUEBA COMPLETOS PARA FRONTEND
-- =============================================
-- Este script agrega datos de prueba exhaustivos para probar
-- todas las funcionalidades del frontend.
--
-- Incluye:
-- - 10 usuarios con diferentes perfiles
-- - 20+ sitios turísticos variados (teatros, restaurantes, museos, parques, etc.)
-- - 50+ reseñas con diferentes calificaciones
-- - 30+ fotografías
-- - Relaciones de seguidores (red social)
-- - Múltiples listas personalizadas
-- - Datos con poca actividad reciente (para consulta #7)
-- =============================================

-- =============================================
-- LIMPIAR DATOS EXISTENTES (OPCIONAL)
-- =============================================
-- Descomentar estas líneas si quieres empezar desde cero
-- TRUNCATE TABLE lista_sitios CASCADE;
-- TRUNCATE TABLE listas_personalizadas CASCADE;
-- TRUNCATE TABLE fotografias CASCADE;
-- TRUNCATE TABLE reseñas CASCADE;
-- TRUNCATE TABLE seguidores CASCADE;
-- TRUNCATE TABLE sitios_turisticos CASCADE;
-- TRUNCATE TABLE usuarios CASCADE;

-- =============================================
-- 1. USUARIOS (10 usuarios)
-- =============================================
-- Contraseña para todos: 'password123'
-- Hash BCrypt: $2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2

INSERT INTO usuarios (nombre, email, contrasena_hash, biografia, fecha_registro) VALUES
('Ana García', 'ana@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Viajera y fotógrafa. Amante de los museos y el arte.', '2024-01-15 10:30:00'),
('Bruno Díaz', 'bruno@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Entusiasta de la gastronomía. Siempre buscando el mejor restaurante.', '2024-02-20 14:15:00'),
('Carla Soto', 'carla@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Exploradora urbana. Me encantan los parques y las vistas.', '2024-03-10 09:45:00'),
('Diego Morales', 'diego@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Crítico de teatro aficionado. Pasión por las artes escénicas.', '2024-04-05 16:20:00'),
('Elena Fernández', 'elena@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Historiadora y guía turística. Amo contar historias de Santiago.', '2024-05-12 11:00:00'),
('Felipe Torres', 'felipe@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Sommelier profesional. Experto en vinos chilenos.', '2024-06-18 13:30:00'),
('Gabriela Rojas', 'gabriela@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Arquitecta. Fascinada por los edificios históricos de la ciudad.', '2024-07-22 10:15:00'),
('Héctor Vargas', 'hector@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Ciclista urbano. Descubriendo Santiago sobre dos ruedas.', '2024-08-30 15:45:00'),
('Isabel Núñez', 'isabel@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Bloguera de viajes. Compartiendo experiencias locales.', '2024-09-14 12:00:00'),
('Javier Pinto', 'javier@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Estudiante de fotografía. Capturando la esencia de la ciudad.', '2024-10-01 08:30:00')
ON CONFLICT (email) DO NOTHING;

-- =============================================
-- 2. SITIOS TURÍSTICOS (20+ sitios variados)
-- =============================================
-- Agregamos coordenadas reales de Santiago
-- Formato: ST_SetSRID(ST_MakePoint(LONGITUD, LATITUD), 4326)

-- Aseguramos que existe la columna ciudad
ALTER TABLE sitios_turisticos ADD COLUMN IF NOT EXISTS ciudad VARCHAR(100);

INSERT INTO sitios_turisticos (nombre, descripcion, tipo, coordenadas, ciudad) VALUES
-- Parques
('Cerro San Cristóbal', 'El gran parque urbano de Santiago, con vistas panorámicas y el Santuario de la Virgen.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6300, -33.4168), 4326), 'Santiago'),
('Parque Forestal', 'Hermoso parque lineal a lo largo del río Mapocho, ideal para caminar.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6450, -33.4360), 4326), 'Santiago'),
('Parque Bicentenario', 'Moderno parque con lagunas artificiales y esculturas.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6100, -33.4050), 4326), 'Santiago'),
('Parque Quinta Normal', 'Amplio parque con museos, lagunas y áreas verdes.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6820, -33.4440), 4326), 'Santiago'),

-- Museos
('Museo Nacional de Bellas Artes', 'Principal museo de arte de Chile con colección permanente y exposiciones temporales.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6418, -33.4350), 4326), 'Santiago'),
('Museo de la Memoria y los DDHH', 'Museo dedicado a la memoria histórica y los derechos humanos.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6820, -33.4450), 4326), 'Santiago'),
('Museo Chileno de Arte Precolombino', 'Fascinante colección de arte de las culturas precolombinas.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6500, -33.4380), 4326), 'Santiago'),
('Centro Cultural La Moneda', 'Centro cultural subterráneo con exposiciones de arte contemporáneo.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6530, -33.4430), 4326), 'Santiago'),

-- Restaurantes
('Bocanáriz', 'Bar de vinos boutique con excelente gastronomía y carta de vinos chilenos.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6353, -33.4385), 4326), 'Santiago'),
('Liguria', 'Tradicional restaurante con ambiente bohemio y comida chilena casera.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6380, -33.4340), 4326), 'Santiago'),
('Peumayen', 'Restaurante de comida ancestral chilena, ingredientes nativos.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6360, -33.4320), 4326), 'Santiago'),
('Astrid y Gastón', 'Alta cocina peruana, uno de los mejores restaurantes de Santiago.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6150, -33.4100), 4326), 'Santiago'),

-- Teatros
('Teatro Municipal de Santiago', 'El centro cultural más antiguo del país, opera y ballet de clase mundial.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6477, -33.4398), 4326), 'Santiago'),
('Teatro Universidad de Chile', 'Teatro histórico con programación variada de música y danza.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6495, -33.4405), 4326), 'Santiago'),
('Centro Gabriela Mistral GAM', 'Moderno centro cultural con teatro, danza y artes visuales.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6465, -33.4375), 4326), 'Santiago'),

-- Monumentos
('La Moneda', 'Palacio de gobierno, un hito histórico y arquitectónico.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6538, -33.4426), 4326), 'Santiago'),
('Plaza de Armas', 'Plaza principal de Santiago, centro histórico de la ciudad.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6510, -33.4372), 4326), 'Santiago'),
('Catedral Metropolitana', 'Imponente catedral neoclásica en la Plaza de Armas.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6505, -33.4370), 4326), 'Santiago'),

-- Cafés
('Café Colmado', 'Café artesanal con excelentes pasteles y ambiente acogedor.', 'Café', ST_SetSRID(ST_MakePoint(-70.6400, -33.4350), 4326), 'Santiago'),
('Wonderland Café', 'Café temático con decoración única y buenos tragos.', 'Café', ST_SetSRID(ST_MakePoint(-70.6420, -33.4345), 4326), 'Santiago'),

-- Bares
('The Clinic', 'Bar con terraza y buena selección de cervezas artesanales.', 'Bar', ST_SetSRID(ST_MakePoint(-70.6365, -33.4330), 4326), 'Santiago'),
('La Piojera', 'Bar tradicional, famoso por la terremoto, bebida típica chilena.', 'Bar', ST_SetSRID(ST_MakePoint(-70.6600, -33.4500), 4326), 'Santiago')
ON CONFLICT DO NOTHING;

-- =============================================
-- 3. RESEÑAS (50+ reseñas variadas)
-- =============================================
-- Distribuidas entre todos los usuarios y sitios
-- Incluye fechas antiguas para la consulta #7

-- Ana García (ID 1) - Muy activa, reseñas recientes
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(1, 1, '¡La vista desde el Cerro San Cristóbal es increíble! Vale totalmente la pena subir.', 5, NOW() - INTERVAL '5 days'),
(1, 5, 'El Museo de Bellas Artes tiene una colección impresionante. Un imperdible para los amantes del arte.', 5, NOW() - INTERVAL '10 days'),
(1, 16, 'La Moneda es espectacular. El cambio de guardia es muy interesante de ver.', 4, NOW() - INTERVAL '15 days'),
(1, 9, 'Bocanáriz tiene la mejor selección de vinos. El sommelier es muy conocedor.', 5, NOW() - INTERVAL '7 days'),
(1, 13, 'Asistí a una ópera en el Teatro Municipal. La acústica es perfecta.', 5, NOW() - INTERVAL '20 days');

-- Bruno Díaz (ID 2) - Enfocado en gastronomía
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(2, 9, 'La mejor selección de vinos que he visto en Santiago. La comida es perfecta.', 5, NOW() - INTERVAL '3 days'),
(2, 10, 'Liguria tiene ese ambiente bohemio que me encanta. La comida casera es deliciosa.', 4, NOW() - INTERVAL '8 days'),
(2, 11, 'Peumayen ofrece una experiencia única con ingredientes ancestrales chilenos.', 5, NOW() - INTERVAL '12 days'),
(2, 12, 'Astrid y Gastón no decepciona. Alta cocina peruana en su mejor expresión.', 5, NOW() - INTERVAL '6 days'),
(2, 19, 'Café Colmado tiene los mejores pasteles de la zona. Muy recomendado.', 4, NOW() - INTERVAL '2 days');

-- Carla Soto (ID 3) - Ama parques y espacios al aire libre
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(3, 1, 'Perfecto para un picnic el fin de semana. El teleférico es genial.', 5, NOW() - INTERVAL '4 days'),
(3, 2, 'El Parque Forestal es ideal para caminar y hacer ejercicio. Muy tranquilo.', 4, NOW() - INTERVAL '9 days'),
(3, 3, 'Parque Bicentenario es moderno y bien mantenido. Perfecto para niños.', 4, NOW() - INTERVAL '14 days'),
(3, 4, 'Quinta Normal tiene mucho espacio verde. Me encanta ir los domingos.', 4, NOW() - INTERVAL '11 days'),
(3, 17, 'La Plaza de Armas siempre está llena de vida. Centro histórico de Santiago.', 3, NOW() - INTERVAL '18 days');

-- Diego Morales (ID 4) - Crítico de teatro
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(4, 13, 'El Teatro Municipal es joya arquitectónica. La programación es de primer nivel.', 5, NOW() - INTERVAL '7 days'),
(4, 14, 'Teatro Universidad de Chile tiene una rica historia. Excelente acústica.', 5, NOW() - INTERVAL '13 days'),
(4, 15, 'GAM es un espacio moderno y versátil. La programación es siempre interesante.', 4, NOW() - INTERVAL '19 days'),
(4, 5, 'El edificio del Museo de Bellas Artes es hermoso por dentro y por fuera.', 4, NOW() - INTERVAL '25 days');

-- Elena Fernández (ID 5) - Historiadora
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(5, 16, 'La Moneda tiene tanta historia. Recomiendo el tour guiado.', 5, NOW() - INTERVAL '5 days'),
(5, 17, 'Plaza de Armas es el corazón de Santiago. Aquí comenzó todo.', 5, NOW() - INTERVAL '10 days'),
(5, 18, 'La Catedral Metropolitana es impresionante. Arquitectura neoclásica pura.', 5, NOW() - INTERVAL '15 days'),
(5, 7, 'El Museo Precolombino tiene piezas únicas de culturas ancestrales.', 5, NOW() - INTERVAL '8 days'),
(5, 6, 'Museo de la Memoria es conmovedor y necesario. Visita obligada.', 5, NOW() - INTERVAL '20 days');

-- Felipe Torres (ID 6) - Sommelier
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(6, 9, 'Bocanáriz es mi lugar favorito. La carta de vinos es excelente.', 5, NOW() - INTERVAL '2 days'),
(6, 11, 'Peumayen tiene un maridaje perfecto entre vino y comida ancestral.', 5, NOW() - INTERVAL '6 days'),
(6, 12, 'La bodega de Astrid y Gastón es impresionante. Grandes vinos.', 4, NOW() - INTERVAL '12 days'),
(6, 21, 'La Piojera es una experiencia auténtica. Probé el famoso terremoto.', 3, NOW() - INTERVAL '16 days');

-- Gabriela Rojas (ID 7) - Arquitecta
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(7, 13, 'La arquitectura del Teatro Municipal es sublime. Cada detalle cuenta.', 5, NOW() - INTERVAL '4 days'),
(7, 5, 'El Palacio de Bellas Artes es una joya arquitectónica del siglo XX.', 5, NOW() - INTERVAL '9 days'),
(7, 18, 'La fachada neoclásica de la Catedral es impresionante.', 4, NOW() - INTERVAL '14 days'),
(7, 8, 'El Centro Cultural La Moneda tiene un diseño subterráneo fascinante.', 4, NOW() - INTERVAL '11 days'),
(7, 15, 'GAM representa la arquitectura contemporánea chilena. Muy innovador.', 5, NOW() - INTERVAL '18 days');

-- Héctor Vargas (ID 8) - Ciclista urbano
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(8, 1, 'Subir el San Cristóbal en bici es un desafío. Las vistas valen el esfuerzo.', 4, NOW() - INTERVAL '3 days'),
(8, 2, 'Parque Forestal tiene buenas ciclovías. Ideal para pedalear.', 5, NOW() - INTERVAL '7 days'),
(8, 3, 'Bicentenario es perfecto para andar en bici con la familia.', 4, NOW() - INTERVAL '13 days'),
(8, 4, 'Quinta Normal tiene rutas ciclísticas amplias y seguras.', 4, NOW() - INTERVAL '17 days');

-- Isabel Núñez (ID 9) - Bloguera de viajes
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(9, 1, 'El Cerro San Cristóbal es el mejor mirador de Santiago. Fotos espectaculares.', 5, NOW() - INTERVAL '1 day'),
(9, 9, 'Bocanáriz es perfecto para una cita romántica. Ambiente íntimo.', 5, NOW() - INTERVAL '5 days'),
(9, 13, 'Asistir al Teatro Municipal es una experiencia de lujo. Totalmente recomendado.', 5, NOW() - INTERVAL '10 days'),
(9, 19, 'Café Colmado es instagrameable y delicioso. Doble ganancia.', 4, NOW() - INTERVAL '3 days'),
(9, 20, 'Wonderland Café tiene una decoración de cuento. Me encantó.', 4, NOW() - INTERVAL '8 days');

-- Javier Pinto (ID 10) - Estudiante de fotografía
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(10, 1, 'Las mejores fotos de Santiago se toman desde aquí. Luz perfecta al atardecer.', 5, NOW() - INTERVAL '2 days'),
(10, 2, 'Parque Forestal es fotogénico en cada estación. Árboles hermosos.', 5, NOW() - INTERVAL '6 days'),
(10, 5, 'El interior del Museo de Bellas Artes es un sueño para fotógrafos.', 5, NOW() - INTERVAL '11 days'),
(10, 17, 'Plaza de Armas tiene mucha vida urbana. Buenas fotos callejeras.', 4, NOW() - INTERVAL '15 days'),
(10, 18, 'La Catedral tiene detalles arquitectónicos increíbles para fotografiar.', 5, NOW() - INTERVAL '9 days');

-- Reseñas ANTIGUAS (más de 3 meses) para probar consulta #7
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(1, 21, 'Experiencia auténtica en La Piojera. Muy tradicional.', 3, NOW() - INTERVAL '120 days'),
(2, 2, 'Buen lugar para caminar.', 4, NOW() - INTERVAL '100 days'),
(3, 7, 'Colección interesante.', 4, NOW() - INTERVAL '110 days');

-- =============================================
-- 4. FOTOGRAFÍAS (30+ fotografías)
-- =============================================

INSERT INTO fotografias (id_usuario, id_sitio, url, fecha) VALUES
-- Ana García - fotógrafa activa
(1, 1, 'https://picsum.photos/800/600?random=1', NOW() - INTERVAL '5 days'),
(1, 1, 'https://picsum.photos/800/600?random=2', NOW() - INTERVAL '5 days'),
(1, 5, 'https://picsum.photos/800/600?random=3', NOW() - INTERVAL '10 days'),
(1, 13, 'https://picsum.photos/800/600?random=4', NOW() - INTERVAL '20 days'),
(1, 9, 'https://picsum.photos/800/600?random=5', NOW() - INTERVAL '7 days'),

-- Bruno Díaz - fotos de comida
(2, 9, 'https://picsum.photos/800/600?random=6', NOW() - INTERVAL '3 days'),
(2, 10, 'https://picsum.photos/800/600?random=7', NOW() - INTERVAL '8 days'),
(2, 11, 'https://picsum.photos/800/600?random=8', NOW() - INTERVAL '12 days'),
(2, 12, 'https://picsum.photos/800/600?random=9', NOW() - INTERVAL '6 days'),

-- Carla Soto - fotos de parques
(3, 1, 'https://picsum.photos/800/600?random=10', NOW() - INTERVAL '4 days'),
(3, 2, 'https://picsum.photos/800/600?random=11', NOW() - INTERVAL '9 days'),
(3, 3, 'https://picsum.photos/800/600?random=12', NOW() - INTERVAL '14 days'),
(3, 4, 'https://picsum.photos/800/600?random=13', NOW() - INTERVAL '11 days'),

-- Diego Morales - fotos de teatros
(4, 13, 'https://picsum.photos/800/600?random=14', NOW() - INTERVAL '7 days'),
(4, 14, 'https://picsum.photos/800/600?random=15', NOW() - INTERVAL '13 days'),
(4, 15, 'https://picsum.photos/800/600?random=16', NOW() - INTERVAL '19 days'),

-- Elena Fernández - fotos históricas
(5, 16, 'https://picsum.photos/800/600?random=17', NOW() - INTERVAL '5 days'),
(5, 17, 'https://picsum.photos/800/600?random=18', NOW() - INTERVAL '10 days'),
(5, 18, 'https://picsum.photos/800/600?random=19', NOW() - INTERVAL '15 days'),

-- Javier Pinto - estudiante de fotografía, muy activo
(10, 1, 'https://picsum.photos/800/600?random=20', NOW() - INTERVAL '2 days'),
(10, 1, 'https://picsum.photos/800/600?random=21', NOW() - INTERVAL '2 days'),
(10, 2, 'https://picsum.photos/800/600?random=22', NOW() - INTERVAL '6 days'),
(10, 5, 'https://picsum.photos/800/600?random=23', NOW() - INTERVAL '11 days'),
(10, 17, 'https://picsum.photos/800/600?random=24', NOW() - INTERVAL '15 days'),
(10, 18, 'https://picsum.photos/800/600?random=25', NOW() - INTERVAL '9 days'),

-- Isabel Núñez - bloguera
(9, 1, 'https://picsum.photos/800/600?random=26', NOW() - INTERVAL '1 day'),
(9, 9, 'https://picsum.photos/800/600?random=27', NOW() - INTERVAL '5 days'),
(9, 13, 'https://picsum.photos/800/600?random=28', NOW() - INTERVAL '10 days'),
(9, 19, 'https://picsum.photos/800/600?random=29', NOW() - INTERVAL '3 days'),
(9, 20, 'https://picsum.photos/800/600?random=30', NOW() - INTERVAL '8 days');

-- =============================================
-- 5. RELACIONES DE SEGUIDORES
-- =============================================
-- Crear la tabla si no existe
CREATE TABLE IF NOT EXISTS seguidores (
    id SERIAL PRIMARY KEY,
    id_seguidor INT NOT NULL,
    id_seguido INT NOT NULL,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_seguidor) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES usuarios(id) ON DELETE CASCADE,
    CHECK (id_seguidor != id_seguido),
    UNIQUE (id_seguidor, id_seguido)
);

-- Ana (1) sigue a muchos usuarios (muy social)
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(1, 2, '2024-02-25 10:00:00'),
(1, 3, '2024-03-15 11:30:00'),
(1, 5, '2024-05-20 14:00:00'),
(1, 9, '2024-09-20 09:00:00'),
(1, 10, '2024-10-05 16:00:00')
ON CONFLICT DO NOTHING;

-- Bruno (2) sigue a gastrónomos
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(2, 6, '2024-06-25 10:00:00'),  -- Sigue al sommelier
(2, 1, '2024-03-01 12:00:00'),
(2, 9, '2024-09-25 15:00:00')
ON CONFLICT DO NOTHING;

-- Carla (3) sigue a exploradores
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(3, 1, '2024-04-10 10:00:00'),
(3, 8, '2024-09-05 11:00:00'),  -- Sigue al ciclista
(3, 9, '2024-10-01 14:00:00')
ON CONFLICT DO NOTHING;

-- Diego (4) sigue a culturales
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(4, 1, '2024-05-01 10:00:00'),
(4, 5, '2024-06-15 12:00:00'),  -- Sigue a la historiadora
(4, 7, '2024-08-01 13:00:00')   -- Sigue a la arquitecta
ON CONFLICT DO NOTHING;

-- Elena (5) es muy seguida (historiadora popular)
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(6, 5, '2024-07-01 10:00:00'),
(7, 5, '2024-08-15 11:00:00'),
(9, 5, '2024-10-10 12:00:00'),
(10, 5, '2024-10-20 13:00:00')
ON CONFLICT DO NOTHING;

-- Felipe (6) sigue a gastrónomos
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(6, 2, '2024-07-05 10:00:00'),
(6, 1, '2024-07-10 11:00:00')
ON CONFLICT DO NOTHING;

-- Más relaciones de seguimiento
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(7, 1, '2024-08-20 10:00:00'),
(8, 3, '2024-09-10 11:00:00'),
(9, 1, '2024-09-25 12:00:00'),
(9, 10, '2024-10-15 13:00:00'),
(10, 1, '2024-10-10 14:00:00'),
(10, 9, '2024-10-20 15:00:00')
ON CONFLICT DO NOTHING;

-- =============================================
-- 6. LISTAS PERSONALIZADAS
-- =============================================

INSERT INTO listas_personalizadas (id_usuario, nombre, fecha_creacion) VALUES
(1, 'Imperdibles de Santiago', '2024-02-01 10:00:00'),
(1, 'Mis Museos Favoritos', '2024-03-15 11:00:00'),
(2, 'Tour Gastronómico', '2024-04-01 12:00:00'),
(2, 'Mejores Vinos de Santiago', '2024-05-10 13:00:00'),
(3, 'Parques para Visitar', '2024-05-20 14:00:00'),
(4, 'Teatros de Santiago', '2024-06-01 15:00:00'),
(5, 'Ruta Histórica', '2024-06-15 16:00:00'),
(9, 'Para el Blog', '2024-09-20 17:00:00'),
(10, 'Fotogénico Santiago', '2024-10-05 18:00:00');

-- =============================================
-- 7. SITIOS EN LISTAS (Relación N:M)
-- =============================================

-- Lista 1: "Imperdibles de Santiago" (Ana)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(1, 1),   -- Cerro San Cristóbal
(1, 5),   -- Museo Bellas Artes
(1, 16),  -- La Moneda
(1, 17),  -- Plaza de Armas
(1, 13)   -- Teatro Municipal
ON CONFLICT DO NOTHING;

-- Lista 2: "Mis Museos Favoritos" (Ana)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(2, 5),   -- Bellas Artes
(2, 6),   -- Museo de la Memoria
(2, 7),   -- Museo Precolombino
(2, 8)    -- Centro Cultural La Moneda
ON CONFLICT DO NOTHING;

-- Lista 3: "Tour Gastronómico" (Bruno)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(3, 9),   -- Bocanáriz
(3, 10),  -- Liguria
(3, 11),  -- Peumayen
(3, 12)   -- Astrid y Gastón
ON CONFLICT DO NOTHING;

-- Lista 4: "Mejores Vinos de Santiago" (Bruno)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(4, 9),   -- Bocanáriz
(4, 11)   -- Peumayen
ON CONFLICT DO NOTHING;

-- Lista 5: "Parques para Visitar" (Carla)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(5, 1),   -- San Cristóbal
(5, 2),   -- Parque Forestal
(5, 3),   -- Bicentenario
(5, 4)    -- Quinta Normal
ON CONFLICT DO NOTHING;

-- Lista 6: "Teatros de Santiago" (Diego)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(6, 13),  -- Teatro Municipal
(6, 14),  -- Teatro Universidad de Chile
(6, 15)   -- GAM
ON CONFLICT DO NOTHING;

-- Lista 7: "Ruta Histórica" (Elena)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(7, 16),  -- La Moneda
(7, 17),  -- Plaza de Armas
(7, 18),  -- Catedral
(7, 7)    -- Museo Precolombino
ON CONFLICT DO NOTHING;

-- Lista 8: "Para el Blog" (Isabel)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(8, 1),   -- San Cristóbal
(8, 9),   -- Bocanáriz
(8, 13),  -- Teatro Municipal
(8, 19),  -- Café Colmado
(8, 20)   -- Wonderland Café
ON CONFLICT DO NOTHING;

-- Lista 9: "Fotogénico Santiago" (Javier)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(9, 1),   -- San Cristóbal
(9, 2),   -- Parque Forestal
(9, 5),   -- Bellas Artes
(9, 17),  -- Plaza de Armas
(9, 18)   -- Catedral
ON CONFLICT DO NOTHING;

-- =============================================
-- 8. ACTUALIZAR VISTA MATERIALIZADA
-- =============================================

REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;

-- =============================================
-- 9. VERIFICACIÓN DE DATOS
-- =============================================

-- Contar usuarios
SELECT COUNT(*) AS total_usuarios FROM usuarios;

-- Contar sitios turísticos
SELECT COUNT(*) AS total_sitios FROM sitios_turisticos;

-- Contar reseñas
SELECT COUNT(*) AS total_reseñas FROM reseñas;

-- Contar fotografías
SELECT COUNT(*) AS total_fotografias FROM fotografias;

-- Contar seguidores
SELECT COUNT(*) AS total_relaciones_seguimiento FROM seguidores;

-- Contar listas
SELECT COUNT(*) AS total_listas FROM listas_personalizadas;

-- Ver sitios con calificación promedio
SELECT
    nombre,
    tipo,
    calificacion_promedio,
    total_reseñas
FROM sitios_turisticos
WHERE total_reseñas > 0
ORDER BY calificacion_promedio DESC, total_reseñas DESC;

-- Ver usuarios más activos
SELECT * FROM resumen_contribuciones_usuario
ORDER BY (total_reseñas + total_fotos + total_listas) DESC;

-- Ver sitios con poca actividad reciente (consulta #7)
SELECT
    s.nombre,
    s.tipo,
    COUNT(DISTINCT r.id) AS reseñas_recientes,
    COUNT(DISTINCT f.id) AS fotos_recientes
FROM sitios_turisticos s
LEFT JOIN reseñas r ON s.id = r.id_sitio AND r.fecha > (NOW() - INTERVAL '90 days')
LEFT JOIN fotografias f ON s.id = f.id_sitio AND f.fecha > (NOW() - INTERVAL '90 days')
GROUP BY s.id, s.nombre, s.tipo
HAVING COUNT(DISTINCT r.id) = 0 AND COUNT(DISTINCT f.id) = 0
ORDER BY s.nombre;

-- =============================================
-- FIN DEL SCRIPT
-- =============================================
