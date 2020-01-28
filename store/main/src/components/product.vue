<template>
  <div class="shadow overflow-hidden bg-bg_top rounded-lg max-h-screen">
    <nuxt-link :to="`/product/${id}`" append>
      <div class="aspect-1-1">
        <img
          :src="imageUrl"
          :alt="name"
          class="absolute top-0 m-auto w-full h-full object-cover object-center"
        />
      </div>
      <p class="text-lg text-fg text-center truncate mx-4">{{ name }}</p>
      <p class="text-lg text-primary text-center mx-4">
        {{ priceString }}
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
import moment from 'moment'
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
  },
  computed: {
    priceString() {
      let convertedPrice

      switch (this.price.currency.toLowerCase()) {
        case 'gbp':
          convertedPrice = this.price.value / 100
          break
        default:
          convertedPrice = this.price.value
          break
      }

      return new Intl.NumberFormat(moment.locale(), {
        style: 'currency',
        currency: this.price.currency
      }).format(convertedPrice)
    }
  }
}
</script>
