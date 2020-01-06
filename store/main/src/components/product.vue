<template>
  <div>
    <nuxt-link :to="`/product/${id}`" append>
      <p class="text-lg lg:text-3xl text-fg">{{ name }}</p>
    </nuxt-link>
  </div>
</template>
<script>
export default {
  props: {
    id: { type: String, required: true },
    name: { type: String, required: true }
  }
}
</script>
