import api from './api'

export const reviewsService = {
  async getAll() {
    const response = await api.get('/resenas')
    return response.data
  },

  async getBySiteId(siteId) {
    const response = await api.get(`/resenas/sitio/${siteId}`)
    return response.data
  },

  async getByUserId(userId) {
    const response = await api.get(`/resenas/usuario/${userId}`)
    return response.data
  },

  async create(reviewData) {
    const response = await api.post('/resenas', reviewData)
    return response.data
  },

  async update(id, reviewData) {
    const response = await api.put(`/resenas/${id}`, reviewData)
    return response.data
  },

  async delete(id) {
    const response = await api.delete(`/resenas/${id}`)
    return response.data
  }
}
