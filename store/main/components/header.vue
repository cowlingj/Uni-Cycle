<template>
  <header class="flex items-center justify-between flex-no-wrap p-6">
    <h1 class="text-xl">Uni-Cycle</h1>
    <nav id="nav" class="flex items-center justify-between flex-wrap">
      <nuxt-link exact replace to="/" class="mr-6">Home</nuxt-link>
      <nuxt-link exact replace to="/events" class="mr-6">Events</nuxt-link>
    </nav>
  </header>
</template>

<script>
export default {}
</script>

<style scoped>
nav * {
  @apply text-gray-600;
}

nav .nuxt-link-exact-active {
  @apply text-black;
}

nav *:hover {
  @apply text-gray-800;
}

nav *:active {
  @apply text-black;
}
</style>
