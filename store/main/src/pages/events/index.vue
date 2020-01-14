<template>
  <article class="h-full w-full">
    <section
      id="error-message"
      v-if="err"
      class="h-full w-full flex flex-col items-center justify-center"
    >
      <p class="text-center font-brand font-swap text-3xl text-fg">
        Sorry, there's a problem getting events
      </p>
      <p class="text-center font-brand font-swap text-3xl text-fg">
        please try later
      </p>
      <!-- TODO: Go Back -->
    </section>
    <section
      id="no-events"
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
      id="events-list"
      v-else
      class="overflow-y-auto overflow-x-hidden h-full w-full flex flex-col items-center"
    >
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
import eventsList from './events-list.gql'
import Event from '@/components/event-card'

export default {
  components: {
    Event
  },
  data() {
    return {
      err: null,
      data: {
        events: []
      }
    }
  },
  async asyncData(context) {
    try {
      const res = await context.app.apolloProvider.clients.cms.query({
        query: eventsList
      })

      return {
        data: {
          events: res.data.allEvents
        }
      }
    } catch (err) {
      return {
        err
      }
    }
  }
}
</script>
