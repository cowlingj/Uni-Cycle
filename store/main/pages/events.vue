<template>
  <article class="h-full w-full">
    <section v-if="err" id="error-message" class="w-4/5">
      <p class="text-center">
        Sorry, there's a problem getting events, please try later
      </p>
    </section>
    <section
      v-else-if="data.events.length == 0"
      class="overflow-hidden h-full w-full flex flex-col items-center"
    >
      <div class="flex-1" aria-hidden="true"></div>
      <h1 class="text-3xl text-center text-fg">Nothing to see here...</h1>
      <div class="flex-1" aria-hidden="true"></div>
      <p class="text-center text-fg">There are no events right now</p>
      <p class="text-center text-fg">please check back later</p>
      <img
        src="~assets/img/benjamin.svg"
        class="object-contain object-right-bottom self-end flex-3"
      />
    </section>
    <section v-else id="events-list" class="w-4/5 overflow-y-scroll">
      <div
        v-for="(event, index) in data.events"
        :key="index"
        class="shadow-lg overflow-hidden p-4 event"
      >
        <h1 class="text-3xl leading-loose">{{ event.title }}</h1>
        <p class="text-base">{{ event.description }}</p>
      </div>
    </section>
  </article>
</template>

<style scoped>
h1 {
  font-family: 'Caviar Dreams';
}

.flex-3 {
  flex: 3 0.3 0;
}
</style>

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
      // TODO: only in dev mode
      // eslint-disable-next-line
      console.log(err)
      return { err }
    }
  }
}
</script>
