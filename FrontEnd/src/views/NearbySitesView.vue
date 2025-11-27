<template>
  <div class="nearby-sites-view">
    <Navbar />

    <div class="header">
      <h1>🗺️ Buscar Sitios Cercanos</h1>
      <p class="subtitle">Encuentra sitios turísticos cerca de una ubicación</p>
    </div>

    <div class="search-container">
      <div class="search-card">
        <h2>📍 Ubicación de Búsqueda</h2>

        <div class="form-group">
          <label for="latitud">Latitud</label>
          <input
            id="latitud"
            v-model.number="searchParams.latitud"
            type="number"
            step="0.0001"
            placeholder="-33.4489"
            class="form-input"
          />
          <span class="help-text">Ejemplo: -33.4489 (Santiago Centro)</span>
        </div>

        <div class="form-group">
          <label for="longitud">Longitud</label>
          <input
            id="longitud"
            v-model.number="searchParams.longitud"
            type="number"
            step="0.0001"
            placeholder="-70.6693"
            class="form-input"
          />
          <span class="help-text">Ejemplo: -70.6693 (Santiago Centro)</span>
        </div>

        <div class="form-group">
          <label for="radio">Radio de Búsqueda (metros)</label>
          <input
            id="radio"
            v-model.number="searchParams.radio"
            type="number"
            min="100"
            max="50000"
            step="100"
            placeholder="1000"
            class="form-input"
          />
          <span class="help-text">Mínimo: 100m | Máximo: 50,000m (50km) | Por defecto: 1,000m (1km)</span>
        </div>

        <div class="form-actions">
          <button @click="buscarSitios" :disabled="loading || !isFormValid" class="btn-primary">
            <span v-if="!loading">🔍 Buscar</span>
            <span v-else>⏳ Buscando...</span>
          </button>

          <button @click="useCurrentLocation" :disabled="loading || gettingLocation" class="btn-secondary">
            <span v-if="!gettingLocation">📍 Usar Mi Ubicación</span>
            <span v-else>📡 Obteniendo ubicación...</span>
          </button>

          <button @click="useSantiagoCenter" :disabled="loading" class="btn-secondary">
            🏛️ Santiago Centro
          </button>
        </div>

        <ErrorMessage v-if="error" :message="error" @close="error = null" />
      </div>
    </div>

    <!-- Resultados -->
    <div v-if="searched" class="results-section">
      <div class="results-header">
        <h2>📊 Resultados</h2>
        <p v-if="sitios.length > 0" class="results-count">
          Se encontraron <strong>{{ sitios.length }}</strong> sitios turísticos dentro de
          <strong>{{ formatDistance(searchParams.radio || 1000) }}</strong>
        </p>
        <p v-else class="no-results">
          No se encontraron sitios turísticos en esta área. Intenta aumentar el radio de búsqueda.
        </p>
      </div>

      <div v-if="sitios.length > 0" class="sites-grid">
        <div
          v-for="sitio in sitios"
          :key="sitio.id"
          class="site-card"
          @click="goToSiteDetail(sitio.id)"
        >
          <div class="site-header">
            <h3>{{ sitio.nombre }}</h3>
            <span class="site-type">{{ sitio.tipo }}</span>
          </div>

          <p class="site-description">{{ sitio.descripcion || 'Sin descripción' }}</p>

          <div class="site-stats">
            <div class="stat">
              <span class="stat-label">⭐ Calificación:</span>
              <span class="stat-value">{{ sitio.calificacionPromedio?.toFixed(1) || 'N/A' }}</span>
            </div>
            <div class="stat">
              <span class="stat-label">💬 Reseñas:</span>
              <span class="stat-value">{{ sitio.totalResenas || 0 }}</span>
            </div>
          </div>

          <div class="site-location">
            <span class="location-label">📍 Coordenadas:</span>
            <span class="location-value">{{ sitio.latitud }}, {{ sitio.longitud }}</span>
          </div>

          <div class="site-distance" v-if="sitio.distancia">
            <span class="distance-label">📏 Distancia:</span>
            <span class="distance-value">{{ formatDistance(sitio.distancia) }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { sitesService } from '@/services/sitesService'
import Navbar from '@/components/layout/Navbar.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const router = useRouter()

const searchParams = ref({
  latitud: null,
  longitud: null,
  radio: 1000
})

const sitios = ref([])
const loading = ref(false)
const error = ref(null)
const searched = ref(false)
const gettingLocation = ref(false)

const isFormValid = computed(() => {
  return searchParams.value.latitud !== null &&
         searchParams.value.longitud !== null &&
         searchParams.value.radio >= 100 &&
         searchParams.value.radio <= 50000
})

const buscarSitios = async () => {
  if (!isFormValid.value) {
    error.value = 'Por favor completa todos los campos correctamente'
    return
  }

  loading.value = true
  error.value = null
  searched.value = false

  try {
    const resultado = await sitesService.searchNearby(
      searchParams.value.latitud,
      searchParams.value.longitud,
      searchParams.value.radio
    )

    sitios.value = resultado
    searched.value = true
  } catch (err) {
    error.value = err.response?.data?.message || 'Error al buscar sitios cercanos'
    console.error('Error en búsqueda:', err)
  } finally {
    loading.value = false
  }
}

const useCurrentLocation = () => {
  if (!navigator.geolocation) {
    error.value = 'Tu navegador no soporta geolocalización'
    return
  }

  gettingLocation.value = true
  error.value = null

  navigator.geolocation.getCurrentPosition(
    (position) => {
      searchParams.value.latitud = position.coords.latitude
      searchParams.value.longitud = position.coords.longitude
      gettingLocation.value = false
    },
    (err) => {
      error.value = 'No se pudo obtener tu ubicación. Por favor verifica los permisos del navegador.'
      gettingLocation.value = false
      console.error('Error de geolocalización:', err)
    }
  )
}

const useSantiagoCenter = () => {
  searchParams.value.latitud = -33.4489
  searchParams.value.longitud = -70.6693
}

const goToSiteDetail = (siteId) => {
  router.push(`/sitios/${siteId}`)
}

const formatDistance = (metros) => {
  if (metros < 1000) {
    return `${metros}m`
  }
  return `${(metros / 1000).toFixed(1)}km`
}
</script>

<style scoped>
.nearby-sites-view {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
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

.search-container {
  margin-bottom: 3rem;
}

.search-card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.search-card h2 {
  color: #2c3e50;
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  font-weight: 600;
  color: #34495e;
  margin-bottom: 0.5rem;
}

.form-input {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: #3498db;
}

.help-text {
  display: block;
  margin-top: 0.25rem;
  font-size: 0.875rem;
  color: #95a5a6;
}

.form-actions {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
  flex-wrap: wrap;
}

.btn-primary, .btn-secondary {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-primary {
  background: #3498db;
  color: white;
  flex: 1;
  min-width: 200px;
}

.btn-primary:hover:not(:disabled) {
  background: #2980b9;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
}

.btn-primary:disabled {
  background: #bdc3c7;
  cursor: not-allowed;
  transform: none;
}

.btn-secondary {
  background: #ecf0f1;
  color: #2c3e50;
}

.btn-secondary:hover:not(:disabled) {
  background: #d5dbdb;
  transform: translateY(-2px);
}

.btn-secondary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.results-section {
  margin-top: 3rem;
}

.results-header {
  margin-bottom: 2rem;
}

.results-header h2 {
  color: #2c3e50;
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.results-count {
  color: #27ae60;
  font-size: 1.1rem;
}

.no-results {
  color: #e74c3c;
  font-size: 1.1rem;
  padding: 2rem;
  background: #ffe6e6;
  border-radius: 8px;
  text-align: center;
}

.sites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.site-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s;
}

.site-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.site-header {
  display: flex;
  justify-content: space-between;
  align-items: start;
  margin-bottom: 1rem;
  gap: 1rem;
}

.site-header h3 {
  color: #2c3e50;
  font-size: 1.3rem;
  margin: 0;
  flex: 1;
}

.site-type {
  background: #3498db;
  color: white;
  padding: 0.3rem 0.8rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  white-space: nowrap;
}

.site-description {
  color: #7f8c8d;
  margin-bottom: 1rem;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.site-stats {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #ecf0f1;
}

.stat {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.stat-label {
  font-size: 0.85rem;
  color: #95a5a6;
}

.stat-value {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2c3e50;
}

.site-location {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
}

.location-label {
  color: #95a5a6;
}

.location-value {
  color: #34495e;
  font-family: monospace;
}

.site-distance {
  display: flex;
  gap: 0.5rem;
  font-size: 0.9rem;
  margin-top: 0.5rem;
  padding-top: 0.5rem;
  border-top: 1px solid #ecf0f1;
}

.distance-label {
  color: #95a5a6;
}

.distance-value {
  color: #27ae60;
  font-weight: 600;
}

@media (max-width: 768px) {
  .nearby-sites-view {
    padding: 1rem;
  }

  .header h1 {
    font-size: 2rem;
  }

  .sites-grid {
    grid-template-columns: 1fr;
  }

  .form-actions {
    flex-direction: column;
  }

  .btn-primary, .btn-secondary {
    width: 100%;
  }
}
</style>
