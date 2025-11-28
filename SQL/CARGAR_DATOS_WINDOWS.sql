-- =============================================
-- SCRIPT DE LIMPIEZA Y RECARGA - VERSION WINDOWS
-- =============================================
-- Compatible con encoding WIN1252
-- Sin emojis ni caracteres especiales
-- =============================================

-- =============================================
-- PASO 0: CREAR INDICE UNICO SI NO EXISTE
-- =============================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE tablename = 'resumen_contribuciones_usuario'
        AND indexname = 'idx_resumen_contribuciones_usuario_id'
    ) THEN
        CREATE UNIQUE INDEX idx_resumen_contribuciones_usuario_id
        ON resumen_contribuciones_usuario(id_usuario);
        RAISE NOTICE 'Indice único creado';
    ELSE
        RAISE NOTICE 'Indice único ya existe';
    END IF;
END $$;

-- =============================================
-- PASO 1: ELIMINAR TODOS LOS DATOS
-- =============================================

RAISE NOTICE 'Eliminando todos los datos existentes...';

-- Usar TRUNCATE CASCADE para eliminar TODO
TRUNCATE TABLE lista_sitios CASCADE;
TRUNCATE TABLE listas_personalizadas CASCADE;
TRUNCATE TABLE fotografias CASCADE;
TRUNCATE TABLE seguidores CASCADE;

-- Para reseñas, verificar si existe la tabla
DO $$
BEGIN
    -- Intentar truncar con el nombre con ñ
    EXECUTE 'TRUNCATE TABLE reseñas CASCADE';
EXCEPTION
    WHEN undefined_table THEN
        -- Si no existe, intentar sin ñ
        BEGIN
            EXECUTE 'TRUNCATE TABLE resenas CASCADE';
        EXCEPTION
            WHEN undefined_table THEN
                RAISE NOTICE 'No se encontró tabla de reseñas';
        END;
END $$;

TRUNCATE TABLE sitios_turisticos RESTART IDENTITY CASCADE;
TRUNCATE TABLE usuarios RESTART IDENTITY CASCADE;

-- Resetear secuencias
DO $$
BEGIN
    -- Resetear secuencias que sabemos que existen
    ALTER SEQUENCE usuarios_id_seq RESTART WITH 1;
    ALTER SEQUENCE sitios_turisticos_id_seq RESTART WITH 1;
    ALTER SEQUENCE fotografias_id_seq RESTART WITH 1;
    ALTER SEQUENCE listas_personalizadas_id_seq RESTART WITH 1;

    -- Intentar resetear seguidores si existe
    BEGIN
        ALTER SEQUENCE seguidores_id_seq RESTART WITH 1;
    EXCEPTION
        WHEN undefined_table THEN
            RAISE NOTICE 'Secuencia seguidores no existe';
    END;

    -- Intentar resetear reseñas con ñ
    BEGIN
        EXECUTE 'ALTER SEQUENCE reseñas_id_seq RESTART WITH 1';
    EXCEPTION
        WHEN undefined_table THEN
            BEGIN
                EXECUTE 'ALTER SEQUENCE resenas_id_seq RESTART WITH 1';
            EXCEPTION
                WHEN undefined_table THEN
                    RAISE NOTICE 'Secuencia reseñas no encontrada';
            END;
    END;
END $$;

RAISE NOTICE 'Datos eliminados correctamente';

-- =============================================
-- PASO 2: INSERTAR USUARIOS
-- =============================================

RAISE NOTICE 'Insertando usuarios...';

INSERT INTO usuarios (nombre, email, contrasena_hash, biografia, fecha_registro) VALUES
('Ana Garcia', 'ana@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Viajera y fotografa. Amante de los museos y el arte.', '2024-01-15 10:30:00'),
('Bruno Diaz', 'bruno@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Entusiasta de la gastronomia. Siempre buscando el mejor restaurante.', '2024-02-20 14:15:00'),
('Carla Soto', 'carla@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Exploradora urbana. Me encantan los parques y las vistas.', '2024-03-10 09:45:00'),
('Diego Morales', 'diego@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Critico de teatro aficionado. Pasion por las artes escenicas.', '2024-04-05 16:20:00'),
('Elena Fernandez', 'elena@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Historiadora y guia turistica. Amo contar historias de Santiago.', '2024-05-12 11:00:00'),
('Felipe Torres', 'felipe@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Sommelier profesional. Experto en vinos chilenos.', '2024-06-18 13:30:00'),
('Gabriela Rojas', 'gabriela@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Arquitecta. Fascinada por los edificios historicos de la ciudad.', '2024-07-22 10:15:00'),
('Hector Vargas', 'hector@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Ciclista urbano. Descubriendo Santiago sobre dos ruedas.', '2024-08-30 15:45:00'),
('Isabel Nunez', 'isabel@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Bloguera de viajes. Compartiendo experiencias locales.', '2024-09-14 12:00:00'),
('Javier Pinto', 'javier@tbd.cl', '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2', 'Estudiante de fotografia. Capturando la esencia de la ciudad.', '2024-10-01 08:30:00');

-- =============================================
-- PASO 3: INSERTAR SITIOS TURISTICOS
-- =============================================

RAISE NOTICE 'Insertando sitios turisticos...';

ALTER TABLE sitios_turisticos ADD COLUMN IF NOT EXISTS ciudad VARCHAR(100);

INSERT INTO sitios_turisticos (nombre, descripcion, tipo, coordenadas, ciudad) VALUES
-- Parques
('Cerro San Cristobal', 'El gran parque urbano de Santiago, con vistas panoramicas.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6300, -33.4168), 4326), 'Santiago'),
('Parque Forestal', 'Hermoso parque lineal a lo largo del rio Mapocho.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6450, -33.4360), 4326), 'Santiago'),
('Parque Bicentenario', 'Moderno parque con lagunas artificiales y esculturas.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6100, -33.4050), 4326), 'Santiago'),
('Parque Quinta Normal', 'Amplio parque con museos, lagunas y areas verdes.', 'Parque', ST_SetSRID(ST_MakePoint(-70.6820, -33.4440), 4326), 'Santiago'),

-- Museos
('Museo Nacional de Bellas Artes', 'Principal museo de arte de Chile.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6418, -33.4350), 4326), 'Santiago'),
('Museo de la Memoria y los DDHH', 'Museo dedicado a la memoria historica.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6820, -33.4450), 4326), 'Santiago'),
('Museo Chileno de Arte Precolombino', 'Coleccion de arte de culturas precolombinas.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6500, -33.4380), 4326), 'Santiago'),
('Centro Cultural La Moneda', 'Centro cultural subterraneo con exposiciones.', 'Museo', ST_SetSRID(ST_MakePoint(-70.6530, -33.4430), 4326), 'Santiago'),

-- Teatros
('Teatro Municipal de Santiago', 'El centro cultural mas antiguo del pais.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6477, -33.4398), 4326), 'Santiago'),
('Teatro Universidad de Chile', 'Teatro historico con programacion variada.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6495, -33.4405), 4326), 'Santiago'),
('Centro Gabriela Mistral GAM', 'Moderno centro cultural con teatro y danza.', 'Teatro', ST_SetSRID(ST_MakePoint(-70.6465, -33.4375), 4326), 'Santiago'),

-- Restaurantes CERCA de teatros (<100m)
('Opera Catedral', 'Restaurante gourmet a pasos del Teatro Municipal.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6480, -33.4400), 4326), 'Santiago'),
('Confiteria Torres', 'Tradicional confiteria junto al Teatro Municipal.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6475, -33.4395), 4326), 'Santiago'),
('Cafe del Teatro', 'Cafe acogedor en el edificio del Teatro Universidad.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6496, -33.4406), 4326), 'Santiago'),

-- Otros restaurantes
('Bocanariz', 'Bar de vinos boutique con excelente gastronomia.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6353, -33.4385), 4326), 'Santiago'),
('Liguria', 'Tradicional restaurante con ambiente bohemio.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6380, -33.4340), 4326), 'Santiago'),
('Peumayen', 'Restaurante de comida ancestral chilena.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6360, -33.4320), 4326), 'Santiago'),
('Astrid y Gaston', 'Alta cocina peruana, uno de los mejores.', 'Restaurante', ST_SetSRID(ST_MakePoint(-70.6150, -33.4100), 4326), 'Santiago'),

-- Monumentos
('La Moneda', 'Palacio de gobierno, un hito historico.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6538, -33.4426), 4326), 'Santiago'),
('Plaza de Armas', 'Plaza principal de Santiago, centro historico.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6510, -33.4372), 4326), 'Santiago'),
('Catedral Metropolitana', 'Imponente catedral neoclasica.', 'Monumento', ST_SetSRID(ST_MakePoint(-70.6505, -33.4370), 4326), 'Santiago'),

-- Cafes
('Cafe Colmado', 'Cafe artesanal con excelentes pasteles.', 'Cafe', ST_SetSRID(ST_MakePoint(-70.6400, -33.4350), 4326), 'Santiago'),
('Wonderland Cafe', 'Cafe tematico con decoracion unica.', 'Cafe', ST_SetSRID(ST_MakePoint(-70.6420, -33.4345), 4326), 'Santiago'),

-- Bares
('The Clinic', 'Bar con terraza y buena seleccion de cervezas.', 'Bar', ST_SetSRID(ST_MakePoint(-70.6365, -33.4330), 4326), 'Santiago'),
('La Piojera', 'Bar tradicional, famoso por la terremoto.', 'Bar', ST_SetSRID(ST_MakePoint(-70.6600, -33.4500), 4326), 'Santiago');

-- =============================================
-- PASO 4: INSERTAR RESENAS (calificaciones ALTAS)
-- =============================================

RAISE NOTICE 'Insertando resenas...';

-- Insertar en la tabla correcta (con o sin ñ)
DO $$
BEGIN
    -- Intentar insertar en tabla con ñ
    BEGIN
        INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
        -- Ana Garcia (ID 1)
        (1, 1, 'La vista desde el Cerro San Cristobal es increible!', 5, NOW() - INTERVAL '5 days'),
        (1, 5, 'El Museo de Bellas Artes tiene una coleccion impresionante.', 5, NOW() - INTERVAL '10 days'),
        (1, 19, 'La Moneda es espectacular. El cambio de guardia es muy interesante.', 4, NOW() - INTERVAL '15 days'),
        (1, 15, 'Bocanariz tiene la mejor seleccion de vinos.', 5, NOW() - INTERVAL '7 days'),
        (1, 9, 'Asisti a una opera en el Teatro Municipal. La acustica es perfecta.', 5, NOW() - INTERVAL '20 days'),

        -- Bruno Diaz (ID 2)
        (2, 15, 'La mejor seleccion de vinos que he visto en Santiago.', 5, NOW() - INTERVAL '3 days'),
        (2, 16, 'Liguria tiene ese ambiente bohemio que me encanta.', 4, NOW() - INTERVAL '8 days'),
        (2, 17, 'Peumayen ofrece una experiencia unica.', 5, NOW() - INTERVAL '12 days'),
        (2, 18, 'Astrid y Gaston no decepciona. Alta cocina peruana.', 5, NOW() - INTERVAL '6 days'),
        (2, 22, 'Cafe Colmado tiene los mejores pasteles de la zona.', 4, NOW() - INTERVAL '2 days'),

        -- Carla Soto (ID 3)
        (3, 1, 'Perfecto para un picnic el fin de semana.', 5, NOW() - INTERVAL '4 days'),
        (3, 2, 'El Parque Forestal es ideal para caminar.', 5, NOW() - INTERVAL '9 days'),
        (3, 3, 'Parque Bicentenario es moderno y bien mantenido.', 4, NOW() - INTERVAL '14 days'),
        (3, 4, 'Quinta Normal tiene mucho espacio verde.', 4, NOW() - INTERVAL '11 days'),
        (3, 20, 'La Plaza de Armas siempre esta llena de vida.', 4, NOW() - INTERVAL '18 days'),

        -- Diego Morales (ID 4)
        (4, 9, 'El Teatro Municipal es joya arquitectonica.', 5, NOW() - INTERVAL '7 days'),
        (4, 10, 'Teatro Universidad de Chile tiene una rica historia.', 5, NOW() - INTERVAL '13 days'),
        (4, 11, 'GAM es un espacio moderno y versatil.', 5, NOW() - INTERVAL '19 days'),
        (4, 12, 'Opera Catedral es perfecto para comer antes de la funcion.', 4, NOW() - INTERVAL '8 days'),
        (4, 13, 'Confiteria Torres es un clasico santiaguino.', 4, NOW() - INTERVAL '15 days'),

        -- Elena Fernandez (ID 5)
        (5, 19, 'La Moneda tiene tanta historia. Recomiendo el tour guiado.', 5, NOW() - INTERVAL '5 days'),
        (5, 20, 'Plaza de Armas es el corazon de Santiago.', 5, NOW() - INTERVAL '10 days'),
        (5, 21, 'La Catedral Metropolitana es impresionante.', 5, NOW() - INTERVAL '15 days'),
        (5, 7, 'El Museo Precolombino tiene piezas unicas.', 5, NOW() - INTERVAL '8 days'),
        (5, 6, 'Museo de la Memoria es conmovedor y necesario.', 5, NOW() - INTERVAL '20 days'),

        -- Felipe Torres (ID 6)
        (6, 15, 'Bocanariz es mi lugar favorito. La carta de vinos es excelente.', 5, NOW() - INTERVAL '2 days'),
        (6, 17, 'Peumayen tiene un maridaje perfecto.', 5, NOW() - INTERVAL '6 days'),
        (6, 18, 'La bodega de Astrid y Gaston es impresionante.', 5, NOW() - INTERVAL '12 days'),
        (6, 12, 'Opera Catedral tiene una carta de vinos sorprendente.', 4, NOW() - INTERVAL '16 days'),

        -- Gabriela Rojas (ID 7)
        (7, 9, 'La arquitectura del Teatro Municipal es sublime.', 5, NOW() - INTERVAL '4 days'),
        (7, 5, 'El Palacio de Bellas Artes es una joya arquitectonica.', 5, NOW() - INTERVAL '9 days'),
        (7, 21, 'La fachada neoclasica de la Catedral es impresionante.', 5, NOW() - INTERVAL '14 days'),
        (7, 8, 'El Centro Cultural La Moneda tiene un diseno subterraneo fascinante.', 5, NOW() - INTERVAL '11 days'),
        (7, 11, 'GAM representa la arquitectura contemporanea chilena.', 5, NOW() - INTERVAL '18 days'),

        -- Hector Vargas (ID 8)
        (8, 1, 'Subir el San Cristobal en bici es un desafio.', 5, NOW() - INTERVAL '3 days'),
        (8, 2, 'Parque Forestal tiene buenas ciclovias.', 5, NOW() - INTERVAL '7 days'),
        (8, 3, 'Bicentenario es perfecto para andar en bici con la familia.', 5, NOW() - INTERVAL '13 days'),
        (8, 4, 'Quinta Normal tiene rutas ciclisticas amplias y seguras.', 4, NOW() - INTERVAL '17 days'),

        -- Isabel Nunez (ID 9)
        (9, 1, 'El Cerro San Cristobal es el mejor mirador de Santiago.', 5, NOW() - INTERVAL '1 day'),
        (9, 15, 'Bocanariz es perfecto para una cita romantica.', 5, NOW() - INTERVAL '5 days'),
        (9, 9, 'Asistir al Teatro Municipal es una experiencia de lujo.', 5, NOW() - INTERVAL '10 days'),
        (9, 22, 'Cafe Colmado es instagrameable y delicioso.', 5, NOW() - INTERVAL '3 days'),
        (9, 23, 'Wonderland Cafe tiene una decoracion de cuento.', 5, NOW() - INTERVAL '8 days'),

        -- Javier Pinto (ID 10)
        (10, 1, 'Las mejores fotos de Santiago se toman desde aqui.', 5, NOW() - INTERVAL '2 days'),
        (10, 2, 'Parque Forestal es fotogenico en cada estacion.', 5, NOW() - INTERVAL '6 days'),
        (10, 5, 'El interior del Museo de Bellas Artes es un sueno para fotografos.', 5, NOW() - INTERVAL '11 days'),
        (10, 20, 'Plaza de Armas tiene mucha vida urbana.', 5, NOW() - INTERVAL '15 days'),
        (10, 21, 'La Catedral tiene detalles arquitectonicos increibles.', 5, NOW() - INTERVAL '9 days'),

        -- Mas resenas para cafes y bares
        (2, 22, 'El cafe es excelente y los pasteles caseros son increibles.', 5, NOW() - INTERVAL '4 days'),
        (3, 23, 'Wonderland es magico, perfecto para una tarde con amigas.', 5, NOW() - INTERVAL '6 days'),
        (6, 24, 'The Clinic tiene buena seleccion de cervezas artesanales.', 4, NOW() - INTERVAL '8 days'),
        (1, 14, 'Cafe del Teatro es ideal para conversar despues de la funcion.', 4, NOW() - INTERVAL '12 days'),

        -- Resena antigua para consulta #7
        (1, 25, 'Experiencia autentica en La Piojera. Muy tradicional.', 3, NOW() - INTERVAL '120 days');

    EXCEPTION
        WHEN undefined_table THEN
            -- Si no existe con ñ, intentar sin ñ
            INSERT INTO resenas (id_usuario, id_sitio, contenido, calificacion, fecha) VALUES
            (1, 1, 'La vista desde el Cerro San Cristobal es increible!', 5, NOW() - INTERVAL '5 days'),
            (1, 5, 'El Museo de Bellas Artes tiene una coleccion impresionante.', 5, NOW() - INTERVAL '10 days'),
            (1, 19, 'La Moneda es espectacular.', 4, NOW() - INTERVAL '15 days'),
            (1, 15, 'Bocanariz tiene la mejor seleccion de vinos.', 5, NOW() - INTERVAL '7 days'),
            (1, 9, 'Asisti a una opera en el Teatro Municipal.', 5, NOW() - INTERVAL '20 days'),
            (2, 15, 'La mejor seleccion de vinos que he visto.', 5, NOW() - INTERVAL '3 days'),
            (2, 16, 'Liguria tiene ese ambiente bohemio que me encanta.', 4, NOW() - INTERVAL '8 days'),
            (2, 17, 'Peumayen ofrece una experiencia unica.', 5, NOW() - INTERVAL '12 days'),
            (2, 18, 'Astrid y Gaston no decepciona.', 5, NOW() - INTERVAL '6 days'),
            (2, 22, 'Cafe Colmado tiene los mejores pasteles.', 4, NOW() - INTERVAL '2 days'),
            (3, 1, 'Perfecto para un picnic.', 5, NOW() - INTERVAL '4 days'),
            (3, 2, 'El Parque Forestal es ideal.', 5, NOW() - INTERVAL '9 days'),
            (3, 3, 'Parque Bicentenario es moderno.', 4, NOW() - INTERVAL '14 days'),
            (3, 4, 'Quinta Normal tiene mucho espacio verde.', 4, NOW() - INTERVAL '11 days'),
            (3, 20, 'La Plaza de Armas esta llena de vida.', 4, NOW() - INTERVAL '18 days'),
            (4, 9, 'El Teatro Municipal es joya arquitectonica.', 5, NOW() - INTERVAL '7 days'),
            (4, 10, 'Teatro Universidad tiene historia.', 5, NOW() - INTERVAL '13 days'),
            (4, 11, 'GAM es un espacio moderno.', 5, NOW() - INTERVAL '19 days'),
            (4, 12, 'Opera Catedral es perfecto.', 4, NOW() - INTERVAL '8 days'),
            (4, 13, 'Confiteria Torres es un clasico.', 4, NOW() - INTERVAL '15 days'),
            (5, 19, 'La Moneda tiene tanta historia.', 5, NOW() - INTERVAL '5 days'),
            (5, 20, 'Plaza de Armas es el corazon de Santiago.', 5, NOW() - INTERVAL '10 days'),
            (5, 21, 'La Catedral es impresionante.', 5, NOW() - INTERVAL '15 days'),
            (5, 7, 'El Museo Precolombino es unico.', 5, NOW() - INTERVAL '8 days'),
            (5, 6, 'Museo de la Memoria es necesario.', 5, NOW() - INTERVAL '20 days'),
            (6, 15, 'Bocanariz es mi favorito.', 5, NOW() - INTERVAL '2 days'),
            (6, 17, 'Peumayen tiene maridaje perfecto.', 5, NOW() - INTERVAL '6 days'),
            (6, 18, 'Astrid y Gaston es impresionante.', 5, NOW() - INTERVAL '12 days'),
            (6, 12, 'Opera Catedral tiene vinos sorprendentes.', 4, NOW() - INTERVAL '16 days'),
            (7, 9, 'Teatro Municipal es sublime.', 5, NOW() - INTERVAL '4 days'),
            (7, 5, 'Palacio de Bellas Artes es una joya.', 5, NOW() - INTERVAL '9 days'),
            (7, 21, 'La Catedral es impresionante.', 5, NOW() - INTERVAL '14 days'),
            (7, 8, 'Centro Cultural La Moneda es fascinante.', 5, NOW() - INTERVAL '11 days'),
            (7, 11, 'GAM es arquitectura contemporanea.', 5, NOW() - INTERVAL '18 days'),
            (8, 1, 'Subir en bici es un desafio.', 5, NOW() - INTERVAL '3 days'),
            (8, 2, 'Parque Forestal tiene ciclovias.', 5, NOW() - INTERVAL '7 days'),
            (8, 3, 'Bicentenario es perfecto para bici.', 5, NOW() - INTERVAL '13 days'),
            (8, 4, 'Quinta Normal tiene rutas amplias.', 4, NOW() - INTERVAL '17 days'),
            (9, 1, 'El mejor mirador de Santiago.', 5, NOW() - INTERVAL '1 day'),
            (9, 15, 'Bocanariz es perfecto para cita.', 5, NOW() - INTERVAL '5 days'),
            (9, 9, 'Teatro Municipal es experiencia de lujo.', 5, NOW() - INTERVAL '10 days'),
            (9, 22, 'Cafe Colmado es instagrameable.', 5, NOW() - INTERVAL '3 days'),
            (9, 23, 'Wonderland tiene decoracion de cuento.', 5, NOW() - INTERVAL '8 days'),
            (10, 1, 'Las mejores fotos desde aqui.', 5, NOW() - INTERVAL '2 days'),
            (10, 2, 'Parque Forestal es fotogenico.', 5, NOW() - INTERVAL '6 days'),
            (10, 5, 'Museo es sueno para fotografos.', 5, NOW() - INTERVAL '11 days'),
            (10, 20, 'Plaza de Armas tiene vida urbana.', 5, NOW() - INTERVAL '15 days'),
            (10, 21, 'La Catedral tiene detalles increibles.', 5, NOW() - INTERVAL '9 days'),
            (2, 22, 'Los pasteles son increibles.', 5, NOW() - INTERVAL '4 days'),
            (3, 23, 'Wonderland es magico.', 5, NOW() - INTERVAL '6 days'),
            (6, 24, 'The Clinic tiene cervezas artesanales.', 4, NOW() - INTERVAL '8 days'),
            (1, 14, 'Cafe del Teatro es ideal.', 4, NOW() - INTERVAL '12 days'),
            (1, 25, 'La Piojera es tradicional.', 3, NOW() - INTERVAL '120 days');
    END;
END $$;

-- =============================================
-- PASO 5: INSERTAR FOTOGRAFIAS
-- =============================================

RAISE NOTICE 'Insertando fotografias...';

INSERT INTO fotografias (id_usuario, id_sitio, url, fecha) VALUES
(1, 1, 'https://picsum.photos/800/600?random=1', NOW() - INTERVAL '5 days'),
(1, 1, 'https://picsum.photos/800/600?random=2', NOW() - INTERVAL '5 days'),
(1, 5, 'https://picsum.photos/800/600?random=3', NOW() - INTERVAL '10 days'),
(1, 9, 'https://picsum.photos/800/600?random=4', NOW() - INTERVAL '20 days'),
(1, 15, 'https://picsum.photos/800/600?random=5', NOW() - INTERVAL '7 days'),
(2, 15, 'https://picsum.photos/800/600?random=6', NOW() - INTERVAL '3 days'),
(2, 16, 'https://picsum.photos/800/600?random=7', NOW() - INTERVAL '8 days'),
(2, 17, 'https://picsum.photos/800/600?random=8', NOW() - INTERVAL '12 days'),
(2, 18, 'https://picsum.photos/800/600?random=9', NOW() - INTERVAL '6 days'),
(3, 1, 'https://picsum.photos/800/600?random=10', NOW() - INTERVAL '4 days'),
(3, 2, 'https://picsum.photos/800/600?random=11', NOW() - INTERVAL '9 days'),
(3, 3, 'https://picsum.photos/800/600?random=12', NOW() - INTERVAL '14 days'),
(3, 4, 'https://picsum.photos/800/600?random=13', NOW() - INTERVAL '11 days'),
(4, 9, 'https://picsum.photos/800/600?random=14', NOW() - INTERVAL '7 days'),
(4, 10, 'https://picsum.photos/800/600?random=15', NOW() - INTERVAL '13 days'),
(4, 11, 'https://picsum.photos/800/600?random=16', NOW() - INTERVAL '19 days'),
(5, 19, 'https://picsum.photos/800/600?random=17', NOW() - INTERVAL '5 days'),
(5, 20, 'https://picsum.photos/800/600?random=18', NOW() - INTERVAL '10 days'),
(5, 21, 'https://picsum.photos/800/600?random=19', NOW() - INTERVAL '15 days'),
(10, 1, 'https://picsum.photos/800/600?random=20', NOW() - INTERVAL '2 days'),
(10, 1, 'https://picsum.photos/800/600?random=21', NOW() - INTERVAL '2 days'),
(10, 2, 'https://picsum.photos/800/600?random=22', NOW() - INTERVAL '6 days'),
(10, 5, 'https://picsum.photos/800/600?random=23', NOW() - INTERVAL '11 days'),
(10, 20, 'https://picsum.photos/800/600?random=24', NOW() - INTERVAL '15 days'),
(10, 21, 'https://picsum.photos/800/600?random=25', NOW() - INTERVAL '9 days'),
(9, 1, 'https://picsum.photos/800/600?random=26', NOW() - INTERVAL '1 day'),
(9, 15, 'https://picsum.photos/800/600?random=27', NOW() - INTERVAL '5 days'),
(9, 9, 'https://picsum.photos/800/600?random=28', NOW() - INTERVAL '10 days'),
(9, 22, 'https://picsum.photos/800/600?random=29', NOW() - INTERVAL '3 days'),
(9, 23, 'https://picsum.photos/800/600?random=30', NOW() - INTERVAL '8 days');

-- =============================================
-- PASO 6: INSERTAR SEGUIDORES
-- =============================================

RAISE NOTICE 'Insertando seguidores...';

INSERT INTO seguidores (id_seguidor, id_seguido, fecha_inicio) VALUES
(1, 2, '2024-02-25 10:00:00'),
(1, 3, '2024-03-15 11:30:00'),
(1, 5, '2024-05-20 14:00:00'),
(1, 9, '2024-09-20 09:00:00'),
(1, 10, '2024-10-05 16:00:00'),
(2, 6, '2024-06-25 10:00:00'),
(2, 1, '2024-03-01 12:00:00'),
(2, 9, '2024-09-25 15:00:00'),
(3, 1, '2024-04-10 10:00:00'),
(3, 8, '2024-09-05 11:00:00'),
(3, 9, '2024-10-01 14:00:00'),
(4, 1, '2024-05-01 10:00:00'),
(4, 5, '2024-06-15 12:00:00'),
(4, 7, '2024-08-01 13:00:00'),
(6, 5, '2024-07-01 10:00:00'),
(7, 5, '2024-08-15 11:00:00'),
(9, 5, '2024-10-10 12:00:00'),
(10, 5, '2024-10-20 13:00:00'),
(6, 2, '2024-07-05 10:00:00'),
(6, 1, '2024-07-10 11:00:00'),
(7, 1, '2024-08-20 10:00:00'),
(8, 3, '2024-09-10 11:00:00'),
(9, 1, '2024-09-25 12:00:00'),
(9, 10, '2024-10-15 13:00:00'),
(10, 1, '2024-10-10 14:00:00'),
(10, 9, '2024-10-20 15:00:00');

-- =============================================
-- PASO 7: INSERTAR LISTAS
-- =============================================

RAISE NOTICE 'Insertando listas personalizadas...';

INSERT INTO listas_personalizadas (id_usuario, nombre, fecha_creacion) VALUES
(1, 'Imperdibles de Santiago', '2024-02-01 10:00:00'),
(1, 'Mis Museos Favoritos', '2024-03-15 11:00:00'),
(2, 'Tour Gastronomico', '2024-04-01 12:00:00'),
(2, 'Mejores Vinos de Santiago', '2024-05-10 13:00:00'),
(3, 'Parques para Visitar', '2024-05-20 14:00:00'),
(4, 'Teatros de Santiago', '2024-06-01 15:00:00'),
(5, 'Ruta Historica', '2024-06-15 16:00:00'),
(9, 'Para el Blog', '2024-09-20 17:00:00'),
(10, 'Fotogenico Santiago', '2024-10-05 18:00:00');

-- =============================================
-- PASO 8: VINCULAR SITIOS A LISTAS
-- =============================================

RAISE NOTICE 'Vinculando sitios a listas...';

INSERT INTO lista_sitios (id_lista, id_sitio) VALUES
(1, 1), (1, 5), (1, 19), (1, 20), (1, 9),
(2, 5), (2, 6), (2, 7), (2, 8),
(3, 15), (3, 16), (3, 17), (3, 18),
(4, 15), (4, 17),
(5, 1), (5, 2), (5, 3), (5, 4),
(6, 9), (6, 10), (6, 11),
(7, 19), (7, 20), (7, 21), (7, 7),
(8, 1), (8, 15), (8, 9), (8, 22), (8, 23),
(9, 1), (9, 2), (9, 5), (9, 20), (9, 21);

-- =============================================
-- PASO 9: REFRESCAR VISTA MATERIALIZADA
-- =============================================

RAISE NOTICE 'Refrescando vista materializada...';

REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;

-- =============================================
-- PASO 10: VERIFICACION
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

    -- Contar reseñas
    BEGIN
        EXECUTE 'SELECT COUNT(*) FROM reseñas' INTO v_resenas;
    EXCEPTION
        WHEN undefined_table THEN
            EXECUTE 'SELECT COUNT(*) FROM resenas' INTO v_resenas;
    END;

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
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'RESUMEN DE DATOS CARGADOS';
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Usuarios:                    %', v_usuarios;
    RAISE NOTICE 'Sitios turisticos:           %', v_sitios;
    RAISE NOTICE 'Resenas:                     %', v_resenas;
    RAISE NOTICE 'Fotografias:                 %', v_fotos;
    RAISE NOTICE 'Relaciones seguimiento:      %', v_seguidores;
    RAISE NOTICE 'Listas personalizadas:       %', v_listas;
    RAISE NOTICE 'Restaurantes cerca teatros:  %', v_sitios_cerca;
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';

    IF v_usuarios < 10 THEN
        RAISE WARNING 'Se esperaban 10 usuarios, encontrados: %', v_usuarios;
    END IF;

    IF v_sitios_cerca = 0 THEN
        RAISE WARNING 'No hay restaurantes cerca de teatros!';
    ELSE
        RAISE NOTICE 'OK: % restaurantes cerca de teatros', v_sitios_cerca;
    END IF;

    RAISE NOTICE 'Datos cargados correctamente';
    RAISE NOTICE '';
END $$;

-- Mostrar calificaciones promedio por tipo
DO $$
BEGIN
    BEGIN
        RAISE NOTICE 'Calificaciones promedio por tipo:';
        EXECUTE $sql$
            SELECT tipo, ROUND(AVG(calificacion_promedio)::numeric, 2) AS promedio, SUM(total_reseñas) AS total
            FROM sitios_turisticos
            WHERE total_reseñas > 0
            GROUP BY tipo
            ORDER BY promedio DESC
        $sql$;
    EXCEPTION
        WHEN undefined_column THEN
            EXECUTE $sql$
                SELECT tipo, ROUND(AVG(calificacion_promedio)::numeric, 2) AS promedio, SUM(total_resenas) AS total
                FROM sitios_turisticos
                WHERE total_resenas > 0
                GROUP BY tipo
                ORDER BY promedio DESC
            $sql$;
    END;
END $$;

-- Mostrar usuarios mas activos
SELECT
    nombre,
    total_reseñas AS resenas,
    total_fotos AS fotos,
    total_listas AS listas,
    (total_reseñas + total_fotos + total_listas) AS total
FROM resumen_contribuciones_usuario
ORDER BY total DESC
LIMIT 10;
