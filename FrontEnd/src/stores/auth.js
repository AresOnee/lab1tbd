import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authService } from '@/services/authService'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(authService.getCurrentUser())
  const token = ref(authService.getToken())
  const loading = ref(false)
  const error = ref(null)

  const isAuthenticated = computed(() => !!token.value)

  async function login(credentials) {
    loading.value = true
    error.value = null
    try {
      const data = await authService.login(credentials)
      user.value = data.user
      token.value = data.token
      return data
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al iniciar sesión'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function register(userData) {
    loading.value = true
    error.value = null
    try {
      const data = await authService.register(userData)
      user.value = data.user
      token.value = data.token
      return data
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al registrarse'
      throw err
    } finally {
      loading.value = false
    }
  }

  function logout() {
    authService.logout()
    user.value = null
    token.value = null
  }

  return {
    user,
    token,
    loading,
    error,
    isAuthenticated,
    login,
    register,
    logout
  }
})
