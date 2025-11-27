-- =============================================
-- RESET Y RECARGA DE DATOS DE PRUEBA
-- =============================================
-- Este script LIMPIA todos los datos existentes
-- y recarga los datos de prueba completos.
--
-- ⚠️ ADVERTENCIA: Este script ELIMINARÁ TODOS LOS DATOS
-- Use con precaución.
-- =============================================

-- Confirmar que quieres continuar
DO $$
BEGIN
    RAISE NOTICE '⚠️  ADVERTENCIA: Este script eliminará TODOS los datos existentes.';
    RAISE NOTICE '⏳ Iniciando limpieza en 2 segundos...';
    PERFORM pg_sleep(2);
END $$;

-- =============================================
-- PASO 1: LIMPIAR DATOS EXISTENTES
-- =============================================

-- Desactivar triggers temporalmente para acelerar el proceso
SET session_replication_role = 'replica';

TRUNCATE TABLE lista_sitios CASCADE;
TRUNCATE TABLE listas_personalizadas CASCADE;
TRUNCATE TABLE fotografias CASCADE;
TRUNCATE TABLE reseñas CASCADE;
TRUNCATE TABLE seguidores CASCADE;
TRUNCATE TABLE sitios_turisticos RESTART IDENTITY CASCADE;
TRUNCATE TABLE usuarios RESTART IDENTITY CASCADE;

-- Reactivar triggers
SET session_replication_role = 'origin';

RAISE NOTICE '✅ Datos eliminados correctamente';

-- =============================================
-- PASO 2: CARGAR DATOS DE PRUEBA
-- =============================================

\i SQL/DATOS_PRUEBA_COMPLETOS.sql

-- =============================================
-- PASO 3: VERIFICACIÓN FINAL
-- =============================================

DO $$
DECLARE
    v_usuarios INT;
    v_sitios INT;
    v_reseñas INT;
    v_fotos INT;
    v_seguidores INT;
    v_listas INT;
BEGIN
    SELECT COUNT(*) INTO v_usuarios FROM usuarios;
    SELECT COUNT(*) INTO v_sitios FROM sitios_turisticos;
    SELECT COUNT(*) INTO v_reseñas FROM reseñas;
    SELECT COUNT(*) INTO v_fotos FROM fotografias;
    SELECT COUNT(*) INTO v_seguidores FROM seguidores;
    SELECT COUNT(*) INTO v_listas FROM listas_personalizadas;

    RAISE NOTICE '';
    RAISE NOTICE '═══════════════════════════════════════';
    RAISE NOTICE '📊 RESUMEN DE DATOS CARGADOS';
    RAISE NOTICE '═══════════════════════════════════════';
    RAISE NOTICE 'Usuarios:          %', v_usuarios;
    RAISE NOTICE 'Sitios:            %', v_sitios;
    RAISE NOTICE 'Reseñas:           %', v_reseñas;
    RAISE NOTICE 'Fotografías:       %', v_fotos;
    RAISE NOTICE 'Seguidores:        %', v_seguidores;
    RAISE NOTICE 'Listas:            %', v_listas;
    RAISE NOTICE '═══════════════════════════════════════';
    RAISE NOTICE '';

    IF v_usuarios < 10 THEN
        RAISE WARNING '⚠️  Se esperaban al menos 10 usuarios, pero se encontraron %', v_usuarios;
    END IF;

    IF v_sitios < 20 THEN
        RAISE WARNING '⚠️  Se esperaban al menos 20 sitios, pero se encontraron %', v_sitios;
    END IF;

    RAISE NOTICE '✅ Reset completado exitosamente';
END $$;
