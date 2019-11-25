<template>
  <article class="relative">
    <img
      src="~assets/img/splash.svg"
      class="h-full object-cover object-left splash top-0 right-0 w-3/4 lg:w-1/2 xl:w-1/4 absolute z-0"
    />
    <div class="w-full tagline absolute bottom-1/3 z-10">
      <h2 class="text-3xl text-center text-fg">
        Choose to re-use with Uni-Cycle
      </h2>
    </div>
  </article>
</template>

<script>
export default {}
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
  filter: opacity(50%);
}
</style>
