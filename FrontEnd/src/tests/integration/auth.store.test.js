import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '@/stores/auth'
import { authService } from '@/services/authService'

// Mock del authService
vi.mock('@/services/authService', () => ({
  authService: {
    login: vi.fn(),
    register: vi.fn(),
    logout: vi.fn(),
    getCurrentUser: vi.fn(),
    getToken: vi.fn(),
    isAuthenticated: vi.fn()
  }
}))

describe('Auth Store (Pinia)', () => {
  beforeEach(() => {
    // Crear una nueva instancia de Pinia antes de cada test
    setActivePinia(createPinia())
    vi.clearAllMocks()
  })

  describe('Estado inicial', () => {
    it('debe inicializar con valores por defecto', () => {
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      expect(store.user).toBeNull()
      expect(store.token).toBeNull()
      expect(store.loading).toBe(false)
      expect(store.error).toBeNull()
    })

    it('debe inicializar con usuario y token si existen en localStorage', () => {
      const mockUser = { id: 1, email: 'test@example.com' }
      const mockToken = 'test-token'

      authService.getCurrentUser.mockReturnValue(mockUser)
      authService.getToken.mockReturnValue(mockToken)

      const store = useAuthStore()

      expect(store.user).toEqual(mockUser)
      expect(store.token).toBe(mockToken)
    })
  })

  describe('Computed: isAuthenticated', () => {
    it('debe retornar true cuando hay un token', () => {
      authService.getCurrentUser.mockReturnValue({ id: 1 })
      authService.getToken.mockReturnValue('test-token')

      const store = useAuthStore()

      expect(store.isAuthenticated).toBe(true)
    })

    it('debe retornar false cuando no hay token', () => {
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      expect(store.isAuthenticated).toBe(false)
    })
  })

  describe('Acción: login', () => {
    it('debe hacer login exitosamente', async () => {
      const mockCredentials = {
        email: 'test@example.com',
        password: 'password123'
      }

      const mockResponse = {
        token: 'test-token-123',
        user: {
          id: 1,
          email: 'test@example.com',
          name: 'Test User'
        }
      }

      authService.login.mockResolvedValue(mockResponse)
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      const result = await store.login(mockCredentials)

      expect(authService.login).toHaveBeenCalledWith(mockCredentials)
      expect(store.user).toEqual(mockResponse.user)
      expect(store.token).toBe(mockResponse.token)
      expect(store.loading).toBe(false)
      expect(store.error).toBeNull()
      expect(result).toEqual(mockResponse)
    })

    it('debe establecer loading a true durante el login', async () => {
      const mockCredentials = { email: 'test@example.com', password: 'password123' }

      authService.login.mockImplementation(() => {
        return new Promise((resolve) => {
          setTimeout(() => resolve({ token: 'token', user: { id: 1 } }), 100)
        })
      })

      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      const loginPromise = store.login(mockCredentials)

      expect(store.loading).toBe(true)

      await loginPromise

      expect(store.loading).toBe(false)
    })

    it('debe manejar errores de login correctamente', async () => {
      const mockCredentials = { email: 'test@example.com', password: 'wrongpassword' }
      const mockError = {
        response: {
          data: {
            message: 'Credenciales inválidas'
          }
        }
      }

      authService.login.mockRejectedValue(mockError)
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      await expect(store.login(mockCredentials)).rejects.toEqual(mockError)

      expect(store.error).toBe('Credenciales inválidas')
      expect(store.loading).toBe(false)
      expect(store.user).toBeNull()
      expect(store.token).toBeNull()
    })

    it('debe manejar errores sin mensaje de respuesta', async () => {
      const mockCredentials = { email: 'test@example.com', password: 'wrongpassword' }
      const mockError = new Error('Network error')

      authService.login.mockRejectedValue(mockError)
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      await expect(store.login(mockCredentials)).rejects.toEqual(mockError)

      expect(store.error).toBe('Error al iniciar sesión')
      expect(store.loading).toBe(false)
    })

    it('debe limpiar el error anterior antes de un nuevo intento de login', async () => {
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      store.error = 'Error anterior'

      const mockCredentials = { email: 'test@example.com', password: 'password123' }
      const mockResponse = { token: 'token', user: { id: 1 } }

      authService.login.mockResolvedValue(mockResponse)

      await store.login(mockCredentials)

      expect(store.error).toBeNull()
    })
  })

  describe('Acción: register', () => {
    it('debe registrar un usuario exitosamente', async () => {
      const mockUserData = {
        email: 'newuser@example.com',
        password: 'password123',
        name: 'New User'
      }

      const mockResponse = {
        token: 'new-token-456',
        user: {
          id: 2,
          email: 'newuser@example.com',
          name: 'New User'
        }
      }

      authService.register.mockResolvedValue(mockResponse)
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      const result = await store.register(mockUserData)

      expect(authService.register).toHaveBeenCalledWith(mockUserData)
      expect(store.user).toEqual(mockResponse.user)
      expect(store.token).toBe(mockResponse.token)
      expect(store.loading).toBe(false)
      expect(store.error).toBeNull()
      expect(result).toEqual(mockResponse)
    })

    it('debe establecer loading a true durante el registro', async () => {
      const mockUserData = { email: 'test@example.com', password: 'password123', name: 'Test' }

      authService.register.mockImplementation(() => {
        return new Promise((resolve) => {
          setTimeout(() => resolve({ token: 'token', user: { id: 1 } }), 100)
        })
      })

      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      const registerPromise = store.register(mockUserData)

      expect(store.loading).toBe(true)

      await registerPromise

      expect(store.loading).toBe(false)
    })

    it('debe manejar errores de registro correctamente', async () => {
      const mockUserData = { email: 'existing@example.com', password: 'password123', name: 'Test' }
      const mockError = {
        response: {
          data: {
            message: 'El email ya está registrado'
          }
        }
      }

      authService.register.mockRejectedValue(mockError)
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      await expect(store.register(mockUserData)).rejects.toEqual(mockError)

      expect(store.error).toBe('El email ya está registrado')
      expect(store.loading).toBe(false)
      expect(store.user).toBeNull()
      expect(store.token).toBeNull()
    })

    it('debe manejar errores de registro sin mensaje de respuesta', async () => {
      const mockUserData = { email: 'test@example.com', password: 'password123', name: 'Test' }
      const mockError = new Error('Network error')

      authService.register.mockRejectedValue(mockError)
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      await expect(store.register(mockUserData)).rejects.toEqual(mockError)

      expect(store.error).toBe('Error al registrarse')
      expect(store.loading).toBe(false)
    })
  })

  describe('Acción: logout', () => {
    it('debe hacer logout correctamente', () => {
      authService.getCurrentUser.mockReturnValue({ id: 1, email: 'test@example.com' })
      authService.getToken.mockReturnValue('test-token')

      const store = useAuthStore()

      store.logout()

      expect(authService.logout).toHaveBeenCalled()
      expect(store.user).toBeNull()
      expect(store.token).toBeNull()
    })

    it('debe limpiar el estado incluso si ya estaba en null', () => {
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      store.logout()

      expect(authService.logout).toHaveBeenCalled()
      expect(store.user).toBeNull()
      expect(store.token).toBeNull()
    })
  })

  describe('Flujo completo de autenticación', () => {
    it('debe manejar el ciclo completo: login -> uso -> logout', async () => {
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      // Estado inicial
      expect(store.isAuthenticated).toBe(false)

      // Login
      const mockCredentials = { email: 'test@example.com', password: 'password123' }
      const mockLoginResponse = {
        token: 'test-token',
        user: { id: 1, email: 'test@example.com', name: 'Test User' }
      }

      authService.login.mockResolvedValue(mockLoginResponse)
      await store.login(mockCredentials)

      expect(store.isAuthenticated).toBe(true)
      expect(store.user).toEqual(mockLoginResponse.user)

      // Logout
      store.logout()

      expect(store.isAuthenticated).toBe(false)
      expect(store.user).toBeNull()
      expect(store.token).toBeNull()
    })

    it('debe manejar múltiples intentos de login fallidos seguidos de un éxito', async () => {
      authService.getCurrentUser.mockReturnValue(null)
      authService.getToken.mockReturnValue(null)

      const store = useAuthStore()

      const mockCredentials = { email: 'test@example.com', password: 'wrongpassword' }
      const mockError = {
        response: {
          data: {
            message: 'Credenciales inválidas'
          }
        }
      }

      // Primer intento fallido
      authService.login.mockRejectedValueOnce(mockError)
      await expect(store.login(mockCredentials)).rejects.toEqual(mockError)
      expect(store.error).toBe('Credenciales inválidas')

      // Segundo intento fallido
      authService.login.mockRejectedValueOnce(mockError)
      await expect(store.login(mockCredentials)).rejects.toEqual(mockError)
      expect(store.error).toBe('Credenciales inválidas')

      // Tercer intento exitoso
      const mockSuccessResponse = {
        token: 'test-token',
        user: { id: 1, email: 'test@example.com' }
      }
      authService.login.mockResolvedValueOnce(mockSuccessResponse)
      await store.login({ email: 'test@example.com', password: 'correctpassword' })

      expect(store.error).toBeNull()
      expect(store.isAuthenticated).toBe(true)
    })
  })
})
