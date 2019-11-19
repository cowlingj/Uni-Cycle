<template>
  <div class="w-screen h-screen root block bg-light">
    <Header active-page="home" class="z-10" />
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
