<template>
  <article class="relative">
    <img
      src="~assets/img/splash.svg"
      aria-hidden="true"
      class="h-full object-cover object-left opacity-50 top-0 right-0 w-3/4 lg:w-1/2 xl:w-1/4 fixed z-0"
    />
    <section class="h-full">
      <div class="h-1/2 empty" />
      <div class="w-full flex justify-center">
        <h2 class="text-3xl font-brand font-swap text-center text-fg">
          Choose to re-use with Uni-Cycle
        </h2>
      </div>
    </section>
    <section v-if="nextEvent" class="h-full">
      <p>{{ nextEvent.title }}</p>
      <p>{{ nextEvent.description }}</p>
      <p>{{ nextEvent.location }}</p>
      <p>{{ relativeTime }}</p>
      <a :href="nextEvent.ical" class="underline cursor-pointer"
        >add to calendar</a
      >
    </section>
    <section class="h-full">
      <p>values</p>
    </section>
  </article>
</template>

<script>
import moment from 'moment'
import eventQuery from './next-event.gql'

export default {
  data: () => ({ nextEvent: null }),
  computed: {
    relativeTime() {
      if (new Date(this.nextEvent.start) < Date.now()) {
        return 'now'
      }
      return moment(this.nextEvent.start).fromNow()
    }
  },
  apollo: {
    $client: 'cms',
    nextEvent: {
      query: eventQuery,
      update: (data) => {
        if (!data.allEvents || data.allEvents.length < 1) {
          return null
        }
        return data.allEvents[0]
      },
      error(err, vm) {
        vm.err = err
      },
      variables: {
        date: new Date().toISOString()
      }
    }
  }
}
</script>
