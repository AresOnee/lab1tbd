#!/bin/bash
# Script para reiniciar el frontend correctamente en Mac/Linux

echo ""
echo "========================================"
echo "   REINICIO DEL FRONTEND"
echo "========================================"
echo ""

# Verificar si existe .env
if [ ! -f .env ]; then
    echo "[ERROR] No existe el archivo .env"
    echo ""
    echo "Creando .env desde .env.example..."
    cp .env.example .env
    echo "[OK] Archivo .env creado"
    echo ""
fi

# Mostrar contenido de .env
echo "Contenido actual de .env:"
echo "----------------------------------------"
cat .env
echo "----------------------------------------"
echo ""

# Verificar si el puerto es correcto
if ! grep -q "8090" .env; then
    echo "[ADVERTENCIA] El archivo .env no contiene el puerto 8090"
    echo "Asegúrate de que contenga: VITE_API_URL=http://localhost:8090/api"
    exit 1
fi

echo "[OK] El archivo .env tiene el puerto correcto (8090)"
echo ""

# Matar cualquier proceso de Vite que pueda estar corriendo
echo "Deteniendo procesos anteriores..."
pkill -f "vite" 2>/dev/null || true
sleep 2
echo ""

# Limpiar caché de Vite
echo "Limpiando cache de Vite..."
if [ -d "node_modules/.vite" ]; then
    rm -rf node_modules/.vite
    echo "[OK] Cache de Vite eliminado"
else
    echo "[INFO] No hay cache de Vite para eliminar"
fi
echo ""

# Iniciar el servidor
echo "Iniciando servidor de desarrollo..."
echo ""
echo "========================================"
echo "   SERVIDOR INICIANDO"
echo "========================================"
echo ""
echo "[IMPORTANTE] Una vez que el servidor inicie:"
echo "  1. Abre el navegador en http://localhost:5173"
echo "  2. Presiona F12 para abrir DevTools"
echo "  3. Ve a la consola y ejecuta: import.meta.env.VITE_API_URL"
echo "  4. Deberías ver: \"http://localhost:8090/api\""
echo ""
echo "Si ves \"undefined\", presiona Ctrl+C y ejecuta este script nuevamente."
echo ""

npm run dev
