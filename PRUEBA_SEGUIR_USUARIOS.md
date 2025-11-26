# 👥 Prueba de Funcionalidad: Seguir Usuarios

## ✅ Funcionalidad Implementada

Se ha implementado el sistema completo de seguimiento entre usuarios (funcionalidad de red social), cumpliendo con el requisito del enunciado (página 3):

> _"Los usuarios pueden agregar sitios, subir fotos, escribir reseñas y **seguir a otros usuarios**"_

---

## ⚠️ ANTES DE PROBAR

### 1. Ejecutar Script de Base de Datos

La funcionalidad requiere crear la tabla `seguidores`. Ejecuta:

```bash
psql -U postgres -d lab1tbd -f "SQL/crear_tabla_seguidores.sql"
```

**O manualmente en psql:**
```sql
CREATE TABLE IF NOT EXISTS seguidores (
    id SERIAL PRIMARY KEY,
    id_seguidor INT NOT NULL,
    id_seguido INT NOT NULL,
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_seguidor) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES usuarios(id) ON DELETE CASCADE,
    CHECK (id_seguidor != id_seguido),
    UNIQUE (id_seguidor, id_seguido)
);

CREATE INDEX idx_seguidores_seguidor ON seguidores(id_seguidor);
CREATE INDEX idx_seguidores_seguido ON seguidores(id_seguido);
```

### 2. Reiniciar Backend
```bash
# Rebuild del proyecto en IntelliJ IDEA
# Iniciar servidor Spring Boot (puerto 8090)
```

### 3. Reiniciar Frontend (si es necesario)
```bash
cd FrontEnd
npm run dev
# http://localhost:5173
```

---

## 📋 COMPONENTES IMPLEMENTADOS

### Backend:
- **Tabla**: `seguidores` con restricciones de integridad
- **Repository**: `SeguidorRepository` con 6 métodos
- **Service**: `SeguidorService` con validaciones
- **Controller**: `SeguidorController` con 6 endpoints

### Frontend:
- **Servicio**: `followersService.js`
- **Componente**: `FollowButton.vue` (botón seguir/dejar de seguir)
- **Vista**: `FollowersView.vue` (lista de seguidores/siguiendo)
- **Actualizado**: `ProfileView.vue` (estadísticas de seguidores)

---

## 🧪 GUÍA DE PRUEBAS

### ✅ Prueba 1: Ver Estadísticas de Seguidores en Perfil

**Objetivo**: Verificar que las estadísticas se muestran correctamente

**Pasos**:
1. Iniciar sesión con `ana@tbd.cl` / `password123`
2. Hacer clic en tu nombre en el navbar → "Mi Perfil" o ir a `/perfil`
3. Observar las tarjetas de estadísticas

**Resultado Esperado**:
- ✅ Se muestran 5 tarjetas:
  - Reseñas
  - Fotos
  - Listas
  - **Seguidores** (nueva)
  - **Siguiendo** (nueva)
- ✅ Las tarjetas de Seguidores y Siguiendo muestran "0" inicialmente
- ✅ Al pasar el mouse sobre Seguidores/Siguiendo, la tarjeta se eleva (efecto hover)
- ✅ El cursor cambia a puntero indicando que son clickeables

---

### ✅ Prueba 2: Seguir a un Usuario

**Objetivo**: Seguir a otro usuario desde su perfil

**Pre-requisito**: Necesitas tener múltiples usuarios en la BD

**Crear usuario adicional (si no existe)**:
```sql
INSERT INTO usuarios (nombre, email, contrasena_hash, biografia)
VALUES ('Carlos Pérez', 'carlos@tbd.cl', '$2a$10$...', 'Fotógrafo profesional');
```

**Pasos**:
1. Cerrar sesión e iniciar sesión como otro usuario (ej: crear cuenta nueva o usar otro usuario)
2. **NOTA**: Para esta prueba, necesitarías un mecanismo para ver otros perfiles
   - Por ahora, se puede probar directamente con la API (ver "Prueba Manual con cURL" más abajo)
3. Alternativamente, si tienes el ID del otro usuario:
   - Ir a `/perfil/2/seguidores` (donde 2 es el ID del otro usuario)
   - O agregar un FollowButton donde sea apropiado

**Resultado Esperado**:
- ✅ Botón muestra "+ Seguir"
- ✅ Al hacer clic, cambia a "✓ Siguiendo" con fondo verde
- ✅ El contador de "Siguiendo" en tu perfil aumenta en 1
- ✅ El contador de "Seguidores" del otro usuario aumenta en 1

---

### ✅ Prueba 3: Dejar de Seguir a un Usuario

**Objetivo**: Dejar de seguir a un usuario que ya seguías

**Pasos**:
1. Estando en un perfil donde ya sigues al usuario
2. El botón debe mostrar "✓ Siguiendo" (fondo verde)
3. Hacer clic en el botón

**Resultado Esperado**:
- ✅ Botón cambia a "+ Seguir" (fondo azul)
- ✅ El contador de "Siguiendo" en tu perfil disminuye en 1
- ✅ El contador de "Seguidores" del otro usuario disminuye en 1

---

### ✅ Prueba 4: Ver Lista de Seguidores

**Objetivo**: Ver quiénes te siguen

**Pre-requisito**: Otro usuario debe seguirte

**Pasos**:
1. Ir a tu perfil (`/perfil`)
2. Hacer clic en la tarjeta "Seguidores"
3. Observar la vista de seguidores

**Resultado Esperado**:
- ✅ Redirige a `/perfil/{tuId}/seguidores?mode=followers`
- ✅ Se muestra el título "👥 Seguidores"
- ✅ Tabs: "Seguidores (N)" y "Siguiendo (M)" donde N, M son los contadores
- ✅ Lista de usuarios que te siguen con:
  - Avatar con inicial del nombre
  - Nombre, email, biografía
  - Fecha de inicio del seguimiento
  - Botón "Ver Perfil"
  - Botón seguir/dejar de seguir (si no es tu propio perfil)
- ✅ Si no tienes seguidores: "Este usuario aún no tiene seguidores"

---

### ✅ Prueba 5: Ver Lista de Siguiendo

**Objetivo**: Ver a quiénes sigues

**Pasos**:
1. Ir a tu perfil (`/perfil`)
2. Hacer clic en la tarjeta "Siguiendo"
3. Observar la vista

**Resultado Esperado**:
- ✅ Redirige a `/perfil/{tuId}/seguidores?mode=following`
- ✅ Se muestra el título "👥 Siguiendo"
- ✅ Tab "Siguiendo" activo
- ✅ Lista de usuarios que sigues
- ✅ Si no sigues a nadie: "Este usuario aún no sigue a nadie"

---

### ✅ Prueba 6: Alternar entre Tabs

**Objetivo**: Cambiar entre vista de seguidores y siguiendo

**Pasos**:
1. Estar en `/perfil/{id}/seguidores`
2. Hacer clic en el tab "Siguiendo"
3. Hacer clic en el tab "Seguidores"

**Resultado Esperado**:
- ✅ La lista cambia dinámicamente
- ✅ El tab activo se resalta en azul
- ✅ Los contadores se actualizan correctamente

---

### ✅ Prueba 7: Validaciones y Casos Límite

#### Caso 7.1: Intentar Seguirse a Sí Mismo
**Prueba Manual (API)**:
```bash
# Intentar seguirte a ti mismo (debe fallar)
curl -X POST http://localhost:8090/api/usuarios/1/seguir \
  -H "Authorization: Bearer {TOKEN_USUARIO_1}"
```

**Resultado Esperado**:
- ❌ Error 400: "Un usuario no puede seguirse a sí mismo"

#### Caso 7.2: Intentar Seguir Dos Veces
**Pasos**:
1. Seguir a un usuario
2. Intentar seguirlo nuevamente (sin dejar de seguir)

**Resultado Esperado**:
- ❌ Error 400: "Ya estás siguiendo a este usuario"

#### Caso 7.3: Dejar de Seguir sin Haber Seguido
**Pasos**:
1. Intentar dejar de seguir a un usuario que nunca has seguido

**Resultado Esperado**:
- ❌ Error 404/400: "No estás siguiendo a este usuario"

#### Caso 7.4: Seguir Usuario Inexistente
**Prueba Manual (API)**:
```bash
curl -X POST http://localhost:8090/api/usuarios/99999/seguir \
  -H "Authorization: Bearer {TOKEN}"
```

**Resultado Esperado**:
- ❌ Error 404: "Usuario a seguir no encontrado"

---

## 🔍 PRUEBA MANUAL CON cURL

### 1. Obtener Token JWT
```bash
curl -X POST http://localhost:8090/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ana@tbd.cl","password":"password123"}'

# Copiar el token de la respuesta
```

### 2. Seguir a un Usuario
```bash
# Seguir al usuario con ID 2
curl -X POST http://localhost:8090/api/usuarios/2/seguir \
  -H "Authorization: Bearer {TU_TOKEN}"

# Respuesta esperada: 204 No Content
```

### 3. Verificar si Estás Siguiendo
```bash
curl -X GET http://localhost:8090/api/usuarios/2/seguir \
  -H "Authorization: Bearer {TU_TOKEN}"

# Respuesta esperada: true
```

### 4. Obtener Lista de Seguidores
```bash
curl -X GET http://localhost:8090/api/usuarios/1/seguidores \
  -H "Authorization: Bearer {TU_TOKEN}"

# Respuesta esperada: Array de UsuarioSeguidorResponse
```

### 5. Obtener Lista de Siguiendo
```bash
curl -X GET http://localhost:8090/api/usuarios/1/siguiendo \
  -H "Authorization: Bearer {TU_TOKEN}"

# Respuesta esperada: Array de UsuarioSeguidorResponse
```

### 6. Obtener Estadísticas
```bash
curl -X GET http://localhost:8090/api/usuarios/1/estadisticas-seguidores \
  -H "Authorization: Bearer {TU_TOKEN}"

# Respuesta esperada:
# {
#   "idUsuario": 1,
#   "totalSeguidores": 2,
#   "totalSiguiendo": 3,
#   "sigueAlUsuarioActual": false
# }
```

### 7. Dejar de Seguir
```bash
curl -X DELETE http://localhost:8090/api/usuarios/2/seguir \
  -H "Authorization: Bearer {TU_TOKEN}"

# Respuesta esperada: 204 No Content
```

---

## 📊 ENDPOINTS DISPONIBLES

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/usuarios/{id}/seguir` | Seguir a un usuario |
| DELETE | `/api/usuarios/{id}/seguir` | Dejar de seguir |
| GET | `/api/usuarios/{id}/seguir` | Verificar si sigues al usuario |
| GET | `/api/usuarios/{id}/seguidores` | Lista de seguidores |
| GET | `/api/usuarios/{id}/siguiendo` | Lista de siguiendo |
| GET | `/api/usuarios/{id}/estadisticas-seguidores` | Estadísticas |

---

## 🗄️ VERIFICACIÓN EN BASE DE DATOS

### Ver relaciones de seguimiento:
```sql
SELECT
    s.id,
    u1.nombre AS seguidor,
    u2.nombre AS seguido,
    s.fecha_inicio
FROM seguidores s
JOIN usuarios u1 ON s.id_seguidor = u1.id
JOIN usuarios u2 ON s.id_seguido = u2.id
ORDER BY s.fecha_inicio DESC;
```

### Contar seguidores de un usuario:
```sql
SELECT COUNT(*) AS seguidores
FROM seguidores
WHERE id_seguido = 1; -- Cambiar 1 por el ID del usuario
```

### Contar siguiendo de un usuario:
```sql
SELECT COUNT(*) AS siguiendo
FROM seguidores
WHERE id_seguidor = 1; -- Cambiar 1 por el ID del usuario
```

### Ver seguimiento mutuo:
```sql
SELECT
    u1.nombre AS usuario1,
    u2.nombre AS usuario2
FROM seguidores s1
JOIN seguidores s2 ON s1.id_seguidor = s2.id_seguido
    AND s1.id_seguido = s2.id_seguidor
JOIN usuarios u1 ON s1.id_seguidor = u1.id
JOIN usuarios u2 ON s1.id_seguido = u2.id
WHERE s1.id < s2.id; -- Evitar duplicados
```

---

## 🎯 CHECKLIST DE VALIDACIÓN

Marca cada item cuando lo hayas probado:

### Base de Datos:
- [ ] Tabla `seguidores` creada correctamente
- [ ] Índices creados en id_seguidor e id_seguido
- [ ] Restricción CHECK impide auto-seguimiento
- [ ] Restricción UNIQUE impide duplicados

### Backend:
- [ ] Endpoint POST /seguir funciona
- [ ] Endpoint DELETE /seguir funciona
- [ ] Endpoint GET /seguir retorna boolean
- [ ] Endpoint GET /seguidores retorna lista
- [ ] Endpoint GET /siguiendo retorna lista
- [ ] Endpoint GET /estadisticas retorna contadores
- [ ] Validación: No auto-seguimiento
- [ ] Validación: No duplicados
- [ ] Validación: Usuario existe

### Frontend:
- [ ] Estadísticas de seguidores en perfil
- [ ] Click en "Seguidores" redirige correctamente
- [ ] Click en "Siguiendo" redirige correctamente
- [ ] FollowersView muestra lista de seguidores
- [ ] FollowersView muestra lista de siguiendo
- [ ] Tabs funcionan correctamente
- [ ] FollowButton muestra estado correcto
- [ ] FollowButton cambia estado al hacer clic
- [ ] Contadores se actualizan después de seguir/dejar de seguir

---

## 📝 NOTAS IMPORTANTES

1. **Usuarios de Prueba**:
   - Para probar completamente, necesitas al menos 2 usuarios
   - Puedes crear usuarios adicionales desde el formulario de registro

2. **Navegación**:
   - Actualmente no hay una vista de "explorar usuarios"
   - Se puede acceder directamente a `/perfil/{id}/seguidores` con el ID del usuario

3. **Restricciones de BD**:
   - Un usuario NO puede seguirse a sí mismo (CHECK constraint)
   - No puede haber relaciones duplicadas (UNIQUE constraint)
   - Si se elimina un usuario, sus relaciones de seguimiento se eliminan (ON DELETE CASCADE)

4. **Optimización**:
   - Índices en `id_seguidor` e `id_seguido` para consultas rápidas
   - Queries eficientes con EXISTS para verificar seguimiento mutuo

5. **Seguimiento Mutuo**:
   - El sistema detecta si dos usuarios se siguen mutuamente
   - Esto se muestra en el campo `sigueAlUsuarioActual` de la respuesta

---

## 🚀 PRÓXIMAS MEJORAS SUGERIDAS

1. **Vista de Explorar Usuarios**: Página para descubrir otros usuarios
2. **Notificaciones**: Alertar cuando alguien te sigue
3. **Feed de Actividad**: Ver actividad de usuarios que sigues
4. **Sugerencias**: Recomendar usuarios para seguir
5. **Búsqueda de Usuarios**: Buscar usuarios por nombre/email

---

## 🔗 REFERENCIAS

- **Enunciado Original**: Página 3 - "Interacción Social"
- **Tabla de BD**: `SQL/crear_tabla_seguidores.sql`
- **Controller**: `Backend/src/main/java/com/tbd/lab1tbd/Controllers/SeguidorController.java`
- **Service Frontend**: `FrontEnd/src/services/followersService.js`
- **Vista**: `FrontEnd/src/views/FollowersView.vue`

---

**¡Funcionalidad de seguir usuarios lista para probar! 👥**
