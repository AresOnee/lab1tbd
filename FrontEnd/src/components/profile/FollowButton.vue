<template>
  <div class="follow-button-container">
    <button
      @click="toggleFollow"
      :disabled="loading"
      :class="['follow-button', isFollowing ? 'following' : 'not-following']"
    >
      <span v-if="!loading">
        {{ isFollowing ? '✓ Siguiendo' : '+ Seguir' }}
      </span>
      <span v-else>⏳</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { followersService } from '@/services/followersService'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

const emit = defineEmits(['follow-changed'])

const isFollowing = ref(false)
const loading = ref(false)

const loadFollowStatus = async () => {
  try {
    isFollowing.value = await followersService.isFollowing(props.userId)
  } catch (error) {
    console.error('Error al verificar estado de seguimiento:', error)
  }
}

const toggleFollow = async () => {
  loading.value = true

  try {
    if (isFollowing.value) {
      await followersService.unfollow(props.userId)
      isFollowing.value = false
    } else {
      await followersService.follow(props.userId)
      isFollowing.value = true
    }

    emit('follow-changed', isFollowing.value)
  } catch (error) {
    alert(error.response?.data?.message || 'Error al actualizar seguimiento')
    console.error('Error al cambiar seguimiento:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadFollowStatus()
})
</script>

<style scoped>
.follow-button-container {
  display: inline-block;
}

.follow-button {
  padding: 0.6rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  min-width: 120px;
}

.follow-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.not-following {
  background: #3498db;
  color: white;
}

.not-following:hover:not(:disabled) {
  background: #2980b9;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
}

.following {
  background: #27ae60;
  color: white;
}

.following:hover:not(:disabled) {
  background: #e74c3c;
  transform: translateY(-2px);
}

.following:hover:not(:disabled)::before {
  content: 'Dejar de seguir';
  position: absolute;
}

.following:hover:not(:disabled) span {
  opacity: 0;
}
</style>
