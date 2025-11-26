<template>
  <div class="photo-card">
    <div class="photo-wrapper">
      <img :src="photo.url" :alt="photo.nombreUsuario" class="photo-image" />
      <button
        v-if="isOwnPhoto"
        @click="handleDelete"
        class="btn-delete"
        title="Eliminar foto"
      >
        🗑️
      </button>
    </div>
    <div class="photo-info">
      <span class="photo-author">📸 {{ photo.nombreUsuario }}</span>
      <span class="photo-date">{{ formatDate(photo.fecha) }}</span>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'

const props = defineProps({
  photo: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['delete'])

const authStore = useAuthStore()

const isOwnPhoto = computed(() => {
  return authStore.user && authStore.user.id === props.photo.idUsuario
})

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const handleDelete = () => {
  if (confirm('¿Estás seguro de que quieres eliminar esta fotografía?')) {
    emit('delete', props.photo.id)
  }
}
</script>

<style scoped>
.photo-card {
  display: flex;
  flex-direction: column;
  border-radius: 8px;
  overflow: hidden;
  background-color: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.photo-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.photo-wrapper {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  background-color: #f5f5f5;
}

.photo-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.btn-delete {
  position: absolute;
  top: 8px;
  right: 8px;
  background-color: rgba(255, 255, 255, 0.95);
  border: none;
  border-radius: 50%;
  width: 36px;
  height: 36px;
  font-size: 1.2rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  transition: all 0.3s;
  opacity: 0;
}

.photo-wrapper:hover .btn-delete {
  opacity: 1;
}

.btn-delete:hover {
  background-color: #fee;
  transform: scale(1.1);
}

.photo-info {
  padding: 0.75rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.5rem;
}

.photo-author {
  font-weight: 500;
  color: #2c3e50;
  font-size: 0.9rem;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.photo-date {
  color: #95a5a6;
  font-size: 0.85rem;
  white-space: nowrap;
}

@media (max-width: 768px) {
  .photo-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.25rem;
  }
}
</style>
