import { createRouter, createWebHistory } from 'vue-router'
import { authService } from '@/services/authService'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/views/HomeView.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/LoginView.vue'),
      meta: { requiresGuest: true }
    },
    {
      path: '/sitios',
      name: 'sites-list',
      component: () => import('@/views/SitesListView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/sitios/cercanos',
      name: 'nearby-sites',
      component: () => import('@/views/NearbySitesView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/sitios/crear',
      name: 'site-create',
      component: () => import('@/views/SiteFormView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/sitios/:id',
      name: 'site-detail',
      component: () => import('@/views/SiteDetailView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/sitios/:id/editar',
      name: 'site-edit',
      component: () => import('@/views/SiteFormView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/perfil',
      name: 'profile',
      component: () => import('@/views/ProfileView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/perfil/:id/seguidores',
      name: 'followers',
      component: () => import('@/views/FollowersView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/mis-listas',
      name: 'lists',
      component: () => import('@/views/ListsView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/mis-listas/:id',
      name: 'list-detail',
      component: () => import('@/views/ListDetailView.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/estadisticas',
      name: 'statistics',
      component: () => import('@/views/StatisticsView.vue'),
      meta: { requiresAuth: true }
    }
  ]
})

// Navigation guards
router.beforeEach((to, from, next) => {
  const isAuthenticated = authService.isAuthenticated()

  // Rutas que requieren autenticación
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ name: 'login' })
  }
  // Rutas solo para invitados (login/register)
  else if (to.meta.requiresGuest && isAuthenticated) {
    next({ name: 'home' })
  }
  else {
    next()
  }
})

export default router
