<template>
  <div>
    <section
      id="products-error"
      v-if="err"
      class="h-full w-full flex flex-col items-center justify-center"
    >
      <p class="text-center font-brand font-swap text-3xl text-fg">
        Sorry, there's a problem getting products
      </p>
      <p class="text-center font-brand font-swap text-3xl text-fg">
        please try later
      </p>
      <!-- TODO: Go Back -->
    </section>
    <section id="no-products" v-else-if="data.products.length === 0">
      <p>no products :(</p>
    </section>
    <section id="product-list" v-else class="w-4/5 m-auto">
      <ul class="grid w-full my-20">
        <li v-for="product in data.products" :key="product.id">
          <Product
            :id="product.id"
            :name="product.name"
            :imageUrl="product.imageUrl"
            :price="product.price"
          />
        </li>
      </ul>
    </section>
  </div>
</template>
<style scoped>
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(12rem, 14rem));
  grid-gap: 1rem;
  justify-content: center;
  grid-auto-rows: 1fr;
}
</style>
<script>
import productList from './product-list.gql'
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
  async asyncData(context) {
    try {
      const res = await context.app.apolloProvider.clients.products.query({
        query: productList
      })
      return {
        data: {
          products: res.data.allProducts.map((product) => {
            return {
              id: product.id,
              name: product.name,
              imageUrl: product.imageUrl ? product.imageUrl : undefined,
              price: product.price
            }
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
