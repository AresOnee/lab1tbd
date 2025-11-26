<template>
  <div class="list-detail-view">
    <Navbar />

    <div class="container">
      <LoadingSpinner v-if="loading" message="Cargando lista..." />

      <div v-else-if="error" class="error-container">
        <ErrorMessage :message="error" />
        <button @click="router.push('/mis-listas')" class="btn-back">
          Volver a Mis Listas
        </button>
      </div>

      <div v-else-if="sites">
        <div class="header">
          <div class="header-content">
            <button @click="router.push('/mis-listas')" class="btn-back-small">
              ← Volver
            </button>
            <h1>{{ listName }}</h1>
            <p class="list-count">{{ sites.length }} {{ sites.length === 1 ? 'sitio' : 'sitios' }}</p>
          </div>
        </div>

        <div v-if="sites.length > 0" class="sites-grid">
          <div
            v-for="site in sites"
            :key="site.id"
            class="site-card"
            @click="goToSite(site.id)"
          >
            <div class="site-header">
              <h3>{{ site.nombre }}</h3>
              <button
                @click.stop="removeSite(site.id)"
                class="btn-remove"
                title="Quitar de la lista"
              >
                ✕
              </button>
            </div>
            <p class="site-description">{{ site.descripcion }}</p>
            <div class="site-meta">
              <span class="site-type">{{ site.tipo }}</span>
              <RatingStars :rating="site.calificacionPromedio || 0" />
            </div>
            <p v-if="site.totalResenas > 0" class="site-reviews">
              {{ site.totalResenas }} {{ site.totalResenas === 1 ? 'reseña' : 'reseñas' }}
            </p>
          </div>
        </div>

        <div v-else class="empty-state">
          <p>Esta lista está vacía</p>
          <p class="empty-subtitle">Agrega sitios desde la vista de detalle de cada lugar</p>
          <button @click="router.push('/sitios')" class="btn-primary">
            Explorar Sitios
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { listsService } from '@/services/listsService'
import { useListsStore } from '@/stores/lists'
import Navbar from '@/components/layout/Navbar.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'
import RatingStars from '@/components/common/RatingStars.vue'

const route = useRoute()
const router = useRouter()
const listsStore = useListsStore()

const listId = ref(route.params.id)
const listName = ref('')
const sites = ref([])
const loading = ref(false)
const error = ref(null)

const loadListSites = async () => {
  loading.value = true
  error.value = null

  try {
    // Cargar sitios de la lista
    sites.value = await listsService.getSites(listId.value)

    // Obtener nombre de la lista desde el store o hacer request
    const list = listsStore.lists.find(l => l.id === parseInt(listId.value))
    listName.value = list?.nombreLista || 'Mi Lista'
  } catch (err) {
    error.value = err.response?.data?.message || 'Error al cargar la lista'
    console.error('Error loading list:', err)
  } finally {
    loading.value = false
  }
}

const goToSite = (siteId) => {
  router.push(`/sitios/${siteId}`)
}

const removeSite = async (siteId) => {
  if (!confirm('¿Quitar este sitio de la lista?')) return

  try {
    await listsStore.removeSiteFromList(listId.value, siteId)
    // Recargar sitios después de eliminar
    await loadListSites()
  } catch (err) {
    alert('Error al quitar el sitio de la lista')
  }
}

onMounted(() => {
  loadListSites()
})
</script>

<style scoped>
.list-detail-view {
  min-height: 100vh;
  background-color: #f8f9fa;
  padding-bottom: 3rem;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.error-container {
  text-align: center;
  padding: 2rem;
}

.btn-back {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-size: 1rem;
  cursor: pointer;
  margin-top: 1rem;
  transition: background-color 0.3s;
}

.btn-back:hover {
  background-color: #2980b9;
}

.header {
  margin-bottom: 2rem;
}

.header-content {
  background-color: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.btn-back-small {
  background-color: #ecf0f1;
  color: #2c3e50;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-size: 0.9rem;
  cursor: pointer;
  margin-bottom: 1rem;
  transition: background-color 0.3s;
}

.btn-back-small:hover {
  background-color: #dfe4e6;
}

.header-content h1 {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
}

.list-count {
  color: #7f8c8d;
  font-size: 1.1rem;
  margin: 0;
}

.sites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.site-card {
  background-color: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.3s, box-shadow 0.3s;
  position: relative;
}

.site-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.site-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 0.75rem;
}

.site-header h3 {
  margin: 0;
  color: #2c3e50;
  flex: 1;
  padding-right: 0.5rem;
}

.btn-remove {
  background-color: #e74c3c;
  color: white;
  border: none;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1rem;
  line-height: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.3s;
  flex-shrink: 0;
}

.btn-remove:hover {
  background-color: #c0392b;
}

.site-description {
  color: #7f8c8d;
  margin: 0 0 1rem 0;
  font-size: 0.95rem;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.site-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.site-type {
  background-color: #3498db;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 500;
}

.site-reviews {
  color: #95a5a6;
  font-size: 0.9rem;
  margin: 0;
}

.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  background-color: white;
  border-radius: 8px;
}

.empty-state p {
  color: #7f8c8d;
  font-size: 1.1rem;
  margin: 0 0 1rem 0;
}

.empty-subtitle {
  font-size: 0.95rem !important;
  margin-bottom: 2rem !important;
}

.btn-primary {
  background-color: #27ae60;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-primary:hover {
  background-color: #229954;
}

@media (max-width: 768px) {
  .sites-grid {
    grid-template-columns: 1fr;
  }
}
</style>
