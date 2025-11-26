import api from './api'

export const listsService = {
  async getAll() {
    const response = await api.get('/listas')
    return response.data
  },

  async getById(id) {
    const response = await api.get(`/listas/${id}`)
    return response.data
  },

  async getByUserId(userId) {
    const response = await api.get(`/listas/usuario/${userId}`)
    return response.data
  },

  async create(listData) {
    const response = await api.post('/listas', listData)
    return response.data
  },

  async update(id, listData) {
    const response = await api.put(`/listas/${id}`, listData)
    return response.data
  },

  async delete(id) {
    const response = await api.delete(`/listas/${id}`)
    return response.data
  },

  async addSite(listId, siteId) {
    const response = await api.post(`/listas/${listId}/sitios/${siteId}`)
    return response.data
  },

  async removeSite(listId, siteId) {
    const response = await api.delete(`/listas/${listId}/sitios/${siteId}`)
    return response.data
  }
}
