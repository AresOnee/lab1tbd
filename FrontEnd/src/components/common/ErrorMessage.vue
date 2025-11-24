<template>
  <div v-if="message" class="error-message">
    <span class="error-icon">⚠️</span>
    <p>{{ message }}</p>
    <button v-if="dismissible" @click="$emit('dismiss')" class="dismiss-btn">
      ✕
    </button>
  </div>
</template>

<script setup>
defineProps({
  message: {
    type: String,
    default: ''
  },
  dismissible: {
    type: Boolean,
    default: true
  }
})

defineEmits(['dismiss'])
</script>

<style scoped>
.error-message {
  background-color: #fee;
  border: 1px solid #fcc;
  border-radius: 4px;
  padding: 1rem;
  margin: 1rem 0;
  display: flex;
  align-items: center;
  gap: 1rem;
  color: #c33;
}

.error-icon {
  font-size: 1.5rem;
}

.error-message p {
  flex: 1;
  margin: 0;
}

.dismiss-btn {
  background: none;
  border: none;
  font-size: 1.25rem;
  cursor: pointer;
  color: #c33;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.dismiss-btn:hover {
  background-color: rgba(204, 51, 51, 0.1);
  border-radius: 50%;
}
</style>
