-- =============================================
-- SCRIPT DE LIMPIEZA Y RECARGA TOTAL
-- =============================================
-- Este script LIMPIA COMPLETAMENTE y recarga
-- todos los datos de prueba con valores correctos
-- =============================================

-- =============================================
-- PASO 1: ELIMINAR TODOS LOS DATOS
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '🗑️  Eliminando todos los datos existentes...';
END $$;

-- Eliminar en orden correcto respetando claves foráneas
DELETE FROM lista_sitios;
DELETE FROM listas_personalizadas;
DELETE FROM fotografias;
DELETE FROM resenas;
DELETE FROM seguidores;
DELETE FROM sitios_turisticos;
DELETE FROM usuarios;

-- Resetear secuencias para que los IDs empiecen desde 1
ALTER SEQUENCE usuarios_id_seq RESTART WITH 1;
ALTER SEQUENCE sitios_turisticos_id_seq RESTART WITH 1;
ALTER SEQUENCE resenas_id_seq RESTART WITH 1;
ALTER SEQUENCE fotografias_id_seq RESTART WITH 1;
ALTER SEQUENCE listas_personalizadas_id_seq RESTART WITH 1;
ALTER SEQUENCE seguidores_id_seq RESTART WITH 1;

DO $$
BEGIN
    RAISE NOTICE '✅ Datos eliminados correctamente';
    RAISE NOTICE '';
END $$;

-- =============================================
-- PASO 2: INSERTAR USUARIOS
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '👥 Insertando usuarios...';
END $$;

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
('Javier Pinto', 'javier@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Estudiante de fotografía. Capturando la esencia de la ciudad.', '2024-10-01 08:30:00');

-- =============================================
-- PASO 3: INSERTAR SITIOS TURÍSTICOS
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '🏛️  Insertando sitios turísticos...';
END $$;

-- Asegurar que existe la columna ciudad
ALTER TABLE sitios_turisticos ADD COLUMN IF NOT EXISTS ciudad VARCHAR(100);

INSERT INTO sitios_turisticos (nombre, descripcion, tipo, coordenadas, ciudad) VALUES
-- Parques (4 sitios)
('Cerro San Cristóbal', 'El gran parque urbano de Santiago, con vistas panorámicas y el Santuario de la Virgen.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6300, -33.4168), 4326), 'Santiago'),
('Parque Forestal', 'Hermoso parque lineal a lo largo del río Mapocho, ideal para caminar.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6450, -33.4360), 4326), 'Santiago'),
('Parque Bicentenario', 'Moderno parque con lagunas artificiales y esculturas.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6100, -33.4050), 4326), 'Santiago'),
('Parque Quinta Normal', 'Amplio parque con museos, lagunas y áreas verdes.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6820, -33.4440), 4326), 'Santiago'),

-- Museos (4 sitios)
('Museo Nacional de Bellas Artes', 'Principal museo de arte de Chile con colección permanente y exposiciones temporales.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6418, -33.4350), 4326), 'Santiago'),
('Museo de la Memoria y los DDHH', 'Museo dedicado a la memoria histórica y los derechos humanos.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6820, -33.4450), 4326), 'Santiago'),
('Museo Chileno de Arte Precolombino', 'Fascinante colección de arte de las culturas precolombinas.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6500, -33.4380), 4326), 'Santiago'),
('Centro Cultural La Moneda', 'Centro cultural subterráneo con exposiciones de arte contemporáneo.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6530, -33.4430), 4326), 'Santiago'),

-- Teatros (3 sitios)
('Teatro Municipal de Santiago', 'El centro cultural más antiguo del país, opera y ballet de clase mundial.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6477, -33.4398), 4326), 'Santiago'),
('Teatro Universidad de Chile', 'Teatro histórico con programación variada de música y danza.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6495, -33.4405), 4326), 'Santiago'),
('Centro Gabriela Mistral GAM', 'Moderno centro cultural con teatro, danza y artes visuales.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6465, -33.4375), 4326), 'Santiago'),

-- Restaurantes CERCA de teatros (<100 metros)
('Ópera Catedral', 'Restaurante gourmet a pasos del Teatro Municipal.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6480, -33.4400), 4326), 'Santiago'),
('Confitería Torres', 'Tradicional confitería junto al Teatro Municipal.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6475, -33.4395), 4326), 'Santiago'),
('Café del Teatro', 'Café acogedor en el mismo edificio del Teatro Universidad.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6496, -33.4406), 4326), 'Santiago'),

-- Otros restaurantes
('Bocanáriz', 'Bar de vinos boutique con excelente gastronomía y carta de vinos chilenos.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6353, -33.4385), 4326), 'Santiago'),
('Liguria', 'Tradicional restaurante con ambiente bohemio y comida chilena casera.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6380, -33.4340), 4326), 'Santiago'),
('Peumayen', 'Restaurante de comida ancestral chilena, ingredientes nativos.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6360, -33.4320), 4326), 'Santiago'),
('Astrid y Gastón', 'Alta cocina peruana, uno de los mejores restaurantes de Santiago.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6150, -33.4100), 4326), 'Santiago'),

-- Monumentos (3 sitios)
('La Moneda', 'Palacio de gobierno, un hito histórico y arquitectónico.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6538, -33.4426), 4326), 'Santiago'),
('Plaza de Armas', 'Plaza principal de Santiago, centro histórico de la ciudad.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6510, -33.4372), 4326), 'Santiago'),
('Catedral Metropolitana', 'Imponente catedral neoclásica en la Plaza de Armas.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6505, -33.4370), 4326), 'Santiago'),

-- Cafés (2 sitios)
('Café Colmado', 'Café artesanal con excelentes pasteles y ambiente acogedor.', 'Café', ST_SetSRID(ST_MakePoint(-70.6400, -33.4350), 4326), 'Santiago'),
('Wonderland Café', 'Café temático con decoración única y buenos tragos.', 'Café', ST_SetSRID(ST_MakePoint(-70.6420, -33.4345), 4326), 'Santiago'),

-- Bares (2 sitios)
('The Clinic', 'Bar con terraza y buena selección de cervezas artesanales.', 'Bar', ST_SetSRID(ST_MakePoint(-70.6365, -33.4330), 4326), 'Santiago'),
('La Piojera', 'Bar tradicional, famoso por la terremoto, bebida típica chilena.', 'Bar', ST_SetSRID(ST_MakePoint(-70.6600, -33.4500), 4326), 'Santiago');

-- =============================================
-- PASO 4: INSERTAR RESEÑAS (con calificaciones ALTAS)
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '⭐ Insertando resenas...';
END $$;

-- Ana García (ID 1) - Muy activa, resenas recientes
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(1, 1, '¡La vista desde el Cerro San Cristóbal es increíble! Vale totalmente la pena subir.', 5, NOW() - INTERVAL '5 days'),
(1, 5, 'El Museo de Bellas Artes tiene una colección impresionante. Un imperdible para los amantes del arte.', 5, NOW() - INTERVAL '10 days'),
(1, 19, 'La Moneda es espectacular. El cambio de guardia es muy interesante de ver.', 4, NOW() - INTERVAL '15 days'),
(1, 15, 'Bocanáriz tiene la mejor selección de vinos. El sommelier es muy conocedor.', 5, NOW() - INTERVAL '7 days'),
(1, 9, 'Asistí a una ópera en el Teatro Municipal. La acústica es perfecta.', 5, NOW() - INTERVAL '20 days');

-- Bruno Díaz (ID 2) - Enfocado en gastronomía
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(2, 15, 'La mejor selección de vinos que he visto en Santiago. La comida es perfecta.', 5, NOW() - INTERVAL '3 days'),
(2, 16, 'Liguria tiene ese ambiente bohemio que me encanta. La comida casera es deliciosa.', 4, NOW() - INTERVAL '8 days'),
(2, 17, 'Peumayen ofrece una experiencia única con ingredientes ancestrales chilenos.', 5, NOW() - INTERVAL '12 days'),
(2, 18, 'Astrid y Gastón no decepciona. Alta cocina peruana en su mejor expresión.', 5, NOW() - INTERVAL '6 days'),
(2, 22, 'Café Colmado tiene los mejores pasteles de la zona. Muy recomendado.', 4, NOW() - INTERVAL '2 days');

-- Carla Soto (ID 3) - Ama parques y espacios al aire libre
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(3, 1, 'Perfecto para un picnic el fin de semana. El teleférico es genial.', 5, NOW() - INTERVAL '4 days'),
(3, 2, 'El Parque Forestal es ideal para caminar y hacer ejercicio. Muy tranquilo.', 5, NOW() - INTERVAL '9 days'),
(3, 3, 'Parque Bicentenario es moderno y bien mantenido. Perfecto para niños.', 4, NOW() - INTERVAL '14 days'),
(3, 4, 'Quinta Normal tiene mucho espacio verde. Me encanta ir los domingos.', 4, NOW() - INTERVAL '11 days'),
(3, 20, 'La Plaza de Armas siempre está llena de vida. Centro histórico de Santiago.', 4, NOW() - INTERVAL '18 days');

-- Diego Morales (ID 4) - Crítico de teatro
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(4, 9, 'El Teatro Municipal es joya arquitectónica. La programación es de primer nivel.', 5, NOW() - INTERVAL '7 days'),
(4, 10, 'Teatro Universidad de Chile tiene una rica historia. Excelente acústica.', 5, NOW() - INTERVAL '13 days'),
(4, 11, 'GAM es un espacio moderno y versátil. La programación es siempre interesante.', 5, NOW() - INTERVAL '19 days'),
(4, 12, 'Ópera Catedral es perfecto para comer antes de la función. Muy conveniente.', 4, NOW() - INTERVAL '8 days'),
(4, 13, 'Confitería Torres es un clásico santiaguino. Ambiente tradicional.', 4, NOW() - INTERVAL '15 days');

-- Elena Fernández (ID 5) - Historiadora
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(5, 19, 'La Moneda tiene tanta historia. Recomiendo el tour guiado.', 5, NOW() - INTERVAL '5 days'),
(5, 20, 'Plaza de Armas es el corazón de Santiago. Aquí comenzó todo.', 5, NOW() - INTERVAL '10 days'),
(5, 21, 'La Catedral Metropolitana es impresionante. Arquitectura neoclásica pura.', 5, NOW() - INTERVAL '15 days'),
(5, 7, 'El Museo Precolombino tiene piezas únicas de culturas ancestrales.', 5, NOW() - INTERVAL '8 days'),
(5, 6, 'Museo de la Memoria es conmovedor y necesario. Visita obligada.', 5, NOW() - INTERVAL '20 days');

-- Felipe Torres (ID 6) - Sommelier
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(6, 15, 'Bocanáriz es mi lugar favorito. La carta de vinos es excelente.', 5, NOW() - INTERVAL '2 days'),
(6, 17, 'Peumayen tiene un maridaje perfecto entre vino y comida ancestral.', 5, NOW() - INTERVAL '6 days'),
(6, 18, 'La bodega de Astrid y Gastón es impresionante. Grandes vinos.', 5, NOW() - INTERVAL '12 days'),
(6, 12, 'Ópera Catedral tiene una carta de vinos sorprendente.', 4, NOW() - INTERVAL '16 days');

-- Gabriela Rojas (ID 7) - Arquitecta
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(7, 9, 'La arquitectura del Teatro Municipal es sublime. Cada detalle cuenta.', 5, NOW() - INTERVAL '4 days'),
(7, 5, 'El Palacio de Bellas Artes es una joya arquitectónica del siglo XX.', 5, NOW() - INTERVAL '9 days'),
(7, 21, 'La fachada neoclásica de la Catedral es impresionante.', 5, NOW() - INTERVAL '14 days'),
(7, 8, 'El Centro Cultural La Moneda tiene un diseño subterráneo fascinante.', 5, NOW() - INTERVAL '11 days'),
(7, 11, 'GAM representa la arquitectura contemporánea chilena. Muy innovador.', 5, NOW() - INTERVAL '18 days');

-- Héctor Vargas (ID 8) - Ciclista urbano
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(8, 1, 'Subir el San Cristóbal en bici es un desafío. Las vistas valen el esfuerzo.', 5, NOW() - INTERVAL '3 days'),
(8, 2, 'Parque Forestal tiene buenas ciclovías. Ideal para pedalear.', 5, NOW() - INTERVAL '7 days'),
(8, 3, 'Bicentenario es perfecto para andar en bici con la familia.', 5, NOW() - INTERVAL '13 days'),
(8, 4, 'Quinta Normal tiene rutas ciclísticas amplias y seguras.', 4, NOW() - INTERVAL '17 days');

-- Isabel Núñez (ID 9) - Bloguera de viajes
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(9, 1, 'El Cerro San Cristóbal es el mejor mirador de Santiago. Fotos espectaculares.', 5, NOW() - INTERVAL '1 day'),
(9, 15, 'Bocanáriz es perfecto para una cita romántica. Ambiente íntimo.', 5, NOW() - INTERVAL '5 days'),
(9, 9, 'Asistir al Teatro Municipal es una experiencia de lujo. Totalmente recomendado.', 5, NOW() - INTERVAL '10 days'),
(9, 22, 'Café Colmado es instagrameable y delicioso. Doble ganancia.', 5, NOW() - INTERVAL '3 days'),
(9, 23, 'Wonderland Café tiene una decoración de cuento. Me encantó.', 5, NOW() - INTERVAL '8 days');

-- Javier Pinto (ID 10) - Estudiante de fotografía
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(10, 1, 'Las mejores fotos de Santiago se toman desde aquí. Luz perfecta al atardecer.', 5, NOW() - INTERVAL '2 days'),
(10, 2, 'Parque Forestal es fotogénico en cada estación. Árboles hermosos.', 5, NOW() - INTERVAL '6 days'),
(10, 5, 'El interior del Museo de Bellas Artes es un sueño para fotógrafos.', 5, NOW() - INTERVAL '11 days'),
(10, 20, 'Plaza de Armas tiene mucha vida urbana. Buenas fotos callejeras.', 5, NOW() - INTERVAL '15 days'),
(10, 21, 'La Catedral tiene detalles arquitectónicos increíbles para fotografiar.', 5, NOW() - INTERVAL '9 days');

-- Más resenas para cafés y bares
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(2, 22, 'El café es excelente y los pasteles caseros son increíbles.', 5, NOW() - INTERVAL '4 days'),
(3, 23, 'Wonderland es mágico, perfecto para una tarde con amigas.', 5, NOW() - INTERVAL '6 days'),
(6, 24, 'The Clinic tiene buena selección de cervezas artesanales.', 4, NOW() - INTERVAL '8 days'),
(1, 14, 'Café del Teatro es ideal para conversar después de la función.', 4, NOW() - INTERVAL '12 days');

-- Reseñas ANTIGUAS (más de 3 meses) para la consulta #7
INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
(1, 25, 'Experiencia auténtica en La Piojera. Muy tradicional.', 3, NOW() - INTERVAL '120 days');

-- =============================================
-- PASO 5: INSERTAR FOTOGRAFÍAS
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '📸 Insertando fotografías...';
END $$;

INSERT INTO fotografias (id_usuario, id_sitio, url, fecha) VALUES
-- Ana García
(1, 1, 'https://picsum.photos/800/600?random=1', NOW() - INTERVAL '5 days'),
(1, 1, 'https://picsum.photos/800/600?random=2', NOW() - INTERVAL '5 days'),
(1, 5, 'https://picsum.photos/800/600?random=3', NOW() - INTERVAL '10 days'),
(1, 9, 'https://picsum.photos/800/600?random=4', NOW() - INTERVAL '20 days'),
(1, 15, 'https://picsum.photos/800/600?random=5', NOW() - INTERVAL '7 days'),

-- Bruno Díaz
(2, 15, 'https://picsum.photos/800/600?random=6', NOW() - INTERVAL '3 days'),
(2, 16, 'https://picsum.photos/800/600?random=7', NOW() - INTERVAL '8 days'),
(2, 17, 'https://picsum.photos/800/600?random=8', NOW() - INTERVAL '12 days'),
(2, 18, 'https://picsum.photos/800/600?random=9', NOW() - INTERVAL '6 days'),

-- Carla Soto
(3, 1, 'https://picsum.photos/800/600?random=10', NOW() - INTERVAL '4 days'),
(3, 2, 'https://picsum.photos/800/600?random=11', NOW() - INTERVAL '9 days'),
(3, 3, 'https://picsum.photos/800/600?random=12', NOW() - INTERVAL '14 days'),
(3, 4, 'https://picsum.photos/800/600?random=13', NOW() - INTERVAL '11 days'),

-- Diego Morales
(4, 9, 'https://picsum.photos/800/600?random=14', NOW() - INTERVAL '7 days'),
(4, 10, 'https://picsum.photos/800/600?random=15', NOW() - INTERVAL '13 days'),
(4, 11, 'https://picsum.photos/800/600?random=16', NOW() - INTERVAL '19 days'),

-- Elena Fernández
(5, 19, 'https://picsum.photos/800/600?random=17', NOW() - INTERVAL '5 days'),
(5, 20, 'https://picsum.photos/800/600?random=18', NOW() - INTERVAL '10 days'),
(5, 21, 'https://picsum.photos/800/600?random=19', NOW() - INTERVAL '15 days'),

-- Javier Pinto
(10, 1, 'https://picsum.photos/800/600?random=20', NOW() - INTERVAL '2 days'),
(10, 1, 'https://picsum.photos/800/600?random=21', NOW() - INTERVAL '2 days'),
(10, 2, 'https://picsum.photos/800/600?random=22', NOW() - INTERVAL '6 days'),
(10, 5, 'https://picsum.photos/800/600?random=23', NOW() - INTERVAL '11 days'),
(10, 20, 'https://picsum.photos/800/600?random=24', NOW() - INTERVAL '15 days'),
(10, 21, 'https://picsum.photos/800/600?random=25', NOW() - INTERVAL '9 days'),

-- Isabel Núñez
(9, 1, 'https://picsum.photos/800/600?random=26', NOW() - INTERVAL '1 day'),
(9, 15, 'https://picsum.photos/800/600?random=27', NOW() - INTERVAL '5 days'),
(9, 9, 'https://picsum.photos/800/600?random=28', NOW() - INTERVAL '10 days'),
(9, 22, 'https://picsum.photos/800/600?random=29', NOW() - INTERVAL '3 days'),
(9, 23, 'https://picsum.photos/800/600?random=30', NOW() - INTERVAL '8 days');

-- =============================================
-- PASO 6: INSERTAR SEGUIDORES
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '👥 Insertando relaciones de seguimiento...';
END $$;

-- Ana (1) sigue a varios
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(1, 2, '2024-02-25 10:00:00'),
(1, 3, '2024-03-15 11:30:00'),
(1, 5, '2024-05-20 14:00:00'),
(1, 9, '2024-09-20 09:00:00'),
(1, 10, '2024-10-05 16:00:00');

-- Bruno (2)
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(2, 6, '2024-06-25 10:00:00'),
(2, 1, '2024-03-01 12:00:00'),
(2, 9, '2024-09-25 15:00:00');

-- Carla (3)
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(3, 1, '2024-04-10 10:00:00'),
(3, 8, '2024-09-05 11:00:00'),
(3, 9, '2024-10-01 14:00:00');

-- Diego (4)
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(4, 1, '2024-05-01 10:00:00'),
(4, 5, '2024-06-15 12:00:00'),
(4, 7, '2024-08-01 13:00:00');

-- Elena (5) es muy seguida
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(6, 5, '2024-07-01 10:00:00'),
(7, 5, '2024-08-15 11:00:00'),
(9, 5, '2024-10-10 12:00:00'),
(10, 5, '2024-10-20 13:00:00');

-- Felipe (6)
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(6, 2, '2024-07-05 10:00:00'),
(6, 1, '2024-07-10 11:00:00');

-- Más relaciones
INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(7, 1, '2024-08-20 10:00:00'),
(8, 3, '2024-09-10 11:00:00'),
(9, 1, '2024-09-25 12:00:00'),
(9, 10, '2024-10-15 13:00:00'),
(10, 1, '2024-10-10 14:00:00'),
(10, 9, '2024-10-20 15:00:00');

-- =============================================
-- PASO 7: INSERTAR LISTAS
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '📝 Insertando listas personalizadas...';
END $$;

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
-- PASO 8: INSERTAR SITIOS EN LISTAS
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '🔗 Vinculando sitios a listas...';
END $$;

-- Lista 1: Imperdibles de Santiago (Ana)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(1, 1),   -- Cerro San Cristóbal
(1, 5),   -- Museo Bellas Artes
(1, 19),  -- La Moneda
(1, 20),  -- Plaza de Armas
(1, 9);   -- Teatro Municipal

-- Lista 2: Mis Museos Favoritos (Ana)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(2, 5),   -- Bellas Artes
(2, 6),   -- Museo de la Memoria
(2, 7),   -- Museo Precolombino
(2, 8);   -- Centro Cultural La Moneda

-- Lista 3: Tour Gastronómico (Bruno)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(3, 15),  -- Bocanáriz
(3, 16),  -- Liguria
(3, 17),  -- Peumayen
(3, 18);  -- Astrid y Gastón

-- Lista 4: Mejores Vinos (Bruno)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(4, 15),  -- Bocanáriz
(4, 17);  -- Peumayen

-- Lista 5: Parques (Carla)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(5, 1),   -- San Cristóbal
(5, 2),   -- Parque Forestal
(5, 3),   -- Bicentenario
(5, 4);   -- Quinta Normal

-- Lista 6: Teatros (Diego)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(6, 9),   -- Teatro Municipal
(6, 10),  -- Teatro U Chile
(6, 11);  -- GAM

-- Lista 7: Ruta Histórica (Elena)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(7, 19),  -- La Moneda
(7, 20),  -- Plaza de Armas
(7, 21),  -- Catedral
(7, 7);   -- Museo Precolombino

-- Lista 8: Para el Blog (Isabel)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(8, 1),   -- San Cristóbal
(8, 15),  -- Bocanáriz
(8, 9),   -- Teatro Municipal
(8, 22),  -- Café Colmado
(8, 23);  -- Wonderland

-- Lista 9: Fotogénico Santiago (Javier)
INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(9, 1),   -- San Cristóbal
(9, 2),   -- Parque Forestal
(9, 5),   -- Bellas Artes
(9, 20),  -- Plaza de Armas
(9, 21);  -- Catedral

-- =============================================
-- PASO 9: REFRESCAR VISTA MATERIALIZADA
-- =============================================

DO $$
BEGIN
    RAISE NOTICE '🔄 Refrescando vista materializada...';
END $$;

REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;

-- =============================================
-- PASO 10: VERIFICACIÓN
-- =============================================

DO $$
DECLARE
    v_usuarios INT;
    v_sitios INT;
    v_resenas INT;
    v_fotos INT;
    v_seguidores INT;
    v_listas INT;
    v_sitios_cerca INT;
BEGIN
    SELECT COUNT(*) INTO v_usuarios FROM usuarios;
    SELECT COUNT(*) INTO v_sitios FROM sitios_turisticos;
    SELECT COUNT(*) INTO v_resenas FROM resenas;
    SELECT COUNT(*) INTO v_fotos FROM fotografias;
    SELECT COUNT(*) INTO v_seguidores FROM seguidores;
    SELECT COUNT(*) INTO v_listas FROM listas_personalizadas;

    -- Verificar sitios cercanos
    SELECT COUNT(*) INTO v_sitios_cerca
    FROM sitios_turisticos r
    WHERE r.tipo = 'Restaurante'
    AND EXISTS (
        SELECT 1 FROM sitios_turisticos t
        WHERE t.tipo = 'Teatro'
        AND ST_DWithin(r.coordenadas, t.coordenadas, 100)
    );

    RAISE NOTICE '';
    RAISE NOTICE '═══════════════════════════════════════';
    RAISE NOTICE '📊 RESUMEN DE DATOS CARGADOS';
    RAISE NOTICE '═══════════════════════════════════════';
    RAISE NOTICE 'Usuarios:                    %', v_usuarios;
    RAISE NOTICE 'Sitios turísticos:           %', v_sitios;
    RAISE NOTICE 'Reseñas:                     %', v_resenas;
    RAISE NOTICE 'Fotografías:                 %', v_fotos;
    RAISE NOTICE 'Relaciones seguimiento:      %', v_seguidores;
    RAISE NOTICE 'Listas personalizadas:       %', v_listas;
    RAISE NOTICE 'Restaurantes cerca teatros:  %', v_sitios_cerca;
    RAISE NOTICE '═══════════════════════════════════════';
    RAISE NOTICE '';

    IF v_sitios_cerca = 0 THEN
        RAISE WARNING '⚠️  No se encontraron restaurantes cerca de teatros!';
    ELSE
        RAISE NOTICE '✅ Se encontraron % restaurantes cerca de teatros', v_sitios_cerca;
    END IF;

    RAISE NOTICE '✅ Todos los datos cargados correctamente';
    RAISE NOTICE '';
END $$;

-- Mostrar calificaciones promedio
SELECT
    tipo,
    ROUND(AVG(calificacion_promedio)::numeric, 2) AS cal_promedio,
    SUM(total_resenas) AS total_resenas
FROM sitios_turisticos
WHERE total_resenas > 0
GROUP BY tipo
ORDER BY cal_promedio DESC;

-- Mostrar usuarios más activos
SELECT
    nombre,
    total_resenas,
    total_fotos,
    total_listas,
    (total_resenas + total_fotos + total_listas) AS total
FROM resumen_contribuciones_usuario
ORDER BY total DESC
LIMIT 10;
