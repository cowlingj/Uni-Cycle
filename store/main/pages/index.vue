<template>
  <article class="overflow-hidden relative flex">
    <img
      class="object-contain max-h-full m-auto justify-center"
      src="https://via.placeholder.com/1000x600.png"
    />
    <div class="m-auto min-w-full tagline">
      <h2 class="text-3xl text-center">Choose to re-use with Uni-Cycle</h2>
    </div>
  </article>
</template>

<script>
export default {
  layout: 'grid'
}
</script>

<style>
.tagline {
  position: absolute;
  bottom: 33%;
  display: flex;
  justify-content: center;
}
</style>
