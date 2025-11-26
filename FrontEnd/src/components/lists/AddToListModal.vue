<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Agregar a Lista</h2>
        <button @click="$emit('close')" class="btn-close">✕</button>
      </div>

      <ErrorMessage :message="error" @dismiss="error = ''" />
      <SuccessMessage :message="successMessage" @dismiss="successMessage = ''" />

      <div class="modal-body">
        <LoadingSpinner v-if="loading" message="Cargando listas..." />

        <div v-else-if="userLists.length === 0" class="empty-state">
          <p>No tienes listas creadas aún.</p>
          <button @click="showCreateList = true" class="btn-create">
            Crear Primera Lista
          </button>
        </div>

        <div v-else class="lists-container">
          <p class="instruction">Selecciona una lista para agregar este sitio:</p>
          <div class="lists-grid">
            <div
              v-for="list in userLists"
              :key="list.id"
              class="list-card"
              @click="handleSelectList(list.id)"
              :class="{ selected: selectedListId === list.id }"
            >
              <h3>{{ list.nombreLista }}</h3>
              <p class="list-description">{{ list.descripcion || 'Sin descripción' }}</p>
              <span class="list-count">{{ list.totalSitios || 0 }} sitios</span>
            </div>
          </div>

          <div class="modal-actions">
            <button @click="$emit('close')" class="btn-cancel">
              Cancelar
            </button>
            <button
              @click="handleAddToList"
              class="btn-submit"
              :disabled="!selectedListId || adding"
            >
              {{ adding ? 'Agregando...' : 'Agregar a Lista' }}
            </button>
          </div>
        </div>
      </div>

      <!-- Mini modal para crear nueva lista -->
      <div v-if="showCreateList" class="create-list-overlay" @click.self="showCreateList = false">
        <div class="create-list-modal">
          <h3>Crear Nueva Lista</h3>
          <form @submit.prevent="handleCreateList">
            <div class="form-group">
              <label for="listName">Nombre de la lista</label>
              <input
                id="listName"
                v-model="newListData.nombre"
                type="text"
                placeholder="Ej: Mis Favoritos"
                required
              />
            </div>
            <div class="form-group">
              <label for="listDescription">Descripción (opcional)</label>
              <textarea
                id="listDescription"
                v-model="newListData.descripcion"
                placeholder="Describe esta lista..."
                rows="3"
              ></textarea>
            </div>
            <div class="form-actions">
              <button type="button" @click="showCreateList = false" class="btn-cancel">
                Cancelar
              </button>
              <button type="submit" class="btn-submit" :disabled="creating">
                {{ creating ? 'Creando...' : 'Crear Lista' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useListsStore } from '@/stores/lists'
import { useAuthStore } from '@/stores/auth'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'
import SuccessMessage from '@/components/common/SuccessMessage.vue'

const props = defineProps({
  siteId: {
    type: [Number, String],
    required: true
  }
})

const emit = defineEmits(['close', 'added'])

const listsStore = useListsStore()
const authStore = useAuthStore()

const userLists = computed(() => listsStore.lists)
const loading = ref(false)
const adding = ref(false)
const creating = ref(false)
const error = ref('')
const successMessage = ref('')
const selectedListId = ref(null)
const showCreateList = ref(false)
const newListData = ref({
  nombre: '',
  descripcion: ''
})

const handleSelectList = (listId) => {
  selectedListId.value = listId
}

const handleAddToList = async () => {
  if (!selectedListId.value) return

  adding.value = true
  error.value = ''
  successMessage.value = ''

  try {
    await listsStore.addSiteToList(selectedListId.value, props.siteId)
    successMessage.value = '✅ Sitio agregado a la lista exitosamente'

    // Cerrar el modal después de 1.5 segundos
    setTimeout(() => {
      emit('added')
      emit('close')
    }, 1500)
  } catch (err) {
    error.value = err.response?.data?.message || 'Error al agregar sitio a la lista'
  } finally {
    adding.value = false
  }
}

const handleCreateList = async () => {
  if (!newListData.value.nombre.trim()) return

  creating.value = true
  error.value = ''

  try {
    const newList = await listsStore.createList({
      nombre: newListData.value.nombre,
      descripcion: newListData.value.descripcion
    })

    showCreateList.value = false
    newListData.value = { nombre: '', descripcion: '' }
    selectedListId.value = newList.id
    successMessage.value = '✅ Lista creada exitosamente'
  } catch (err) {
    error.value = err.response?.data?.message || 'Error al crear lista'
  } finally {
    creating.value = false
  }
}

onMounted(async () => {
  if (!authStore.user) return

  loading.value = true
  try {
    await listsStore.fetchByUserId(authStore.user.id)
  } catch (err) {
    error.value = 'Error al cargar tus listas'
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background-color: white;
  border-radius: 8px;
  width: 100%;
  max-width: 700px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e0e0e0;
}

.modal-header h2 {
  margin: 0;
  color: #2c3e50;
}

.btn-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #7f8c8d;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.btn-close:hover {
  background-color: #f0f0f0;
}

.modal-body {
  padding: 1.5rem;
}

.empty-state {
  text-align: center;
  padding: 3rem 1rem;
}

.empty-state p {
  color: #7f8c8d;
  margin-bottom: 1.5rem;
}

.btn-create {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.3s;
}

.btn-create:hover {
  background-color: #2980b9;
}

.lists-container {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.instruction {
  color: #2c3e50;
  margin: 0;
  font-weight: 500;
}

.lists-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
}

.list-card {
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  padding: 1rem;
  cursor: pointer;
  transition: all 0.3s;
  background-color: white;
}

.list-card:hover {
  border-color: #3498db;
  box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
}

.list-card.selected {
  border-color: #3498db;
  background-color: #ebf5fb;
  box-shadow: 0 2px 8px rgba(52, 152, 219, 0.3);
}

.list-card h3 {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
  font-size: 1.1rem;
}

.list-description {
  margin: 0 0 0.75rem 0;
  color: #7f8c8d;
  font-size: 0.9rem;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.list-count {
  display: inline-block;
  background-color: #ecf0f1;
  color: #2c3e50;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 500;
}

.modal-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

.btn-cancel,
.btn-submit {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-cancel {
  background-color: #ecf0f1;
  color: #2c3e50;
}

.btn-cancel:hover {
  background-color: #dfe4e6;
}

.btn-submit {
  background-color: #3498db;
  color: white;
}

.btn-submit:hover:not(:disabled) {
  background-color: #2980b9;
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Create list mini-modal styles */
.create-list-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1001;
}

.create-list-modal {
  background-color: white;
  border-radius: 8px;
  padding: 2rem;
  width: 90%;
  max-width: 500px;
}

.create-list-modal h3 {
  margin: 0 0 1.5rem 0;
  color: #2c3e50;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.form-group label {
  color: #2c3e50;
  font-weight: 500;
}

.form-group input,
.form-group textarea {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #3498db;
}

.form-group textarea {
  resize: vertical;
  min-height: 80px;
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1.5rem;
}
</style>
