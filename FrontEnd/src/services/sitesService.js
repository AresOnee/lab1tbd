import api from './api'

export const sitesService = {
  async getAll(params = {}) {
    const response = await api.get('/sitios', { params })
    return response.data
  },

  async getById(id) {
    const response = await api.get(`/sitios/${id}`)
    return response.data
  },

  async create(siteData) {
    const response = await api.post('/sitios', siteData)
    return response.data
  },

  async update(id, siteData) {
    const response = await api.put(`/sitios/${id}`, siteData)
    return response.data
  },

  async delete(id) {
    const response = await api.delete(`/sitios/${id}`)
    return response.data
  },

  async searchByType(type) {
    const response = await api.get('/sitios/tipo', { params: { tipo: type } })
    return response.data
  },

  async searchNearby(lat, lng, radius) {
    const response = await api.get('/sitios/cercanos', {
      params: { lat, lng, radius }
    })
    return response.data
  },

  async getPopularSites() {
    const response = await api.get('/sitios/populares')
    return response.data
  }
}
