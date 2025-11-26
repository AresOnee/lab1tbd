import { defineStore } from 'pinia'
import { ref } from 'vue'
import { reviewsService } from '@/services/reviewsService'

export const useReviewsStore = defineStore('reviews', () => {
  const reviews = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchBySiteId(siteId) {
    loading.value = true
    error.value = null
    try {
      reviews.value = await reviewsService.getBySiteId(siteId)
      return reviews.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar reseñas'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchByUserId(userId) {
    loading.value = true
    error.value = null
    try {
      reviews.value = await reviewsService.getByUserId(userId)
      return reviews.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar reseñas'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function createReview(reviewData) {
    loading.value = true
    error.value = null
    try {
      const newReviewId = await reviewsService.create(reviewData)
      // El backend devuelve solo el ID, no el objeto completo
      // La lista se recarga desde el componente con fetchBySiteId
      return newReviewId
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al crear reseña'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function updateReview(id, reviewData) {
    loading.value = true
    error.value = null
    try {
      await reviewsService.update(id, reviewData)
      // El backend devuelve 204 No Content (sin body)
      // La lista se recarga desde el componente con fetchBySiteId
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al actualizar reseña'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deleteReview(id) {
    loading.value = true
    error.value = null
    try {
      await reviewsService.delete(id)
      reviews.value = reviews.value.filter(r => r.id !== id)
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al eliminar reseña'
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    reviews,
    loading,
    error,
    fetchBySiteId,
    fetchByUserId,
    createReview,
    updateReview,
    deleteReview
  }
})
