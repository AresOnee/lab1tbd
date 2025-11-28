<template>
  <div class="review-card">
    <div class="review-header">
      <div class="review-author">
        <div class="author-info">
          <router-link
            :to="`/perfil/${review.idUsuario}`"
            class="author-name"
          >
            {{ review.nombreUsuario || review.usuarioNombre }}
          </router-link>
          <FollowButton
            v-if="!isOwnReview"
            :user-id="review.idUsuario"
            size="small"
          />
        </div>
        <RatingStars :rating="review.calificacion" :show-value="false" />
      </div>
      <div class="review-meta">
        <span class="review-date">{{ formatDate(review.fecha) }}</span>
        <div v-if="isOwnReview" class="review-actions">
          <button @click="$emit('edit', review)" class="btn-icon" title="Editar">
            ✏️
          </button>
          <button @click="handleDelete" class="btn-icon btn-delete" title="Eliminar">
            🗑️
          </button>
        </div>
      </div>
    </div>
    <p class="review-content">{{ review.contenido }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import RatingStars from '@/components/common/RatingStars.vue'
import FollowButton from '@/components/profile/FollowButton.vue'

const props = defineProps({
  review: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['edit', 'delete'])

const authStore = useAuthStore()

const isOwnReview = computed(() => {
  return authStore.user && authStore.user.id === props.review.idUsuario
})

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const handleDelete = () => {
  if (confirm('¿Estás seguro de que quieres eliminar esta reseña?')) {
    emit('delete', props.review.id)
  }
}
</script>

<style scoped>
.review-card {
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  padding: 1rem;
  background-color: white;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 0.75rem;
  gap: 1rem;
}

.review-author {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.author-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.author-name {
  color: #2c3e50;
  font-size: 1rem;
  font-weight: bold;
  text-decoration: none;
  transition: color 0.3s;
}

.author-name:hover {
  color: #3498db;
  text-decoration: underline;
}

.review-meta {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-shrink: 0;
}

.review-date {
  color: #95a5a6;
  font-size: 0.85rem;
  white-space: nowrap;
}

.review-actions {
  display: flex;
  gap: 0.5rem;
}

.btn-icon {
  background: none;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 4px;
  transition: background-color 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
}

.btn-icon:hover {
  background-color: #f0f0f0;
}

.btn-delete:hover {
  background-color: #ffe5e5;
}

.review-content {
  color: #34495e;
  margin: 0;
  line-height: 1.6;
  word-wrap: break-word;
}

@media (max-width: 768px) {
  .review-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .review-meta {
    width: 100%;
    justify-content: space-between;
  }
}
</style>
