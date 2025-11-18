<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue';

const preventF12 = (event) => {
  if (event.key === 'F12') {
    event.preventDefault();
  }
};

const preventRightClick = (event) => {
  event.preventDefault();
};

onMounted(() => {
  window.addEventListener('keydown', preventF12);
  window.addEventListener('contextmenu', preventRightClick);
});

onUnmounted(() => {
  window.removeEventListener('keydown', preventF12);
  window.removeEventListener('contextmenu', preventRightClick);
});
</script>

<template>
  <div class="app-container">
    <router-view></router-view>
  </div>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  height: 100%;
  width: 100%;
  overflow: hidden;
}

.app-container {
  width: 100vw;
  height: 100vh;
  overflow: auto;
}
</style>
