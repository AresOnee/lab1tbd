-- Actualizar con el hash BCrypt VÁLIDO para 'password123'
-- Hash generado y verificado por GenerarHash.java
-- Este hash tiene 60 caracteres y es válido

BEGIN;

UPDATE usuarios
SET contrasena_hash = '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2'
WHERE email = 'ana@tbd.cl';

-- Verificar el cambio
SELECT
    email,
    contrasena_hash,
    length(contrasena_hash) as longitud,
    CASE
        WHEN length(contrasena_hash) = 60 THEN '✅ HASH CORRECTO'
        ELSE '❌ HASH INCORRECTO'
    END as estado
FROM usuarios
WHERE email = 'ana@tbd.cl';

COMMIT;
