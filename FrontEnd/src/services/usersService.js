import api from './api'

export const usersService = {
  async getProfile(userId) {
    const response = await api.get(`/usuarios/${userId}`)
    return response.data
  },

  async updateProfile(userId, userData) {
    const response = await api.put(`/usuarios/${userId}`, userData)
    return response.data
  },

  async getContributions(userId) {
    const response = await api.get(`/usuarios/${userId}/contribuciones`)
    return response.data
  },

  async getActivity(userId) {
    const response = await api.get(`/usuarios/${userId}/actividad`)
    return response.data
  }
}
