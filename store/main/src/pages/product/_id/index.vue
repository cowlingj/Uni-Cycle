<template>
  <div class="w-4/5 mx-auto p-4 md:my-20">
    <section id="product-error" v-if="err || !data.product">
      <h1 class="text-fg">
        opps, something went wrong, please try again later
      </h1>
    </section>
    <section
      id="product"
      v-else
      class="w-full grid grid-gap-8 grid-columns-1 grid-rows-2 md:grid-columns-2 md:grid-rows-1"
    >
      <!-- TODO: add some size limits (50% height - 80% height/ ) 100% -->
      <img
        :src="data.product.imageUrl"
        class="row-start-1 row-end-2 col-start-1 col-end-2 max-h-screen/2 m-auto"
      />
      <div
        class="row-start-2 row-end-3 col-start-1 col-end-2  md:row-start-1 md:row-end-2 md:col-start-2 md:col-end-3 flex flex-col"
      >
        <h1 class="text-fg text-3xl">{{ data.product.name }}</h1>
        <h2 class="text-fg text-xl">{{ $priceString(data.product.price) }}</h2>
        <div class="flex-grow flex-shrink-0 min-h-4 empty" />
        <div
          class="justify-self-end grid grid-gap-4 grid-columns-1 grid-rows-2 lg:grid-columns-2 lg:grid-rows-1"
        >
          <a
            id="product-page__reserve-product"
            :href="reserveProduct"
            class="bg-primary dark:bg-none p-2 dark:border dark:border-primary text-center shadow rounded text-fg dark:text-primary"
            >Reserve Product</a
          >
          <a
            id="product-page__more-info"
            :href="moreInfo"
            class="text-fg bg-action_secondary dark:bg-none dark:border dark:border-action_secondary p-2 text-center shadow rounded"
            >more info</a
          >
        </div>
      </div>
    </section>
  </div>
</template>
<style scoped>
#product {
  grid-template-areas:
    'img'
    'info';
}

@media (min-width: 768px) {
  #product {
    grid-template-areas: 'img info';
  }
}

.grid-pos-img {
  grid-area: img;
}

.grid-pos-info {
  grid-area: info;
}

.empty::after {
  content: '\200b';
}
</style>
<script>
import productQuery from './product.gql'
import moreInfo from './more-info-template'
import reserveProduct from './reserve-product-template'
import defaultImageUrl from '@/assets/img/img_no-product.svg'

export default {
  data() {
    return {
      err: null,
      data: {
        product: null
      }
    }
  },
  computed: {
    moreInfo() {
      return moreInfo({
        email: {
          address: this.$env.CONTACT_EMAIL
        },
        product: this.data.product
      })
    },
    reserveProduct() {
      return reserveProduct({
        email: {
          address: this.$env.CONTACT_EMAIL
        },
        product: this.data.product
      })
    }
  },
  async asyncData(context) {
    try {
      const res = await context.app.apolloProvider.clients.products.query({
        query: productQuery,
        variables: {
          id: context.params.id
        }
      })
      return {
        data: {
          product: Object.assign({}, res.data.product, {
            imageUrl: res.data.product.imageUrl
              ? res.data.product.imageUrl
              : defaultImageUrl
          })
        }
      }
    } catch (err) {
      return {
        err
      }
    }
  }
}
</script>
