<template>
  <div class="sites-list-view">
    <Navbar />

    <div class="container">
      <div class="header">
        <h1>Explorar Sitios Turísticos</h1>
        <router-link to="/sitios/crear" class="btn-add">
          + Agregar Sitio
        </router-link>
      </div>

      <div class="filters">
        <div class="filter-group">
          <label>Tipo de sitio</label>
          <select v-model="selectedType" @change="filterSites">
            <option value="">Todos</option>
            <option value="Parque">Parque</option>
            <option value="Museo">Museo</option>
            <option value="Restaurante">Restaurante</option>
            <option value="Playa">Playa</option>
            <option value="Monumento">Monumento</option>
            <option value="Teatro">Teatro</option>
            <option value="Otro">Otro</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Buscar</label>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Nombre del sitio..."
            @input="filterSites"
          />
        </div>
      </div>

      <!-- Placeholder para Mapa Interactivo (Laboratorio 2) -->
      <div class="map-placeholder">
        <div class="map-placeholder-content">
          <div class="map-icon">🗺️</div>
          <h3>Mapa Interactivo</h3>
          <p>Aquí se mostrará la ubicación de los sitios turísticos</p>
          <p class="map-note">Funcionalidad disponible en la siguiente entrega</p>
        </div>
      </div>

      <LoadingSpinner v-if="sitesStore.loading" message="Cargando sitios..." />
      <ErrorMessage v-else-if="sitesStore.error" :message="sitesStore.error" />

      <div v-else-if="filteredSites.length > 0" class="sites-grid">
        <SiteCard
          v-for="site in filteredSites"
          :key="site.id"
          :site="site"
        />
      </div>

      <div v-else class="no-sites">
        <p>No se encontraron sitios con los filtros seleccionados.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSitesStore } from '@/stores/sites'
import Navbar from '@/components/layout/Navbar.vue'
import SiteCard from '@/components/common/SiteCard.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const sitesStore = useSitesStore()

const selectedType = ref('')
const searchQuery = ref('')

const filteredSites = computed(() => {
  let sites = sitesStore.sites

  if (selectedType.value) {
    sites = sites.filter(site => site.tipo === selectedType.value)
  }

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    sites = sites.filter(site =>
      site.nombre.toLowerCase().includes(query) ||
      site.descripcion?.toLowerCase().includes(query)
    )
  }

  return sites
})

const filterSites = async () => {
  if (selectedType.value) {
    await sitesStore.searchByType(selectedType.value)
  } else {
    await sitesStore.fetchAll()
  }
}

onMounted(async () => {
  await sitesStore.fetchAll()
})
</script>

<style scoped>
.sites-list-view {
  min-height: 100vh;
  background-color: #f8f9fa;
  padding-bottom: 3rem;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.header h1 {
  color: #2c3e50;
  margin: 0;
}

.btn-add {
  background-color: #27ae60;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  text-decoration: none;
  font-weight: 600;
  transition: background-color 0.3s;
}

.btn-add:hover {
  background-color: #229954;
}

.filters {
  background-color: white;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.filter-group {
  flex: 1;
  min-width: 200px;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.filter-group label {
  color: #2c3e50;
  font-weight: 500;
}

.filter-group select,
.filter-group input {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
}

.filter-group select:focus,
.filter-group input:focus {
  outline: none;
  border-color: #3498db;
}

/* Placeholder para Mapa Interactivo */
.map-placeholder {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 3rem 2rem;
  margin-bottom: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  min-height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.map-placeholder-content {
  text-align: center;
  color: white;
}

.map-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.map-placeholder-content h3 {
  font-size: 1.8rem;
  margin: 0 0 0.5rem 0;
  font-weight: 700;
}

.map-placeholder-content p {
  font-size: 1.1rem;
  margin: 0.5rem 0;
  opacity: 0.95;
}

.map-note {
  font-size: 0.9rem !important;
  opacity: 0.8 !important;
  font-style: italic;
  margin-top: 1rem !important;
}

.sites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

.no-sites {
  text-align: center;
  padding: 3rem;
  background-color: white;
  border-radius: 8px;
}

.no-sites p {
  color: #7f8c8d;
  margin: 0;
  font-size: 1.1rem;
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .btn-add {
    text-align: center;
  }

  .sites-grid {
    grid-template-columns: 1fr;
  }
}
</style>
