<template>
  <div class="shadow overflow-hidden bg-bg_mid rounded-lg max-h-screen">
    <nuxt-link :to="`/product/${id}`" append>
      <div class="aspect-1-1">
        <img
          :src="imageUrl"
          :alt="name"
          lazy
          class="absolute top-0 m-auto w-full h-full object-cover object-center"
        />
      </div>
      <p class="text-lg text-fg text-center truncate mx-4">{{ name }}</p>
      <p class="text-lg text-primary text-center mx-4">
        {{ $priceString(price) }}
      </p>
    </nuxt-link>
  </div>
</template>
<style scoped>
.aspect-1-1 {
  height: 0;
  overflow: hidden;
  padding-top: 100%;
  position: relative;
}
</style>
<script>
import defaultImageUrl from '@/assets/img/img_no-product.svg'

export default {
  props: {
    id: { type: String, required: true },
    name: { type: String, required: true },
    imageUrl: {
      type: String,
      required: false,
      default: defaultImageUrl
    },
    // TODO: validation
    price: { type: Object, required: true }
  }
}
</script>
