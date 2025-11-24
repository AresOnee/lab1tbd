<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Crear Nueva Lista</h2>
        <button @click="$emit('close')" class="btn-close">✕</button>
      </div>

      <ErrorMessage :message="error" @dismiss="error = ''" />

      <form @submit.prevent="handleSubmit" class="list-form">
        <div class="form-group">
          <label for="nombre">Nombre de la lista *</label>
          <input
            id="nombre"
            v-model="formData.nombre"
            type="text"
            placeholder="Ej: Lugares para visitar en 2024"
            required
          />
        </div>

        <div class="form-group">
          <label for="descripcion">Descripción (opcional)</label>
          <textarea
            id="descripcion"
            v-model="formData.descripcion"
            placeholder="Describe tu lista..."
            rows="4"
          ></textarea>
        </div>

        <div class="form-actions">
          <button type="button" @click="$emit('close')" class="btn-cancel">
            Cancelar
          </button>
          <button type="submit" class="btn-submit" :disabled="loading">
            {{ loading ? 'Creando...' : 'Crear Lista' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useListsStore } from '@/stores/lists'
import { useAuthStore } from '@/stores/auth'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const emit = defineEmits(['close', 'created'])

const listsStore = useListsStore()
const authStore = useAuthStore()

const formData = reactive({
  nombre: '',
  descripcion: ''
})

const loading = ref(false)
const error = ref('')

const handleSubmit = async () => {
  error.value = ''
  loading.value = true

  try {
    await listsStore.createList({
      nombre: formData.nombre,
      descripcion: formData.descripcion,
      usuarioId: authStore.user.id
    })
    emit('created')
  } catch (err) {
    error.value = listsStore.error || 'Error al crear la lista'
  } finally {
    loading.value = false
  }
}
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
  max-width: 600px;
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

.list-form {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
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
}

.form-actions {
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
  background-color: #27ae60;
  color: white;
}

.btn-submit:hover:not(:disabled) {
  background-color: #229954;
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
