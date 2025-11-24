<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Subir Fotografía</h2>
        <button @click="$emit('close')" class="btn-close">✕</button>
      </div>

      <ErrorMessage :message="error" @dismiss="error = ''" />

      <form @submit.prevent="handleSubmit" class="photo-form">
        <div class="form-group">
          <label for="url">URL de la fotografía</label>
          <input
            id="url"
            v-model="formData.url"
            type="url"
            placeholder="https://ejemplo.com/foto.jpg"
            required
          />
          <small>Ingresa la URL pública de tu imagen</small>
        </div>

        <div v-if="formData.url" class="preview">
          <p>Vista previa:</p>
          <img :src="formData.url" alt="Preview" @error="imageError = true" />
          <p v-if="imageError" class="error-text">No se pudo cargar la imagen</p>
        </div>

        <div class="form-actions">
          <button type="button" @click="$emit('close')" class="btn-cancel">
            Cancelar
          </button>
          <button type="submit" class="btn-submit" :disabled="loading || imageError">
            {{ loading ? 'Subiendo...' : 'Subir Foto' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, watch } from 'vue'
import { usePhotosStore } from '@/stores/photos'
import { useAuthStore } from '@/stores/auth'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const props = defineProps({
  siteId: {
    type: [String, Number],
    required: true
  }
})

const emit = defineEmits(['close', 'uploaded'])

const photosStore = usePhotosStore()
const authStore = useAuthStore()

const formData = reactive({
  url: ''
})

const loading = ref(false)
const error = ref('')
const imageError = ref(false)

watch(() => formData.url, () => {
  imageError.value = false
})

const handleSubmit = async () => {
  if (imageError.value) return

  error.value = ''
  loading.value = true

  try {
    await photosStore.uploadPhoto({
      sitioId: props.siteId,
      usuarioId: authStore.user.id,
      url: formData.url
    })
    emit('uploaded')
  } catch (err) {
    error.value = photosStore.error || 'Error al subir la fotografía'
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

.photo-form {
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

.form-group input {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
}

.form-group input:focus {
  outline: none;
  border-color: #3498db;
}

.form-group small {
  color: #7f8c8d;
  font-size: 0.85rem;
}

.preview {
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  padding: 1rem;
}

.preview p {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
  font-weight: 500;
}

.preview img {
  width: 100%;
  max-height: 300px;
  object-fit: contain;
  border-radius: 4px;
}

.error-text {
  color: #e74c3c;
  font-size: 0.9rem;
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
