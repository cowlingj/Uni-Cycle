<template>
  <article class="h-full w-full">
    <section
      v-if="err"
      id="error-message"
      class="h-full w-full flex flex-col items-center justify-center"
    >
      <p class="text-center font-brand text-3xl text-fg">
        Sorry, there's a problem getting events
      </p>
      <p class="text-center font-brand text-3xl text-fg">
        please try later
      </p>
      <!-- TODO: Go Back -->
    </section>
    <section
      v-else-if="data.events.length == 0"
      class="overflow-hidden h-full w-full flex flex-col items-center"
    >
      <div class="flex-1" aria-hidden="true"></div>
      <h1 class="text-3xl text-center text-fg text-brand">
        Nothing to see here...
      </h1>
      <div class="flex-1" aria-hidden="true"></div>
      <p class="text-center text-fg">There are no events right now</p>
      <p class="text-center text-fg">please check back later</p>
      <img
        src="~assets/img/benjamin.svg"
        class="object-contain object-right-bottom self-end flex-3"
      />
    </section>
    <section
      v-else
      id="events-list"
      class="overflow-y-auto overflow-x-hidden h-full w-full flex flex-col items-center"
    >
      <!-- TODO: make more card like? -->

      <Event
        v-for="(event, index) in data.events"
        :key="index"
        :title="event.title"
        :description="event.description"
        :location="event.location"
        :start="event.start"
        :end="event.end"
        :ical="event.ical"
      />
    </section>
  </article>
</template>

<style scoped>
.flex-3 {
  flex: 3 0.3 0;
}
</style>

<script>
import axios from 'axios'
import Event from '@/components/event-card'

export default {
  components: {
    Event
  },
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
      const res = await axios.get(`${url}`, {
        params: { query: '{ allEvents { start, end, title, description, location, ical } }' }
      })

      return {
        err: null,
        data: {
          events: res.data.data.allEvents
        }
      }
    } catch (err) {
      /* istanbul ignore next */
      if (process.server || context.app.$env.NODE_ENV === 'development') {
        /* eslint-disable-next-line */
        console.log(err)
      }
      return {
        err: null,
        data: {
          events: [
            {
              title: 'christmas market',
              description: 'come to the market were running',
              location: 'picadilly gardens',
              start: '2020-01-01 12:24:24',
              end: '2020-01-02 12:24:24',
              ical: 'http://www.example.com'
            },
            {
              title: 'christmas market',
              description: 'come to the market were running',
              location: 'picadilly gardens',
              start: '2020-01-01 12:24:24',
              end: '2020-01-02 12:24:24',
              ical: 'http://www.example.com'
            }
          ]
        }
      }
    }
  }
}
</script>
