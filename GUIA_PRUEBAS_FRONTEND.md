# 🧪 Guía de Pruebas Funcionales - Lab1TBD
## Red Social de Turismo - Frontend Testing

---

## ⚠️ ANTES DE EMPEZAR

### 1. Ejecutar Migración de Base de Datos
```powershell
psql -U postgres -d lab1tbd -f "SQL/EJECUTAR_MIGRACION_TABLA_RESENAS.sql"
```

### 2. Iniciar Backend
- Rebuild Project en IntelliJ IDEA
- Iniciar servidor Spring Boot (puerto 8090)

### 3. Iniciar Frontend
```bash
cd FrontEnd
npm run dev
```
- Abrir navegador en http://localhost:5173

---

## 📋 LISTA DE PRUEBAS FUNCIONALES

### ✅ Módulo 1: Autenticación y Registro

#### **Prueba 1.1: Login de Usuario Existente**
**Objetivo:** Verificar que un usuario puede iniciar sesión

**Pasos:**
1. Abrir http://localhost:5173
2. Hacer clic en "Iniciar Sesión" (si no está ya en login)
3. Ingresar credenciales:
   - Email: `ana@tbd.cl`
   - Contraseña: `password123`
4. Hacer clic en "Iniciar Sesión"

**Resultado Esperado:**
- ✅ Redirección a la página principal (Home)
- ✅ Se muestra el nombre del usuario en el navbar
- ✅ Se muestra el botón "Cerrar Sesión"
- ✅ Token JWT guardado en localStorage

**Cómo Verificar Token:**
- Abrir DevTools (F12) → Console
- Ejecutar: `localStorage.getItem('token')`
- Debe retornar un token JWT (string largo)

---

#### **Prueba 1.2: Login con Credenciales Incorrectas**
**Objetivo:** Verificar que el sistema rechaza credenciales inválidas

**Pasos:**
1. En la página de login
2. Ingresar credenciales incorrectas:
   - Email: `ana@tbd.cl`
   - Contraseña: `wrongpassword`
3. Hacer clic en "Iniciar Sesión"

**Resultado Esperado:**
- ✅ Se muestra mensaje de error
- ✅ No se guarda token
- ✅ Usuario permanece en página de login

---

#### **Prueba 1.3: Registro de Nuevo Usuario**
**Objetivo:** Crear una cuenta nueva

**Pasos:**
1. En la página de login, hacer clic en "Registrarse"
2. Completar el formulario:
   - Nombre: `Usuario Prueba`
   - Email: `test@tbd.cl`
   - Contraseña: `password123`
   - Biografía: `Usuario de prueba para testing`
3. Hacer clic en "Registrarse"

**Resultado Esperado:**
- ✅ Usuario creado exitosamente
- ✅ Login automático
- ✅ Redirección a Home

---

#### **Prueba 1.4: Cerrar Sesión**
**Objetivo:** Verificar que el logout funciona correctamente

**Pasos:**
1. Estando logueado, hacer clic en "Cerrar Sesión"

**Resultado Esperado:**
- ✅ Token eliminado de localStorage
- ✅ Redirección a página de login
- ✅ No se puede acceder a rutas protegidas

---

### ✅ Módulo 2: Visualización de Sitios Turísticos

#### **Prueba 2.1: Ver Todos los Sitios**
**Objetivo:** Listar todos los sitios turísticos

**Pasos:**
1. Desde Home, hacer clic en "Sitios" o "Ver Todos"
2. Observar la lista de sitios

**Resultado Esperado:**
- ✅ Se muestran todos los sitios con:
  - Nombre
  - Tipo (Parque, Museo, Restaurante, etc.)
  - Calificación promedio (estrellas)
  - Número de reseñas
  - Coordenadas (latitud, longitud)

---

#### **Prueba 2.2: Ver Sitios Populares**
**Objetivo:** Verificar el endpoint de sitios más populares

**Pasos:**
1. En Home, buscar la sección "Sitios Populares"
2. Observar los sitios mostrados

**Resultado Esperado:**
- ✅ Se muestran máximo 10 sitios
- ✅ Ordenados por calificación promedio (DESC)
- ✅ Solo sitios con al menos 1 reseña

---

#### **Prueba 2.3: Filtrar Sitios por Tipo**
**Objetivo:** Filtrar sitios por categoría

**Pasos:**
1. En la lista de sitios, buscar filtro por tipo
2. Seleccionar "Parque"
3. Observar resultados

**Resultado Esperado:**
- ✅ Solo se muestran sitios de tipo "Parque"
- ✅ Filtro funciona sin errores

**Repetir con otros tipos:** Museo, Teatro, Restaurante

---

#### **Prueba 2.4: Ver Detalle de un Sitio**
**Objetivo:** Ver información completa de un sitio específico

**Pasos:**
1. En la lista de sitios, hacer clic en un sitio (ej: "Cerro San Cristóbal")
2. Observar la página de detalle

**Resultado Esperado:**
- ✅ Se muestra toda la información del sitio:
  - Nombre completo
  - Descripción
  - Tipo
  - Calificación promedio
  - Coordenadas en mapa (si está implementado)
- ✅ Se muestran las reseñas del sitio
- ✅ Se muestran las fotografías del sitio

---

### ✅ Módulo 3: Gestión de Reseñas

#### **Prueba 3.1: Crear una Reseña**
**Objetivo:** Agregar una reseña a un sitio turístico

**Pasos:**
1. Ir al detalle de un sitio (ej: "Museo Nacional de Bellas Artes")
2. Buscar el formulario "Agregar Reseña"
3. Completar:
   - Calificación: 5 estrellas
   - Contenido: `Excelente museo, muy bien mantenido. Las exposiciones son increíbles.`
4. Hacer clic en "Publicar Reseña"

**Resultado Esperado:**
- ✅ Reseña creada exitosamente
- ✅ Reseña aparece inmediatamente en la lista
- ✅ Calificación promedio del sitio se actualiza (trigger automático)
- ✅ Contador de reseñas aumenta

**Verificar en Backend:**
- Logs deben mostrar: `INSERT INTO resenas ...`
- Trigger debe actualizar `total_resenas` y `calificacion_promedio`

---

#### **Prueba 3.2: Editar una Reseña Propia**
**Objetivo:** Modificar una reseña que el usuario creó

**Pasos:**
1. En el detalle del sitio, buscar tu reseña
2. Hacer clic en "Editar" (icono de lápiz)
3. Cambiar:
   - Calificación: 4 estrellas
   - Contenido: `Muy buen museo, pero un poco caro.`
4. Guardar cambios

**Resultado Esperado:**
- ✅ Reseña actualizada exitosamente
- ✅ Se muestra el contenido y calificación nuevos
- ✅ Calificación promedio del sitio se recalcula

---

#### **Prueba 3.3: Eliminar una Reseña Propia**
**Objetivo:** Borrar una reseña

**Pasos:**
1. En el detalle del sitio, buscar tu reseña
2. Hacer clic en "Eliminar" (icono de basura)
3. Confirmar eliminación

**Resultado Esperado:**
- ✅ Reseña eliminada
- ✅ Ya no aparece en la lista
- ✅ Calificación promedio del sitio se recalcula
- ✅ Contador de reseñas disminuye

---

#### **Prueba 3.4: Intentar Editar Reseña de Otro Usuario**
**Objetivo:** Verificar autorización

**Pasos:**
1. Ver el detalle de un sitio que tenga reseñas de otros usuarios
2. Intentar editar una reseña que no es tuya

**Resultado Esperado:**
- ✅ No se muestra el botón "Editar" en reseñas de otros
- ✅ Si se intenta por API directa: Error 403 Forbidden

---

### ✅ Módulo 4: Gestión de Fotografías

#### **Prueba 4.1: Agregar Fotografía a un Sitio**
**Objetivo:** Subir una foto a un sitio turístico

**Pasos:**
1. Ir al detalle de un sitio
2. Buscar sección "Agregar Fotografía"
3. Ingresar URL de imagen (ej: `https://picsum.photos/800/600`)
4. Hacer clic en "Subir Foto"

**Resultado Esperado:**
- ✅ Fotografía agregada exitosamente
- ✅ Foto aparece en la galería del sitio
- ✅ Se muestra el nombre del autor (tu usuario)

---

#### **Prueba 4.2: Eliminar Fotografía Propia**
**Objetivo:** Borrar una foto que subiste

**Pasos:**
1. En la galería del sitio, buscar una foto tuya
2. Hacer clic en "Eliminar"
3. Confirmar

**Resultado Esperado:**
- ✅ Fotografía eliminada
- ✅ Ya no aparece en la galería

---

### ✅ Módulo 5: Perfil de Usuario

#### **Prueba 5.1: Ver Mi Perfil**
**Objetivo:** Visualizar el perfil del usuario autenticado

**Pasos:**
1. Hacer clic en "Perfil" o en el nombre de usuario en navbar
2. Observar la página de perfil

**Resultado Esperado:**
- ✅ Se muestra información del usuario:
  - Nombre
  - Email
  - Biografía
- ✅ Estadísticas:
  - Total de reseñas escritas
  - Total de fotografías subidas
  - Total de listas creadas
- ✅ Lista de todas las reseñas del usuario
- ✅ Lista de todas las fotografías del usuario
- ✅ Lista de todas las listas del usuario

**IMPORTANTE:** Esta prueba era la que daba error 403 antes de nuestra corrección.

---

#### **Prueba 5.2: Editar Perfil**
**Objetivo:** Actualizar información del usuario

**Pasos:**
1. En perfil, hacer clic en "Editar Perfil"
2. Cambiar:
   - Nombre: `Ana López`
   - Biografía: `Amante de los viajes y la fotografía`
3. Guardar cambios

**Resultado Esperado:**
- ✅ Perfil actualizado
- ✅ Cambios se reflejan inmediatamente

---

### ✅ Módulo 6: Listas Personalizadas

#### **Prueba 6.1: Crear una Lista**
**Objetivo:** Crear una lista personalizada de sitios

**Pasos:**
1. Ir a "Mis Listas"
2. Hacer clic en "Crear Nueva Lista"
3. Ingresar nombre: `Mis Favoritos`
4. Guardar

**Resultado Esperado:**
- ✅ Lista creada exitosamente
- ✅ Aparece en "Mis Listas"

---

#### **Prueba 6.2: Agregar Sitio a una Lista**
**Objetivo:** Añadir un sitio a una lista personalizada

**Pasos:**
1. Ir al detalle de un sitio
2. Buscar "Agregar a Lista"
3. Seleccionar lista "Mis Favoritos"
4. Confirmar

**Resultado Esperado:**
- ✅ Sitio agregado a la lista
- ✅ Mensaje de confirmación

---

#### **Prueba 6.3: Ver Sitios de una Lista**
**Objetivo:** Visualizar contenido de una lista

**Pasos:**
1. Ir a "Mis Listas"
2. Hacer clic en "Mis Favoritos"
3. Observar los sitios

**Resultado Esperado:**
- ✅ Se muestran todos los sitios agregados
- ✅ Con toda su información (nombre, tipo, calificación)

---

#### **Prueba 6.4: Eliminar Sitio de una Lista**
**Objetivo:** Quitar un sitio de una lista

**Pasos:**
1. En el detalle de la lista, hacer clic en "Eliminar" en un sitio
2. Confirmar

**Resultado Esperado:**
- ✅ Sitio removido de la lista
- ✅ Lista actualizada

---

#### **Prueba 6.5: Eliminar una Lista**
**Objetivo:** Borrar una lista completa

**Pasos:**
1. En "Mis Listas", hacer clic en "Eliminar Lista"
2. Confirmar

**Resultado Esperado:**
- ✅ Lista eliminada
- ✅ Ya no aparece en "Mis Listas"
- ✅ Los sitios que contenía NO se eliminan (solo la lista)

---

### ✅ Módulo 7: Gestión de Sitios (CRUD)

#### **Prueba 7.1: Crear Nuevo Sitio**
**Objetivo:** Agregar un sitio turístico nuevo

**Pasos:**
1. Hacer clic en "Agregar Sitio" o "Nuevo Sitio"
2. Completar formulario:
   - Nombre: `Plaza de Armas`
   - Descripción: `Centro histórico de Santiago`
   - Tipo: `Parque`
   - Latitud: `-33.4372`
   - Longitud: `-70.6506`
3. Guardar

**Resultado Esperado:**
- ✅ Sitio creado exitosamente
- ✅ Aparece en la lista de sitios
- ✅ Se puede ver su detalle

---

#### **Prueba 7.2: Editar un Sitio**
**Objetivo:** Modificar información de un sitio

**Pasos:**
1. En el detalle de un sitio, hacer clic en "Editar"
2. Cambiar descripción
3. Guardar

**Resultado Esperado:**
- ✅ Sitio actualizado
- ✅ Cambios visibles inmediatamente

---

#### **Prueba 7.3: Eliminar un Sitio**
**Objetivo:** Borrar un sitio turístico

**Pasos:**
1. En el detalle de un sitio, hacer clic en "Eliminar"
2. Confirmar

**Resultado Esperado:**
- ✅ Sitio eliminado
- ✅ Ya no aparece en la lista
- ✅ Sus reseñas y fotos también se eliminan (CASCADE)

---

## 🐛 VERIFICACIÓN DE ERRORES CORREGIDOS

### ✅ Error 403 en Perfil (RESUELTO)
**Antes:** Al hacer clic en "Perfil" → Error 403 Forbidden

**Ahora debe funcionar:**
1. Ir a Perfil
2. **Verificar que NO aparece error 403**
3. **Verificar que se cargan:**
   - Reseñas del usuario
   - Fotografías del usuario
   - Listas del usuario

---

### ✅ Error de Columna total_reseñas (RESUELTO)
**Antes:** Error PostgreSQL: "no existe la columna total_reseñas"

**Ahora debe funcionar:**
1. Ver sitios populares
2. **Verificar que NO hay error en logs del backend**
3. **Verificar que se muestran los sitios**

---

### ✅ Error de Tabla reseñas (RESUELTO)
**Antes:** Error PostgreSQL: "no existe la relación reseñas"

**Ahora debe funcionar:**
1. Ver reseñas de un sitio
2. Crear una reseña
3. **Verificar que NO hay error de tabla**

---

## 📊 CHECKLIST FINAL DE VALIDACIÓN

Marca cada item cuando lo hayas probado exitosamente:

### Autenticación
- [ ] Login correcto
- [ ] Login con credenciales incorrectas (debe fallar)
- [ ] Registro de nuevo usuario
- [ ] Logout

### Sitios
- [ ] Ver todos los sitios
- [ ] Ver sitios populares
- [ ] Filtrar por tipo
- [ ] Ver detalle de sitio
- [ ] Crear sitio
- [ ] Editar sitio
- [ ] Eliminar sitio

### Reseñas
- [ ] Crear reseña
- [ ] Editar reseña propia
- [ ] Eliminar reseña propia
- [ ] Ver reseñas de un sitio
- [ ] Ver reseñas en mi perfil

### Fotografías
- [ ] Agregar fotografía a sitio
- [ ] Eliminar fotografía propia
- [ ] Ver galería de fotos de un sitio
- [ ] Ver mis fotografías en perfil

### Perfil
- [ ] Ver mi perfil (sin error 403)
- [ ] Ver estadísticas de contribuciones
- [ ] Editar perfil

### Listas
- [ ] Crear lista
- [ ] Agregar sitio a lista
- [ ] Ver sitios de una lista
- [ ] Eliminar sitio de lista
- [ ] Eliminar lista
- [ ] Ver mis listas en perfil (sin error 403)

---

## 🔍 DEBUGGING - Si Algo Falla

### Backend no responde (Error de conexión)
**Verificar:**
```bash
# ¿Está el backend corriendo?
# Debería estar en http://localhost:8090
```

### Error 403 en requests
**Verificar:**
1. ¿Token existe en localStorage?
2. ¿Token está siendo enviado en headers?
3. Revisar logs del backend - debe decir "Usuario autenticado exitosamente"

### Error de base de datos
**Verificar:**
1. ¿Ejecutaste el script de migración de la tabla resenas?
2. Revisar logs del backend para ver el error SQL exacto

### Frontend no carga
**Verificar:**
```bash
cd FrontEnd
npm run dev
# Debe iniciar en http://localhost:5173
```

---

## 📝 NOTAS ADICIONALES

### Datos de Prueba Incluidos
- **Usuario:** `ana@tbd.cl` / `password123`
- **Sitios:** 5 sitios turísticos pre-cargados
- **Reseñas:** Algunas reseñas de ejemplo

### Endpoints Disponibles
- POST `/api/auth/login`
- POST `/api/auth/registro`
- GET `/api/sitios`
- GET `/api/sitios/populares`
- GET `/api/sitios/tipo?tipo=Parque`
- GET `/api/sitios/{id}`
- POST `/api/sitios`
- PUT `/api/sitios/{id}`
- DELETE `/api/sitios/{id}`
- GET `/api/sitios/{id}/reseñas`
- POST `/api/sitios/{id}/reseñas`
- GET `/api/resenas/usuario/{id}`
- PUT `/api/reseñas/{id}`
- DELETE `/api/reseñas/{id}`
- GET `/api/sitios/{id}/fotografias`
- POST `/api/sitios/{id}/fotografias`
- GET `/api/fotografias/usuario/{id}`
- DELETE `/api/fotografias/{id}`
- GET `/api/listas/mis-listas`
- GET `/api/listas/usuario/{id}`
- POST `/api/listas`
- DELETE `/api/listas/{id}`
- GET `/api/listas/{id}/sitios`
- POST `/api/listas/{id}/sitios/{idSitio}`
- DELETE `/api/listas/{id}/sitios/{idSitio}`

---

**¡Listo para probar! 🚀**
