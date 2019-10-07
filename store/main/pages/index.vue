<template>
  <div class="w-screen h-screen main">
    <header class="flex items-center justify-between flex-no-wrap p-6">
      <h1 class="text-xl">Uni-Cycle</h1>
      <nav class="flex items-center justify-between flex-wrap">
        <a class="mr-6 active">Home</a>
        <a class="mr-6">Events</a>
      </nav>
    </header>
    <article class="overflow-hidden relative flex">
      <img
        class="object-contain max-h-full m-auto justify-center"
        src="https://via.placeholder.com/1000x600.png"
      />
      <div class="m-auto min-w-full tagline">
        <h2 class="text-3xl text-center">Choose to re-use with Uni-Cycle</h2>
      </div>
    </article>
  </div>
</template>

<script>
export default {}
</script>

<style>
.tagline {
  position: absolute;
  bottom: 33%;
  display: flex;
  justify-content: center;
}

.main {
  display: grid;
  grid-template-rows: max-content 1fr;
}
</style>
