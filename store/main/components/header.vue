<template>
  <div class="shadow-lg">
    <header
      class="flex items-center justify-between flex-no-wrap p-6 bg-primary"
    >
      <img
        id="menu"
        class="mr-6 lg:hidden"
        src="~assets/img/menu.svg"
        alt="menu icon"
        @click="toggleMenu"
      />
      <h1 class="text-xl font-brand">Uni-Cycle</h1>
      <div class="flex-grow" />
      <nav
        id="nav--lg"
        class="hidden lg:flex items-center justify-between flex-wrap"
      >
        <nuxt-link exact replace to="/" class="mr-6">Home</nuxt-link>
        <nuxt-link exact replace to="/events" class="mr-6">Events</nuxt-link>
      </nav>
    </header>
    <nav id="nav" class="hidden p-3 bg-secondary">
      <nuxt-link exact replace to="/" class="block py-1 text-center text-lg">
        Home
      </nuxt-link>
      <nuxt-link
        exact
        replace
        to="/events"
        class="block py-1 text-center text-lg"
      >
        Events
      </nuxt-link>
    </nav>
  </div>
</template>

<script>
export default {
  methods: {
    toggleMenu(event) {
      const hiddenClass = 'hidden'
      const classes = document.getElementById('nav').classList
      if (classes.contains(hiddenClass)) {
        classes.remove(hiddenClass)
      } else {
        classes.add(hiddenClass)
      }
    }
  }
}
</script>

<style scoped>
nav * {
  @apply text-fg;
}

@media (prefers-color-scheme: dark) {
  header,
  nav {
    background-color: var(--color-bg);
  }

  h1 {
    color: var(--color-primary);
  }

  nav * {
    @apply text-secondary;
  }
}
</style>
