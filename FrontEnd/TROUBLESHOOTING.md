# 🔧 Solución de Problemas - Error de Conexión

## ❌ Error: `ERR_CONNECTION_REFUSED` en `:8080/api/auth/login`

Este error significa que el frontend está intentando conectarse al puerto **8080** cuando debería usar el puerto **8090**.

---

## ✅ SOLUCIÓN RÁPIDA (Windows)

### Opción 1: Usar el script automático

1. Abre una terminal (CMD o PowerShell) en la carpeta `FrontEnd/`
2. Ejecuta:
   ```cmd
   reiniciar-frontend.bat
   ```
3. El script automáticamente:
   - Verificará y creará el archivo `.env` si no existe
   - Limpiará el caché de Vite
   - Detendrá procesos anteriores
   - Iniciará el servidor correctamente

### Opción 2: Pasos manuales

1. **Asegúrate de estar en la carpeta FrontEnd:**
   ```cmd
   cd FrontEnd
   ```

2. **Verifica que el archivo .env exista:**
   ```cmd
   dir .env
   ```

   Si NO existe, créalo:
   ```cmd
   copy .env.example .env
   ```

3. **Verifica el contenido del .env:**
   ```cmd
   type .env
   ```

   Debe mostrar:
   ```
   VITE_API_URL=http://localhost:8090/api
   ```

4. **DETÉN completamente cualquier proceso de Vite:**
   - Ve a la terminal donde corre `npm run dev`
   - Presiona `Ctrl+C` dos veces para asegurarte de que se detuvo
   - O ejecuta: `taskkill /F /IM node.exe`

5. **Limpia el caché de Vite:**
   ```cmd
   rmdir /s /q node_modules\.vite
   ```

6. **Inicia el servidor nuevamente:**
   ```cmd
   npm run dev
   ```

7. **Limpia el caché del navegador:**
   - Presiona `Ctrl+Shift+R` para forzar recarga
   - O cierra y abre el navegador nuevamente

---

## ✅ SOLUCIÓN RÁPIDA (Mac/Linux)

### Opción 1: Usar el script automático

1. Abre una terminal en la carpeta `FrontEnd/`
2. Ejecuta:
   ```bash
   ./reiniciar-frontend.sh
   ```

### Opción 2: Pasos manuales

1. **Asegúrate de estar en la carpeta FrontEnd:**
   ```bash
   cd FrontEnd
   ```

2. **Verifica que el archivo .env exista:**
   ```bash
   ls -la .env
   ```

   Si NO existe, créalo:
   ```bash
   cp .env.example .env
   ```

3. **Verifica el contenido del .env:**
   ```bash
   cat .env
   ```

   Debe mostrar:
   ```
   VITE_API_URL=http://localhost:8090/api
   ```

4. **DETÉN completamente Vite:**
   ```bash
   pkill -f vite
   ```

5. **Limpia el caché de Vite:**
   ```bash
   rm -rf node_modules/.vite
   ```

6. **Inicia el servidor nuevamente:**
   ```bash
   npm run dev
   ```

7. **Limpia el caché del navegador:**
   - Presiona `Cmd+Shift+R` para forzar recarga

---

## 🔍 Verificar que Funcionó

1. Abre el navegador en `http://localhost:5173`
2. Presiona `F12` para abrir DevTools
3. Ve a la pestaña "Console"
4. Ejecuta este comando:
   ```javascript
   import.meta.env.VITE_API_URL
   ```

**Resultado esperado:**
```
"http://localhost:8090/api"
```

**Si ves `undefined` o `http://localhost:8080/api`:**
- Vite no cargó el archivo `.env` correctamente
- Repite los pasos anteriores asegurándote de **reiniciar completamente Vite**

---

## 🛠️ Script de Verificación

Puedes usar el script de verificación para diagnosticar el problema:

```bash
node verificar-env.js
```

Este script te dirá:
- ✅ Si el archivo `.env` existe
- ✅ Si tiene el contenido correcto
- ✅ Si está usando el puerto correcto (8090)

---

## 🧩 Problemas Comunes

### 1. "El archivo .env existe pero Vite sigue usando puerto 8080"

**Causa:** Vite NO recarga automáticamente las variables de entorno. Solo las lee al iniciar.

**Solución:**
- DEBES reiniciar completamente Vite (no solo refrescar el navegador)
- Presiona `Ctrl+C` en la terminal donde corre Vite
- Ejecuta `npm run dev` nuevamente

### 2. "Sigo viendo el puerto 8080 después de reiniciar Vite"

**Causa:** El navegador tiene la aplicación en caché.

**Solución:**
- Abre DevTools (F12)
- Ve a Network → Marca "Disable cache"
- Presiona `Ctrl+Shift+R` para forzar recarga sin caché
- O cierra y abre el navegador completamente

### 3. "No puedo crear el archivo .env en Windows"

**Causa:** Windows Notepad agrega extensión `.txt` automáticamente.

**Solución:**
- Usa la terminal CMD: `copy .env.example .env`
- O usa VSCode/otro editor: Archivo → Guardar como → Nombre: `.env` (sin extensión)
- O usa PowerShell: `Copy-Item .env.example .env`

### 4. "El puerto 8090 también falla"

**Causa:** El backend no está corriendo.

**Solución:**
1. Ve a la carpeta `Backend/`
2. Inicia el backend:
   - Windows: `mvnw.cmd spring-boot:run`
   - Mac/Linux: `./mvnw spring-boot:run`
3. Espera a ver: `Started Lab1tbdApplication`
4. Verifica abriendo: http://localhost:8090/api

### 5. "El script .bat no funciona en Windows"

**Causa:** Política de ejecución de scripts o permisos.

**Solución:**
- Ejecuta CMD como Administrador
- O usa PowerShell: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
- O ejecuta los pasos manuales (ver arriba)

---

## 📊 Puertos del Proyecto

| Servicio | Puerto | URL |
|----------|--------|-----|
| Frontend (Vite) | 5173 | http://localhost:5173 |
| Backend (Spring Boot) | 8090 | http://localhost:8090/api |
| Base de Datos (PostgreSQL) | 5432 | jdbc:postgresql://localhost:5432/lab1tbd |

---

## 🆘 Última Opción

Si NADA de lo anterior funciona, el fallback en `api.js` ahora usa el puerto **8090** por defecto. Esto significa que incluso sin el archivo `.env`, debería funcionar.

**Verifica el archivo `src/services/api.js` línea 3:**
```javascript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8090/api'
```

El fallback debe ser `8090`, NO `8080`.

Si el fallback es `8080`, haz pull de los últimos cambios:
```bash
git pull origin claude/check-cors-requirements-01Bo4GLtNaSTkZ8bxhpKk5nT
```

---

## 📝 Notas Importantes

- ⚠️ **Vite solo lee `.env` al iniciar**, no durante hot-reload
- ⚠️ **El archivo `.env` NO está en el repositorio** (está en `.gitignore`)
- ⚠️ **Cada desarrollador debe crear su propio `.env`** basado en `.env.example`
- ✅ **El fallback ahora es 8090**, así que debería funcionar incluso sin `.env`

---

¿Sigues teniendo problemas? Revisa:
- `SETUP.md` - Guía de configuración completa
- `README.md` - Documentación general del proyecto
