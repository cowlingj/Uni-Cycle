<template>
  <div class="shadow overflow-hidden p-4 bg-bg_top">
    <nuxt-link :to="`/product/${id}`" append>
      <img
        v-if="imageUrl"
        :src="imageUrl"
        :alt="name"
        class="m-auto w-auto h-64 object-contain"
      />
      <p class="text-lg lg:text-3xl text-fg text-center">{{ name }}</p>
      <p class="text-lg lg:text-3xl text-primary text-center">
        {{ priceString }}
      </p>
    </nuxt-link>
  </div>
</template>
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

      switch(this.price.currency.toLowerCase()) {
        case 'gbp':
          convertedPrice = this.price.value / 100
          break;
        default:
          convertedPrice = this.price.value
          break;
      }

      return new Intl.NumberFormat(moment.locale(), {
        style: 'currency',
        currency: this.price.currency
      }).format(convertedPrice)
    }
  }
}
</script>
