<template>
  <div class="shadow overflow-hidden m-6 w-4/5 bg-bg_mid">
    <div class="event-heading" @click="toggleDescHidden">
      <div class="m-4">
        <div class="flex flex-row items-center">
          <h2
            class="title flex-1 text-lg lg:text-3xl leading-loose text-fg mr-4"
          >
            {{ title }}
          </h2>
          <h2 class="start-string flex-0 text-sm lg:text-xl text-base text-fg">
            {{ relativeStart }}
          </h2>
        </div>
        <h2 class="location text-sm lg:text-base text-fg">
          {{ location }}
        </h2>
      </div>
    </div>
    <div class="more hidden">
      <hr class="border border-bg_highlight" />
      <div class="m-4">
        <p class="start text-sm lg:text-base text-fg">
          start: {{ shortStart }}
        </p>
        <p class="end text-sm lg:text-base text-fg">end: {{ shortEnd }}</p>
        <pre
          class="description text-base text-fg font-sans whitespace-pre-wrap break-words"
          >{{ description }}</pre
        >
        <a class="ical text-sm lg:text-base text-fg" :href="ical">
          add to calendar
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'

export default {
  props: {
    title: String,
    start: [String, Date],
    end: [String, Date],
    location: String,
    description: String,
    ical: String
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
