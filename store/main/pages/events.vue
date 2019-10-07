<template>
  <div class="w-screen h-screen main">
    <header class="flex items-center justify-between flex-no-wrap p-6">
      <h1 class="text-xl">Uni-Cycle</h1>
      <nav class="flex items-center justify-between flex-wrap">
        <a class="mr-6 active">Home</a>
        <a class="mr-6">Events</a>
      </nav>
    </header>
    <article id="events-list">
      <section v-for="(event, index) in data.events" :key="index">
        <h1>{{ event.title }}</h1>
        <p>{{ event.description }}</p>
      </section>
    </article>
  </div>
</template>

<script>
function fold(strings) {
  return strings.map((str) => str.replace(/\n\s*/g, ' ')).join('')
}

export default {
  data() {
    return {
      data: {
        events: [
          {
            title: 'Placeholder',
            description: fold`
          this is a placeholder description for some event taking place
          it should even turn multi lne strings into single strings`
          }
        ]
      }
    }
  }
}
</script>
