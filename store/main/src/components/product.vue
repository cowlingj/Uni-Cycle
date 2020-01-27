<template>
  <div>
    <nuxt-link :to="`/product/${id}`" append>
      <img
        v-if="imageUrl"
        :src="imageUrl"
        :alt="name"
        class="w-full h-64 object-contain"
      />
      <img
        v-else
        :alt="name"
        src="~assets/img/img_no-product.svg"
        class="w-full h-64 object-contain"
      />
      <p class="text-lg lg:text-3xl text-fg text-center">{{ name }}</p>
    </nuxt-link>
  </div>
</template>
<script>
export default {
  props: {
    id: { type: String, required: true },
    name: { type: String, required: true },
    imageUrl: {
      type: [String, null],
      required: false,
      default: null
    }
  }
}
</script>
