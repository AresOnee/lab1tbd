import api from './api'

export const photosService = {
  async getAll() {
    const response = await api.get('/fotografias')
    return response.data
  },

  async getBySiteId(siteId) {
    const response = await api.get(`/sitios/${siteId}/fotografias`)
    return response.data
  },

  async getByUserId(userId) {
    const response = await api.get(`/fotografias/usuario/${userId}`)
    return response.data
  },

  async upload(photoData) {
    const { sitioId, ...data } = photoData
    const response = await api.post(`/sitios/${sitioId}/fotografias`, data)
    return response.data
  },

  async delete(id) {
    const response = await api.delete(`/fotografias/${id}`)
    return response.data
  }
}
