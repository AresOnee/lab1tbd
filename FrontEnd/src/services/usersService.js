import api from './api'

export const usersService = {
  async getProfile(userId) {
    const response = await api.get(`/users/${userId}`)
    return response.data
  },

  async updateProfile(userId, userData) {
    const response = await api.put(`/users/${userId}`, userData)
    return response.data
  },

  async getContributions(userId) {
    const response = await api.get(`/users/${userId}/contribuciones`)
    return response.data
  },

  async getActivity(userId) {
    const response = await api.get(`/users/${userId}/actividad`)
    return response.data
  }
}
