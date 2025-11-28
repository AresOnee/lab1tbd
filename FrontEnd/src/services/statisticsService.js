import api from './api'


export const statisticsService = {

  async getStatsByType() {
    const response = await api.get('/estadisticas/por-tipo')
    return response.data
  },

  async getTopReviewers() {
    const response = await api.get('/estadisticas/top-resenadores')
    return response.data
  },

  async getProximityAnalysis() {
    const response = await api.get('/estadisticas/proximidad')
    return response.data
  },

  async getUnusualRatings() {
    const response = await api.get('/estadisticas/valoraciones-inusuales')
    return response.data
  },

  async getLowContributionSites() {
    const response = await api.get('/estadisticas/pocas-contribuciones')
    return response.data
  },

  async getLongestReviews() {
    const response = await api.get('/estadisticas/resenas-largas')
    return response.data
  },

  async getContributionsSummary() {
    const response = await api.get('/estadisticas/resumen-contribuciones')
    return response.data
  }
}
