/**
 * Script para verificar que las variables de entorno se carguen correctamente
 * Ejecutar con: node verificar-env.js
 */

console.log('\n=== VERIFICACIÓN DE VARIABLES DE ENTORNO ===\n');

// Verificar archivo .env
const fs = require('fs');
const path = require('path');

const envPath = path.join(__dirname, '.env');
const envExamplePath = path.join(__dirname, '.env.example');

console.log('1. Verificando archivos...');
console.log(`   .env existe: ${fs.existsSync(envPath) ? '✅' : '❌'}`);
console.log(`   .env.example existe: ${fs.existsSync(envExamplePath) ? '✅' : '❌'}`);

if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf8');
  console.log('\n2. Contenido de .env:');
  console.log('   ' + envContent.split('\n').filter(line => line.trim()).join('\n   '));

  const hasViteApiUrl = envContent.includes('VITE_API_URL');
  const hasPort8090 = envContent.includes('8090');

  console.log('\n3. Validación:');
  console.log(`   Contiene VITE_API_URL: ${hasViteApiUrl ? '✅' : '❌'}`);
  console.log(`   Usa puerto 8090: ${hasPort8090 ? '✅' : '❌'}`);

  if (!hasViteApiUrl || !hasPort8090) {
    console.log('\n⚠️  ERROR: Tu archivo .env no está configurado correctamente');
    console.log('   Debería contener: VITE_API_URL=http://localhost:8090/api');
  } else {
    console.log('\n✅ Tu archivo .env está correctamente configurado');
  }
} else {
  console.log('\n❌ ERROR: No existe el archivo .env');
  console.log('\n📝 SOLUCIÓN:');
  if (process.platform === 'win32') {
    console.log('   En Windows, ejecuta: copy .env.example .env');
  } else {
    console.log('   En Mac/Linux, ejecuta: cp .env.example .env');
  }
}

console.log('\n4. Sistema operativo:', process.platform);
console.log('5. Directorio actual:', __dirname);

console.log('\n=== INSTRUCCIONES ===');
console.log('\nPara que Vite cargue las variables de entorno:');
console.log('1. Asegúrate de que el archivo .env existe y está correcto (ver arriba)');
console.log('2. DETÉN completamente el servidor de Vite con Ctrl+C');
console.log('3. Inicia nuevamente con: npm run dev');
console.log('4. Recarga el navegador con Ctrl+Shift+R');
console.log('\n⚠️  IMPORTANTE: Vite NO recarga .env con hot-reload, debes reiniciar completamente\n');
