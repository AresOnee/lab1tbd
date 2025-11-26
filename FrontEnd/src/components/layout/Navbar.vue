<template>
  <nav class="navbar">
    <div class="navbar-container">
      <div class="navbar-brand">
        <router-link to="/" class="brand-link">
          <h1>TurismoMap</h1>
        </router-link>
      </div>

      <div class="navbar-menu" :class="{ 'is-active': isMenuOpen }">
        <div class="navbar-start">
          <router-link v-if="isAuthenticated" to="/sitios" class="navbar-item">
            Explorar Sitios
          </router-link>
          <router-link v-if="isAuthenticated" to="/sitios/cercanos" class="navbar-item">
            🗺️ Buscar Cercanos
          </router-link>
          <router-link v-if="isAuthenticated" to="/mis-listas" class="navbar-item">
            Mis Listas
          </router-link>
        </div>

        <div class="navbar-end">
          <template v-if="isAuthenticated">
            <router-link to="/perfil" class="navbar-item">
              {{ user?.nombre || 'Mi Perfil' }}
            </router-link>
            <button @click="handleLogout" class="navbar-item btn-logout">
              Cerrar Sesión
            </button>
          </template>
          <template v-else>
            <router-link to="/login" class="navbar-item btn-primary">
              Iniciar Sesión
            </router-link>
          </template>
        </div>
      </div>

      <button class="navbar-burger" @click="toggleMenu">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </div>
  </nav>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const router = useRouter()
const isMenuOpen = ref(false)

const isAuthenticated = computed(() => authStore.isAuthenticated)
const user = computed(() => authStore.user)

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}

const handleLogout = () => {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.navbar {
  background-color: #2c3e50;
  color: white;
  padding: 1rem 0;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.navbar-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.navbar-brand h1 {
  margin: 0;
  font-size: 1.5rem;
  color: #3498db;
}

.brand-link {
  text-decoration: none;
}

.navbar-menu {
  display: flex;
  align-items: center;
  gap: 2rem;
  flex: 1;
  justify-content: space-between;
  margin-left: 2rem;
}

.navbar-start,
.navbar-end {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.navbar-item {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background-color 0.3s;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1rem;
}

.navbar-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.btn-primary {
  background-color: #3498db;
  color: white;
}

.btn-primary:hover {
  background-color: #2980b9;
}

.btn-logout {
  background-color: #e74c3c;
}

.btn-logout:hover {
  background-color: #c0392b;
}

.navbar-burger {
  display: none;
  flex-direction: column;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
}

.navbar-burger span {
  display: block;
  width: 25px;
  height: 3px;
  background-color: white;
  margin: 3px 0;
  transition: 0.3s;
}

@media (max-width: 768px) {
  .navbar-burger {
    display: flex;
  }

  .navbar-menu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background-color: #2c3e50;
    flex-direction: column;
    padding: 1rem;
    gap: 0.5rem;
  }

  .navbar-menu.is-active {
    display: flex;
  }

  .navbar-start,
  .navbar-end {
    flex-direction: column;
    width: 100%;
  }

  .navbar-item {
    width: 100%;
    text-align: center;
  }
}
</style>
