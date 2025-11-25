import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Programa standalone para generar y verificar hashes BCrypt
 *
 * COMPILAR Y EJECUTAR EN WINDOWS:
 * 1. Asegúrate de que el backend esté compilado (mvn compile)
 * 2. Ejecuta: mvn exec:java -Dexec.mainClass="GenerarHash"
 *
 * O desde IntelliJ IDEA:
 * 1. Abre este archivo
 * 2. Click derecho → Run 'GenerarHash.main()'
 */
public class GenerarHash {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(10); // strength 10

        String password = "password123";

        System.out.println("\n" + "=".repeat(80));
        System.out.println("GENERADOR Y VERIFICADOR DE HASH BCRYPT");
        System.out.println("=".repeat(80) + "\n");

        // Generar 3 hashes diferentes (BCrypt usa salt aleatorio)
        System.out.println("Generando 3 hashes diferentes para: " + password);
        System.out.println("-".repeat(80));

        String hash1 = encoder.encode(password);
        String hash2 = encoder.encode(password);
        String hash3 = encoder.encode(password);

        System.out.println("\nHash 1: " + hash1);
        System.out.println("Hash 2: " + hash2);
        System.out.println("Hash 3: " + hash3);

        System.out.println("\nNOTA: Los hashes son diferentes porque BCrypt usa un salt aleatorio,");
        System.out.println("      pero TODOS son válidos para la misma contraseña.\n");

        // Verificar todos los hashes
        System.out.println("Verificando que todos los hashes son válidos:");
        System.out.println("-".repeat(80));
        System.out.println("Hash 1 válido: " + encoder.matches(password, hash1));
        System.out.println("Hash 2 válido: " + encoder.matches(password, hash2));
        System.out.println("Hash 3 válido: " + encoder.matches(password, hash3));

        // Verificar el hash que proporcioné anteriormente
        System.out.println("\n\nVerificando el hash que Claude proporcionó:");
        System.out.println("-".repeat(80));
        String claudeHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        System.out.println("Hash: " + claudeHash);

        try {
            boolean isValid = encoder.matches(password, claudeHash);
            if (isValid) {
                System.out.println("✓ HASH VÁLIDO - Corresponde a '" + password + "'");
                System.out.println("\nPuedes usar este hash sin problema.");
            } else {
                System.out.println("✗ HASH INVÁLIDO - NO corresponde a '" + password + "'");
                System.out.println("\nDEBES usar uno de los hashes generados arriba.");
            }
        } catch (Exception e) {
            System.out.println("✗ ERROR - Hash mal formado: " + e.getMessage());
            System.out.println("\nDEBES usar uno de los hashes generados arriba.");
        }

        // Verificar el hash original inválido
        System.out.println("\n\nVerificando el hash ORIGINAL (datos_prueba.sql anterior):");
        System.out.println("-".repeat(80));
        String oldHash = "$2a$10$c.9tt.1nC6f.Lq.3v.iP0eE.j.w.C.H0C.F.w.t.M.s.J.q.C.b";
        System.out.println("Hash: " + oldHash);

        try {
            boolean isValid = encoder.matches(password, oldHash);
            System.out.println("Resultado: " + (isValid ? "✓ VÁLIDO" : "✗ INVÁLIDO"));
        } catch (Exception e) {
            System.out.println("✗ ERROR - Hash mal formado: " + e.getMessage());
        }

        // Instrucciones finales
        System.out.println("\n\n" + "=".repeat(80));
        System.out.println("INSTRUCCIONES PARA ACTUALIZAR LA BASE DE DATOS");
        System.out.println("=".repeat(80));
        System.out.println("\n1. Elige UNO de los hashes generados arriba (cualquiera sirve)");
        System.out.println("   Recomiendo usar Hash 1: " + hash1);
        System.out.println("\n2. Ejecuta este comando SQL en pgAdmin o psql:");
        System.out.println("\n   UPDATE usuarios");
        System.out.println("   SET contrasena_hash = '" + hash1 + "'");
        System.out.println("   WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');");
        System.out.println("\n3. Intenta iniciar sesión con:");
        System.out.println("   Email: ana@tbd.cl");
        System.out.println("   Password: password123");
        System.out.println("\n" + "=".repeat(80) + "\n");
    }
}
