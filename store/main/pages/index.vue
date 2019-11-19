<template>
  <article class="relative">
    <div
      class="max-h-screen h-full top-0 right-0 w-3/4 lg:w-1/2 absolute overflow-hidden z-0"
    >
      <img
        src="~assets/img/splash.svg"
        class="h-full w-full object-cover object-left splash relative"
      />
    </div>
    <div class="w-full tagline absolute bottom-1/3 z-10">
      <h2 class="text-3xl text-center">Choose to re-use with Uni-Cycle</h2>
    </div>
  </article>
</template>

<script>
export default {
  layout: 'grid'
}
</script>

<style scoped>
.tagline {
  display: flex;
  justify-content: center;
}

.tagline h2 {
  font-family: 'Caviar Dreams';
}

.splash {
  right: -50%;
  filter: opacity(50%);
}
</style>
