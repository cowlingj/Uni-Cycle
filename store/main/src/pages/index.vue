<template>
  <article class="relative z-0 h-full w-full overflow-y-auto">
    <section class="h-full">
      <div class="h-1/2 empty" />
      <div class="w-full flex justify-center">
        <h2 class="text-3xl font-brand font-swap text-center text-fg">
          Choose to re-use with Uni-Cycle
        </h2>
      </div>
    </section>
    <section
      v-if="nextEvent"
      class="h-full flex flex-col content-center items-center justify-center z-10"
    >
      <div
        class="max-w-4/5 min-h-1/2 lg:max-w-1/2 bg-bg_mid rounded shadow p-2"
      >
        <p class="text-3xl">Join us at our next event!</p>
        <p class="leading-loose text-2xl">{{ nextEvent.title }}</p>
        <div class="flex flex-row items-start">
          <DescriptionIcon fill="var(--color-fg)" class="flex-0 mr-4" />
          <h2 class="text-lg flex-1 self-center">
            {{ nextEvent.description }}
          </h2>
        </div>
        <div class="flex flex-row items-start">
          <LocationIcon fill="var(--color-fg)" class="flex-0 mr-4" />
          <h2 class="text-lg flex-1 self-center">
            {{ nextEvent.location }}
          </h2>
        </div>
        <div class="flex flex-row items-start relativeTime">
          <ClockIcon fill="var(--color-fg)" class="flex-0 mr-4" />
          <h2 class="text-lg flex-1 self-center">
            {{ relativeTime }}
          </h2>
        </div>
        <div class="flex flex-row items-start">
          <CalendarIcon fill="var(--color-fg)" class="flex-0 mr-4" />
          <a :href="nextEvent.ical" class="underline cursor-pointer text-lg"
            >add to calendar</a
          >
        </div>
      </div>
    </section>
    <section class="h-full">
      <p>values</p>
    </section>
  </article>
</template>

<style scoped>
article::after {
  content: '';
  background: url('~assets/img/splash.svg');
  background-size: auto 100%;
  background-repeat: no-repeat;
  background-position: right;
  background-attachment: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  position: fixed;
  z-index: -1;
  opacity: 0.5;
}
</style>

<script>
import moment from 'moment'
import eventQuery from './next-event.gql'
import ClockIcon from '@/assets/img/ic_clock.svg?inline'
import DescriptionIcon from '@/assets/img/ic_description.svg?inline'
import LocationIcon from '@/assets/img/ic_map-pin.svg?inline'
import CalendarIcon from '@/assets/img/ic_calendar.svg?inline'

export default {
  components: {
    ClockIcon,
    DescriptionIcon,
    LocationIcon,
    CalendarIcon
  },
  data: () => ({ nextEvent: null }),
  computed: {
    relativeTime() {
      if (new Date(this.nextEvent.start).getTime() < Date.now()) {
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
