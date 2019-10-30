<template>
  <article class="flex justify-center">
    <section v-if="err" id="error-message" class="w-4/5">
      <p class="text-center">
        Sorry, there's a problem getting events, please try later
      </p>
    </section>
    <section v-else id="events-list" class="w-4/5">
      <div
        v-for="(event, index) in data.events"
        :key="index"
        class="shadow-lg overflow-hidden p-4 event"
      >
        <h1 class="text-xl leading-loose">{{ event.title }}</h1>
        <p class="text-base">{{ event.description }}</p>
      </div>
    </section>
  </article>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      data: {
        events: []
      }
    }
  },
  async asyncData(context) {
    const url = context.app.$getCmsUrl()

    try {
      const res = await axios.get(`${url}/graphql`, {
        params: { query: '{ events { title, description } }' }
      })

      return {
        err: null,
        data: {
          events: res.data.data.events
        }
      }
    } catch (err) {
      // todo: only in dev mode
      console.log(err)
      return { err }
    }
  }
}
</script>
