<template>
  <article class="flex justify-center">
    <section v-if="err" id="error-message">
      <p>Sorry, there's a problem getting events, please try later</p>
    </section>
    <section id="events-list" v-else>
      <div
        v-for="(event, index) in data.events"
        :key="index"
        class="shadow-lg overflow-hidden w-4/5 p-4 event"
      >
        <h1 class="text-xl leading-loose">{{ event.title }}</h1>
        <p class="text-base">{{ event.description }}</p>
      </div>
    </section>
  </article>
</template>

<script>
import axios from 'axios'
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
  },
  async asyncData(context) {
    try {
      const res = await axios.get(`${context.app.$env.CMS_URL}/graphql`, {
        params: { query: '{ events { title, description } }' }
      })

      return {
        err: null,
        data: {
          events: res.data.data.events
        }
      }
    } catch (err) {
      return { err }
    }
  }
}
</script>
