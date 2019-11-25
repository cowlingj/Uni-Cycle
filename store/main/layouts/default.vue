<template>
  <div class="w-screen h-screen max-w-full root bg-bg">
    <Header active-page="home" class="z-10" />
    <nuxt class="bg-bg" />
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
.root {
  display: grid;
  grid-template-rows: max-content 1fr;
}
</style>
