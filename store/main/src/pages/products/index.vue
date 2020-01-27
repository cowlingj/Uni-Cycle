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
    <section id="product-list" v-else class="w-1/2 m-auto">
      <ul class="grid">
        <li v-for="product in data.products" :key="product.id">
          <Product
            :id="product.id"
            :name="product.name"
            :imageUrl="product.imageUrl"
          />
        </li>
      </ul>
    </section>
  </div>
</template>
<style scoped>
.grid {
  display: grid;
  grid-template-columns: 1fr;
  grid-gap: 1rem;
  justify-content: center;
}

@media (min-width: 768px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 900px) {
  .grid {
    grid-template-columns: repeat(4, minmax(1fr, 800px));
  }
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
          products: res.data.allProducts
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
