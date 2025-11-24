import { defineStore } from 'pinia'
import { ref } from 'vue'
import { photosService } from '@/services/photosService'

export const usePhotosStore = defineStore('photos', () => {
  const photos = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchBySiteId(siteId) {
    loading.value = true
    error.value = null
    try {
      photos.value = await photosService.getBySiteId(siteId)
      return photos.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar fotografías'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchByUserId(userId) {
    loading.value = true
    error.value = null
    try {
      photos.value = await photosService.getByUserId(userId)
      return photos.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar fotografías'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function uploadPhoto(photoData) {
    loading.value = true
    error.value = null
    try {
      const newPhoto = await photosService.upload(photoData)
      photos.value.unshift(newPhoto)
      return newPhoto
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al subir fotografía'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deletePhoto(id) {
    loading.value = true
    error.value = null
    try {
      await photosService.delete(id)
      photos.value = photos.value.filter(p => p.id !== id)
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al eliminar fotografía'
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    photos,
    loading,
    error,
    fetchBySiteId,
    fetchByUserId,
    uploadPhoto,
    deletePhoto
  }
})
