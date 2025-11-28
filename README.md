# 🗺️ Mapa Colaborativo de Sitios Turísticos

**Laboratorio 1 - Taller de Base de Datos**
Universidad de Santiago de Chile
Grupo 5

---

## 📋 Descripción

Red social interactiva donde los usuarios pueden descubrir, compartir y calificar sitios de interés turístico. La plataforma integra funcionalidades geoespaciales para búsquedas por ubicación, permitiendo a la comunidad colaborar en la creación de un recurso de viaje dinámico y actualizado.

### Características Principales

- 🔐 **Autenticación segura** con JWT
- 🏛️ **Catálogo de sitios turísticos** (museos, parques, restaurantes, teatros)
- ⭐ **Sistema de reseñas y calificaciones** (1-5 estrellas)
- 📸 **Galería de fotografías** de cada sitio
- 📝 **Listas personalizadas** de lugares favoritos
- 👥 **Red social** - Sigue a otros usuarios y ve sus contribuciones
- 📍 **Búsqueda geoespacial** - Encuentra sitios cercanos usando PostGIS
- 📊 **Estadísticas en tiempo real** - Triggers y vistas materializadas

---

## 🛠️ Tecnologías

### Backend
- **Spring Boot 3.5.7** con Java 17
- **PostgreSQL 14+** con extensión PostGIS
- **Spring Security** + JWT (JSON Web Tokens)
- **JDBC nativo** (sin JPA/Hibernate, solo SQL puro)
- **BCrypt** para hashing de contraseñas

### Frontend
- **Vue.js 3.5.22** (Composition API)
- **Pinia** para gestión de estado
- **Vue Router 4** para navegación
- **Axios 1.13.2** para peticiones HTTP
- **Vite** como build tool

### Base de Datos
- **PostgreSQL 14+**
- **PostGIS** para datos geoespaciales
- Triggers automáticos
- Procedimientos almacenados
- Vistas materializadas
- Índices optimizados (B-Tree y GIST)

---

## 📁 Estructura del Proyecto

```
lab1tbd/
├── Backend/                    # API RESTful en Spring Boot
│   ├── src/main/java/com/tbd/lab1tbd/
│   │   ├── Auth/              # Autenticación JWT
│   │   ├── Controllers/       # Endpoints REST
│   │   ├── Models/            # Entidades
│   │   ├── Repositories/      # Acceso a datos (SQL nativo)
│   │   ├── Services/          # Lógica de negocio
│   │   └── Config/            # Configuración Spring Security
│   └── pom.xml
│
├── FrontEnd/                   # Aplicación Vue.js
│   ├── src/
│   │   ├── components/        # Componentes reutilizables
│   │   ├── views/             # Vistas principales
│   │   ├── stores/            # Pinia stores
│   │   ├── services/          # API services (Axios)
│   │   └── router/            # Rutas Vue Router
│   └── package.json
│
├── SQL/                        # Scripts de base de datos
│   ├── tablitas.sql           # Creación de esquema completo
│   ├── crear_tabla_seguidores.sql
│   ├── consultas_enunciado.sql # 9 consultas requeridas
│   └── CARGAR_DATOS_WINDOWS.sql # Datos de prueba
│
├── DOCUMENTACION_BASE_DATOS.md # Documentación detallada de BD
├── README.md                   # Este archivo
└── Enunciado 1- Grupo 5.docx.pdf
```

---

## 🚀 Instalación y Configuración

### Requisitos Previos

- **Java 17** o superior ([Descargar](https://www.oracle.com/java/technologies/downloads/))
- **PostgreSQL 14+** ([Descargar](https://www.postgresql.org/download/))
- **Node.js 20+** ([Descargar](https://nodejs.org/))
- **Maven 3.6+** (incluido con Spring Boot)
- **Git**

### 1️⃣ Clonar el Repositorio

```bash
git clone https://github.com/AresOnee/lab1tbd.git
cd lab1tbd
```

### 2️⃣ Configurar Base de Datos

#### Paso 1: Crear base de datos

```bash
# Conectar a PostgreSQL
psql -U postgres

# Crear base de datos
CREATE DATABASE lab1tbd;

# Habilitar PostGIS
\c lab1tbd
CREATE EXTENSION IF NOT EXISTS postgis;

# Salir
\q
```

#### Paso 2: Ejecutar scripts de creación

**Opción A: Desde línea de comandos**
```bash
# Crear esquema completo (tablas, triggers, vistas, índices)
psql -U postgres -d lab1tbd -f SQL/tablitas.sql

# Agregar tabla de seguidores
psql -U postgres -d lab1tbd -f SQL/crear_tabla_seguidores.sql

# Cargar datos de prueba
psql -U postgres -d lab1tbd -f SQL/CARGAR_DATOS_WINDOWS.sql
```

**Opción B: Desde pgAdmin o DBeaver**
1. Conectar a la base de datos `lab1tbd`
2. Abrir y ejecutar `SQL/tablitas.sql`
3. Abrir y ejecutar `SQL/crear_tabla_seguidores.sql`
4. Abrir y ejecutar `SQL/CARGAR_DATOS_WINDOWS.sql`

#### Paso 3: Verificar instalación

```sql
-- Verificar tablas creadas
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Verificar datos cargados
SELECT COUNT(*) FROM usuarios;      -- Debe retornar 10
SELECT COUNT(*) FROM sitios_turisticos; -- Debe retornar 25
SELECT COUNT(*) FROM reseñas;       -- Debe retornar 53
```

### 3️⃣ Configurar Backend

#### Paso 1: Configurar application.properties

Editar `Backend/src/main/resources/application.properties`:

```properties
# Configuración de base de datos
spring.datasource.url=jdbc:postgresql://localhost:5432/lab1tbd
spring.datasource.username=postgres
spring.datasource.password=TU_CONTRASEÑA_AQUI

# JWT Configuration
jwt.secret=tu_clave_secreta_muy_segura_cambiar_en_produccion_minimo_256_bits
jwt.expiration=86400000

# Puerto del servidor
server.port=8080
```

**IMPORTANTE:** Cambiar `TU_CONTRASEÑA_AQUI` por tu contraseña de PostgreSQL.

#### Paso 2: Compilar y ejecutar

```bash
cd Backend

# Opción 1: Con Maven Wrapper (recomendado)
./mvnw spring-boot:run

# Opción 2: Con Maven instalado
mvn spring-boot:run

# Opción 3: Generar JAR y ejecutar
./mvnw clean package
java -jar target/lab1tbd-0.0.1-SNAPSHOT.jar
```

El backend estará disponible en: `http://localhost:8080`

#### Verificar que funciona:
```bash
curl http://localhost:8080/auth/login
# Debe retornar un error esperado (falta body), confirmando que el servidor está activo
```

### 4️⃣ Configurar Frontend

```bash
cd FrontEnd

# Instalar dependencias
npm install

# Ejecutar servidor de desarrollo
npm run dev
```

La aplicación estará disponible en: `http://localhost:5173`

---

## 👤 Usuarios de Prueba

Los datos de prueba incluyen 10 usuarios con contraseña `password123`:

| Email | Nombre | Rol |
|-------|--------|-----|
| maria.lopez@email.com | María López | Exploradora activa |
| juan.perez@email.com | Juan Pérez | Crítico gastronómico |
| ana.garcia@email.com | Ana García | Fotógrafa profesional |
| carlos.rodriguez@email.com | Carlos Rodríguez | Guía turístico |
| sofia.martinez@email.com | Sofía Martínez | Historiadora |
| diego.sanchez@email.com | Diego Sánchez | Amante del arte |
| lucia.torres@email.com | Lucía Torres | Aventurera |
| pablo.ramirez@email.com | Pablo Ramírez | Foodie |
| valentina.castro@email.com | Valentina Castro | Viajera frecuente |
| mateo.morales@email.com | Mateo Morales | Influencer turístico |

**Contraseña para todos:** `password123`

### Ejemplo de Login:
```json
POST http://localhost:8080/auth/login
Content-Type: application/json

{
  "email": "maria.lopez@email.com",
  "password": "password123"
}
```

---

## 📖 Uso de la Aplicación

### Flujo de Usuario

1. **Registro/Login**
   - Acceder a `http://localhost:5173`
   - Crear cuenta o iniciar sesión con usuarios de prueba

2. **Explorar Sitios**
   - Ver catálogo de sitios turísticos
   - Filtrar por tipo (Parque, Museo, Restaurante, Teatro)
   - Ver detalles, fotos y reseñas

3. **Contribuir**
   - Escribir reseñas con calificaciones
   - Subir fotografías
   - Crear listas personalizadas

4. **Interacción Social**
   - Seguir a otros usuarios
   - Ver perfiles con estadísticas
   - Explorar contribuciones de la comunidad

5. **Búsqueda Geoespacial** (desde backend)
   ```sql
   SELECT * FROM buscar_sitios_cercanos(-70.6483, -33.4372, 1000);
   -- Busca sitios a menos de 1km de Plaza de Armas, Santiago
   ```

---

## 🔌 API Endpoints

### Autenticación
```
POST   /auth/register          # Registrar nuevo usuario
POST   /auth/login             # Iniciar sesión (retorna JWT)
```

### Usuarios
```
GET    /users                  # Listar usuarios
GET    /users/{id}             # Obtener usuario por ID
PUT    /users/{id}             # Actualizar usuario
DELETE /users/{id}             # Eliminar usuario
```

### Sitios Turísticos
```
GET    /sitios                 # Listar sitios
GET    /sitios/{id}            # Obtener sitio por ID
POST   /sitios                 # Crear sitio
PUT    /sitios/{id}            # Actualizar sitio
DELETE /sitios/{id}            # Eliminar sitio
```

### Reseñas
```
GET    /resenas                # Listar reseñas
GET    /resenas/sitio/{id}     # Reseñas de un sitio
POST   /resenas                # Crear reseña
PUT    /resenas/{id}           # Actualizar reseña
DELETE /resenas/{id}           # Eliminar reseña
```

### Fotografías
```
GET    /fotografias            # Listar fotografías
GET    /fotografias/sitio/{id} # Fotos de un sitio
POST   /fotografias            # Subir fotografía
DELETE /fotografias/{id}       # Eliminar fotografía
```

### Listas
```
GET    /listas                 # Listar listas
GET    /listas/usuario/{id}    # Listas de un usuario
POST   /listas                 # Crear lista
DELETE /listas/{id}            # Eliminar lista
POST   /listas/{id}/sitios/{sitioId} # Agregar sitio a lista
```

### Seguidores
```
POST   /seguidores/follow/{id}    # Seguir usuario
DELETE /seguidores/unfollow/{id}  # Dejar de seguir
GET    /seguidores/{id}/followers # Seguidores de usuario
GET    /seguidores/{id}/following # Usuarios seguidos
GET    /seguidores/isfollowing/{id} # Verificar si sigues a usuario
```

### Estadísticas
```
GET    /estadisticas/usuario/{id} # Estadísticas de usuario
```

**Autenticación:** Todos los endpoints (excepto `/auth/*`) requieren header:
```
Authorization: Bearer <JWT_TOKEN>
```

---

## 🗄️ Base de Datos

### Esquema

La base de datos está normalizada en 3FN con las siguientes tablas:

- **usuarios** - Información de usuarios
- **sitios_turisticos** - Lugares turísticos (con coordenadas PostGIS)
- **reseñas** - Calificaciones y comentarios
- **fotografias** - URLs de imágenes
- **listas_personalizadas** - Listas creadas por usuarios
- **lista_sitios** - Relación N:M entre listas y sitios
- **seguidores** - Relación de seguimiento entre usuarios

### Elementos Avanzados

#### Triggers
- **trigger_actualizar_calificacion**: Actualiza automáticamente `calificacion_promedio` y `total_reseñas` cuando se modifica una reseña.

#### Procedimientos Almacenados
- **buscar_sitios_cercanos(long, lat, radio)**: Búsqueda geoespacial usando PostGIS.

#### Vistas Materializadas
- **resumen_contribuciones_usuario**: Pre-calcula estadísticas de usuarios (reseñas, fotos, listas).

#### Índices
- B-Tree en foreign keys para JOINs rápidos
- **GIST** en columna `coordenadas` para búsquedas geoespaciales eficientes

### Consultas SQL Implementadas

Las 9 consultas requeridas están en `SQL/consultas_enunciado.sql`:

1. ✅ Calificación promedio y conteo por tipo de sitio
2. ✅ Top 5 reseñadores más activos (últimos 6 meses)
3. ✅ Restaurantes a <100m de teatros (búsqueda geoespacial)
4. ✅ Sitios con calificación >4.5 y <10 reseñas
5. ✅ Total de reseñas por región/ciudad
6. ✅ Trigger de actualización automática de calificaciones
7. ✅ Sitios sin contribuciones en 3 meses
8. ✅ 3 reseñas más largas de usuarios con promedio >4.0
9. ✅ Vista materializada de resumen de contribuciones

**Ver documentación completa:** [DOCUMENTACION_BASE_DATOS.md](./DOCUMENTACION_BASE_DATOS.md)

---

## 🧪 Testing

### Backend (Spring Boot)
```bash
cd Backend
./mvnw test
```

### Frontend (Vue.js + Vitest)
```bash
cd FrontEnd

# Ejecutar tests
npm run test

# Tests con UI interactiva
npm run test:ui

# Tests con coverage
npm run test:coverage
```

---

## 📦 Construcción para Producción

### Backend
```bash
cd Backend
./mvnw clean package

# El JAR se genera en:
# target/lab1tbd-0.0.1-SNAPSHOT.jar

# Ejecutar:
java -jar target/lab1tbd-0.0.1-SNAPSHOT.jar
```

### Frontend
```bash
cd FrontEnd
npm run build

# Los archivos estáticos se generan en:
# dist/

# Servir con cualquier servidor web:
npx serve dist
```

---

## 🐛 Solución de Problemas

### Error: "Connection refused" al backend

**Causa:** Backend no está ejecutándose.

**Solución:**
```bash
cd Backend
./mvnw spring-boot:run
```

---

### Error: "relation does not exist" en PostgreSQL

**Causa:** Tablas no creadas.

**Solución:**
```bash
psql -U postgres -d lab1tbd -f SQL/tablitas.sql
psql -U postgres -d lab1tbd -f SQL/crear_tabla_seguidores.sql
```

---

### Error: "Cannot find module 'axios'"

**Causa:** Dependencias no instaladas.

**Solución:**
```bash
cd FrontEnd
npm install
```

---

### Error: "JWT token missing or invalid"

**Causa:** Token expirado o no enviado.

**Solución:**
1. Hacer login nuevamente
2. Copiar el token del response
3. Incluir en header: `Authorization: Bearer <token>`

---

### Error: "Password incorrect" con usuarios de prueba

**Causa:** Datos de prueba no cargados.

**Solución:**
```bash
psql -U postgres -d lab1tbd -f SQL/CARGAR_DATOS_WINDOWS.sql
```

---

## 📝 Funcionalidades Extras Implementadas

Más allá de los requisitos del enunciado:

- ✅ **Sistema completo de seguidores**
  - Tabla `seguidores` con constraints
  - Endpoints para seguir/dejar de seguir
  - Vista de seguidores y siguiendo
  - Botones de seguir en reseñas y perfiles

- ✅ **Suite de tests automatizados**
  - Tests unitarios con Vitest
  - Coverage del 100% en módulos críticos

- ✅ **Interfaz responsive**
  - Diseño adaptable a móviles y tablets
  - Componentes reutilizables

- ✅ **Validaciones completas**
  - Frontend: Validación de formularios
  - Backend: Spring Validation
  - Base de datos: CHECK constraints

---

## 👥 Equipo - Grupo 5

**Integrantes:**
- [Nombres de integrantes del grupo]

**Curso:** Taller de Base de Datos Diurno 2-2025
**Profesor:** Matías Calderón
**Ayudantes:** Pablo Macuada, Fernando Solis

---

## 📄 Licencia

Este proyecto es parte de un trabajo académico para la Universidad de Santiago de Chile.

---

## 📚 Recursos Adicionales

- [Documentación Spring Boot](https://spring.io/projects/spring-boot)
- [Documentación Vue.js 3](https://vuejs.org/)
- [PostGIS Documentation](https://postgis.net/documentation/)
- [JWT.io](https://jwt.io/)
- [Documentación completa de la BD](./DOCUMENTACION_BASE_DATOS.md)

---

## 📞 Soporte

Para dudas o problemas:
1. Revisar la [documentación de base de datos](./DOCUMENTACION_BASE_DATOS.md)
2. Verificar la sección de [solución de problemas](#🐛-solución-de-problemas)
3. Consultar con el equipo docente

---

**Fecha de entrega:** 20 de octubre de 2025
**Versión:** 1.0
**Última actualización:** 28 de noviembre de 2025
