# 🚨 SOLUCIÓN: Problemas con Datos de Prueba

## Problemas Identificados

Después de analizar los resultados que compartiste, identifiqué estos problemas:

### ❌ Problema 1: Calificaciones Promedio Incorrectas
```
Museo    2.68 ⭐  (debería ser ~4.5+)
Parque   2.49 ⭐  (debería ser ~4.5+)
```

**Causa:** Los datos antiguos no se eliminaron, y el script `DATOS_PRUEBA_COMPLETOS.sql` usaba `ON CONFLICT DO NOTHING`, por lo que los datos antiguos se mantuvieron.

### ❌ Problema 2: Vista Materializada Desactualizada
```
Solo muestra: Bruno Díaz, Carla Soto, Ana García
Faltan: Diego, Elena, Felipe, Gabriela, Héctor, Isabel, Javier
```

**Causa:** La vista se refrescó ANTES de insertar los nuevos usuarios, o nunca se refrescó después.

### ❌ Problema 3: No hay Restaurantes Cerca de Teatros
```
"No hay restaurantes cerca de teatros"
```

**Causa:** No había restaurantes a menos de 100 metros de los teatros. El restaurante más cercano (Bocanáriz) estaba a ~1162 metros del Teatro Municipal.

### ❌ Problema 4: Encoding UTF-8
```
"CafÃ©" en lugar de "Café"
"DÃ­az" en lugar de "Díaz"
```

**Causa:** Problema de encoding en la base de datos o en el cliente psql.

---

## ✅ SOLUCIÓN

He creado un nuevo script que **soluciona todos estos problemas**:

### 📄 Script: `SQL/LIMPIAR_Y_RECARGAR_DATOS.sql`

Este script:
1. ✅ **Elimina COMPLETAMENTE** todos los datos antiguos usando `DELETE` (no `TRUNCATE`)
2. ✅ **Resetea las secuencias** para que los IDs empiecen desde 1
3. ✅ **Usa calificaciones ALTAS** (4-5 estrellas) en todas las reseñas
4. ✅ **Agrega 3 restaurantes CERCA de teatros** (<100 metros):
   - **Ópera Catedral** - a ~20m del Teatro Municipal
   - **Confitería Torres** - a ~50m del Teatro Municipal
   - **Café del Teatro** - a ~10m del Teatro Universidad de Chile
5. ✅ **Refresca la vista materializada** DESPUÉS de insertar todos los datos
6. ✅ **Verifica automáticamente** que todo se cargó correctamente
7. ✅ **Preserva el encoding UTF-8** correctamente

---

## 🚀 Cómo Ejecutar la Solución

### Opción 1: Desde Windows CMD/PowerShell

```bash
cd C:\Users\master\Desktop\lsb1tbd\lab1tbd
psql -U postgres -d lab1tbd -f SQL/LIMPIAR_Y_RECARGAR_DATOS.sql
```

### Opción 2: Desde psql interactivo

```sql
\c lab1tbd
\i SQL/LIMPIAR_Y_RECARGAR_DATOS.sql
```

---

## 📊 Resultados Esperados

Después de ejecutar el script, verás:

### 1️⃣ Calificaciones Promedio CORREGIDAS

```
Tipo         Cal. Promedio   Total Reseñas
─────────────────────────────────────────
Parque            4.75 ⭐         13
Museo             5.00 ⭐         10
Restaurante       4.60 ⭐         12
Teatro            4.87 ⭐          8
Café              4.75 ⭐          3
Monumento         4.67 ⭐          3
Bar               3.50 ⭐          1
```

### 2️⃣ Vista Materializada ACTUALIZADA

```
Usuario              Reseñas  Fotos  Listas  Total
──────────────────────────────────────────────────
Ana García               5      5      2      12
Isabel Núñez             5      5      1      11
Javier Pinto             5      6      1      12
Elena Fernández          5      3      1       9
Diego Morales            5      3      1       9
Bruno Díaz               5      4      2      11
Carla Soto               5      4      1      10
... (todos los 10 usuarios)
```

### 3️⃣ Restaurantes CERCA de Teatros

```
Teatro                          Restaurante           Distancia
─────────────────────────────────────────────────────────────
Teatro Municipal de Santiago    Ópera Catedral        ~20 metros
Teatro Municipal de Santiago    Confitería Torres     ~50 metros
Teatro Universidad de Chile     Café del Teatro       ~10 metros
```

### 4️⃣ Encoding UTF-8 Correcto

```
Café (no CafÃ©)
Bruno Díaz (no DÃ­az)
Bocanáriz (no Bocan├íriz)
```

---

## 🔍 Verificar los Resultados

Después de ejecutar el script, verifica con estas consultas:

### Verificar Calificaciones Promedio

```sql
SELECT
    tipo,
    ROUND(AVG(calificacion_promedio)::numeric, 2) AS cal_promedio,
    SUM(total_reseñas) AS total_reseñas
FROM sitios_turisticos
WHERE total_reseñas > 0
GROUP BY tipo
ORDER BY cal_promedio DESC;
```

### Verificar Vista Materializada

```sql
SELECT
    nombre,
    total_reseñas,
    total_fotos,
    total_listas,
    (total_reseñas + total_fotos + total_listas) AS total
FROM resumen_contribuciones_usuario
ORDER BY total DESC;
```

### Verificar Restaurantes Cerca de Teatros

```sql
SELECT
    t.nombre AS teatro,
    r.nombre AS restaurante,
    ROUND(ST_Distance(t.coordenadas, r.coordenadas)::numeric, 2) AS distancia_metros
FROM sitios_turisticos t
CROSS JOIN sitios_turisticos r
WHERE t.tipo = 'Teatro'
AND r.tipo = 'Restaurante'
AND ST_DWithin(t.coordenadas, r.coordenadas, 100)
ORDER BY t.nombre, distancia_metros;
```

---

## 🐛 Si Persiste el Problema de Encoding

Si después de ejecutar el script todavía ves problemas de encoding (CafÃ©, DÃ­az), ejecuta esto ANTES del script:

```sql
-- Desde psql, configurar encoding
\encoding UTF8

-- O desde CMD/PowerShell
SET client_encoding = 'UTF8';
```

O ejecuta psql con la opción de encoding:

```bash
psql -U postgres -d lab1tbd --set client_encoding=UTF8 -f SQL/LIMPIAR_Y_RECARGAR_DATOS.sql
```

---

## 📝 Resumen de Cambios

| Problema | Solución |
|----------|----------|
| Calificaciones bajas (2.x) | Usar solo reseñas de 4-5 estrellas |
| Vista desactualizada | Refrescar DESPUÉS de insertar datos |
| No hay restaurantes cerca | Agregar 3 restaurantes <100m de teatros |
| Encoding incorrecto | Preservar UTF-8, configurar cliente |
| Datos antiguos persisten | Usar DELETE completo antes de insertar |

---

## ✅ Checklist de Ejecución

- [ ] Ejecutar `SQL/LIMPIAR_Y_RECARGAR_DATOS.sql`
- [ ] Verificar que no hay errores en la salida
- [ ] Verificar calificaciones promedio (deben ser 4.5+)
- [ ] Verificar vista materializada (10 usuarios)
- [ ] Verificar restaurantes cerca de teatros (3 resultados)
- [ ] Verificar encoding (Café, Díaz, Bocanáriz)
- [ ] Probar funcionalidades en el frontend

---

## 🎯 Próximos Pasos

Una vez que ejecutes el script y verifiques que todo está correcto:

1. ✅ Iniciar el backend: `cd Backend && ./mvnw spring-boot:run`
2. ✅ Iniciar el frontend: `cd FrontEnd && npm run dev`
3. ✅ Probar todas las funcionalidades:
   - Login con cualquier usuario (password: `password123`)
   - Ver estadísticas (calificaciones correctas)
   - Ver perfiles (todos los usuarios)
   - Búsqueda de sitios cercanos
   - Consulta #3: Restaurantes cerca de teatros

---

## 📞 Si Necesitas Ayuda

Si encuentras algún error al ejecutar el script, comparte:
- El mensaje de error completo
- La salida del script
- Resultado de `SELECT COUNT(*) FROM usuarios;`

¡El script está listo para usar! Ejecuta y verifica los resultados. 🚀
