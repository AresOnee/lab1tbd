# 🔐 Verificación del Hash BCrypt

## ⚠️ Problema Reportado

El hash BCrypt proporcionado podría **NO corresponder** a la contraseña `password123`. Necesitamos verificarlo y generar uno correcto.

---

## ✅ Solución: Genera el Hash Correcto en TU Máquina

### Paso 1: Ejecutar el Generador de Hash

#### Opción A: Desde IntelliJ IDEA (MÁS FÁCIL)

1. Abre IntelliJ IDEA
2. Abre el proyecto `Backend`
3. Navega a: `Backend/GenerarHash.java`
4. Click derecho en el archivo → **Run 'GenerarHash.main()'**
5. Mira la salida en la consola

#### Opción B: Desde Terminal (CMD o PowerShell)

```cmd
cd Backend
mvnw.cmd exec:java -Dexec.mainClass="GenerarHash"
```

### Paso 2: Leer la Salida

El programa te mostrará:

1. **3 hashes diferentes generados** (todos válidos para `password123`)
2. **Verificación del hash que Claude proporcionó** (si es válido o no)
3. **Instrucciones SQL** para actualizar la base de datos

### Paso 3: Actualizar la Base de Datos

Copia el comando SQL que aparece en la salida del programa y ejecútalo en pgAdmin:

```sql
UPDATE usuarios
SET contrasena_hash = '<el-hash-generado>'
WHERE email IN ('ana@tbd.cl', 'bruno@tbd.cl', 'carla@tbd.cl');
```

---

## 🔍 ¿Por Qué BCrypt Genera Hashes Diferentes?

BCrypt usa un **salt aleatorio** cada vez que genera un hash, por eso:

```
password123 → $2a$10$ABC...  (válido)
password123 → $2a$10$XYZ...  (también válido)
password123 → $2a$10$123...  (también válido)
```

**Todos son diferentes, pero todos son válidos para la misma contraseña.**

---

## 📊 Estructura de un Hash BCrypt

```
$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
 │   │  │                                                          │
 │   │  │                                                          └─ Hash (31 chars)
 │   │  └─ Salt (22 chars)
 │   └─ Cost factor (10 = 2^10 = 1024 iterations)
 └─ Algorithm identifier ($2a = BCrypt)
```

---

## ❓ Preguntas Frecuentes

### 1. ¿El hash que Claude proporcionó es válido?

**Ejecuta `GenerarHash.java` para verificarlo.** El programa te dirá si es válido o no.

Si es válido:
- ✅ Puedes usarlo sin problema
- ✅ Ya está en `datos_prueba.sql`

Si NO es válido:
- ❌ Usa uno de los hashes generados por el programa
- ❌ Actualiza `SQL/datos_prueba.sql` y `SQL/actualizar_contraseñas.sql`

### 2. ¿Puedo usar cualquier hash generado?

Sí. BCrypt genera un salt aleatorio, así que cada ejecución produce un hash diferente. **Todos son válidos** para la misma contraseña.

### 3. ¿Cómo verifico que un hash corresponde a una contraseña?

```java
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
boolean matches = encoder.matches("password123", "$2a$10$...");
System.out.println("Válido: " + matches);
```

O usa el programa `GenerarHash.java` que ya hace esto.

### 4. ¿Por qué el hash original era inválido?

El hash original era:
```
$2a$10$c.9tt.1nC6f.Lq.3v.iP0eE.j.w.C.H0C.F.w.t.M.s.J.q.C.b
```

Tiene caracteres **inválidos** (los puntos no pertenecen al alfabeto BCrypt). BCrypt usa este alfabeto:
```
./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
```

---

## 🎯 Resumen

1. **Ejecuta `GenerarHash.java`** en tu máquina Windows
2. **Copia el hash generado** (usa Hash 1)
3. **Ejecuta el UPDATE SQL** en pgAdmin
4. **Intenta iniciar sesión** con `ana@tbd.cl` / `password123`
5. **¡Debería funcionar!**

---

## 📝 Notas Importantes

- **NO edites el hash manualmente** - debe ser generado por BCrypt
- **Ejecuta el programa en TU máquina** - yo no puedo generar hashes aquí (estoy offline)
- **Verifica ANTES de actualizar** - asegúrate de que el hash sea válido

---

## 🆘 Si Nada Funciona

Si después de ejecutar `GenerarHash.java` y actualizar la base de datos el login sigue fallando:

1. Verifica los logs del backend
2. Comparte el error exacto
3. Verifica que la contraseña en la BD sea exactamente el hash generado (sin espacios extra)
4. Asegúrate de que el backend esté usando BCrypt (ya debería estarlo)

---

**¡Ejecuta `GenerarHash.java` y compárteme el resultado!** Así sabré si el hash que proporcioné es válido o necesitas usar uno nuevo.
