import { defineStore } from 'pinia'
import { ref } from 'vue'
import { listsService } from '@/services/listsService'

export const useListsStore = defineStore('lists', () => {
  const lists = ref([])
  const currentList = ref(null)
  const loading = ref(false)
  const error = ref(null)

  async function fetchByUserId(userId) {
    loading.value = true
    error.value = null
    try {
      lists.value = await listsService.getByUserId(userId)
      return lists.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar listas'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id) {
    loading.value = true
    error.value = null
    try {
      currentList.value = await listsService.getById(id)
      return currentList.value
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al cargar lista'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function createList(listData) {
    loading.value = true
    error.value = null
    try {
      const newList = await listsService.create(listData)
      lists.value.push(newList)
      return newList
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al crear lista'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function updateList(id, listData) {
    loading.value = true
    error.value = null
    try {
      const updatedList = await listsService.update(id, listData)
      const index = lists.value.findIndex(l => l.id === id)
      if (index !== -1) {
        lists.value[index] = updatedList
      }
      return updatedList
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al actualizar lista'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deleteList(id) {
    loading.value = true
    error.value = null
    try {
      await listsService.delete(id)
      lists.value = lists.value.filter(l => l.id !== id)
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al eliminar lista'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function addSiteToList(listId, siteId) {
    loading.value = true
    error.value = null
    try {
      await listsService.addSite(listId, siteId)
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al agregar sitio a la lista'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function removeSiteFromList(listId, siteId) {
    loading.value = true
    error.value = null
    try {
      await listsService.removeSite(listId, siteId)
    } catch (err) {
      error.value = err.response?.data?.message || 'Error al eliminar sitio de la lista'
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    lists,
    currentList,
    loading,
    error,
    fetchByUserId,
    fetchById,
    createList,
    updateList,
    deleteList,
    addSiteToList,
    removeSiteFromList
  }
})
