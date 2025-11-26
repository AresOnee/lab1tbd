<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Editar Reseña</h2>
        <button @click="$emit('close')" class="btn-close">✕</button>
      </div>

      <ErrorMessage :message="error" @dismiss="error = ''" />

      <form @submit.prevent="handleSubmit" class="review-form">
        <div class="form-group">
          <label>Calificación</label>
          <RatingStars
            v-model:rating="formData.calificacion"
            :editable="true"
            class="editable"
          />
        </div>

        <div class="form-group">
          <label for="contenido">Tu reseña</label>
          <textarea
            id="contenido"
            v-model="formData.contenido"
            placeholder="Comparte tu experiencia..."
            rows="6"
            required
          ></textarea>
        </div>

        <div class="form-actions">
          <button type="button" @click="$emit('close')" class="btn-cancel">
            Cancelar
          </button>
          <button type="submit" class="btn-submit" :disabled="loading">
            {{ loading ? 'Guardando...' : 'Actualizar Reseña' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useReviewsStore } from '@/stores/reviews'
import RatingStars from '@/components/common/RatingStars.vue'
import ErrorMessage from '@/components/common/ErrorMessage.vue'

const props = defineProps({
  review: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['close', 'updated'])

const reviewsStore = useReviewsStore()

const formData = reactive({
  calificacion: props.review.calificacion,
  contenido: props.review.contenido
})

const loading = ref(false)
const error = ref('')

const handleSubmit = async () => {
  error.value = ''
  loading.value = true

  try {
    await reviewsStore.updateReview(props.review.id, {
      calificacion: formData.calificacion,
      contenido: formData.contenido
    })
    emit('updated')
    emit('close')
  } catch (err) {
    error.value = reviewsStore.error || 'Error al actualizar la reseña'
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

.review-form {
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

.form-group textarea {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
}

.form-group textarea:focus {
  outline: none;
  border-color: #3498db;
}

.rating-stars.editable {
  cursor: pointer;
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
  background-color: #f39c12;
  color: white;
}

.btn-submit:hover:not(:disabled) {
  background-color: #e67e22;
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
