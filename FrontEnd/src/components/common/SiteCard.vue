<template>
  <div class="site-card" @click="goToSite">
    <div class="site-image">
      <img v-if="site.foto" :src="site.foto" :alt="site.nombre" />
      <div v-else class="no-image">Sin imagen</div>
      <span class="site-type">{{ site.tipo }}</span>
    </div>
    <div class="site-content">
      <h3 class="site-name">{{ site.nombre }}</h3>
      <p class="site-description">{{ truncateDescription(site.descripcion) }}</p>
      <div class="site-footer">
        <RatingStars :rating="site.calificacionPromedio || 0" />
        <span class="reviews-count">
          {{ site.totalResenas || 0 }} reseñas
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import RatingStars from './RatingStars.vue'

const props = defineProps({
  site: {
    type: Object,
    required: true
  }
})

const router = useRouter()

const truncateDescription = (text) => {
  if (!text) return ''
  return text.length > 100 ? text.substring(0, 100) + '...' : text
}

const goToSite = () => {
  router.push(`/sitios/${props.site.id}`)
}
</script>

<style scoped>
.site-card {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.3s, box-shadow 0.3s;
  background-color: white;
}

.site-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.site-image {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
}

.site-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #ecf0f1;
  color: #7f8c8d;
}

.site-type {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: rgba(52, 152, 219, 0.9);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.85rem;
}

.site-content {
  padding: 1rem;
}

.site-name {
  margin: 0 0 0.5rem 0;
  font-size: 1.25rem;
  color: #2c3e50;
}

.site-description {
  color: #7f8c8d;
  margin: 0 0 1rem 0;
  font-size: 0.9rem;
  line-height: 1.4;
}

.site-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.reviews-count {
  color: #95a5a6;
  font-size: 0.9rem;
}
</style>
