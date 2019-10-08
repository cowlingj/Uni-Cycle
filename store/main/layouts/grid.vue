<template>
  <div class="w-screen h-screen root">
    <Header active-page="home" />
    <nuxt />
  </div>
</template>

<script>
import Header from '@/components/header'

export default {
  components: {
    Header
  }
}
</script>

<style scoped>
html {
  -ms-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
}

.root {
  display: grid;
  grid-template-rows: max-content 1fr;
}
</style>
