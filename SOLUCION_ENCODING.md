# Solución al Problema de Encoding de Caracteres (ñ)

## Resumen del Problema
PostgreSQL almacenó la columna `total_reseñas` con una codificación diferente a la que Java estaba enviando en las consultas SQL, causando errores como:
```
ERROR: no existe la columna «total_reseñas»
Hint: Probablemente quiera hacer referencia a la columna «sitios_turisticos.total_reseÃ±as».
```

## Solución Implementada
Se renombró la columna problemática a `total_resenas` (sin la letra ñ) en toda la aplicación para evitar problemas de codificación de caracteres.

## Archivos Modificados

### Backend (Java)
1. **Backend/src/main/java/com/tbd/lab1tbd/Entities/SitioTuristico.java**
   - ✅ Campo `totalReseñas` → `totalResenas`

2. **Backend/src/main/java/com/tbd/lab1tbd/Repositories/SitioTuristicoRepository.java**
   - ✅ Constante `SELECT_COLUMNS` actualizada: `total_resenas`
   - ✅ RowMapper actualizado para leer `total_resenas`
   - ✅ Método `findPopulares()` actualizado

3. **Backend/src/main/java/com/tbd/lab1tbd/Repositories/ListaRepository.java**
   - ✅ RowMapper `SITIO_MAPPER` actualizado
   - ✅ Consulta SQL en `getSitiosByListaId()` actualizada

### Base de Datos (SQL)
4. **SQL/EJECUTAR_MIGRACION_COMPLETA.sql** (NUEVO)
   - Script principal que ejecuta toda la migración
   - Crea columna `total_resenas`
   - Copia datos desde la columna antigua
   - Actualiza el trigger

5. **SQL/update_trigger_column_name.sql** (NUEVO)
   - Actualiza la función del trigger para usar `total_resenas`

6. **SQL/consultas_enunciado.sql**
   - ✅ Consulta 1: `total_reseñas` → `total_resenas`
   - ✅ Consulta 4: `total_reseñas` → `total_resenas`
   - ✅ Consulta 5: `total_reseñas_por_ciudad` → `total_resenas_por_ciudad`

7. **SQL/INSTRUCCIONES_MIGRACION.md** (NUEVO)
   - Documentación completa del proceso de migración

### Frontend
- **No requiere cambios** - Ya usaba `totalResenas` (camelCase sin ñ)

## Pasos para Aplicar la Solución

### 1. Detener el Backend
Detén la aplicación Spring Boot si está corriendo.

### 2. Ejecutar Migración de Base de Datos
Abre PowerShell en la raíz del proyecto y ejecuta:

```powershell
psql -U postgres -d lab1tbd -f "SQL/EJECUTAR_MIGRACION_COMPLETA.sql"
```

Este script:
- ✅ Muestra el estado actual de las columnas
- ✅ Crea la nueva columna `total_resenas`
- ✅ Copia todos los datos (recalculando desde la tabla reseñas)
- ✅ Actualiza el trigger para usar la nueva columna
- ✅ Verifica que los datos se copiaron correctamente
- ✅ Hace COMMIT automáticamente

### 3. Recompilar el Backend
1. Abre el proyecto en IntelliJ IDEA
2. Ve a: **Build → Rebuild Project**
3. Espera a que termine la recompilación

### 4. Reiniciar el Backend
Inicia el servidor Spring Boot normalmente.

### 5. Probar los Endpoints
Ejecuta estos comandos para verificar que todo funciona:

```bash
# GET todos los sitios (requiere autenticación)
curl -H "Authorization: Bearer <tu_token>" http://localhost:8090/api/sitios

# GET sitios populares (requiere autenticación)
curl -H "Authorization: Bearer <tu_token>" http://localhost:8090/api/sitios/populares

# GET sitios por tipo (requiere autenticación)
curl -H "Authorization: Bearer <tu_token>" "http://localhost:8090/api/sitios/tipo?tipo=Parque"
```

O simplemente usa el frontend para probar.

## Verificación Post-Migración

### Verificar Columnas en PostgreSQL
```powershell
psql -U postgres -d lab1tbd -c "\d sitios_turisticos"
```

Deberías ver ambas columnas:
- `total_resenas` (nueva, la que se usa ahora)
- La columna antigua con el nombre mal codificado (puede aparecer como `total_rese├▒as`)

### Verificar Datos
```powershell
psql -U postgres -d lab1tbd -c "SELECT id, nombre, total_resenas FROM sitios_turisticos LIMIT 5;"
```

Deberías ver los conteos de reseñas correctamente.

### Verificar Trigger
Inserta una nueva reseña y verifica que actualiza `total_resenas`:

```sql
-- Insertar una reseña de prueba
INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion)
VALUES (1, 1, 'Excelente lugar!', 5);

-- Verificar que se actualizó total_resenas
SELECT id, nombre, calificacion_promedio, total_resenas
FROM sitios_turisticos
WHERE id = 1;
```

## (Opcional) Eliminar Columna Antigua

Si deseas limpiar completamente la base de datos:

```powershell
psql -U postgres -d lab1tbd
```

Dentro de psql:
```sql
-- Ver las columnas actuales
\d sitios_turisticos

-- Eliminar la columna antigua
-- (Necesitarás copiar el nombre exacto como aparece en \d)
-- Podría ser algo como:
ALTER TABLE sitios_turisticos DROP COLUMN total_reseÃ±as;
-- O sin acentos si Windows muestra caracteres extraños
```

**PRECAUCIÓN:** Solo haz esto DESPUÉS de verificar que todo funciona correctamente con la nueva columna.

## Problemas Conocidos

### "JWT expired"
Si ves este error en los logs del backend, simplemente:
1. Haz logout en el frontend
2. Vuelve a hacer login
3. Esto generará un nuevo token válido

### "Column already exists"
Si al ejecutar la migración ves: `column "total_resenas" already exists`
- Esto está bien, significa que ya ejecutaste el script antes
- El script es idempotente y no causará problemas

### Backend sigue mostrando errores de columna
1. Verifica que recompilaste el proyecto (**Rebuild Project**)
2. Reinicia completamente IntelliJ
3. Asegúrate de que no hay errores de compilación en la consola

## Archivos de Respaldo

Se crearon varios archivos SQL de respaldo/alternativos:
- `SQL/fix_column_encoding.sql` - Enfoque alternativo para verificar columnas
- `SQL/fix_column_name_simple.sql` - Versión más simple de la migración

No necesitas ejecutar estos archivos si `EJECUTAR_MIGRACION_COMPLETA.sql` funcionó correctamente.

## Contacto / Soporte

Si encuentras algún problema durante la migración, revisa:
1. Los logs del backend para errores específicos
2. Los logs de PostgreSQL
3. La salida del script de migración SQL

---

**Fecha de solución:** 2025-11-25
**Problema resuelto:** Encoding de caracteres especiales (ñ) en nombres de columnas PostgreSQL
