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
      const newReview = await reviewsService.create(reviewData)
      reviews.value.unshift(newReview)
      return newReview
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
      const updatedReview = await reviewsService.update(id, reviewData)
      const index = reviews.value.findIndex(r => r.id === id)
      if (index !== -1) {
        reviews.value[index] = updatedReview
      }
      return updatedReview
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
