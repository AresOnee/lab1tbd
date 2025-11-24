<template>
  <div class="lists-view">
    <Navbar />

    <div class="container">
      <div class="header">
        <h1>Mis Listas Personalizadas</h1>
        <button @click="showCreateModal = true" class="btn-create">
          + Nueva Lista
        </button>
      </div>

      <LoadingSpinner v-if="listsStore.loading" message="Cargando listas..." />
      <ErrorMessage v-else-if="listsStore.error" :message="listsStore.error" />

      <div v-else-if="lists.length > 0" class="lists-grid">
        <div v-for="list in lists" :key="list.id" class="list-card">
          <div class="list-header">
            <h3>{{ list.nombre }}</h3>
            <div class="list-actions">
              <button @click="viewList(list.id)" class="btn-icon" title="Ver">
                👁️
              </button>
              <button @click="deleteList(list.id)" class="btn-icon" title="Eliminar">
                🗑️
              </button>
            </div>
          </div>
          <p v-if="list.descripcion" class="list-description">{{ list.descripcion }}</p>
          <div class="list-meta">
            <span>{{ list.totalSitios || 0 }} sitios</span>
            <span class="list-date">{{ formatDate(list.fechaCreacion) }}</span>
          </div>
        </div>
      </div>

      <div v-else class="no-lists">
        <p>No tienes listas aún. ¡Crea tu primera lista!</p>
        <button @click="showCreateModal = true" class="btn-create">
          Crear Primera Lista
        </button>
      </div>
    </div>

    <CreateListModal
      v-if="showCreateModal"
      @close="showCreateModal = false"
      @created="onListCreated"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useListsStore } from '@/stores/lists'
import { useAuthStore } from '@/stores/auth'
import Navbar from '@/components/layout/Navbar.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'
import CreateListModal from '@/components/lists/CreateListModal.vue'

const router = useRouter()
const listsStore = useListsStore()
const authStore = useAuthStore()

const lists = computed(() => listsStore.lists)
const showCreateModal = ref(false)

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const viewList = (listId) => {
  router.push(`/mis-listas/${listId}`)
}

const deleteList = async (listId) => {
  if (confirm('¿Estás seguro de eliminar esta lista?')) {
    await listsStore.deleteList(listId)
  }
}

const onListCreated = async () => {
  showCreateModal.value = false
  await listsStore.fetchByUserId(authStore.user.id)
}

onMounted(async () => {
  await listsStore.fetchByUserId(authStore.user.id)
})
</script>

<style scoped>
.lists-view {
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

.btn-create {
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

.btn-create:hover {
  background-color: #229954;
}

.lists-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.list-card {
  background-color: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.list-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 0.75rem;
}

.list-header h3 {
  margin: 0;
  color: #2c3e50;
  flex: 1;
}

.list-actions {
  display: flex;
  gap: 0.5rem;
}

.btn-icon {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.25rem;
  padding: 0.25rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.btn-icon:hover {
  background-color: #ecf0f1;
}

.list-description {
  color: #7f8c8d;
  margin: 0 0 1rem 0;
  font-size: 0.9rem;
  line-height: 1.4;
}

.list-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.85rem;
  color: #95a5a6;
  padding-top: 0.75rem;
  border-top: 1px solid #ecf0f1;
}

.list-date {
  font-style: italic;
}

.no-lists {
  text-align: center;
  padding: 4rem 2rem;
  background-color: white;
  border-radius: 8px;
}

.no-lists p {
  color: #7f8c8d;
  font-size: 1.1rem;
  margin: 0 0 1.5rem 0;
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .lists-grid {
    grid-template-columns: 1fr;
  }
}
</style>
