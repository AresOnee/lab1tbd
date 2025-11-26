<template>
  <div class="followers-view">
    <div class="header">
      <h1>👥 {{ isFollowersMode ? 'Seguidores' : 'Siguiendo' }}</h1>
      <p class="subtitle">{{ userName }}</p>
    </div>

    <div class="tabs">
      <button
        @click="changeMode('followers')"
        :class="['tab', { active: isFollowersMode }]"
      >
        Seguidores ({{ stats.totalSeguidores || 0 }})
      </button>
      <button
        @click="changeMode('following')"
        :class="['tab', { active: !isFollowersMode }]"
      >
        Siguiendo ({{ stats.totalSiguiendo || 0 }})
      </button>
    </div>

    <div v-if="loading" class="loading">
      <p>⏳ Cargando...</p>
    </div>

    <div v-else-if="error" class="error">
      <p>❌ {{ error }}</p>
    </div>

    <div v-else-if="users.length === 0" class="empty-state">
      <p>{{ emptyMessage }}</p>
    </div>

    <div v-else class="users-grid">
      <div
        v-for="user in users"
        :key="user.idUsuario"
        class="user-card"
      >
        <div class="user-info">
          <div class="user-avatar">
            {{ user.nombre.charAt(0).toUpperCase() }}
          </div>
          <div class="user-details">
            <h3>{{ user.nombre }}</h3>
            <p class="user-email">{{ user.email }}</p>
            <p v-if="user.biografia" class="user-bio">{{ user.biografia }}</p>
            <p class="follow-date">
              Desde {{ formatDate(user.fechaSeguimiento) }}
            </p>
          </div>
        </div>

        <div class="user-actions">
          <button @click="viewProfile(user.idUsuario)" class="btn-view">
            Ver Perfil
          </button>
          <FollowButton
            v-if="user.idUsuario !== currentUserId"
            :user-id="user.idUsuario"
            @follow-changed="onFollowChanged"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { followersService } from '@/services/followersService'
import { useAuthStore } from '@/stores/auth'
import FollowButton from '@/components/profile/FollowButton.vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const userId = ref(null)
const userName = ref('')
const mode = ref('followers') // 'followers' or 'following'
const users = ref([])
const stats = ref({})
const loading = ref(false)
const error = ref(null)

const currentUserId = computed(() => authStore.user?.id)
const isFollowersMode = computed(() => mode.value === 'followers')
const emptyMessage = computed(() => {
  return isFollowersMode.value
    ? 'Este usuario aún no tiene seguidores'
    : 'Este usuario aún no sigue a nadie'
})

const loadData = async () => {
  loading.value = true
  error.value = null

  try {
    // Obtener estadísticas
    stats.value = await followersService.getStats(userId.value)

    // Obtener lista según el modo
    if (isFollowersMode.value) {
      users.value = await followersService.getFollowers(userId.value)
    } else {
      users.value = await followersService.getFollowing(userId.value)
    }
  } catch (err) {
    error.value = err.response?.data?.message || 'Error al cargar datos'
    console.error('Error:', err)
  } finally {
    loading.value = false
  }
}

const changeMode = (newMode) => {
  mode.value = newMode
  loadData()
}

const viewProfile = (id) => {
  router.push(`/perfil/${id}`)
}

const onFollowChanged = () => {
  // Recargar los datos cuando cambia el estado de seguimiento
  loadData()
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Watch para cambios en la ruta
watch(() => route.params.id, (newId) => {
  if (newId) {
    userId.value = parseInt(newId)
    loadData()
  }
}, { immediate: true })

onMounted(() => {
  userId.value = parseInt(route.params.id) || currentUserId.value
  mode.value = route.query.mode || 'followers'

  // Obtener nombre del usuario (simplificado, podrías hacer una llamada a la API)
  if (userId.value === currentUserId.value) {
    userName.value = authStore.user?.nombre || 'Tu perfil'
  } else {
    userName.value = '' // Se podría obtener de la API
  }

  loadData()
})
</script>

<style scoped>
.followers-view {
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

.tabs {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  border-bottom: 2px solid #ecf0f1;
}

.tab {
  padding: 1rem 2rem;
  background: none;
  border: none;
  border-bottom: 3px solid transparent;
  font-size: 1.1rem;
  font-weight: 600;
  color: #7f8c8d;
  cursor: pointer;
  transition: all 0.3s;
}

.tab.active {
  color: #3498db;
  border-bottom-color: #3498db;
}

.tab:hover:not(.active) {
  color: #2c3e50;
}

.loading,
.error,
.empty-state {
  text-align: center;
  padding: 3rem;
  font-size: 1.2rem;
}

.error {
  color: #e74c3c;
}

.empty-state {
  color: #95a5a6;
}

.users-grid {
  display: grid;
  gap: 1.5rem;
}

.user-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 0.3s;
}

.user-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.user-info {
  display: flex;
  gap: 1.5rem;
  align-items: center;
  flex: 1;
}

.user-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
  flex-shrink: 0;
}

.user-details {
  flex: 1;
}

.user-details h3 {
  color: #2c3e50;
  margin-bottom: 0.25rem;
  font-size: 1.2rem;
}

.user-email {
  color: #7f8c8d;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.user-bio {
  color: #34495e;
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
}

.follow-date {
  color: #95a5a6;
  font-size: 0.85rem;
}

.user-actions {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.btn-view {
  padding: 0.6rem 1.2rem;
  background: #ecf0f1;
  color: #2c3e50;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-view:hover {
  background: #d5dbdb;
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .followers-view {
    padding: 1rem;
  }

  .header h1 {
    font-size: 2rem;
  }

  .user-card {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .user-info {
    width: 100%;
  }

  .user-actions {
    width: 100%;
    justify-content: flex-end;
  }
}
</style>
