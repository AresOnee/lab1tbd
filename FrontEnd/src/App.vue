<script setup>
import { RouterView } from 'vue-router'
</script>

<template>
  <div id="app">
    <RouterView />
  </div>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial,
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  background-color: #f8f9fa;
}

#app {
  min-height: 100vh;
}

a {
  color: #3498db;
  transition: color 0.3s;
}

a:hover {
  color: #2980b9;
}

button {
  font-family: inherit;
}

input,
textarea,
select {
  font-family: inherit;
}
</style>
