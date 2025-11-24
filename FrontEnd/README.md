# Frontend - Mapa Colaborativo de Sitios Turísticos

Frontend desarrollado con Vue.js 3 para la aplicación de mapa colaborativo de sitios turísticos.

## Tecnologías Utilizadas

- **Vue.js 3** - Framework JavaScript progresivo
- **Vite** - Build tool y dev server
- **Pinia** - State management
- **Vue Router** - Enrutamiento
- **Axios** - Cliente HTTP para comunicación con API
- **JWT** - Autenticación basada en tokens

## Estructura del Proyecto

```
src/
├── assets/          # Recursos estáticos (estilos, imágenes)
├── components/      # Componentes reutilizables
│   ├── common/      # Componentes comunes (botones, cards, etc.)
│   ├── layout/      # Componentes de layout (Navbar, Footer)
│   ├── sites/       # Componentes relacionados con sitios
│   ├── reviews/     # Componentes de reseñas
│   ├── photos/      # Componentes de fotografías
│   └── lists/       # Componentes de listas personalizadas
├── views/           # Vistas/páginas de la aplicación
├── router/          # Configuración de rutas
├── services/        # Servicios de API (Axios)
├── stores/          # Stores de Pinia (state management)
└── composables/     # Composables de Vue (lógica reutilizable)
```

## Configuración

### 1. Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto basándote en `.env.example`:

```bash
cp .env.example .env
```

Edita el archivo `.env` y configura la URL de tu backend:

```
VITE_API_URL=http://localhost:8080/api
```

### 2. Instalación de Dependencias

```bash
npm install
```

## Comandos Disponibles

### Desarrollo

Inicia el servidor de desarrollo con hot-reload:

```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:5173`

### Producción

Compila y minifica para producción:

```bash
npm run build
```

### Preview

Previsualiza la build de producción:

```bash
npm run preview
```

## Funcionalidades Implementadas

### ✅ Autenticación
- Sistema de login/registro con JWT
- Guards de rutas para proteger páginas
- Persistencia de sesión en localStorage

### ✅ Gestión de Sitios Turísticos
- Listado de sitios con filtros por tipo
- Vista detallada de cada sitio
- Creación y edición de sitios
- Búsqueda de sitios

### ✅ Reseñas
- Sistema de calificación con estrellas
- Escritura y visualización de reseñas
- Reseñas por sitio y por usuario

### ✅ Fotografías
- Subida de fotografías (por URL)
- Galería de fotos por sitio
- Fotos del perfil de usuario

### ✅ Listas Personalizadas
- Creación de listas de sitios favoritos
- Gestión de listas (crear, ver, eliminar)
- Agregar sitios a listas

### ✅ Perfil de Usuario
- Vista de perfil con estadísticas
- Historial de reseñas y fotos
- Contribuciones del usuario

### ✅ Mapa Interactivo (Planificado)
- Espacio reservado en el diseño para futura implementación
- Coordenadas almacenadas para cada sitio

## Estructura de Rutas

| Ruta | Componente | Protegida | Descripción |
|------|-----------|-----------|-------------|
| `/` | HomeView | No | Página de inicio |
| `/login` | LoginView | Solo invitados | Login/Registro |
| `/sitios` | SitesListView | Sí | Listado de sitios |
| `/sitios/crear` | SiteFormView | Sí | Crear nuevo sitio |
| `/sitios/:id` | SiteDetailView | Sí | Detalle de sitio |
| `/sitios/:id/editar` | SiteFormView | Sí | Editar sitio |
| `/perfil` | ProfileView | Sí | Perfil de usuario |
| `/mis-listas` | ListsView | Sí | Listas personalizadas |

## Integración con Backend

El frontend se comunica con el backend a través de Axios. Los servicios están organizados por entidad:

- `authService.js` - Autenticación
- `sitesService.js` - Sitios turísticos
- `reviewsService.js` - Reseñas
- `photosService.js` - Fotografías
- `listsService.js` - Listas personalizadas
- `usersService.js` - Usuarios

Cada petición HTTP incluye automáticamente el token JWT en los headers cuando el usuario está autenticado.

## Gestión de Estado

Utiliza Pinia para el manejo de estado global:

- **auth** - Estado de autenticación
- **sites** - Sitios turísticos
- **reviews** - Reseñas
- **photos** - Fotografías
- **lists** - Listas personalizadas

## Diseño Responsive

La aplicación está diseñada para funcionar en dispositivos móviles, tablets y desktop, con breakpoints en:

- Mobile: < 768px
- Tablet/Desktop: >= 768px

## Mejoras Futuras

- [ ] Implementación del mapa interactivo con Leaflet o Google Maps
- [ ] Filtros avanzados de búsqueda
- [ ] Sistema de seguimiento de usuarios
- [ ] Notificaciones en tiempo real
- [ ] Modo oscuro
- [ ] Internacionalización (i18n)
- [ ] PWA (Progressive Web App)
- [ ] Carga de imágenes desde dispositivo (no solo URL)

## Soporte de Navegadores

- Chrome/Edge (últimas 2 versiones)
- Firefox (últimas 2 versiones)
- Safari (últimas 2 versiones)

## Recommended IDE Setup

[VS Code](https://code.visualstudio.com/) + [Vue (Official)](https://marketplace.visualstudio.com/items?itemName=Vue.volar)

## Licencia

Este proyecto es parte del curso Taller de Base de Datos de la Universidad de Santiago de Chile.
