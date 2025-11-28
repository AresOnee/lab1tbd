<template>
  <div class="background-container">
    <transition-group name="fade" tag="div" class="image-wrapper">
      <div
        v-for="(img, index) in [images[currentImage]]"
        :key="img"
        class="bg-image"
        :style="{ backgroundImage: 'url(' + img + ')' }"
      ></div>
    </transition-group>

    <div class="form-wrapper">
      <v-card elevation="10" rounded="xl" class="pa-8 login-card">
        <v-card-title class="text-center">
          <div class="text-h4 font-weight-bold">Explora Chile</div>
          <div class="text-subtitle-2 mt-1">
            Descubre lugares increíbles cerca de ti
          </div>
        </v-card-title>

        <v-divider class="my-4" />

        <v-alert v-if="authStore.error" type="error" density="compact" class="mb-4">
          {{ authStore.error }}
        </v-alert>

        <v-form @submit.prevent="doLogin" v-model="valid">
          <v-text-field
            v-model="email"
            label="Correo"
            prepend-inner-icon="mdi-email-outline"
            variant="outlined"
            density="comfortable"
            :rules="[rules.required]"
          />

          <v-text-field
            v-model="password"
            label="Contraseña"
            prepend-inner-icon="mdi-lock-outline"
            type="password"
            variant="outlined"
            density="comfortable"
            :rules="[rules.required]"
          />

          <v-btn
            block
            size="large"
            color="blue-darken-2"
            class="mt-4"
            rounded="lg"
            type="submit"
            :loading="authStore.loading"
          >
            Iniciar Sesión
          </v-btn>
        </v-form>

        <div class="text-center mt-4">
          ¿No tienes cuenta?
          <v-btn variant="text" color="blue-darken-2" @click="goRegister">
            Crear cuenta
          </v-btn>
        </div>
      </v-card>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from '@/stores/auth';

// Importación de imágenes
import img1 from "@/assets/carrusel/img1.jpg";
import img2 from "@/assets/carrusel/img2.jpg";
import img3 from "@/assets/carrusel/img3.jpg";
import img4 from "@/assets/carrusel/img4.jpg";

const images = [img1, img2, img3, img4];
const currentImage = ref(0);

setInterval(() => {
  currentImage.value = (currentImage.value + 1) % images.length;
}, 5000);

const router = useRouter();
const authStore = useAuthStore(); // Instancia del store

const email = ref("");
const password = ref("");
const valid = ref(false);

const rules = { required: v => !!v || "Campo obligatorio" };

const doLogin = async () => {
  if (!valid.value) return;

  try {
    await authStore.login({
        email: email.value, 
        password: password.value
    });
    
    // Si no hay error, redirigir
    router.push("/"); 
  } catch (err) {
    console.error("Error en login:", err);
   
  }
};

const goRegister = () => router.push("/register");
</script>

<style scoped>
/* Estilos traídos del Grupo 5 */
.background-container {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
}

.image-wrapper {
  width: 100%;
  height: 100%;
  position: absolute;
  inset: 0;
}

.bg-image {
  position: absolute;
  inset: 0;
  width: 102%;
  height: 102%;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  filter: blur(8px);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 1.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.form-wrapper {
  position: absolute;
  inset: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.login-card {
  width: 100%;
  max-width: 420px;
  background: white;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}
</style>