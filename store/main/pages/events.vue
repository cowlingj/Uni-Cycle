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
import axios from '@nuxtjs/axios'
function fold(strings) {
  return strings.map((str) => str.replace(/\n\s*/g, ' ')).join('')
}

export default {
  data() {
    return {
      data: {
        events: [
          {
            title: 'Placeholder 1',
            description: fold`
          this is a placeholder description for some event taking place`
          },
          {
            title: 'Placeholder1',
            description: fold`
          this is a placeholder description for some event taking place`
          }
        ]
      }
    }
  },
  async asyncData(context) {
    if (process.server) {
      console.log(`HOST: ${context.req.headers.host}`)
      context.beforeNuxtRender(({ nuxtState }) => {
        nuxtState.CMS_EXTERNAL_HOST = context.req.headers.host
      })
    }

    const url = process.server
      ? context.app.$env.CMS_CLUSTER_URL
      : `http://${context.nuxtState.CMS_EXTERNAL_HOST}/cms`

    console.log(`URL: ${url}`)
    console.log(`NUXT STATE: ${JSON.stringify(context.nuxtState)}`)

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
      return { err }
    }
  }
}
</script>
