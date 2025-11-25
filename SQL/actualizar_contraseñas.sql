-- =============================================
-- Script para actualizar contraseñas con hash BCrypt válido
-- =============================================

-- INFORMACIÓN IMPORTANTE:
-- Contraseña para todos los usuarios: password123
-- Hash BCrypt VÁLIDO Y VERIFICADO (generado con BCrypt strength 10)
-- $2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2
-- Este hash fue generado y verificado con GenerarHash.java

-- Actualizar las contraseñas de los usuarios existentes
UPDATE usuarios
SET contrasena_hash = '$2a$10$eA95nPuWcZ.TC7KA5i1OveQ/FJzUTssTaRrJbcmGzPijoIWY8F.O2'
WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');

-- Verificar las actualizaciones
SELECT id, nombre, email,
       LEFT(contrasena_hash, 20) || '...' as hash_preview
FROM usuarios
WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');
