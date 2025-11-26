import api from './api'

export const reviewsService = {
  async getAll() {
    const response = await api.get('/resenas')
    return response.data
  },

  async getBySiteId(siteId) {
    const response = await api.get(`/sitios/${siteId}/reseñas`)
    return response.data
  },

  async getByUserId(userId) {
    const response = await api.get(`/resenas/usuario/${userId}`)
    return response.data
  },

  async create(reviewData) {
    const { sitioId, ...data } = reviewData
    const response = await api.post(`/sitios/${sitioId}/reseñas`, data)
    return response.data
  },

  async update(id, reviewData) {
    const response = await api.put(`/reseñas/${id}`, reviewData)
    return response.data
  },

  async delete(id) {
    const response = await api.delete(`/reseñas/${id}`)
    return response.data
  }
}
