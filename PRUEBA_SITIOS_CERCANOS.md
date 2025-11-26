# 🗺️ Prueba de Búsqueda de Sitios Cercanos

## ✅ Funcionalidad Implementada

Se ha implementado la búsqueda geoespacial de sitios turísticos cercanos a una ubicación específica, utilizando el procedimiento almacenado `buscar_sitios_cercanos` de PostGIS.

---

## 📋 Componentes Implementados

### Backend:
- **Repository**: `SitioTuristicoRepository.findCercanos()`
- **Service**: `SitioTuristicoService.getCercanos()`
- **Controller**: `GET /api/sitios/cercanos?lat={lat}&lng={lng}&radio={metros}`

### Frontend:
- **Vista**: `NearbySitesView.vue` - Interfaz completa de búsqueda
- **Ruta**: `/sitios/cercanos`
- **Navbar**: Enlace "🗺️ Buscar Cercanos"

### Base de Datos:
- **Procedimiento Almacenado**: `buscar_sitios_cercanos(longitud, latitud, radio_metros)`
- **Ubicación**: `/home/user/lab1tbd/SQL/tablitas.sql` líneas 239-264

---

## 🧪 GUÍA DE PRUEBAS

### Paso 1: Verificar que el Backend esté corriendo
```bash
# El backend debe estar corriendo en http://localhost:8090
# Verifica los logs de Spring Boot
```

### Paso 2: Verificar que el Frontend esté corriendo
```bash
cd FrontEnd
npm run dev
# Debe estar en http://localhost:5173
```

### Paso 3: Iniciar Sesión
1. Abrir http://localhost:5173
2. Iniciar sesión con:
   - Email: `ana@tbd.cl`
   - Contraseña: `password123`

---

## 📍 PRUEBAS FUNCIONALES

### ✅ Prueba 1: Búsqueda con Coordenadas de Santiago Centro

**Objetivo**: Buscar sitios turísticos cerca de Santiago Centro

**Pasos**:
1. Hacer clic en "🗺️ Buscar Cercanos" en el navbar
2. Hacer clic en el botón "🏛️ Santiago Centro"
   - Esto pre-llena: Lat: `-33.4489`, Lng: `-70.6693`
3. Dejar el radio en `1000` metros (1 km)
4. Hacer clic en "🔍 Buscar"

**Resultado Esperado**:
- ✅ Se muestran sitios turísticos dentro de 1 km del centro de Santiago
- ✅ Cada sitio muestra:
  - Nombre y tipo
  - Descripción
  - Calificación promedio y número de reseñas
  - Coordenadas exactas
- ✅ Al hacer clic en un sitio, redirige al detalle

---

### ✅ Prueba 2: Búsqueda con Radio Personalizado

**Objetivo**: Probar búsqueda con diferentes radios

**Pasos**:
1. En la página de búsqueda cercanos
2. Usar coordenadas de Santiago Centro (botón "🏛️ Santiago Centro")
3. Cambiar el radio a `5000` metros (5 km)
4. Hacer clic en "🔍 Buscar"

**Resultado Esperado**:
- ✅ Se muestran más sitios que en la búsqueda anterior
- ✅ El mensaje muestra: "dentro de 5km"
- ✅ Todos los sitios están dentro del radio especificado

---

### ✅ Prueba 3: Búsqueda con Ubicación Manual

**Objetivo**: Buscar sitios cerca de una ubicación específica

**Pasos**:
1. En la página de búsqueda cercanos
2. Ingresar manualmente:
   - Latitud: `-33.4372` (Plaza de Armas)
   - Longitud: `-70.6506`
   - Radio: `500` metros
3. Hacer clic en "🔍 Buscar"

**Resultado Esperado**:
- ✅ Se muestran solo sitios muy cercanos a Plaza de Armas
- ✅ Si no hay sitios, muestra mensaje: "No se encontraron sitios turísticos en esta área"
- ✅ Sugiere aumentar el radio de búsqueda

---

### ✅ Prueba 4: Validación de Parámetros

**Objetivo**: Verificar que las validaciones funcionan correctamente

**Caso 4.1: Radio muy pequeño**
1. Ingresar coordenadas válidas
2. Cambiar radio a `50` metros
3. Intentar buscar

**Resultado Esperado**:
- ✅ Backend acepta (mínimo es 100m, pero frontend no valida menos de 100)
- ✅ Probablemente no encuentre resultados por radio muy pequeño

**Caso 4.2: Radio muy grande**
1. Ingresar coordenadas válidas
2. Cambiar radio a `100000` metros (100 km)
3. Intentar buscar

**Resultado Esperado**:
- ❌ Backend rechaza con error: "El radio máximo permitido es 50000 metros (50 km)"
- ✅ Se muestra mensaje de error en frontend

**Caso 4.3: Campos vacíos**
1. Dejar latitud y/o longitud vacíos
2. Intentar buscar

**Resultado Esperado**:
- ✅ Botón "🔍 Buscar" está deshabilitado
- ✅ No se permite hacer la búsqueda

---

### ✅ Prueba 5: Geolocalización del Navegador (Opcional)

**Objetivo**: Usar la ubicación actual del usuario

**Pasos**:
1. En la página de búsqueda cercanos
2. Hacer clic en "📍 Usar Mi Ubicación"
3. Permitir el acceso a la ubicación cuando el navegador lo solicite
4. Hacer clic en "🔍 Buscar"

**Resultado Esperado**:
- ✅ Los campos de latitud y longitud se llenan automáticamente
- ✅ Se buscan sitios cerca de tu ubicación real
- ✅ Si se deniega el permiso, muestra mensaje de error

**Nota**: Esta funcionalidad requiere:
- Navegador con soporte de Geolocation API
- Permiso del usuario para acceder a la ubicación
- Conexión HTTPS (o localhost)

---

### ✅ Prueba 6: Navegación desde Resultados

**Objetivo**: Verificar que se puede acceder al detalle de sitios encontrados

**Pasos**:
1. Realizar una búsqueda exitosa
2. Hacer clic en cualquier tarjeta de sitio

**Resultado Esperado**:
- ✅ Redirige a `/sitios/{id}`
- ✅ Muestra el detalle completo del sitio
- ✅ Se puede regresar con el botón "atrás" del navegador

---

## 🔍 VERIFICACIÓN TÉCNICA

### Verificar Endpoint en Backend

**Usando cURL** (requiere token JWT):
```bash
# 1. Login para obtener token
curl -X POST http://localhost:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ana@tbd.cl","password":"password123"}'

# 2. Copiar el token de la respuesta y usarlo:
curl -X GET "http://localhost:8090/api/sitios/cercanos?lat=-33.4489&lng=-70.6693&radio=1000" \
  -H "Authorization: Bearer {TU_TOKEN_AQUI}"
```

**Respuesta Esperada**:
```json
[
  {
    "id": 1,
    "nombre": "Cerro San Cristóbal",
    "descripcion": "...",
    "tipo": "Parque",
    "latitud": -33.4258,
    "longitud": -70.6344,
    "calificacionPromedio": 4.5,
    "totalResenas": 10
  },
  ...
]
```

---

### Verificar Procedimiento Almacenado en PostgreSQL

**Ejecutar directamente en psql**:
```sql
-- Buscar sitios cerca de Santiago Centro (radio 1000m)
SELECT
  id,
  nombre,
  tipo,
  ST_Y(coordenadas::geometry) AS latitud,
  ST_X(coordenadas::geometry) AS longitud
FROM buscar_sitios_cercanos(-70.6693, -33.4489, 1000);
```

**Resultado Esperado**:
- Retorna filas con sitios dentro del radio especificado
- Las coordenadas están correctamente formateadas

---

## 📊 CASOS DE USO REALES

### Caso 1: Turista en Santiago Centro
```
Ubicación: Plaza de Armas (-33.4372, -70.6506)
Radio: 500 metros
Resultado: Encuentra sitios históricos cercanos
```

### Caso 2: Búsqueda Amplia en Providencia
```
Ubicación: Metro Baquedano (-33.4372, -70.6343)
Radio: 2000 metros
Resultado: Encuentra parques, museos y restaurantes en el sector
```

### Caso 3: Exploración de Zona Turística
```
Ubicación: Barrio Bellavista (-33.4285, -70.6342)
Radio: 1500 metros
Resultado: Encuentra sitios culturales y de entretenimiento
```

---

## ⚙️ CONFIGURACIÓN TÉCNICA

### Parámetros del Endpoint:
- **lat** (Double, requerido): Latitud de la ubicación de referencia
- **lng** (Double, requerido): Longitud de la ubicación de referencia
- **radio** (Integer, opcional): Radio de búsqueda en metros
  - Por defecto: 1000 metros (1 km)
  - Mínimo: 100 metros
  - Máximo: 50000 metros (50 km)

### Requisitos:
- ✅ PostgreSQL con extensión PostGIS
- ✅ Procedimiento almacenado `buscar_sitios_cercanos` creado
- ✅ Índice GIST en columna `coordenadas` para rendimiento
- ✅ Autenticación JWT activa

---

## 🎯 CHECKLIST DE VALIDACIÓN

Marca cada item cuando lo hayas probado:

- [ ] Búsqueda con Santiago Centro (1 km)
- [ ] Búsqueda con radio personalizado (5 km)
- [ ] Búsqueda con coordenadas manuales
- [ ] Validación de radio mínimo/máximo
- [ ] Validación de campos requeridos
- [ ] Geolocalización del navegador (si es posible)
- [ ] Navegación al detalle de sitios
- [ ] Mensaje cuando no hay resultados
- [ ] Enlace en navbar funciona
- [ ] Endpoint responde correctamente con token JWT
- [ ] Procedimiento almacenado funciona en PostgreSQL

---

## 📝 NOTAS IMPORTANTES

1. **Coordenadas de Santiago, Chile**:
   - Centro: `-33.4489, -70.6693`
   - Plaza de Armas: `-33.4372, -70.6506`
   - Cerro San Cristóbal: `-33.4258, -70.6344`

2. **Formato de Coordenadas**:
   - Latitud: valores negativos en hemisferio sur
   - Longitud: valores negativos en hemisferio oeste

3. **Rendimiento**:
   - El índice GIST en la columna `coordenadas` optimiza las búsquedas
   - Búsquedas con radios grandes (>10 km) pueden ser más lentas

4. **Autenticación**:
   - Todos los endpoints requieren token JWT válido
   - El token se envía en el header `Authorization: Bearer {token}`

---

## 🔗 Referencias

- **Enunciado Original**: Página 4, punto "Exploración"
- **Procedimiento Almacenado**: `/home/user/lab1tbd/SQL/tablitas.sql` líneas 239-264
- **Consulta SQL #3**: Análisis de proximidad entre sitios
- **PostGIS ST_DWithin**: https://postgis.net/docs/ST_DWithin.html

---

**¡Funcionalidad lista para probar! 🚀**
