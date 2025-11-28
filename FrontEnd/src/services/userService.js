import api from './api'

export const userService = {
  /**
   * Obtener usuario por ID
   * @param {number} userId - ID del usuario
   * @returns {Promise<Object>} Datos del usuario
   */
  async getUserById(userId) {
    const response = await api.get(`/users/${userId}`)
    return response.data
  },

  /**
   * Actualizar perfil de usuario
   * @param {number} userId - ID del usuario
   * @param {Object} userData - Datos a actualizar
   * @returns {Promise<void>}
   */
  async updateUser(userId, userData) {
    const response = await api.put(`/users/${userId}`, userData)
    return response.data
  }
}
