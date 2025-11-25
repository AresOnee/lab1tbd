# 🔐 Instrucciones para Solucionar el Login

## Problema

Las contraseñas en la base de datos tienen un **hash BCrypt inválido**, por eso Spring Security las rechaza con el error:

```
WARN ... BCryptPasswordEncoder : Encoded password does not look like BCrypt
```

## Solución: Actualizar las Contraseñas

### Paso 1: Ejecutar el Script SQL

Abre pgAdmin o psql y ejecuta el archivo `actualizar_contraseñas.sql`:

#### Opción A: Con psql (línea de comandos)

```bash
psql -U postgres -d lab1tbd -f SQL/actualizar_contraseñas.sql
```

#### Opción B: Con pgAdmin

1. Abre pgAdmin
2. Conecta a la base de datos `lab1tbd`
3. Abre el Query Tool (Tools → Query Tool)
4. Copia y pega el contenido de `actualizar_contraseñas.sql`
5. Ejecuta (F5 o ícono de ▶️)

#### Opción C: Comando SQL directo

Simplemente ejecuta este comando en tu base de datos:

```sql
UPDATE usuarios
SET contrasena_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'
WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');
```

### Paso 2: Probar el Login

Ahora puedes iniciar sesión con:

| Email | Contraseña |
|-------|------------|
| `ana@tbd.cl` | `password123` |
| `bruno@tbd.cl` | `password123` |
| `carla@tbd.cl` | `password123` |

---

## 📝 Notas Importantes

1. **Todos los usuarios tienen la misma contraseña:** `password123`

2. **El hash BCrypt es válido:** `$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy`

3. **No puedes registrarte con `ana@tbd.cl`** porque ya existe. Usa otro email o inicia sesión directamente.

4. **Para registrar un nuevo usuario:**
   - Usa un email diferente (ejemplo: `damian@tbd.cl`)
   - El backend automáticamente hasheará la contraseña con BCrypt
   - Podrás iniciar sesión inmediatamente después del registro

---

## ❓ Preguntas Frecuentes

### ¿Por qué falló el hash original?

El hash en `datos_prueba.sql` era:
```
$2a$10$c.9tt.1nC6f.Lq.3v.iP0eE.j.w.C.H0C.F.w.t.M.s.J.q.C.b
```

Este hash tiene caracteres inválidos (puntos en lugares incorrectos). Un hash BCrypt válido usa el alfabeto BCrypt específico: `./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`

### ¿Cómo genero un hash BCrypt para testing?

Puedes usar herramientas online o este código Java:

```java
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class HashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "password123";
        String hash = encoder.encode(password);
        System.out.println("Hash: " + hash);
    }
}
```

### ¿Qué pasa si olvido la contraseña?

Para desarrollo, simplemente ejecuta el UPDATE nuevamente con el hash que quieras. Para producción, necesitarías implementar un sistema de "olvidé mi contraseña" con tokens temporales.

---

## ✅ Verificación

Después de actualizar las contraseñas, verifica que el hash sea correcto:

```sql
SELECT email, LEFT(contrasena_hash, 7) as hash_prefix
FROM usuarios;
```

Deberías ver:
```
     email     | hash_prefix
---------------|-------------
 ana@tbd.cl    | $2a$10$
 bruno@tbd.cl  | $2a$10$
 carla@tbd.cl  | $2a$10$
```

El prefijo `$2a$10$` indica BCrypt con strength 10 (10 rondas).
