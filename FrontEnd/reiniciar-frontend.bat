@echo off
REM Script para reiniciar el frontend correctamente en Windows
echo.
echo ========================================
echo   REINICIO DEL FRONTEND
echo ========================================
echo.

REM Verificar si existe .env
if not exist .env (
    echo [ERROR] No existe el archivo .env
    echo.
    echo Creando .env desde .env.example...
    copy .env.example .env
    echo [OK] Archivo .env creado
    echo.
)

REM Mostrar contenido de .env
echo Contenido actual de .env:
echo ----------------------------------------
type .env
echo ----------------------------------------
echo.

REM Verificar si el puerto es correcto
findstr /C:"8090" .env >nul
if errorlevel 1 (
    echo [ADVERTENCIA] El archivo .env no contiene el puerto 8090
    echo Asegurate de que contenga: VITE_API_URL=http://localhost:8090/api
    pause
    exit /b 1
)

echo [OK] El archivo .env tiene el puerto correcto (8090)
echo.

REM Matar cualquier proceso de Node/Vite que pueda estar corriendo
echo Deteniendo procesos anteriores...
taskkill /F /IM node.exe 2>nul
timeout /t 2 /nobreak >nul
echo.

REM Limpiar caché de Vite
echo Limpiando cache de Vite...
if exist node_modules\.vite (
    rmdir /s /q node_modules\.vite
    echo [OK] Cache de Vite eliminado
) else (
    echo [INFO] No hay cache de Vite para eliminar
)
echo.

REM Iniciar el servidor
echo Iniciando servidor de desarrollo...
echo.
echo ========================================
echo   SERVIDOR INICIANDO
echo ========================================
echo.
echo [IMPORTANTE] Una vez que el servidor inicie:
echo   1. Abre el navegador en http://localhost:5173
echo   2. Presiona F12 para abrir DevTools
echo   3. Ve a la consola y ejecuta: import.meta.env.VITE_API_URL
echo   4. Deberias ver: "http://localhost:8090/api"
echo.
echo Si ves "undefined", presiona Ctrl+C y ejecuta este script nuevamente.
echo.

npm run dev
