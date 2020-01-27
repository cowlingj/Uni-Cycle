<template>
  <div class="shadow-md">
    <header
      class="flex items-center justify-between flex-no-wrap p-6 bg-primary dark:bg-bg_mid"
    >
      <div
        id="menu"
        @click="toggleMenu"
        class="mr-6 lg:hidden h-6 w-6 flex-none"
      >
        <MenuIcon
          class="h-full w-full fill-current text-fg dark:text-primary cursor-pointer"
          alt="menu icon"
        />
      </div>
      <h1 class="text-xl font-brand text-fg dark:text-primary font-swap">
        Uni-Cycle
      </h1>
      <div class="flex-grow" />
      <nav
        class="hidden lg:flex items-center justify-between flex-wrap text-fg dark:text-primary"
      >
        <nuxt-link exact replace to="/" class="mr-6">Home</nuxt-link>
        <nuxt-link exact replace to="/products" class="mr-6">
          Products
        </nuxt-link>
      </nav>
    </header>
    <nav
      id="nav"
      @click="toggleMenu"
      class="hidden lg:hidden p-3 bg-primary dark:bg-bg_mid dark:bg-bg text-fg dark:text-primary"
    >
      <nuxt-link
        exact
        replace
        to="/"
        class="block py-1 text-center text-lg hover:underline"
      >
        Home
      </nuxt-link>
      <nuxt-link
        exact
        replace
        to="/products"
        class="block py-1 text-center text-lg  hover:underline"
      >
        Products
      </nuxt-link>
    </nav>
  </div>
</template>

<script>
import MenuIcon from '@/assets/img/ic_menu.svg?inline'

export default {
  components: {
    MenuIcon
  },
  methods: {
    toggleMenu(event) {
      const hiddenClass = 'hidden'
      const classes = this.$el.querySelector('#nav').classList
      if (classes.contains(hiddenClass)) {
        classes.remove(hiddenClass)
      } else {
        classes.add(hiddenClass)
      }
    }
  }
}
</script>
