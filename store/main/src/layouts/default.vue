<template>
  <div
    class="root h-screen w-full min-h-screen bg-bg_bot grid grid-columns-1 grid-rows-2"
  >
    <Header
      active-page="home"
      class="row-start-1 row-end-2 col-start-1 col-end-2 z-10"
    />
    <nuxt
      class="w-full bg-bg_bot row-start-2 row-end-3 col-start-1 col-end-2 overflow-y-auto"
    />
  </div>
</template>
<style scoped>
.root {
  grid-template-rows: max-content 1fr;
}
</style>
<script>
import Header from '@/components/header'

export default {
  components: {
    Header
  },
  created() {
    this.$updateLocale()
  }
}
</script>
