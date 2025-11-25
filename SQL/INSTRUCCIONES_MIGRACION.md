# Instrucciones para Migración de Columna total_reseñas → total_resenas

## Problema
La columna `total_reseñas` en la tabla `sitios_turisticos` tiene un problema de codificación de caracteres. PostgreSQL la almacenó con un encoding diferente, causando errores como:
```
ERROR: no existe la columna «total_reseñas»
Hint: Probablemente quiera hacer referencia a la columna «sitios_turisticos.total_reseÃ±as».
```

## Solución
Renombrar la columna a `total_resenas` (sin ñ) para evitar problemas de encoding.

## Pasos a Ejecutar

### 1. Detener el Backend
Asegúrate de que la aplicación Spring Boot esté detenida para evitar errores durante la migración.

### 2. Ejecutar el Script de Migración
Abre PowerShell o CMD y ejecuta:

```powershell
psql -U postgres -d lab1tbd -f "SQL/EJECUTAR_MIGRACION_COMPLETA.sql"
```

Este script hará:
- ✅ Crear la columna `total_resenas` (sin ñ)
- ✅ Copiar todos los datos desde la columna antigua
- ✅ Actualizar el trigger para usar la nueva columna
- ✅ Verificar que los datos se copiaron correctamente

### 3. Verificar los Resultados
El script mostrará:
- Estado actual de las columnas
- Datos copiados (primeros 10 registros)
- Columnas después de la migración

Si todo se ve correcto, el script hará COMMIT automáticamente.

### 4. (Opcional) Eliminar la Columna Antigua
Si deseas eliminar la columna antigua con encoding problemático:

```powershell
psql -U postgres -d lab1tbd
```

Dentro de psql, ejecuta:
```sql
\d sitios_turisticos
```

Identifica la columna con el nombre mal codificado (probablemente aparecerá como `total_rese├▒as` o similar en Windows).

Luego intenta eliminarla (ajusta el nombre según lo que veas):
```sql
DROP TABLE IF EXISTS temp_backup;
CREATE TABLE temp_backup AS SELECT * FROM sitios_turisticos;

-- Opción 1: Si puedes ver el nombre exacto, intenta:
-- ALTER TABLE sitios_turisticos DROP COLUMN <nombre_exacto>;

-- Opción 2: Si no funciona, recrear la tabla sin esa columna:
-- Ver INSTRUCCIONES_RECREAR_TABLA.sql
```

### 5. Reiniciar el Backend
Ya se actualizó el código Java para usar `total_resenas`. Simplemente:
1. Abre el proyecto en IntelliJ IDEA
2. Haz "Rebuild Project"
3. Inicia el backend normalmente

## Archivos Modificados

### Backend (Java)
- ✅ `Entities/SitioTuristico.java` - Campo renombrado de `totalReseñas` a `totalResenas`
- ✅ `Repositories/SitioTuristicoRepository.java` - Consultas SQL actualizadas

### Base de Datos (SQL)
- ✅ Nueva columna `total_resenas` creada
- ✅ Trigger actualizado

## Verificación Final
Después de reiniciar el backend, prueba estos endpoints:
- GET http://localhost:8090/api/sitios (debe funcionar)
- GET http://localhost:8090/api/sitios/populares (debe funcionar)
- GET http://localhost:8090/api/sitios/tipo?tipo=Parque (debe funcionar)

Si ves errores de "JWT expired", simplemente haz login nuevamente desde el frontend.

## Problemas Comunes

**Error: "column total_resenas already exists"**
- Significa que ya ejecutaste el script antes. Esto está bien, el script es idempotente.

**Error: "no existe la columna total_reseñas" al intentar eliminarla**
- Esto es esperado debido al encoding. Usa la opción de recrear la tabla si es necesario.

**Backend aún muestra errores**
- Asegúrate de haber hecho "Rebuild Project" en IntelliJ
- Verifica que no haya errores de compilación
- Reinicia completamente el servidor
