import { describe, it, expect, beforeEach, vi } from 'vitest'
import { authService } from '@/services/authService'
import api from '@/services/api'

// Mock del módulo api
vi.mock('@/services/api', () => ({
  default: {
    post: vi.fn()
  }
}))

// Mock de localStorage
const localStorageMock = (() => {
  let store = {}

  return {
    getItem: vi.fn((key) => store[key] || null),
    setItem: vi.fn((key, value) => {
      store[key] = value.toString()
    }),
    removeItem: vi.fn((key) => {
      delete store[key]
    }),
    clear: vi.fn(() => {
      store = {}
    })
  }
})()

Object.defineProperty(window, 'localStorage', {
  value: localStorageMock
})

describe('authService', () => {
  beforeEach(() => {
    // Limpiar todos los mocks antes de cada test
    vi.clearAllMocks()
    localStorageMock.clear()
  })

  describe('login', () => {
    it('debe hacer login exitosamente y guardar token y usuario en localStorage', async () => {
      const mockCredentials = {
        email: 'test@example.com',
        password: 'password123'
      }

      const mockResponse = {
        data: {
          token: 'test-token-123',
          user: {
            id: 1,
            email: 'test@example.com',
            name: 'Test User'
          }
        }
      }

      api.post.mockResolvedValue(mockResponse)

      const result = await authService.login(mockCredentials)

      expect(api.post).toHaveBeenCalledWith('/auth/login', mockCredentials)
      expect(localStorageMock.setItem).toHaveBeenCalledWith('token', 'test-token-123')
      expect(localStorageMock.setItem).toHaveBeenCalledWith('user', JSON.stringify(mockResponse.data.user))
      expect(result).toEqual(mockResponse.data)
    })

    it('debe manejar error cuando el login falla', async () => {
      const mockCredentials = {
        email: 'test@example.com',
        password: 'wrongpassword'
      }

      const mockError = new Error('Invalid credentials')
      api.post.mockRejectedValue(mockError)

      await expect(authService.login(mockCredentials)).rejects.toThrow('Invalid credentials')
      expect(localStorageMock.setItem).not.toHaveBeenCalled()
    })

    it('no debe guardar en localStorage si no hay token en la respuesta', async () => {
      const mockCredentials = {
        email: 'test@example.com',
        password: 'password123'
      }

      const mockResponse = {
        data: {
          user: {
            id: 1,
            email: 'test@example.com'
          }
        }
      }

      api.post.mockResolvedValue(mockResponse)

      await authService.login(mockCredentials)

      expect(localStorageMock.setItem).not.toHaveBeenCalled()
    })
  })

  describe('register', () => {
    it('debe registrar un usuario exitosamente y guardar token y usuario', async () => {
      const mockUserData = {
        email: 'newuser@example.com',
        password: 'password123',
        name: 'New User'
      }

      const mockResponse = {
        data: {
          token: 'new-user-token',
          user: {
            id: 2,
            email: 'newuser@example.com',
            name: 'New User'
          }
        }
      }

      api.post.mockResolvedValue(mockResponse)

      const result = await authService.register(mockUserData)

      expect(api.post).toHaveBeenCalledWith('/auth/register', mockUserData)
      expect(localStorageMock.setItem).toHaveBeenCalledWith('token', 'new-user-token')
      expect(localStorageMock.setItem).toHaveBeenCalledWith('user', JSON.stringify(mockResponse.data.user))
      expect(result).toEqual(mockResponse.data)
    })

    it('debe manejar error cuando el registro falla', async () => {
      const mockUserData = {
        email: 'existing@example.com',
        password: 'password123',
        name: 'Existing User'
      }

      const mockError = new Error('Email already exists')
      api.post.mockRejectedValue(mockError)

      await expect(authService.register(mockUserData)).rejects.toThrow('Email already exists')
      expect(localStorageMock.setItem).not.toHaveBeenCalled()
    })
  })

  describe('logout', () => {
    it('debe eliminar token y usuario de localStorage', () => {
      localStorageMock.setItem('token', 'test-token')
      localStorageMock.setItem('user', JSON.stringify({ id: 1, email: 'test@example.com' }))

      authService.logout()

      expect(localStorageMock.removeItem).toHaveBeenCalledWith('token')
      expect(localStorageMock.removeItem).toHaveBeenCalledWith('user')
    })
  })

  describe('getCurrentUser', () => {
    it('debe retornar el usuario actual desde localStorage', () => {
      const mockUser = { id: 1, email: 'test@example.com', name: 'Test User' }
      localStorageMock.setItem('user', JSON.stringify(mockUser))

      const user = authService.getCurrentUser()

      expect(localStorageMock.getItem).toHaveBeenCalledWith('user')
      expect(user).toEqual(mockUser)
    })

    it('debe retornar null si no hay usuario en localStorage', () => {
      const user = authService.getCurrentUser()

      expect(user).toBeNull()
    })

    it('debe manejar JSON inválido en localStorage', () => {
      localStorageMock.getItem.mockReturnValueOnce('invalid-json')

      expect(() => authService.getCurrentUser()).toThrow()
    })
  })

  describe('getToken', () => {
    it('debe retornar el token desde localStorage', () => {
      localStorageMock.clear()
      localStorageMock.setItem('token', 'test-token-123')

      const token = authService.getToken()

      expect(localStorageMock.getItem).toHaveBeenCalledWith('token')
      expect(token).toBe('test-token-123')
    })

    it('debe retornar null si no hay token en localStorage', () => {
      localStorageMock.clear()

      const token = authService.getToken()

      expect(token).toBeNull()
    })
  })

  describe('isAuthenticated', () => {
    it('debe retornar true si hay un token', () => {
      localStorageMock.clear()
      localStorageMock.setItem('token', 'test-token')

      const isAuth = authService.isAuthenticated()

      expect(isAuth).toBe(true)
    })

    it('debe retornar false si no hay token', () => {
      localStorageMock.clear()

      const isAuth = authService.isAuthenticated()

      expect(isAuth).toBe(false)
    })

    it('debe retornar false si el token está vacío', () => {
      localStorageMock.clear()
      localStorageMock.setItem('token', '')

      const isAuth = authService.isAuthenticated()

      expect(isAuth).toBe(false)
    })
  })
})
