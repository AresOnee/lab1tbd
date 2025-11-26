<template>
  <div class="profile-view">
    <Navbar />

    <div class="container">
      <LoadingSpinner v-if="loading" message="Cargando perfil..." />

      <div v-else class="profile-content">
        <div class="profile-header">
          <div class="profile-avatar">
            {{ userInitial }}
          </div>
          <div class="profile-info">
            <h1>{{ user?.nombre }}</h1>
            <p class="profile-email">{{ user?.email }}</p>
            <p v-if="user?.biografia" class="profile-bio">{{ user.biografia }}</p>
            <p v-else class="profile-bio-empty">Sin biografía</p>
          </div>
          <button @click="showEditProfile = true" class="btn-edit-profile">
            ✏️ Editar Perfil
          </button>
        </div>

        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-number">{{ stats.totalResenas }}</div>
            <div class="stat-label">Reseñas</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ stats.totalFotos }}</div>
            <div class="stat-label">Fotos</div>
          </div>
          <div class="stat-card">
            <div class="stat-number">{{ stats.totalListas }}</div>
            <div class="stat-label">Listas</div>
          </div>
          <div class="stat-card clickable" @click="viewFollowers">
            <div class="stat-number">{{ followersStats.totalSeguidores || 0 }}</div>
            <div class="stat-label">Seguidores</div>
          </div>
          <div class="stat-card clickable" @click="viewFollowing">
            <div class="stat-number">{{ followersStats.totalSiguiendo || 0 }}</div>
            <div class="stat-label">Siguiendo</div>
          </div>
        </div>

        <div class="tabs">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            class="tab-button"
            :class="{ active: activeTab === tab.id }"
          >
            {{ tab.label }}
          </button>
        </div>

        <div class="tab-content">
          <div v-if="activeTab === 'reviews'" class="reviews-list">
            <h2>Mis Reseñas</h2>
            <div v-if="reviews.length > 0" class="content-grid">
              <div v-for="review in reviews" :key="review.id" class="review-item">
                <router-link :to="`/sitios/${review.sitioId}`" class="item-link">
                  <h3>{{ review.sitioNombre }}</h3>
                </router-link>
                <RatingStars :rating="review.calificacion" :show-value="false" />
                <p>{{ review.contenido }}</p>
                <small>{{ formatDate(review.fecha) }}</small>
              </div>
            </div>
            <p v-else class="no-content">No has escrito reseñas aún.</p>
          </div>

          <div v-if="activeTab === 'photos'" class="photos-list">
            <h2>Mis Fotografías</h2>
            <div v-if="photos.length > 0" class="photos-grid">
              <div v-for="photo in photos" :key="photo.id" class="photo-item">
                <img :src="photo.url" :alt="photo.sitioNombre" />
                <div class="photo-info">
                  <router-link :to="`/sitios/${photo.sitioId}`">
                    {{ photo.sitioNombre }}
                  </router-link>
                </div>
              </div>
            </div>
            <p v-else class="no-content">No has subido fotografías aún.</p>
          </div>

          <div v-if="activeTab === 'lists'" class="lists-section">
            <h2>Mis Listas</h2>
            <router-link to="/mis-listas" class="btn-primary">
              Ver todas mis listas
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <ProfileEditForm
      v-if="showEditProfile"
      :user="user"
      @close="showEditProfile = false"
      @updated="onProfileUpdated"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useReviewsStore } from '@/stores/reviews'
import { usePhotosStore } from '@/stores/photos'
import { useListsStore } from '@/stores/lists'
import { followersService } from '@/services/followersService'
import Navbar from '@/components/layout/Navbar.vue'
import RatingStars from '@/components/common/RatingStars.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ProfileEditForm from '@/components/profile/ProfileEditForm.vue'

const router = useRouter()
const authStore = useAuthStore()
const reviewsStore = useReviewsStore()
const photosStore = usePhotosStore()
const listsStore = useListsStore()

const user = computed(() => authStore.user)
const reviews = computed(() => reviewsStore.reviews)
const photos = computed(() => photosStore.photos)

const loading = ref(false)
const activeTab = ref('reviews')
const showEditProfile = ref(false)

const stats = ref({
  totalResenas: 0,
  totalFotos: 0,
  totalListas: 0
})

const followersStats = ref({
  totalSeguidores: 0,
  totalSiguiendo: 0
})

const tabs = [
  { id: 'reviews', label: 'Reseñas' },
  { id: 'photos', label: 'Fotografías' },
  { id: 'lists', label: 'Listas' }
]

const userInitial = computed(() => {
  return user.value?.nombre?.charAt(0).toUpperCase() || 'U'
})

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const onProfileUpdated = () => {
  showEditProfile.value = false
  // El perfil ya está actualizado en authStore por ProfileEditForm
}

const viewFollowers = () => {
  router.push(`/perfil/${user.value.id}/seguidores?mode=followers`)
}

const viewFollowing = () => {
  router.push(`/perfil/${user.value.id}/seguidores?mode=following`)
}

onMounted(async () => {
  loading.value = true
  try {
    const userId = user.value.id
    await Promise.all([
      reviewsStore.fetchByUserId(userId),
      photosStore.fetchByUserId(userId),
      listsStore.fetchByUserId(userId),
      followersService.getStats(userId).then(data => {
        followersStats.value = data
      })
    ])

    stats.value = {
      totalResenas: reviews.value.length,
      totalFotos: photos.value.length,
      totalListas: listsStore.lists.length
    }
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.profile-view {
  min-height: 100vh;
  background-color: #f8f9fa;
  padding-bottom: 3rem;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.profile-header {
  background-color: white;
  padding: 2rem;
  border-radius: 8px;
  display: flex;
  gap: 2rem;
  align-items: center;
  margin-bottom: 2rem;
}

.profile-avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2.5rem;
  font-weight: bold;
}

.profile-info h1 {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
}

.profile-email {
  color: #7f8c8d;
  margin: 0 0 0.5rem 0;
}

.profile-bio {
  color: #34495e;
  margin: 0;
}

.profile-bio-empty {
  color: #95a5a6;
  font-style: italic;
  margin: 0;
}

.btn-edit-profile {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.95rem;
  font-weight: 500;
  transition: background-color 0.3s;
  white-space: nowrap;
  margin-left: auto;
}

.btn-edit-profile:hover {
  background-color: #2980b9;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1rem;
  margin-bottom: 2rem;
}

.stat-card {
  background-color: white;
  padding: 1.5rem;
  border-radius: 8px;
  text-align: center;
  transition: all 0.3s;
}

.stat-card.clickable {
  cursor: pointer;
}

.stat-card.clickable:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  background-color: #f8f9fa;
}

.stat-number {
  font-size: 2.5rem;
  font-weight: bold;
  color: #3498db;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #7f8c8d;
  font-size: 0.9rem;
}

.tabs {
  background-color: white;
  padding: 1rem;
  border-radius: 8px 8px 0 0;
  display: flex;
  gap: 0.5rem;
}

.tab-button {
  padding: 0.75rem 1.5rem;
  border: none;
  background: none;
  cursor: pointer;
  color: #7f8c8d;
  font-weight: 500;
  border-radius: 4px;
  transition: background-color 0.3s, color 0.3s;
}

.tab-button.active {
  background-color: #3498db;
  color: white;
}

.tab-button:hover:not(.active) {
  background-color: #ecf0f1;
}

.tab-content {
  background-color: white;
  padding: 2rem;
  border-radius: 0 0 8px 8px;
}

.tab-content h2 {
  margin: 0 0 1.5rem 0;
  color: #2c3e50;
}

.content-grid {
  display: grid;
  gap: 1rem;
}

.review-item {
  border: 1px solid #e0e0e0;
  padding: 1rem;
  border-radius: 6px;
}

.item-link {
  text-decoration: none;
  color: #3498db;
}

.item-link:hover {
  text-decoration: underline;
}

.review-item h3 {
  margin: 0 0 0.5rem 0;
}

.review-item p {
  margin: 0.5rem 0;
  color: #34495e;
}

.review-item small {
  color: #95a5a6;
}

.photos-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
}

.photo-item {
  position: relative;
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
}

.photo-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-info {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  padding: 1rem;
  color: white;
}

.photo-info a {
  color: white;
  text-decoration: none;
}

.photo-info a:hover {
  text-decoration: underline;
}

.no-content {
  text-align: center;
  color: #7f8c8d;
  padding: 2rem;
}

.btn-primary {
  display: inline-block;
  background-color: #3498db;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  text-decoration: none;
  font-weight: 600;
  transition: background-color 0.3s;
}

.btn-primary:hover {
  background-color: #2980b9;
}

@media (max-width: 768px) {
  .profile-header {
    flex-direction: column;
    text-align: center;
  }

  .stats-grid {
    grid-template-columns: 1fr;
  }

  .tabs {
    flex-direction: column;
  }
}
</style>
