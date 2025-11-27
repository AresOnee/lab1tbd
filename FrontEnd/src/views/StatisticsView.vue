<template>
  <div class="statistics-view">
    <Navbar />

    <div class="header">
      <h1>📊 Panel de Estadísticas</h1>
      <p class="subtitle">Consultas SQL del Enunciado del Laboratorio</p>
    </div>

    <!-- Botón de recarga global -->
    <div class="reload-section">
      <button @click="loadAllStatistics" :disabled="loading" class="btn-reload">
        <span v-if="!loading">🔄 Recargar Todas las Estadísticas</span>
        <span v-else>⏳ Cargando...</span>
      </button>
    </div>

    <ErrorMessage v-if="error" :message="error" @close="error = null" />

    <!-- Grid de Estadísticas -->
    <div class="stats-grid">

      <!-- Consulta #1: Estadísticas por Tipo -->
      <div class="stat-card">
        <h2>📈 Consulta #1: Estadísticas por Tipo</h2>
        <p class="description">Calificación promedio y total de reseñas por tipo de sitio</p>

        <div v-if="statsByType.length > 0" class="data-table">
          <table>
            <thead>
              <tr>
                <th>Tipo</th>
                <th>Cal. Promedio</th>
                <th>Total Reseñas</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="stat in statsByType" :key="stat.tipo">
                <td class="type-cell">{{ stat.tipo }}</td>
                <td class="rating-cell">{{ stat.calificacionPromedioGeneral?.toFixed(2) || 'N/A' }} ⭐</td>
                <td class="count-cell">{{ stat.totalResenasGeneral || 0 }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p v-else class="no-data">No hay datos disponibles</p>
      </div>

      <!-- Consulta #2: Top Reseñadores -->
      <div class="stat-card">
        <h2>👑 Consulta #2: Top Reseñadores</h2>
        <p class="description">5 usuarios más activos (últimos 6 meses)</p>

        <div v-if="topReviewers.length > 0" class="leaderboard">
          <div v-for="(reviewer, index) in topReviewers" :key="index" class="leaderboard-item">
            <span class="rank">{{ index + 1 }}°</span>
            <span class="name">{{ reviewer.nombreUsuario }}</span>
            <span class="count">{{ reviewer.conteoResenas }} reseñas</span>
          </div>
        </div>
        <p v-else class="no-data">No hay reseñadores activos en los últimos 6 meses</p>
      </div>

      <!-- Consulta #3: Análisis de Proximidad -->
      <div class="stat-card full-width">
        <h2>📍 Consulta #3: Análisis de Proximidad</h2>
        <p class="description">Restaurantes a menos de 100 metros de Teatros</p>

        <div v-if="proximityAnalysis.length > 0" class="data-table">
          <table>
            <thead>
              <tr>
                <th>Teatro</th>
                <th>Restaurante</th>
                <th>Distancia</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in proximityAnalysis" :key="index">
                <td>{{ item.nombreTeatro }}</td>
                <td>{{ item.nombreRestaurante }}</td>
                <td class="distance-cell">{{ item.distanciaEnMetros?.toFixed(1) }}m</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p v-else class="no-data">No hay restaurantes cerca de teatros</p>
      </div>

      <!-- Consulta #4: Valoraciones Inusuales -->
      <div class="stat-card">
        <h2>⚠️ Consulta #4: Valoraciones Inusuales</h2>
        <p class="description">Sitios con alta calificación (>4.5) pero pocas reseñas (<10)</p>

        <div v-if="unusualRatings.length > 0" class="site-list">
          <div v-for="site in unusualRatings" :key="site.nombre" class="site-item">
            <div class="site-name">{{ site.nombre }}</div>
            <div class="site-stats">
              <span class="rating">⭐ {{ site.calificacionPromedio?.toFixed(1) }}</span>
              <span class="count">{{ site.totalResenas }} reseñas</span>
            </div>
          </div>
        </div>
        <p v-else class="no-data">No hay sitios con estas características</p>
      </div>

      <!-- Consulta #7: Pocas Contribuciones -->
      <div class="stat-card">
        <h2>💤 Consulta #7: Sitios con Pocas Contribuciones</h2>
        <p class="description">Sin actividad (reseñas/fotos) en los últimos 3 meses</p>

        <div v-if="lowContribution.length > 0" class="site-list">
          <div v-for="site in lowContribution.slice(0, 10)" :key="site.nombre" class="site-item">
            <div class="site-name">{{ site.nombre }}</div>
            <div class="site-stats">
              <span class="type">{{ site.tipo }}</span>
              <span class="date">
                {{ site.fechaUltimaContribucion ? formatDate(site.fechaUltimaContribucion) : 'Sin actividad' }}
              </span>
            </div>
          </div>
          <p v-if="lowContribution.length > 10" class="more-items">
            + {{ lowContribution.length - 10 }} sitios más
          </p>
        </div>
        <p v-else class="no-data">Todos los sitios tienen actividad reciente</p>
      </div>

      <!-- Consulta #8: Reseñas Más Largas -->
      <div class="stat-card full-width">
        <h2>📝 Consulta #8: Reseñas Más Largas</h2>
        <p class="description">Top 3 reseñas más extensas de usuarios con promedio >4.0</p>

        <div v-if="longestReviews.length > 0" class="reviews-list">
          <div v-for="(review, index) in longestReviews" :key="index" class="review-card">
            <div class="review-header">
              <span class="rank">{{ index + 1 }}</span>
              <span class="author">{{ review.nombreUsuario }}</span>
              <span class="site">→ {{ review.nombreSitio }}</span>
              <span class="length">{{ review.longitudResena }} caracteres</span>
            </div>
            <div class="review-content">
              "{{ review.contenido }}"
            </div>
          </div>
        </div>
        <p v-else class="no-data">No hay reseñas disponibles</p>
      </div>

      <!-- Consulta #9: Resumen de Contribuciones -->
      <div class="stat-card full-width">
        <h2>🏆 Consulta #9: Resumen de Contribuciones</h2>
        <p class="description">Vista materializada: Total de contribuciones por usuario</p>

        <div v-if="contributionsSummary.length > 0" class="data-table">
          <table>
            <thead>
              <tr>
                <th>Usuario</th>
                <th>Reseñas</th>
                <th>Fotos</th>
                <th>Listas</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="user in contributionsSummary" :key="user.idUsuario">
                <td class="name-cell">{{ user.nombre }}</td>
                <td class="count-cell">{{ user.totalResenas || 0 }}</td>
                <td class="count-cell">{{ user.totalFotos || 0 }}</td>
                <td class="count-cell">{{ user.totalListas || 0 }}</td>
                <td class="total-cell">
                  {{ (user.totalResenas || 0) + (user.totalFotos || 0) + (user.totalListas || 0) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p v-else class="no-data">No hay usuarios con contribuciones</p>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { statisticsService } from '@/services/statisticsService'
import Navbar from '@/components/layout/Navbar.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const statsByType = ref([])
const topReviewers = ref([])
const proximityAnalysis = ref([])
const unusualRatings = ref([])
const lowContribution = ref([])
const longestReviews = ref([])
const contributionsSummary = ref([])

const loading = ref(false)
const error = ref(null)

const loadAllStatistics = async () => {
  loading.value = true
  error.value = null

  try {
    const results = await Promise.allSettled([
      statisticsService.getStatsByType(),
      statisticsService.getTopReviewers(),
      statisticsService.getProximityAnalysis(),
      statisticsService.getUnusualRatings(),
      statisticsService.getLowContributionSites(),
      statisticsService.getLongestReviews(),
      statisticsService.getContributionsSummary()
    ])

    statsByType.value = results[0].status === 'fulfilled' ? results[0].value : []
    topReviewers.value = results[1].status === 'fulfilled' ? results[1].value : []
    proximityAnalysis.value = results[2].status === 'fulfilled' ? results[2].value : []
    unusualRatings.value = results[3].status === 'fulfilled' ? results[3].value : []
    lowContribution.value = results[4].status === 'fulfilled' ? results[4].value : []
    longestReviews.value = results[5].status === 'fulfilled' ? results[5].value : []
    contributionsSummary.value = results[6].status === 'fulfilled' ? results[6].value : []

    // Verificar si hay errores
    const failedRequests = results.filter(r => r.status === 'rejected')
    if (failedRequests.length > 0) {
      console.error('Errores en algunas consultas:', failedRequests)
    }

  } catch (err) {
    error.value = 'Error al cargar las estadísticas'
    console.error('Error:', err)
  } finally {
    loading.value = false
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'Nunca'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(() => {
  loadAllStatistics()
})
</script>

<style scoped>
.statistics-view {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
  background: #f8f9fa;
  min-height: 100vh;
}

.header {
  text-align: center;
  margin-bottom: 2rem;
}

.header h1 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #7f8c8d;
  font-size: 1.1rem;
}

.reload-section {
  text-align: center;
  margin-bottom: 2rem;
}

.btn-reload {
  padding: 1rem 2rem;
  background: #3498db;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(52, 152, 219, 0.3);
}

.btn-reload:hover:not(:disabled) {
  background: #2980b9;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
}

.btn-reload:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
  gap: 1.5rem;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.stat-card.full-width {
  grid-column: 1 / -1;
}

.stat-card h2 {
  color: #2c3e50;
  font-size: 1.3rem;
  margin-bottom: 0.5rem;
}

.description {
  color: #7f8c8d;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.no-data {
  text-align: center;
  color: #95a5a6;
  padding: 2rem;
  font-style: italic;
}

/* Tables */
.data-table {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  background: #ecf0f1;
  padding: 0.75rem;
  text-align: left;
  font-weight: 600;
  color: #2c3e50;
  border-bottom: 2px solid #bdc3c7;
}

td {
  padding: 0.75rem;
  border-bottom: 1px solid #ecf0f1;
}

.type-cell {
  font-weight: 600;
  color: #3498db;
}

.rating-cell {
  color: #f39c12;
  font-weight: 600;
}

.count-cell {
  text-align: center;
  font-weight: 600;
}

.distance-cell {
  text-align: right;
  color: #27ae60;
  font-weight: 600;
}

.name-cell {
  font-weight: 600;
  color: #2c3e50;
}

.total-cell {
  text-align: center;
  font-weight: 700;
  color: #e74c3c;
  font-size: 1.1rem;
}

/* Leaderboard */
.leaderboard {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.leaderboard-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: #ecf0f1;
  border-radius: 8px;
  transition: all 0.3s;
}

.leaderboard-item:hover {
  background: #d5dbdb;
  transform: translateX(5px);
}

.rank {
  font-size: 1.5rem;
  font-weight: 700;
  color: #3498db;
  min-width: 40px;
}

.name {
  flex: 1;
  font-weight: 600;
  color: #2c3e50;
}

.count {
  color: #7f8c8d;
  font-weight: 600;
}

/* Site List */
.site-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.site-item {
  padding: 0.75rem;
  border-left: 4px solid #3498db;
  background: #f8f9fa;
  border-radius: 4px;
}

.site-name {
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 0.25rem;
}

.site-stats {
  display: flex;
  gap: 1rem;
  font-size: 0.9rem;
  color: #7f8c8d;
}

.rating {
  color: #f39c12;
  font-weight: 600;
}

.type {
  color: #3498db;
  font-weight: 600;
}

.date {
  color: #95a5a6;
}

.more-items {
  text-align: center;
  color: #7f8c8d;
  font-style: italic;
  margin-top: 0.5rem;
}

/* Reviews */
.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.review-card {
  border: 1px solid #ecf0f1;
  border-radius: 8px;
  padding: 1rem;
  background: #f8f9fa;
}

.review-header {
  display: flex;
  gap: 1rem;
  align-items: center;
  margin-bottom: 0.75rem;
  flex-wrap: wrap;
}

.review-header .rank {
  font-size: 1.2rem;
  font-weight: 700;
  color: #e74c3c;
  min-width: auto;
}

.author {
  font-weight: 600;
  color: #3498db;
}

.site {
  color: #7f8c8d;
}

.length {
  margin-left: auto;
  color: #27ae60;
  font-weight: 600;
  font-size: 0.9rem;
}

.review-content {
  color: #34495e;
  line-height: 1.6;
  font-style: italic;
  padding-left: 1rem;
  border-left: 3px solid #3498db;
}

@media (max-width: 768px) {
  .statistics-view {
    padding: 1rem;
  }

  .stats-grid {
    grid-template-columns: 1fr;
  }

  .stat-card.full-width {
    grid-column: 1;
  }

  .header h1 {
    font-size: 2rem;
  }

  .review-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .length {
    margin-left: 0;
  }
}
</style>
