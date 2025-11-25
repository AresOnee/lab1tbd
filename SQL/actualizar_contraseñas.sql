-- =============================================
-- Script para actualizar contraseñas con hash BCrypt válido
-- =============================================

-- INFORMACIÓN IMPORTANTE:
-- Contraseña para todos los usuarios: password123
-- Hash BCrypt válido (generado con BCrypt strength 10)
-- $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy

-- Actualizar las contraseñas de los usuarios existentes
UPDATE usuarios
SET contrasena_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');

-- Verificar las actualizaciones
SELECT id, nombre, email,
       LEFT(contrasena_hash, 20) || '...' as hash_preview
FROM usuarios
WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');
