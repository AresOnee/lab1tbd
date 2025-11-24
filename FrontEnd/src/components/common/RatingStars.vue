<template>
  <div class="rating-stars">
    <span
      v-for="star in 5"
      :key="star"
      class="star"
      :class="getStarClass(star)"
      @click="editable && setRating(star)"
    >
      ★
    </span>
    <span v-if="showValue" class="rating-value">{{ rating.toFixed(1) }}</span>
  </div>
</template>

<script setup>
const props = defineProps({
  rating: {
    type: Number,
    default: 0
  },
  editable: {
    type: Boolean,
    default: false
  },
  showValue: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['update:rating'])

const getStarClass = (star) => {
  if (star <= props.rating) {
    return 'filled'
  } else if (star - 0.5 <= props.rating) {
    return 'half-filled'
  }
  return 'empty'
}

const setRating = (star) => {
  emit('update:rating', star)
}
</script>

<style scoped>
.rating-stars {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.star {
  font-size: 1.25rem;
  color: #ddd;
  transition: color 0.2s;
}

.star.filled {
  color: #f39c12;
}

.star.half-filled {
  color: #f39c12;
  opacity: 0.5;
}

.star.empty {
  color: #ddd;
}

.rating-stars.editable .star {
  cursor: pointer;
}

.rating-stars.editable .star:hover {
  color: #f39c12;
}

.rating-value {
  margin-left: 0.5rem;
  color: #7f8c8d;
  font-size: 0.9rem;
}
</style>
