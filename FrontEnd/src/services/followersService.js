import api from './api'

export const followersService = {
  /**
   * Seguir a un usuario
   * @param {number} userId - ID del usuario a seguir
   */
  async follow(userId) {
    const response = await api.post(`/usuarios/${userId}/seguir`)
    return response.data
  },

  /**
   * Dejar de seguir a un usuario
   * @param {number} userId - ID del usuario a dejar de seguir
   */
  async unfollow(userId) {
    const response = await api.delete(`/usuarios/${userId}/seguir`)
    return response.data
  },

  /**
   * Verificar si estás siguiendo a un usuario
   * @param {number} userId - ID del usuario
   * @returns {Promise<boolean>}
   */
  async isFollowing(userId) {
    const response = await api.get(`/usuarios/${userId}/seguir`)
    return response.data
  },

  /**
   * Obtener lista de seguidores de un usuario
   * @param {number} userId - ID del usuario
   * @returns {Promise<Array>}
   */
  async getFollowers(userId) {
    const response = await api.get(`/usuarios/${userId}/seguidores`)
    return response.data
  },

  /**
   * Obtener lista de usuarios que sigue un usuario
   * @param {number} userId - ID del usuario
   * @returns {Promise<Array>}
   */
  async getFollowing(userId) {
    const response = await api.get(`/usuarios/${userId}/siguiendo`)
    return response.data
  },

  /**
   * Obtener estadísticas de seguidores
   * @param {number} userId - ID del usuario
   * @returns {Promise<Object>}
   */
  async getStats(userId) {
    const response = await api.get(`/usuarios/${userId}/estadisticas-seguidores`)
    return response.data
  }
}
