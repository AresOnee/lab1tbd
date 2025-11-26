import api from './api'

/**
 * Servicio para consumir las consultas SQL del enunciado.
 * Cada método corresponde a una consulta específica.
 */
export const statisticsService = {
  /**
   * Consulta #1: Estadísticas por tipo de sitio
   * @returns {Promise<Array>}
   */
  async getStatsByType() {
    const response = await api.get('/estadisticas/por-tipo')
    return response.data
  },

  /**
   * Consulta #2: Top 5 reseñadores más activos (últimos 6 meses)
   * @returns {Promise<Array>}
   */
  async getTopReviewers() {
    const response = await api.get('/estadisticas/top-resenadores')
    return response.data
  },

  /**
   * Consulta #3: Análisis de proximidad (Restaurantes cerca de Teatros)
   * @returns {Promise<Array>}
   */
  async getProximityAnalysis() {
    const response = await api.get('/estadisticas/proximidad')
    return response.data
  },

  /**
   * Consulta #4: Sitios con valoraciones inusuales
   * @returns {Promise<Array>}
   */
  async getUnusualRatings() {
    const response = await api.get('/estadisticas/valoraciones-inusuales')
    return response.data
  },

  /**
   * Consulta #7: Sitios con pocas contribuciones
   * @returns {Promise<Array>}
   */
  async getLowContributionSites() {
    const response = await api.get('/estadisticas/pocas-contribuciones')
    return response.data
  },

  /**
   * Consulta #8: Top 3 reseñas más largas
   * @returns {Promise<Array>}
   */
  async getLongestReviews() {
    const response = await api.get('/estadisticas/resenas-largas')
    return response.data
  },

  /**
   * Consulta #9: Resumen de contribuciones por usuario
   * @returns {Promise<Array>}
   */
  async getContributionsSummary() {
    const response = await api.get('/estadisticas/resumen-contribuciones')
    return response.data
  }
}
