<template>
  <div v-if="message" class="success-message">
    <span class="success-icon">✓</span>
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
.success-message {
  background-color: #d4edda;
  border: 1px solid #c3e6cb;
  border-radius: 4px;
  padding: 1rem;
  margin: 1rem 0;
  display: flex;
  align-items: center;
  gap: 1rem;
  color: #155724;
}

.success-icon {
  font-size: 1.5rem;
  font-weight: bold;
}

.success-message p {
  flex: 1;
  margin: 0;
}

.dismiss-btn {
  background: none;
  border: none;
  font-size: 1.25rem;
  cursor: pointer;
  color: #155724;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.dismiss-btn:hover {
  background-color: rgba(21, 87, 36, 0.1);
  border-radius: 50%;
}
</style>
