# Instrucciones: Datos de Prueba para Frontend

## 📋 Resumen

Este documento explica cómo cargar datos de prueba completos en la base de datos para probar todas las funcionalidades del frontend.

## 🎯 ¿Qué incluye el script?

El archivo `SQL/DATOS_PRUEBA_COMPLETOS.sql` incluye:

- ✅ **10 usuarios** con diferentes perfiles y biografías
- ✅ **22 sitios turísticos** variados (parques, museos, restaurantes, teatros, monumentos, cafés, bares)
- ✅ **50+ reseñas** distribuidas entre usuarios y sitios
- ✅ **30+ fotografías** con URLs de placeholder
- ✅ **20+ relaciones de seguidores** (red social)
- ✅ **9 listas personalizadas** con sitios agregados
- ✅ **Datos con poca actividad reciente** (para consulta #7)
- ✅ **Coordenadas reales** de Santiago para búsqueda geoespacial

## 🚀 Cómo ejecutar el script

### Opción 1: Desde la línea de comandos (Windows)

```bash
psql -U postgres -d lab1tbd -f SQL/DATOS_PRUEBA_COMPLETOS.sql
```

### Opción 2: Desde psql interactivo

```sql
\c lab1tbd
\i SQL/DATOS_PRUEBA_COMPLETOS.sql
```

### Opción 3: Desde pgAdmin

1. Abrir pgAdmin
2. Conectar a la base de datos `lab1tbd`
3. Abrir Query Tool
4. Cargar el archivo `SQL/DATOS_PRUEBA_COMPLETOS.sql`
5. Ejecutar (F5)

## 👥 Usuarios de Prueba

Todos los usuarios tienen la misma contraseña: **`password123`**

| Email | Nombre | Perfil |
|-------|--------|--------|
| ana@tbd.cl | Ana García | Viajera y fotógrafa |
| bruno@tbd.cl | Bruno Díaz | Entusiasta de gastronomía |
| carla@tbd.cl | Carla Soto | Exploradora urbana |
| diego@tbd.cl | Diego Morales | Crítico de teatro |
| elena@tbd.cl | Elena Fernández | Historiadora |
| felipe@tbd.cl | Felipe Torres | Sommelier |
| gabriela@tbd.cl | Gabriela Rojas | Arquitecta |
| hector@tbd.cl | Héctor Vargas | Ciclista urbano |
| isabel@tbd.cl | Isabel Núñez | Bloguera de viajes |
| javier@tbd.cl | Javier Pinto | Estudiante de fotografía |

## 🏛️ Sitios Turísticos

### Parques (4)
- Cerro San Cristóbal
- Parque Forestal
- Parque Bicentenario
- Parque Quinta Normal

### Museos (4)
- Museo Nacional de Bellas Artes
- Museo de la Memoria y los DDHH
- Museo Chileno de Arte Precolombino
- Centro Cultural La Moneda

### Restaurantes (4)
- Bocanáriz ⭐ (corregido encoding UTF-8)
- Liguria
- Peumayen
- Astrid y Gastón

### Teatros (3)
- Teatro Municipal de Santiago
- Teatro Universidad de Chile
- Centro Gabriela Mistral (GAM)

### Monumentos (3)
- La Moneda
- Plaza de Armas
- Catedral Metropolitana

### Cafés (2)
- Café Colmado
- Wonderland Café

### Bares (2)
- The Clinic
- La Piojera

## 🧪 Funcionalidades que puedes probar en el Frontend

### 1. Autenticación
- ✅ Login con cualquier email de la tabla (password: `password123`)
- ✅ Registro de nuevos usuarios
- ✅ Logout

### 2. Lista de Sitios
- ✅ Ver todos los sitios turísticos
- ✅ Filtrar por tipo (Parque, Museo, Restaurante, etc.)
- ✅ Ver calificación promedio de cada sitio
- ✅ Ver total de reseñas

### 3. Detalle de Sitio
- ✅ Ver información completa del sitio
- ✅ Ver reseñas de usuarios
- ✅ Ver galería de fotografías
- ✅ Ver calificación promedio
- ✅ Ver coordenadas en mapa

### 4. Reseñas
- ✅ Crear nueva reseña
- ✅ Editar reseña propia
- ✅ Ver reseñas de otros usuarios
- ✅ Calificaciones de 1 a 5 estrellas

### 5. Fotografías
- ✅ Subir fotografías a sitios
- ✅ Ver galería de fotos
- ✅ Ver fotos por usuario

### 6. Perfiles de Usuario
- ✅ Ver perfil propio
- ✅ Ver perfil de otros usuarios
- ✅ Ver estadísticas de contribuciones
- ✅ Ver reseñas del usuario
- ✅ Ver fotos del usuario
- ✅ Ver listas del usuario

### 7. Seguimiento de Usuarios
- ✅ Seguir a otros usuarios
- ✅ Dejar de seguir
- ✅ Ver lista de seguidores
- ✅ Ver lista de seguidos
- ✅ Ver cuántos seguidores tiene un usuario

**Relaciones de prueba:**
- Ana García es muy social (sigue a 5 usuarios)
- Elena Fernández es muy popular (4 usuarios la siguen)
- Todos los usuarios tienen al menos una relación

### 8. Listas Personalizadas
- ✅ Crear listas personalizadas
- ✅ Agregar sitios a listas
- ✅ Ver listas propias
- ✅ Ver listas de otros usuarios
- ✅ Eliminar sitios de listas

**Listas de ejemplo:**
- "Imperdibles de Santiago" (Ana) - 5 sitios
- "Tour Gastronómico" (Bruno) - 4 sitios
- "Parques para Visitar" (Carla) - 4 sitios
- "Teatros de Santiago" (Diego) - 3 sitios
- "Ruta Histórica" (Elena) - 4 sitios

### 9. Búsqueda de Sitios Cercanos
- ✅ Buscar sitios dentro de un radio
- ✅ Usar coordenadas del usuario
- ✅ Ver distancia en metros

**Coordenadas de prueba (Santiago centro):**
- Latitud: -33.4372
- Longitud: -70.6506
- Radio recomendado: 2000 metros

**Sitios cercanos entre sí:**
- Teatro Municipal y Bocanáriz: ~1162 metros
- Plaza de Armas y Catedral: muy cerca (~50 metros)
- Museo Bellas Artes y Parque Forestal: adyacentes

### 10. Estadísticas
- ✅ Ver sitios mejor calificados
- ✅ Ver sitios con más reseñas
- ✅ Ver usuarios más activos
- ✅ Ver sitios por tipo
- ✅ Ver actividad reciente

### 11. Sitios con Poca Actividad (Consulta #7)
- ✅ Ver sitios sin reseñas/fotos en los últimos 3 meses
- ✅ Filtrar por fecha de última actividad

**Sitios con poca actividad reciente:**
- La Piojera (última actividad hace +120 días)
- Algunos sitios no tienen reseñas recientes

## 📊 Estadísticas de los Datos

Después de ejecutar el script verás:

```
Total usuarios:           10
Total sitios:             22
Total reseñas:            50+
Total fotografías:        30+
Total relaciones:         20+
Total listas:             9
```

## 🔍 Consultas SQL para Verificar

### Ver sitios mejor calificados
```sql
SELECT nombre, tipo, calificacion_promedio, total_reseñas
FROM sitios_turisticos
WHERE total_reseñas > 0
ORDER BY calificacion_promedio DESC, total_reseñas DESC
LIMIT 10;
```

### Ver usuarios más activos
```sql
SELECT * FROM resumen_contribuciones_usuario
ORDER BY (total_reseñas + total_fotos + total_listas) DESC;
```

### Ver seguidores de un usuario
```sql
SELECT
    u.nombre AS seguidor,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u ON s.id_seguidor = u.id
WHERE s.id_seguido = 1  -- Elena Fernández
ORDER BY s.fecha_inicio DESC;
```

### Ver sitios cercanos (ejemplo)
```sql
SELECT
    nombre,
    tipo,
    ST_Distance(
        coordenadas,
        ST_MakePoint(-70.6506, -33.4372)::geography
    ) AS distancia_metros
FROM sitios_turisticos
WHERE ST_DWithin(
    coordenadas,
    ST_MakePoint(-70.6506, -33.4372)::geography,
    2000  -- 2 km de radio
)
ORDER BY distancia_metros;
```

### Ver sitios con poca actividad reciente
```sql
SELECT
    s.nombre,
    s.tipo,
    COUNT(DISTINCT r.id) AS reseñas_recientes,
    COUNT(DISTINCT f.id) AS fotos_recientes
FROM sitios_turisticos s
LEFT JOIN reseñas r ON s.id = r.id_sitio AND r.fecha > (NOW() - INTERVAL '90 days')
LEFT JOIN fotografias f ON s.id = f.id_sitio AND f.fecha > (NOW() - INTERVAL '90 days')
GROUP BY s.id, s.nombre, s.tipo
HAVING COUNT(DISTINCT r.id) = 0 AND COUNT(DISTINCT f.id) = 0;
```

## ⚠️ Notas Importantes

1. **Encoding UTF-8**: El nombre "Bocanáriz" está correctamente codificado en el script
2. **Coordenadas**: Todas las coordenadas son reales de Santiago, Chile
3. **Fechas**: Las reseñas y fotos tienen fechas variadas (desde hoy hasta 120 días atrás)
4. **Contraseñas**: Todos los usuarios tienen la misma contraseña hasheada con BCrypt
5. **ON CONFLICT**: El script usa `ON CONFLICT DO NOTHING` para evitar duplicados

## 🐛 Solución de Problemas

### Problema: Error de encoding al mostrar "Bocanáriz"
**Solución:** Verificar que:
- La base de datos use encoding UTF-8
- El cliente (psql) use encoding UTF-8
- El archivo .sql esté guardado en UTF-8

### Problema: No se cargan las coordenadas
**Solución:**
- Verificar que la extensión PostGIS esté instalada: `CREATE EXTENSION IF NOT EXISTS postgis;`
- Ejecutar primero el script `tablitas.sql` si no existe la estructura

### Problema: No se puede seguir a usuarios
**Solución:**
- Verificar que existe la tabla `seguidores`: `\d seguidores`
- Ejecutar el script `SQL/crear_tabla_seguidores.sql` si no existe

## 📝 Próximos Pasos

1. ✅ Ejecutar el script de datos de prueba
2. ✅ Verificar que los datos se cargaron correctamente
3. ✅ Iniciar el backend: `cd Backend && ./mvnw spring-boot:run`
4. ✅ Iniciar el frontend: `cd FrontEnd && npm run dev`
5. ✅ Probar todas las funcionalidades listadas arriba
6. ✅ Reportar cualquier problema encontrado

## 🎓 Casos de Prueba Sugeridos

### Caso 1: Usuario nuevo
1. Registrarse con email nuevo
2. Crear una reseña
3. Subir una foto
4. Crear una lista personalizada
5. Seguir a otros usuarios

### Caso 2: Usuario existente
1. Login con `ana@tbd.cl` / `password123`
2. Ver perfil (debería tener 5 reseñas, 5 fotos, 2 listas)
3. Ver seguidores (debería seguir a 5 usuarios)
4. Editar una reseña propia

### Caso 3: Búsqueda geoespacial
1. Ir a "Sitios Cercanos"
2. Usar coordenadas: -33.4372, -70.6506
3. Radio: 2000 metros
4. Verificar que aparecen múltiples sitios

### Caso 4: Estadísticas
1. Ir a vista de estadísticas
2. Verificar gráficos de sitios por tipo
3. Ver top 10 sitios mejor calificados
4. Ver usuarios más activos

## 📞 Soporte

Si tienes problemas ejecutando el script, verifica:
- Conexión a la base de datos
- Extensión PostGIS instalada
- Estructura de tablas creada (tablitas.sql)
- Encoding UTF-8 en base de datos y cliente
