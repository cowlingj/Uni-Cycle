<template>
  <div class="shadow overflow-hidden m-6 w-4/5 bg-bg_mid">
    <div class="event-heading" @click="toggleDescHidden">
      <div class="m-4">
        <div class="flex flex-row items-baseline">
          <h2 class="title flex-1 text-lg lg:text-3xl text-fg mr-4">
            {{ title }}
          </h2>
          <h2 class="start-string flex-0 text-base lg:text-lg text-fg">
            {{ relativeStart }}
          </h2>
        </div>
        <div class="flex flex-row items-start">
          <LocationIcon class="flex-0 mr-4" />
          <h2 class="location text-base lg:text-lg text-fg flex-1 self-center">
            {{ location }}
          </h2>
        </div>
      </div>
    </div>
    <div class="more hidden">
      <hr class="border-t border-bg_highlight" />
      <div class="m-4">
        <div class="flex flex-row items-start">
          <ClockIcon class="flex-0 mr-4" />
          <p class="date text-base text-fg flex-1 self-center">
            {{ shortStart }} - {{ shortEnd }}
          </p>
        </div>
        <div class="flex flex-row items-start py-4">
          <DescriptionIcon class="flex-0 mr-4" />
          <pre
            class="description text-base text-fg font-sans whitespace-pre-wrap break-words flex-1"
            >{{ description }}</pre
          >
        </div>
        <a class="ical flex flex-row items-start" :href="ical">
          <CalendarIcon class="flex-0 mr-4" />
          <p class="flex-1 text-base text-fg underline self-center">
            add to calendar
          </p>
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'
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
  props: {
    title: { type: String, required: true },
    start: { type: [String, Date], required: true },
    end: { type: [String, Date], required: true },
    location: { type: String, required: true },
    description: { type: String, required: true },
    ical: { type: String, required: true }
  },
  computed: {
    relativeStart() {
      return moment(this.start).fromNow()
    },
    shortStart() {
      return moment(this.start).format('l')
    },
    shortEnd() {
      return moment(this.end).format('l')
    }
  },
  methods: {
    toggleDescHidden(event) {
      const classes = this.$el.querySelector('.more').classList
      if (classes.contains('hidden')) {
        classes.remove('hidden')
      } else {
        classes.add('hidden')
      }
    }
  }
}
</script>
