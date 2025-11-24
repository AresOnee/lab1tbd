<template>
  <div class="home-view">
    <Navbar />

    <div class="hero-section">
      <div class="hero-content">
        <h1>Descubre Lugares Increíbles</h1>
        <p>Explora, comparte y califica sitios turísticos en un mapa colaborativo</p>
        <div class="hero-actions">
          <router-link to="/sitios" class="btn-primary">
            Explorar Sitios
          </router-link>
          <router-link v-if="isAuthenticated" to="/sitios/crear" class="btn-secondary">
            Agregar Sitio
          </router-link>
        </div>
      </div>
    </div>

    <div class="map-section">
      <div class="container">
        <h2>Mapa Interactivo</h2>
        <div class="map-placeholder">
          <div class="map-info">
            <h3>🗺️ Próximamente: Mapa Interactivo</h3>
            <p>
              En esta sección podrás visualizar todos los sitios turísticos
              en un mapa interactivo con filtros por tipo, calificación y distancia.
            </p>
            <ul>
              <li>Visualiza sitios en tiempo real</li>
              <li>Filtra por tipo de lugar</li>
              <li>Descubre lugares cercanos</li>
              <li>Ve calificaciones y fotos</li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="popular-sites-section">
      <div class="container">
        <h2>Sitios Populares</h2>

        <LoadingSpinner v-if="loading" message="Cargando sitios..." />
        <ErrorMessage v-else-if="error" :message="error" />

        <div v-else-if="popularSites.length > 0" class="sites-grid">
          <SiteCard
            v-for="site in popularSites"
            :key="site.id"
            :site="site"
          />
        </div>

        <p v-else class="no-sites">No hay sitios disponibles aún.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useSitesStore } from '@/stores/sites'
import { useAuthStore } from '@/stores/auth'
import Navbar from '@/components/layout/Navbar.vue'
import SiteCard from '@/components/common/SiteCard.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const sitesStore = useSitesStore()
const authStore = useAuthStore()

const popularSites = ref([])
const loading = ref(false)
const error = ref('')

const isAuthenticated = computed(() => authStore.isAuthenticated)

onMounted(async () => {
  if (isAuthenticated.value) {
    loading.value = true
    try {
      popularSites.value = await sitesStore.fetchPopular()
    } catch (err) {
      error.value = 'Error al cargar sitios populares'
    } finally {
      loading.value = false
    }
  }
})
</script>

<style scoped>
.home-view {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 4rem 2rem;
  text-align: center;
}

.hero-content h1 {
  font-size: 3rem;
  margin: 0 0 1rem 0;
}

.hero-content p {
  font-size: 1.25rem;
  margin: 0 0 2rem 0;
  opacity: 0.9;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn-primary,
.btn-secondary {
  padding: 0.875rem 2rem;
  border-radius: 6px;
  text-decoration: none;
  font-weight: 600;
  transition: transform 0.3s, box-shadow 0.3s;
}

.btn-primary {
  background-color: white;
  color: #667eea;
}

.btn-secondary {
  background-color: transparent;
  color: white;
  border: 2px solid white;
}

.btn-primary:hover,
.btn-secondary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.map-section {
  background-color: white;
  padding: 3rem 0;
}

.map-placeholder {
  background-color: #ecf0f1;
  border: 2px dashed #bdc3c7;
  border-radius: 12px;
  padding: 3rem;
  min-height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.map-info {
  text-align: center;
  max-width: 600px;
}

.map-info h3 {
  color: #2c3e50;
  font-size: 1.75rem;
  margin: 0 0 1rem 0;
}

.map-info p {
  color: #7f8c8d;
  margin: 0 0 1.5rem 0;
  line-height: 1.6;
}

.map-info ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.map-info ul li {
  color: #34495e;
  padding: 0.5rem 0;
  font-weight: 500;
}

.map-info ul li::before {
  content: '✓ ';
  color: #27ae60;
  font-weight: bold;
  margin-right: 0.5rem;
}

.popular-sites-section {
  padding: 3rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.container h2 {
  color: #2c3e50;
  margin: 0 0 2rem 0;
  font-size: 2rem;
}

.sites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

.no-sites {
  text-align: center;
  color: #7f8c8d;
  padding: 2rem;
}

@media (max-width: 768px) {
  .hero-content h1 {
    font-size: 2rem;
  }

  .hero-content p {
    font-size: 1rem;
  }

  .sites-grid {
    grid-template-columns: 1fr;
  }
}
</style>
