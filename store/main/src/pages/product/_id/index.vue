<template>
  <div>
    <section id="product-error" v-if="err">
      <h1>opps, something went wrong, please try again later</h1>
    </section>
    <section id="product" v-else>
      <h1>{{ data.product.name }}</h1>
      <p>More deatils coming soon</p>
    </section>
  </div>
</template>

<script>
import productQuery from './product.gql'

export default {
  data() {
    return {
      err: null,
      data: {
        product: null
      }
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
          product: res.data.productById
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
