<template>
  <div class="site-detail-view">
    <Navbar />

    <LoadingSpinner v-if="loading" message="Cargando sitio..." />

    <div v-else-if="site" class="container">
      <div class="site-header">
        <div class="site-info">
          <h1>{{ site.nombre }}</h1>
          <div class="site-meta">
            <span class="site-type">{{ site.tipo }}</span>
            <RatingStars :rating="site.calificacionPromedio || 0" />
          </div>
        </div>
        <div class="site-actions">
          <button @click="addToList" class="btn-action">+ Agregar a lista</button>
          <button
            v-if="isAuthenticated"
            @click="editSite"
            class="btn-edit"
          >
            ✏️ Editar
          </button>
          <button
            v-if="isAuthenticated"
            @click="deleteSite"
            class="btn-delete"
          >
            🗑️ Eliminar
          </button>
        </div>
      </div>

      <div class="site-content">
        <div class="main-content">
          <section class="photos-section">
            <h2>Fotografías</h2>
            <div v-if="photos.length > 0" class="photos-grid">
              <PhotoCard
                v-for="photo in photos"
                :key="photo.id"
                :photo="photo"
                @delete="handleDeletePhoto"
              />
            </div>
            <p v-else class="no-content">No hay fotografías aún.</p>
            <button
              v-if="isAuthenticated"
              @click="showUploadPhoto = true"
              class="btn-secondary"
            >
              Subir Foto
            </button>
          </section>

          <section class="description-section">
            <h2>Descripción</h2>
            <p>{{ site.descripcion }}</p>
          </section>

          <section class="reviews-section">
            <div class="reviews-header">
              <h2>Reseñas ({{ reviews.length }})</h2>
              <button
                v-if="isAuthenticated"
                @click="showCreateReview = true"
                class="btn-primary"
              >
                Escribir Reseña
              </button>
            </div>

            <div v-if="reviews.length > 0" class="reviews-list">
              <ReviewCard
                v-for="review in reviews"
                :key="review.id"
                :review="review"
                @edit="handleEditReview"
                @delete="handleDeleteReview"
              />
            </div>
            <p v-else class="no-content">No hay reseñas aún. Sé el primero en dejar una.</p>
          </section>
        </div>

        <aside class="sidebar">
          <div class="info-card">
            <h3>Ubicación</h3>
            <p v-if="site.latitud && site.longitud" class="coordinates">
              <strong>Latitud:</strong> {{ site.latitud }}<br />
              <strong>Longitud:</strong> {{ site.longitud }}
            </p>
            <p v-else class="no-coordinates">
              Coordenadas no disponibles
            </p>
            <div class="map-preview">
              <p>Vista previa del mapa</p>
              <p class="map-placeholder-text">El mapa se mostrará aquí en futuras versiones</p>
            </div>
          </div>
        </aside>
      </div>
    </div>

    <ReviewForm
      v-if="showCreateReview"
      :site-id="siteId"
      @close="showCreateReview = false"
      @created="onReviewCreated"
    />

    <ReviewEditForm
      v-if="showEditReview"
      :review="editingReview"
      @close="showEditReview = false"
      @updated="onReviewUpdated"
    />

    <PhotoUpload
      v-if="showUploadPhoto"
      :site-id="siteId"
      @close="showUploadPhoto = false"
      @uploaded="onPhotoUploaded"
    />

    <AddToListModal
      v-if="showAddToList"
      :site-id="siteId"
      @close="showAddToList = false"
      @added="showAddToList = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSitesStore } from '@/stores/sites'
import { useReviewsStore } from '@/stores/reviews'
import { usePhotosStore } from '@/stores/photos'
import { useAuthStore } from '@/stores/auth'
import Navbar from '@/components/layout/Navbar.vue'
import RatingStars from '@/components/common/RatingStars.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ReviewForm from '@/components/reviews/ReviewForm.vue'
import ReviewEditForm from '@/components/reviews/ReviewEditForm.vue'
import ReviewCard from '@/components/reviews/ReviewCard.vue'
import PhotoUpload from '@/components/photos/PhotoUpload.vue'
import PhotoCard from '@/components/photos/PhotoCard.vue'
import AddToListModal from '@/components/lists/AddToListModal.vue'

const route = useRoute()
const router = useRouter()
const sitesStore = useSitesStore()
const reviewsStore = useReviewsStore()
const photosStore = usePhotosStore()
const authStore = useAuthStore()

const siteId = computed(() => route.params.id)
const site = computed(() => sitesStore.currentSite)
const reviews = computed(() => reviewsStore.reviews)
const photos = computed(() => photosStore.photos)
const isAuthenticated = computed(() => authStore.isAuthenticated)

const loading = ref(false)
const showCreateReview = ref(false)
const showEditReview = ref(false)
const showUploadPhoto = ref(false)
const showAddToList = ref(false)
const editingReview = ref(null)

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const addToList = () => {
  if (!isAuthenticated.value) {
    alert('Debes iniciar sesión para agregar sitios a listas')
    return
  }
  showAddToList.value = true
}

const editSite = () => {
  router.push(`/sitios/${siteId.value}/editar`)
}

const deleteSite = async () => {
  if (!confirm('¿Estás seguro de eliminar este sitio? Esta acción no se puede deshacer y eliminará también todas sus reseñas y fotos.')) {
    return
  }

  try {
    await sitesStore.deleteSite(siteId.value)
    alert('Sitio eliminado exitosamente')
    router.push('/sitios')
  } catch (error) {
    alert('Error al eliminar el sitio')
  }
}

const handleEditReview = (review) => {
  editingReview.value = review
  showEditReview.value = true
}

const handleDeleteReview = async (reviewId) => {
  try {
    await reviewsStore.deleteReview(reviewId)
    await reviewsStore.fetchBySiteId(siteId.value)
  } catch (error) {
    alert('Error al eliminar la reseña')
  }
}

const handleDeletePhoto = async (photoId) => {
  try {
    await photosStore.deletePhoto(photoId)
    await photosStore.fetchBySiteId(siteId.value)
  } catch (error) {
    alert('Error al eliminar la fotografía')
  }
}

const onReviewCreated = async () => {
  showCreateReview.value = false
  await reviewsStore.fetchBySiteId(siteId.value)
}

const onReviewUpdated = async () => {
  showEditReview.value = false
  await reviewsStore.fetchBySiteId(siteId.value)
}

const onPhotoUploaded = async () => {
  showUploadPhoto.value = false
  await photosStore.fetchBySiteId(siteId.value)
}

onMounted(async () => {
  loading.value = true
  try {
    await Promise.all([
      sitesStore.fetchById(siteId.value),
      reviewsStore.fetchBySiteId(siteId.value),
      photosStore.fetchBySiteId(siteId.value)
    ])
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.site-detail-view {
  min-height: 100vh;
  background-color: #f8f9fa;
  padding-bottom: 3rem;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.site-header {
  background-color: white;
  padding: 2rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.site-info h1 {
  margin: 0 0 1rem 0;
  color: #2c3e50;
}

.site-meta {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.site-type {
  background-color: #3498db;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.9rem;
}

.site-actions {
  display: flex;
  gap: 1rem;
}

.btn-action {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.3s;
}

.btn-action:hover {
  background-color: #2980b9;
}

.btn-edit {
  background-color: #f39c12;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.3s;
}

.btn-edit:hover {
  background-color: #e67e22;
}

.btn-delete {
  background-color: #e74c3c;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.3s;
}

.btn-delete:hover {
  background-color: #c0392b;
}

.site-content {
  display: grid;
  grid-template-columns: 1fr 350px;
  gap: 2rem;
}

.main-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

section {
  background-color: white;
  padding: 2rem;
  border-radius: 8px;
}

section h2 {
  margin: 0 0 1.5rem 0;
  color: #2c3e50;
}

.photos-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 1rem;
}

.btn-primary,
.btn-secondary {
  background-color: #27ae60;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.3s;
}

.btn-secondary {
  background-color: #95a5a6;
}

.btn-primary:hover {
  background-color: #229954;
}

.btn-secondary:hover {
  background-color: #7f8c8d;
}

.reviews-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.no-content {
  color: #7f8c8d;
  text-align: center;
  padding: 2rem 0;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.info-card {
  background-color: white;
  padding: 1.5rem;
  border-radius: 8px;
}

.info-card h3 {
  margin: 0 0 1rem 0;
  color: #2c3e50;
}

.coordinates {
  color: #2c3e50;
  line-height: 1.8;
  margin: 0 0 1rem 0;
}

.no-coordinates {
  color: #95a5a6;
  font-style: italic;
  margin: 0 0 1rem 0;
}

.map-preview {
  background-color: #ecf0f1;
  border: 2px dashed #bdc3c7;
  border-radius: 6px;
  padding: 2rem;
  text-align: center;
  margin-top: 1rem;
}

.map-placeholder-text {
  color: #7f8c8d;
  font-size: 0.9rem;
  margin: 0.5rem 0 0 0;
}

@media (max-width: 968px) {
  .site-content {
    grid-template-columns: 1fr;
  }

  .site-header {
    flex-direction: column;
    gap: 1rem;
  }
}
</style>
