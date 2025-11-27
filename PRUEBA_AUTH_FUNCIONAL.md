# Pruebas Funcionales del Módulo de Autenticación

## Resumen

Este documento describe las pruebas funcionales implementadas para el módulo de autenticación del sistema. Las pruebas cubren tanto el servicio de autenticación (`authService.js`) como el store de estado global (`auth.js` - Pinia).

## Herramientas Utilizadas

- **Vitest**: Framework de testing para Vue 3
- **@vue/test-utils**: Utilidades para testing de componentes Vue
- **happy-dom**: Entorno DOM ligero para tests
- **@vitest/coverage-v8**: Generación de reportes de cobertura

## Estructura de Archivos

```
FrontEnd/
├── src/
│   ├── services/
│   │   ├── authService.js         # Servicio de autenticación
│   │   └── api.js                 # Cliente HTTP
│   ├── stores/
│   │   └── auth.js                # Store de autenticación (Pinia)
│   └── tests/
│       ├── unit/
│       │   └── authService.test.js         # Tests unitarios
│       └── integration/
│           └── auth.store.test.js          # Tests de integración
├── vitest.config.js               # Configuración de Vitest
└── package.json
```

## Cobertura de Código

```
-----------------|---------|----------|---------|---------|-------------------
File             | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
-----------------|---------|----------|---------|---------|-------------------
All files        |     100 |       90 |     100 |     100 |
 services        |     100 |    83.33 |     100 |     100 |
  authService.js |     100 |    83.33 |     100 |     100 | 15
 stores          |     100 |      100 |     100 |     100 |
  auth.js        |     100 |      100 |     100 |     100 |
-----------------|---------|----------|---------|---------|-------------------
```

**Resumen:**
- ✅ **100% de cobertura de statements**
- ✅ **90% de cobertura de branches**
- ✅ **100% de cobertura de funciones**
- ✅ **100% de cobertura de líneas**

## Tests Unitarios - authService.js

### Casos de Prueba

#### 1. Login (`authService.login`)

**✅ Test: Debe hacer login exitosamente y guardar token y usuario en localStorage**
- Verifica que se llame al API con las credenciales correctas
- Verifica que el token se guarde en localStorage
- Verifica que el usuario se guarde en localStorage
- Verifica que retorne los datos correctos

**✅ Test: Debe manejar error cuando el login falla**
- Verifica que lance una excepción cuando las credenciales son inválidas
- Verifica que NO se guarde nada en localStorage en caso de error

**✅ Test: No debe guardar en localStorage si no hay token en la respuesta**
- Verifica el manejo de respuestas incompletas del servidor

#### 2. Registro (`authService.register`)

**✅ Test: Debe registrar un usuario exitosamente y guardar token y usuario**
- Verifica que se llame al API con los datos del usuario
- Verifica que el token se guarde en localStorage
- Verifica que el usuario se guarde en localStorage
- Verifica que retorne los datos correctos

**✅ Test: Debe manejar error cuando el registro falla**
- Verifica que lance una excepción cuando el email ya existe
- Verifica que NO se guarde nada en localStorage en caso de error

#### 3. Logout (`authService.logout`)

**✅ Test: Debe eliminar token y usuario de localStorage**
- Verifica que se eliminen tanto el token como el usuario
- Verifica que se llamen los métodos removeItem correctamente

#### 4. Obtener Usuario Actual (`authService.getCurrentUser`)

**✅ Test: Debe retornar el usuario actual desde localStorage**
- Verifica que se obtenga el usuario parseado correctamente

**✅ Test: Debe retornar null si no hay usuario en localStorage**
- Verifica el comportamiento cuando no hay sesión activa

**✅ Test: Debe manejar JSON inválido en localStorage**
- Verifica que lance una excepción si el JSON está corrupto

#### 5. Obtener Token (`authService.getToken`)

**✅ Test: Debe retornar el token desde localStorage**
- Verifica que se obtenga el token correctamente

**✅ Test: Debe retornar null si no hay token en localStorage**
- Verifica el comportamiento cuando no hay sesión activa

#### 6. Verificar Autenticación (`authService.isAuthenticated`)

**✅ Test: Debe retornar true si hay un token**
- Verifica que detecte correctamente una sesión activa

**✅ Test: Debe retornar false si no hay token**
- Verifica que detecte correctamente cuando no hay sesión

**✅ Test: Debe retornar false si el token está vacío**
- Verifica que un token vacío no se considere válido

## Tests de Integración - auth.js (Pinia Store)

### Casos de Prueba

#### 1. Estado Inicial

**✅ Test: Debe inicializar con valores por defecto**
- Verifica que user, token, loading y error inicien correctamente

**✅ Test: Debe inicializar con usuario y token si existen en localStorage**
- Verifica que se restaure la sesión desde localStorage

#### 2. Computed: isAuthenticated

**✅ Test: Debe retornar true cuando hay un token**
- Verifica la propiedad computada isAuthenticated

**✅ Test: Debe retornar false cuando no hay token**
- Verifica el estado no autenticado

#### 3. Acción: login

**✅ Test: Debe hacer login exitosamente**
- Verifica que se actualice el estado del store
- Verifica que se limpien los errores
- Verifica que loading se maneje correctamente

**✅ Test: Debe establecer loading a true durante el login**
- Verifica el estado de carga durante operaciones asíncronas

**✅ Test: Debe manejar errores de login correctamente**
- Verifica que se establezca el mensaje de error
- Verifica que el estado se mantenga limpio en caso de error

**✅ Test: Debe manejar errores sin mensaje de respuesta**
- Verifica el mensaje de error por defecto

**✅ Test: Debe limpiar el error anterior antes de un nuevo intento de login**
- Verifica que los errores no persistan entre intentos

#### 4. Acción: register

**✅ Test: Debe registrar un usuario exitosamente**
- Verifica que se actualice el estado del store
- Verifica que se limpien los errores
- Verifica que loading se maneje correctamente

**✅ Test: Debe establecer loading a true durante el registro**
- Verifica el estado de carga durante operaciones asíncronas

**✅ Test: Debe manejar errores de registro correctamente**
- Verifica que se establezca el mensaje de error
- Verifica que el estado se mantenga limpio en caso de error

**✅ Test: Debe manejar errores de registro sin mensaje de respuesta**
- Verifica el mensaje de error por defecto

#### 5. Acción: logout

**✅ Test: Debe hacer logout correctamente**
- Verifica que se limpie el estado del store
- Verifica que se llame al servicio de logout

**✅ Test: Debe limpiar el estado incluso si ya estaba en null**
- Verifica que el logout sea idempotente

#### 6. Flujo Completo de Autenticación

**✅ Test: Debe manejar el ciclo completo: login → uso → logout**
- Verifica el flujo completo de autenticación
- Verifica que isAuthenticated cambie correctamente

**✅ Test: Debe manejar múltiples intentos de login fallidos seguidos de un éxito**
- Verifica el manejo de errores múltiples
- Verifica la recuperación después de errores

## Comandos para Ejecutar los Tests

### Ejecutar todos los tests
```bash
cd FrontEnd
npm run test
```

### Ejecutar tests una sola vez (CI/CD)
```bash
npm run test:run
```

### Ejecutar tests con reporte de cobertura
```bash
npm run test:coverage
```

### Ejecutar tests con interfaz gráfica
```bash
npm run test:ui
```

## Resultados de la Ejecución

```
✓ src/tests/unit/authService.test.js (14 tests)
✓ src/tests/integration/auth.store.test.js (17 tests)

Test Files  2 passed (2)
     Tests  31 passed (31)
  Start at  03:39:00
  Duration  2.14s
```

## Interpretación de Resultados

### ✅ Todos los tests pasaron exitosamente

- **31 tests** ejecutados
- **0 fallos**
- **100% de cobertura de código** en las funciones principales
- **Tiempo de ejecución:** ~2.14 segundos

### Áreas Cubiertas

1. **Autenticación básica:** Login y registro de usuarios
2. **Gestión de sesión:** Almacenamiento y recuperación de tokens
3. **Manejo de errores:** Errores de red, credenciales inválidas, etc.
4. **Estado de la aplicación:** Loading states, errores, usuario actual
5. **Flujos completos:** Ciclos completos de autenticación
6. **Edge cases:** JSON inválido, tokens vacíos, múltiples intentos

## Conclusiones

✅ El módulo de autenticación está completamente testeado
✅ La cobertura de código es excelente (100% funciones, 90% branches)
✅ Se cubren tanto casos normales como casos extremos
✅ Los tests son mantenibles y bien documentados
✅ El tiempo de ejecución es razonable

## Recomendaciones

1. **Tests E2E:** Considerar agregar tests end-to-end con Cypress o Playwright
2. **Tests de componentes:** Agregar tests para componentes de UI (LoginForm, RegisterForm)
3. **Tests de performance:** Verificar tiempos de respuesta bajo carga
4. **Security testing:** Agregar tests específicos de seguridad (XSS, CSRF)

## Próximos Pasos

- [ ] Implementar tests E2E para flujos completos de usuario
- [ ] Agregar tests de componentes Vue
- [ ] Configurar CI/CD para ejecutar tests automáticamente
- [ ] Agregar tests de regresión para bugs conocidos
