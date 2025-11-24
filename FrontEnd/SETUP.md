# Guía de Configuración del Frontend

## Problema: Frontend no puede conectarse al Backend

Si ves errores como `ERR_CONNECTION_REFUSED` en el puerto 8080, significa que el frontend está intentando conectarse al puerto incorrecto. El backend corre en el puerto **8090**, no en el 8080.

## Solución: Configurar Variables de Entorno

Sigue estos pasos **en tu máquina local** (Windows/Mac/Linux):

### Paso 1: Actualizar el Repositorio

Primero, asegúrate de tener los últimos cambios:

```bash
git pull origin claude/check-cors-requirements-01Bo4GLtNaSTkZ8bxhpKk5nT
```

### Paso 2: Crear el Archivo .env

El archivo `.env` **NO está en el repositorio** (está en .gitignore para evitar conflictos entre diferentes entornos). Debes crearlo manualmente:

#### En Windows:

```cmd
cd FrontEnd
copy .env.example .env
```

#### En Mac/Linux:

```bash
cd FrontEnd
cp .env.example .env
```

### Paso 3: Verificar el Contenido del .env

Abre el archivo `FrontEnd/.env` y verifica que contenga:

```
VITE_API_URL=http://localhost:8090/api
```

**Nota:** El puerto debe ser **8090** (no 8080).

### Paso 4: Reiniciar Completamente Vite

Es **CRÍTICO** que reinicies completamente el servidor de desarrollo de Vite. Un simple refresh del navegador NO es suficiente.

1. **Detener Vite:** Ve a la terminal donde está corriendo el frontend y presiona `Ctrl+C` para detenerlo completamente
2. **Iniciar nuevamente:**
   ```bash
   npm run dev
   ```
3. **Forzar recarga del navegador:** Una vez que Vite inicie, abre el navegador y presiona `Ctrl+Shift+R` (Windows/Linux) o `Cmd+Shift+R` (Mac) para forzar la recarga

### Paso 5: Verificar la Conexión

Abre las herramientas de desarrollo del navegador (F12) y ve a la consola. Escribe:

```javascript
import.meta.env.VITE_API_URL
```

Deberías ver: `"http://localhost:8090/api"`

Si ves `undefined` o el puerto 8080, significa que Vite no cargó el archivo `.env` correctamente.

## Problemas Comunes

### 1. "Vite no lee mi archivo .env"

**Soluciones:**

- Verifica que el archivo se llame exactamente `.env` (sin extensión adicional como `.env.txt`)
- Verifica que esté en la carpeta `FrontEnd/`, no en la raíz del proyecto
- Detén completamente Vite con `Ctrl+C` y vuelve a iniciar con `npm run dev`
- Verifica que no haya espacios antes o después de la línea `VITE_API_URL=http://localhost:8090/api`

### 2. "Sigo viendo el puerto 8080"

**Causa:** El navegador tiene la aplicación en caché.

**Solución:**
1. Cierra completamente el navegador
2. Abre las herramientas de desarrollo (F12)
3. Ve a Network → Marca la opción "Disable cache"
4. Recarga con `Ctrl+Shift+R`

### 3. "ERR_CONNECTION_REFUSED en el puerto 8090"

**Causa:** El backend no está corriendo.

**Solución:**
1. Ve a la carpeta `Backend/`
2. Inicia el backend:
   ```bash
   ./mvnw spring-boot:run
   ```
   O en Windows:
   ```cmd
   mvnw.cmd spring-boot:run
   ```
3. Espera hasta ver el mensaje: `Started Lab1tbdApplication`

## Verificación Final

Para verificar que todo está correcto:

1. **Backend:** Abre http://localhost:8090/api en el navegador. Deberías ver un error 401 o 404 (eso es normal, significa que el backend está funcionando)

2. **Frontend:** Abre http://localhost:5173 y verifica en la consola del navegador (F12) que NO haya errores de conexión

3. **Variables de entorno:** En la consola del navegador, ejecuta `console.log(import.meta.env.VITE_API_URL)` y deberías ver `http://localhost:8090/api`

## Resumen de Puertos

| Servicio | Puerto |
|----------|--------|
| Frontend (Vite) | 5173 |
| Backend (Spring Boot) | 8090 |
| Base de Datos (PostgreSQL) | 5432 |

## Notas Importantes

- **NUNCA** commitees el archivo `.env` al repositorio
- El archivo `.env.example` SÍ está en el repositorio y sirve como plantilla
- Cada desarrollador debe crear su propio `.env` basado en `.env.example`
- Vite solo lee las variables de entorno al iniciar, no durante hot-reload
