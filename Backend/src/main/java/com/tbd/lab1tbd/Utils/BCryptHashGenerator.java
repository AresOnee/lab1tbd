package com.tbd.lab1tbd.Utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utilidad para generar y verificar hashes BCrypt
 * Ejecutar con: mvn exec:java -Dexec.mainClass="com.tbd.lab1tbd.Utils.BCryptHashGenerator"
 */
public class BCryptHashGenerator {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        String password = "password123";

        System.out.println("=".repeat(80));
        System.out.println("GENERADOR DE HASH BCRYPT");
        System.out.println("=".repeat(80));
        System.out.println();

        // Generar hash
        String hash = encoder.encode(password);
        System.out.println("Contraseña: " + password);
        System.out.println("Hash BCrypt generado:");
        System.out.println(hash);
        System.out.println();

        // Verificar que el hash funciona
        boolean matches = encoder.matches(password, hash);
        System.out.println("Verificación: " + (matches ? "✓ VÁLIDO" : "✗ INVÁLIDO"));
        System.out.println();

        // Verificar el hash anterior (el que estaba incorrecto)
        String oldInvalidHash = "$2a$10$c.9tt.1nC6f.Lq.3v.iP0eE.j.w.C.H0C.F.w.t.M.s.J.q.C.b";
        System.out.println("Hash anterior (INVÁLIDO):");
        System.out.println(oldInvalidHash);
        try {
            boolean oldMatches = encoder.matches(password, oldInvalidHash);
            System.out.println("Verificación hash anterior: " + (oldMatches ? "✓ VÁLIDO" : "✗ INVÁLIDO"));
        } catch (Exception e) {
            System.out.println("Verificación hash anterior: ✗ ERROR - " + e.getMessage());
        }
        System.out.println();

        // Verificar el hash que proporcioné
        String myHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        System.out.println("Hash que proporcioné:");
        System.out.println(myHash);
        try {
            boolean myMatches = encoder.matches(password, myHash);
            System.out.println("Verificación mi hash: " + (myMatches ? "✓ VÁLIDO" : "✗ INVÁLIDO"));
        } catch (Exception e) {
            System.out.println("Verificación mi hash: ✗ ERROR - " + e.getMessage());
        }
        System.out.println();

        System.out.println("=".repeat(80));
        System.out.println("INSTRUCCIONES:");
        System.out.println("=".repeat(80));
        System.out.println("1. Copia el hash generado arriba");
        System.out.println("2. Actualiza la base de datos con este comando SQL:");
        System.out.println();
        System.out.println("   UPDATE usuarios");
        System.out.println("   SET contrasena_hash = '" + hash + "'");
        System.out.println("   WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');");
        System.out.println();
        System.out.println("3. También actualiza SQL/datos_prueba.sql con este hash");
        System.out.println("=".repeat(80));
    }
}
