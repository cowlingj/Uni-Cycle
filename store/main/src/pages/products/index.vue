<template>
  <div>
    <div v-if="err" id="products-error">
      <p>error getting products</p>
    </div>
    <div v-else-if="data.products.length === 0" id="no-products">
      <p>no products :(</p>
    </div>
    <ul v-else id="product-list" class="w-1/2 m-auto">
      <li
        v-for="(product, index) in data.products"
        :key="product.id"
        class="relative"
        :style="{
          'padding-top': index === 0 ? '0' : '1px'
        }"
      >
        <hr
          v-if="index !== 0"
          class="absolute w-full top-0 border-t border-bg_highlight"
        />
        <Product :id="product.id" :name="product.name" />
      </li>
    </ul>
  </div>
</template>

<script>
import Product from '@/components/product'

export default {
  components: {
    Product
  },
  data() {
    return {
      err: null,
      data: {
        products: []
      }
    }
  },
  apollo: {},
  async asyncData(context) {
    const url = context.app.$getProductsUrl()

    try {
      const res = await context.$axios.get(`${url}`, {
        params: {
          query: '{ allProducts { id, name } }'
        }
      })

      return {
        err: null,
        data: {
          products: res.data.data.allProducts
        }
      }
    } catch (err) {
      /* istanbul ignore next */
      if (process.server || context.app.$env.NODE_ENV === 'development') {
        /* eslint-disable-next-line */
        console.log(err)
      }
      return {
        err,
        data: null
      }
    }
  }
}
</script>
