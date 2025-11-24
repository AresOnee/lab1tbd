<template>
  <div class="login-view">
    <div class="login-container">
      <div class="login-header">
        <h1>{{ isLogin ? 'Iniciar Sesión' : 'Registrarse' }}</h1>
        <p>{{ isLogin ? 'Bienvenido de vuelta' : 'Crea tu cuenta' }}</p>
      </div>

      <ErrorMessage :message="errorMessage" @dismiss="errorMessage = ''" />

      <form @submit.prevent="handleSubmit" class="login-form">
        <div v-if="!isLogin" class="form-group">
          <label for="nombre">Nombre completo</label>
          <input
            id="nombre"
            v-model="formData.nombre"
            type="text"
            placeholder="Tu nombre"
            required
          />
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <input
            id="email"
            v-model="formData.email"
            type="email"
            placeholder="tu@email.com"
            required
          />
        </div>

        <div class="form-group">
          <label for="password">Contraseña</label>
          <input
            id="password"
            v-model="formData.password"
            type="password"
            placeholder="••••••••"
            required
          />
        </div>

        <div v-if="!isLogin" class="form-group">
          <label for="biografia">Biografía (opcional)</label>
          <textarea
            id="biografia"
            v-model="formData.biografia"
            placeholder="Cuéntanos sobre ti..."
            rows="3"
          ></textarea>
        </div>

        <button type="submit" class="btn-submit" :disabled="authStore.loading">
          {{ authStore.loading ? 'Cargando...' : (isLogin ? 'Iniciar Sesión' : 'Registrarse') }}
        </button>
      </form>

      <div class="login-footer">
        <p>
          {{ isLogin ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?' }}
          <button @click="toggleMode" class="btn-link">
            {{ isLogin ? 'Regístrate' : 'Inicia sesión' }}
          </button>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const router = useRouter()
const authStore = useAuthStore()

const isLogin = ref(true)
const errorMessage = ref('')

const formData = reactive({
  nombre: '',
  email: '',
  password: '',
  biografia: ''
})

const toggleMode = () => {
  isLogin.value = !isLogin.value
  errorMessage.value = ''
}

const handleSubmit = async () => {
  errorMessage.value = ''
  try {
    if (isLogin.value) {
      await authStore.login({
        email: formData.email,
        password: formData.password
      })
    } else {
      await authStore.register({
        nombre: formData.nombre,
        email: formData.email,
        password: formData.password,
        biografia: formData.biografia
      })
    }
    router.push('/')
  } catch (error) {
    errorMessage.value = authStore.error || 'Ocurrió un error. Intenta nuevamente.'
  }
}
</script>

<style scoped>
.login-view {
  min-height: calc(100vh - 60px);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 2rem;
}

.login-container {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  width: 100%;
  max-width: 450px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.login-header h1 {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
  font-size: 2rem;
}

.login-header p {
  margin: 0;
  color: #7f8c8d;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  color: #2c3e50;
  font-weight: 500;
}

.form-group input,
.form-group textarea {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #3498db;
}

.btn-submit {
  padding: 0.875rem;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-submit:hover:not(:disabled) {
  background-color: #2980b9;
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.login-footer {
  margin-top: 1.5rem;
  text-align: center;
}

.login-footer p {
  margin: 0;
  color: #7f8c8d;
}

.btn-link {
  background: none;
  border: none;
  color: #3498db;
  cursor: pointer;
  font-size: 1rem;
  text-decoration: underline;
  padding: 0;
  margin-left: 0.25rem;
}

.btn-link:hover {
  color: #2980b9;
}
</style>
