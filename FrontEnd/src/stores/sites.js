import { defineStore } from 'pinia'
import { ref } from 'vue'
import { sitesService } from '@/services/sitesService'

export const useSitesStore = defineStore('sites', () => {
  const sites = ref([])
  const currentSite = ref(null)
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = {}) {
    loading.value = true
    error.value = null
    try {
      sites.value = await sitesService.getAll(params)
      return sites.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar sitios'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id) {
    loading.value = true
    error.value = null
    try {
      currentSite.value = await sitesService.getById(id)
      return currentSite.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar sitio'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function createSite(siteData) {
    loading.value = true
    error.value = null
    try {
      const newSiteId = await sitesService.create(siteData)
      // Backend returns only ID, not full object
      // Component should reload the list after creation
      return newSiteId
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al crear sitio'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function updateSite(id, siteData) {
    loading.value = true
    error.value = null
    try {
      const updatedSite = await sitesService.update(id, siteData)
      const index = sites.value.findIndex(s => s.id === id)
      if (index !== -1) {
        sites.value[index] = updatedSite
      }
      return updatedSite
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al actualizar sitio'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deleteSite(id) {
    loading.value = true
    error.value = null
    try {
      await sitesService.delete(id)
      sites.value = sites.value.filter(s => s.id !== id)
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al eliminar sitio'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function searchByType(type) {
    loading.value = true
    error.value = null
    try {
      sites.value = await sitesService.searchByType(type)
      return sites.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al buscar sitios'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchPopular() {
    loading.value = true
    error.value = null
    try {
      const popularSites = await sitesService.getPopularSites()
      return popularSites
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar sitios populares'
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    sites,
    currentSite,
    loading,
    error,
    fetchAll,
    fetchById,
    createSite,
    updateSite,
    deleteSite,
    searchByType,
    fetchPopular
  }
})
