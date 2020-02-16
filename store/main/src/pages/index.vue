<template>
  <article class="relative z-0 h-full w-full overflow-y-auto">
    <section class="h-full w-full splash">
      <div class="h-1/2 empty" />
      <div class="w-full flex justify-center">
        <h2 class="text-3xl font-brand font-swap text-center text-fg">
          Choose to re-use with Uni-Cycle
        </h2>
      </div>
    </section>
    <section
      v-if="nextEvent"
      class="min-h-full flex flex-col content-center items-center justify-center z-10"
    >
      <h2 class="text-3xl leading-loose text-center">
        Join us at our next event!
      </h2>
      <div
        class="max-w-4/5 min-h-1/2 lg:max-w-1/2 bg-bg_mid rounded shadow p-2"
      >
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
    <section v-if="values" class="min-h-full">
      <h2 class="text-3xl w-full text-center leading-loose">Our Values</h2>
      <pre class="font-sans w-4/5 m-auto whitespace-pre-wrap">{{ values }}</pre>
    </section>
  </article>
</template>

<style scoped>
article::before {
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

.splash::before {
  content: '';
  background: linear-gradient(
      rgba(199, 223, 224, 0.8),
      rgba(199, 223, 224, 0.8)
    ),
    url('~assets/img/img_splash.jpg');
  background-size: auto;
  background-repeat: no-repeat;
  background-position: center;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  position: absolute;
  z-index: -1;
  opacity: 1;
}

@media (prefers-color-scheme: dark) {
  .splash::before {
    background: linear-gradient(
        rgba(128, 139, 139, 0.8),
        rgba(128, 139, 139, 0.8)
      ),
      url('~assets/img/img_splash.jpg');
    background-size: auto;
    background-repeat: no-repeat;
    background-position: center;
  }
}
</style>

<script>
import moment from 'moment'
import eventQuery from './next-event.gql'
import valuesQuery from './values.gql'
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
  data() {
    return {
      nextEvent: null,
      values: null
    }
  },
  computed: {
    relativeTime() {
      if (new Date(this.nextEvent.start).getTime() < Date.now()) {
        return 'now'
      }
      return moment(this.nextEvent.start).fromNow()
    }
  },
  apollo: {
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
      },
      client: 'cms'
    },
    values: {
      query: valuesQuery,
      update: (data) => {
        if (!data.allStringValues || data.allStringValues.length < 1) {
          return null
        }
        return data.allStringValues[0].value
      },
      error(err, vm) {
        vm.err = err
      },
      client: 'cms'
    }
  }
}
</script>
