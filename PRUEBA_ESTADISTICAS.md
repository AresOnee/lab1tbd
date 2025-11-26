# 📊 Guía de Pruebas: Dashboard de Estadísticas

## ✅ Funcionalidad Implementada

Dashboard visual que muestra las 7 consultas SQL del enunciado del laboratorio como estadísticas en tiempo real.

---

## ⚠️ ANTES DE EMPEZAR

### 1. Verificar que Backend está corriendo
```bash
# Backend debe estar en http://localhost:8090
# Verifica en los logs de Spring Boot que no haya errores
```

### 2. Verificar que Frontend está corriendo
```bash
cd FrontEnd
npm run dev
# Debe estar en http://localhost:5173
```

### 3. Tener datos de prueba

Para que las estadísticas sean interesantes, necesitas:
- ✅ Múltiples sitios turísticos de diferentes tipos
- ✅ Varias reseñas de diferentes usuarios
- ✅ Algunas fotografías
- ✅ Al menos un teatro y un restaurante cercano (para análisis de proximidad)

Si no tienes datos, puedes crearlos desde la interfaz o usar los datos de prueba del script SQL.

---

## 🧪 GUÍA DE PRUEBAS PASO A PASO

### ✅ Prueba 1: Acceder al Dashboard

**Pasos**:
1. Abrir http://localhost:5173
2. Iniciar sesión con:
   - Email: `ana@tbd.cl`
   - Contraseña: `password123`
3. En el navbar, hacer clic en **"📊 Estadísticas"**

**Resultado Esperado**:
- ✅ Redirige a `/estadisticas`
- ✅ Se muestra el título "📊 Panel de Estadísticas"
- ✅ Aparece botón "🔄 Recargar Todas las Estadísticas"
- ✅ Se muestran varias tarjetas con estadísticas
- ✅ Mensaje "⏳ Cargando..." mientras se obtienen los datos
- ✅ Las tarjetas se llenan con datos (o muestran "No hay datos disponibles")

---

### ✅ Prueba 2: Consulta #1 - Estadísticas por Tipo

**Ubicación**: Primera tarjeta (lado izquierdo superior)

**Qué muestra**:
- Tabla con columnas: Tipo | Cal. Promedio | Total Reseñas
- Cada fila es un tipo de sitio (Parque, Museo, Restaurante, Teatro, etc.)

**Resultado Esperado**:
- ✅ Muestra todos los tipos de sitios que existen en la BD
- ✅ Calificación promedio tiene formato: `4.50 ⭐`
- ✅ Total de reseñas es un número entero
- ✅ Los datos coinciden con lo que hay en la base de datos

**Verificación Manual**:
```sql
-- Ejecutar en psql para verificar
SELECT
    tipo,
    AVG(calificacion_promedio) AS calificacion_promedio_general,
    SUM(total_resenas) AS total_resenas_general
FROM sitios_turisticos
GROUP BY tipo
ORDER BY total_resenas_general DESC;
```

---

### ✅ Prueba 3: Consulta #2 - Top Reseñadores

**Ubicación**: Segunda tarjeta (lado derecho superior)

**Qué muestra**:
- Leaderboard (ranking) de los 5 usuarios más activos
- Solo cuenta reseñas de los últimos 6 meses
- Formato: `1° Nombre Usuario - X reseñas`

**Resultado Esperado**:
- ✅ Máximo 5 usuarios
- ✅ Ordenados de mayor a menor número de reseñas
- ✅ Números de ranking: 1°, 2°, 3°, 4°, 5°
- ✅ Si no hay reseñas recientes: "No hay reseñadores activos en los últimos 6 meses"

**Verificación Manual**:
```sql
-- Ejecutar en psql
WITH ResenasRecientes AS (
    SELECT
        id_usuario,
        COUNT(*) AS conteo_resenas
    FROM reseñas
    WHERE fecha >= (CURRENT_TIMESTAMP - INTERVAL '6 months')
    GROUP BY id_usuario
)
SELECT
    u.nombre,
    rr.conteo_resenas
FROM ResenasRecientes rr
JOIN usuarios u ON rr.id_usuario = u.id
ORDER BY rr.conteo_resenas DESC
LIMIT 5;
```

---

### ✅ Prueba 4: Consulta #3 - Análisis de Proximidad

**Ubicación**: Tercera tarjeta (ancho completo)

**Qué muestra**:
- Tabla de restaurantes que están a menos de 100 metros de teatros
- Columnas: Teatro | Restaurante | Distancia

**Resultado Esperado**:
- ✅ Solo muestra pares teatro-restaurante que están cerca (<100m)
- ✅ Distancia en formato: `45.3m`
- ✅ Si no hay sitios cercanos: "No hay restaurantes cerca de teatros"

**Cómo generar datos de prueba**:
```sql
-- Crear un teatro
INSERT INTO sitios_turisticos (nombre, tipo, coordenadas)
VALUES (
    'Teatro Municipal',
    'Teatro',
    ST_SetSRID(ST_MakePoint(-70.6506, -33.4372), 4326)
);

-- Crear un restaurante cercano (a ~50 metros)
INSERT INTO sitios_turisticos (nombre, tipo, coordenadas)
VALUES (
    'Restaurante Central',
    'Restaurante',
    ST_SetSRID(ST_MakePoint(-70.6501, -33.4372), 4326)
);
```

**Verificación Manual**:
```sql
SELECT
    t.nombre AS nombre_teatro,
    r.nombre AS nombre_restaurante,
    ST_Distance(t.coordenadas, r.coordenadas) AS distancia_en_metros
FROM sitios_turisticos t
JOIN sitios_turisticos r ON ST_DWithin(t.coordenadas, r.coordenadas, 100)
WHERE t.tipo = 'Teatro' AND r.tipo = 'Restaurante' AND t.id != r.id
ORDER BY distancia_en_metros ASC;
```

---

### ✅ Prueba 5: Consulta #4 - Valoraciones Inusuales

**Ubicación**: Cuarta tarjeta (lado izquierdo)

**Qué muestra**:
- Lista de sitios con:
  - Calificación promedio > 4.5
  - Menos de 10 reseñas
- Útil para encontrar sitios prometedores o con pocas evaluaciones

**Resultado Esperado**:
- ✅ Cada sitio muestra: nombre, calificación (ej: `⭐ 4.8`), número de reseñas
- ✅ Solo sitios que cumplan ambas condiciones
- ✅ Si no hay: "No hay sitios con estas características"

**Verificación Manual**:
```sql
SELECT nombre, calificacion_promedio, total_resenas
FROM sitios_turisticos
WHERE calificacion_promedio > 4.5
    AND total_resenas < 10
    AND total_resenas > 0
ORDER BY calificacion_promedio DESC;
```

---

### ✅ Prueba 6: Consulta #7 - Sitios con Pocas Contribuciones

**Ubicación**: Quinta tarjeta (lado derecho)

**Qué muestra**:
- Sitios sin actividad (reseñas o fotos) en los últimos 3 meses
- Muestra máximo 10 sitios + contador de adicionales
- Fecha de última contribución o "Sin actividad"

**Resultado Esperado**:
- ✅ Lista de sitios con tipo y fecha
- ✅ Fecha en formato: `dic 2024` o `Sin actividad`
- ✅ Si hay más de 10: "+ X sitios más"
- ✅ Si todos tienen actividad reciente: "Todos los sitios tienen actividad reciente"

**Verificación Manual**:
```sql
WITH UltimasContribuciones AS (
    SELECT
        id_sitio,
        MAX(fecha) AS ultima_fecha
    FROM (
        SELECT id_sitio, fecha FROM reseñas
        UNION ALL
        SELECT id_sitio, fecha FROM fotografias
    ) AS contribuciones
    GROUP BY id_sitio
)
SELECT
    s.nombre,
    s.tipo,
    uc.ultima_fecha
FROM sitios_turisticos s
LEFT JOIN UltimasContribuciones uc ON s.id = uc.id_sitio
WHERE uc.ultima_fecha IS NULL
    OR uc.ultima_fecha < (CURRENT_TIMESTAMP - INTERVAL '3 months')
ORDER BY uc.ultima_fecha ASC NULLS FIRST;
```

---

### ✅ Prueba 7: Consulta #8 - Reseñas Más Largas

**Ubicación**: Sexta tarjeta (ancho completo)

**Qué muestra**:
- Top 3 reseñas más extensas
- Solo de usuarios que tienen promedio de calificación > 4.0
- Muestra: autor, sitio, contenido completo, longitud

**Resultado Esperado**:
- ✅ Máximo 3 reseñas
- ✅ Ordenadas por longitud (más larga primero)
- ✅ Ranking: #1, #2, #3
- ✅ Longitud en formato: `523 caracteres`
- ✅ Contenido de la reseña entre comillas
- ✅ Si no hay: "No hay reseñas disponibles"

**Verificación Manual**:
```sql
WITH PromedioUsuario AS (
    SELECT
        id_usuario,
        AVG(calificacion) AS promedio_calificacion
    FROM reseñas
    GROUP BY id_usuario
    HAVING AVG(calificacion) > 4.0
)
SELECT
    u.nombre AS nombre_usuario,
    s.nombre AS nombre_sitio,
    r.contenido,
    LENGTH(r.contenido) AS longitud_resena
FROM reseñas r
JOIN usuarios u ON r.id_usuario = u.id
JOIN sitios_turisticos s ON r.id_sitio = s.id
JOIN PromedioUsuario pu ON r.id_usuario = pu.id_usuario
ORDER BY longitud_resena DESC
LIMIT 3;
```

---

### ✅ Prueba 8: Consulta #9 - Resumen de Contribuciones

**Ubicación**: Séptima tarjeta (ancho completo, al final)

**Qué muestra**:
- Tabla con todos los usuarios y sus contribuciones totales
- Columnas: Usuario | Reseñas | Fotos | Listas | Total
- Datos de la vista materializada `resumen_contribuciones_usuario`

**Resultado Esperado**:
- ✅ Todos los usuarios del sistema
- ✅ Columna "Total" suma las tres contribuciones
- ✅ Ordenado por número de reseñas (de mayor a menor)
- ✅ Si no hay usuarios con contribuciones: "No hay usuarios con contribuciones"

**Verificación Manual**:
```sql
-- Ver la vista materializada
SELECT * FROM resumen_contribuciones_usuario
ORDER BY total_resenas DESC;

-- Si está desactualizada, refrescarla:
REFRESH MATERIALIZED VIEW CONCURRENTLY resumen_contribuciones_usuario;
```

---

### ✅ Prueba 9: Botón de Recarga

**Pasos**:
1. En el dashboard, hacer clic en **"🔄 Recargar Todas las Estadísticas"**
2. Observar el comportamiento

**Resultado Esperado**:
- ✅ Botón muestra "⏳ Cargando..." mientras recarga
- ✅ Botón queda deshabilitado durante la carga
- ✅ Todas las tarjetas se actualizan con datos frescos
- ✅ Si hay errores en alguna consulta, las demás siguen mostrando datos

---

### ✅ Prueba 10: Responsive Design

**Pasos**:
1. Abrir el dashboard
2. Redimensionar la ventana del navegador
3. Probar en móvil (F12 → Toggle Device Toolbar)

**Resultado Esperado**:
- ✅ En pantallas grandes: Grid de 2 columnas
- ✅ En móvil: Una sola columna
- ✅ Tarjetas de "ancho completo" se mantienen en una columna
- ✅ Tablas se desplazan horizontalmente si es necesario
- ✅ Todo el contenido es legible

---

## 🔍 VERIFICACIÓN TÉCNICA

### Verificar Endpoints con cURL

```bash
# 1. Login para obtener token
curl -X POST http://localhost:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ana@tbd.cl","password":"password123"}'

# Copiar el token y usarlo en las siguientes peticiones

TOKEN="tu_token_aqui"

# 2. Probar cada endpoint

# Consulta #1
curl -X GET http://localhost:8090/api/estadisticas/por-tipo \
  -H "Authorization: Bearer $TOKEN"

# Consulta #2
curl -X GET http://localhost:8090/api/estadisticas/top-resenadores \
  -H "Authorization: Bearer $TOKEN"

# Consulta #3
curl -X GET http://localhost:8090/api/estadisticas/proximidad \
  -H "Authorization: Bearer $TOKEN"

# Consulta #4
curl -X GET http://localhost:8090/api/estadisticas/valoraciones-inusuales \
  -H "Authorization: Bearer $TOKEN"

# Consulta #7
curl -X GET http://localhost:8090/api/estadisticas/pocas-contribuciones \
  -H "Authorization: Bearer $TOKEN"

# Consulta #8
curl -X GET http://localhost:8090/api/estadisticas/resenas-largas \
  -H "Authorization: Bearer $TOKEN"

# Consulta #9
curl -X GET http://localhost:8090/api/estadisticas/resumen-contribuciones \
  -H "Authorization: Bearer $TOKEN"
```

### Verificar en DevTools

1. Abrir DevTools (F12)
2. Ir a pestaña **Network**
3. Recargar el dashboard
4. Verificar que se hacen 7 peticiones a `/api/estadisticas/*`
5. Todas deben retornar **200 OK**
6. Revisar el contenido JSON de las respuestas

---

## 🐛 SOLUCIÓN DE PROBLEMAS

### Problema 1: "No hay datos disponibles" en todas las tarjetas

**Causa**: No hay suficientes datos en la base de datos

**Solución**:
```sql
-- Verificar que hay datos
SELECT COUNT(*) FROM sitios_turisticos;
SELECT COUNT(*) FROM reseñas;
SELECT COUNT(*) FROM fotografias;

-- Si no hay datos, cargar datos de prueba
\i SQL/datos_prueba.sql
```

### Problema 2: Error 403 en las peticiones

**Causa**: Token JWT inválido o expirado

**Solución**:
1. Cerrar sesión
2. Volver a iniciar sesión
3. Intentar nuevamente

### Problema 3: "No hay restaurantes cerca de teatros"

**Causa**: No hay sitios de estos tipos cercanos entre sí

**Solución**: Crear datos de prueba (ver Prueba 4 arriba)

### Problema 4: Error 500 en alguna consulta

**Causa**: Problemas con PostGIS o vista materializada

**Solución**:
```sql
-- Verificar extensión PostGIS
SELECT PostGIS_version();

-- Verificar vista materializada
SELECT * FROM pg_matviews WHERE matviewname = 'resumen_contribuciones_usuario';

-- Si no existe, crearla:
\i SQL/tablitas.sql
```

### Problema 5: Botón de recarga no hace nada

**Causa**: Error JavaScript en consola

**Solución**:
1. Abrir consola de DevTools
2. Revisar errores
3. Verificar que `statisticsService.js` existe
4. Rebuild del frontend: `npm run dev`

---

## 📊 CHECKLIST DE VALIDACIÓN

Marca cada item cuando lo hayas probado:

### Frontend:
- [ ] Dashboard carga correctamente en `/estadisticas`
- [ ] Enlace en navbar funciona
- [ ] Botón de recarga funciona
- [ ] Consulta #1 muestra datos
- [ ] Consulta #2 muestra top reseñadores
- [ ] Consulta #3 muestra análisis de proximidad
- [ ] Consulta #4 muestra valoraciones inusuales
- [ ] Consulta #7 muestra sitios sin actividad
- [ ] Consulta #8 muestra reseñas largas
- [ ] Consulta #9 muestra resumen de contribuciones
- [ ] Diseño responsive funciona
- [ ] Estados vacíos se muestran correctamente

### Backend:
- [ ] Endpoint `/api/estadisticas/por-tipo` funciona
- [ ] Endpoint `/api/estadisticas/top-resenadores` funciona
- [ ] Endpoint `/api/estadisticas/proximidad` funciona
- [ ] Endpoint `/api/estadisticas/valoraciones-inusuales` funciona
- [ ] Endpoint `/api/estadisticas/pocas-contribuciones` funciona
- [ ] Endpoint `/api/estadisticas/resenas-largas` funciona
- [ ] Endpoint `/api/estadisticas/resumen-contribuciones` funciona
- [ ] Todos los endpoints requieren autenticación JWT
- [ ] Respuestas tienen formato JSON correcto

### Base de Datos:
- [ ] Todas las consultas SQL funcionan en psql
- [ ] Vista materializada existe
- [ ] Extensión PostGIS está habilitada
- [ ] Hay datos de prueba suficientes

---

## 🎯 CASOS DE USO REALES

### Caso 1: Análisis de Actividad
```
Como administrador, quiero ver:
- Qué tipos de sitios son más populares (Consulta #1)
- Qué usuarios están más activos (Consulta #2)
- Qué sitios necesitan más promoción (Consulta #7)
```

### Caso 2: Descubrir Oportunidades
```
Como turista, quiero:
- Encontrar sitios prometedores con alta calificación pero pocas reseñas (Consulta #4)
- Ver dónde comer cerca de atracciones culturales (Consulta #3)
- Leer las mejores reseñas para inspirarme (Consulta #8)
```

### Caso 3: Reportes de Gestión
```
Como gerente, necesito:
- Estadísticas por categoría para tomar decisiones (Consulta #1)
- Identificar usuarios valiosos para programa de recompensas (Consulta #9)
- Ver qué sitios necesitan atención (Consulta #7)
```

---

## 📝 NOTAS IMPORTANTES

1. **Datos Dinámicos**: Las estadísticas se calculan en tiempo real desde la BD
2. **Vista Materializada**: La Consulta #9 usa cache, refrescar si es necesario
3. **Consulta #5**: No implementada (requiere columna 'ciudad')
4. **Consulta #6**: Es un trigger, no aparece en el dashboard
5. **Performance**: Todas las consultas se cargan en paralelo para mayor velocidad

---

**¡Dashboard de estadísticas listo para usar! 📊**
