import api from './api'

export const followersService = {

  async follow(userId) {
    const response = await api.post(`/usuarios/${userId}/seguir`)
    return response.data
  },


  async unfollow(userId) {
    const response = await api.delete(`/usuarios/${userId}/seguir`)
    return response.data
  },


  async isFollowing(userId) {
    const response = await api.get(`/usuarios/${userId}/seguir`)
    return response.data
  },


  async getFollowers(userId) {
    const response = await api.get(`/usuarios/${userId}/seguidores`)
    return response.data
  },


  async getFollowing(userId) {
    const response = await api.get(`/usuarios/${userId}/siguiendo`)
    return response.data
  },


  async getStats(userId) {
    const response = await api.get(`/usuarios/${userId}/estadisticas-seguidores`)
    return response.data
  }
}
