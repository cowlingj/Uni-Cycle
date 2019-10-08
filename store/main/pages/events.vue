<template>
  <article id="events-list" class="flex justify-center">
    <section
      v-for="(event, index) in data.events"
      :key="index"
      class="shadow-lg overflow-hidden w-4/5 p-4"
    >
      <h1 class="text-xl leading-loose">{{ event.title }}</h1>
      <p class="text-base">{{ event.description }}</p>
    </section>
  </article>
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
          this is a placeholder description for some event taking place`
          }
        ]
      }
    }
  }
}
</script>
