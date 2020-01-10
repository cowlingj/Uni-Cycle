<template>
  <div>
    <section
      v-if="err"
      id="products-error"
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
    <section v-else-if="data.products.length === 0" id="no-products">
      <p>no products :(</p>
    </section>
    <section v-else id="product-list" class="w-1/2 m-auto">
      <ul>
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
    </section>
  </div>
</template>

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
  apollo: {
    products: {
      query: productList,
      update: (data) => data.allProducts,
      error(_err, vm) {
        vm.err = true
        vm.products = []
      },
      client: 'products'
    }
  }
}
</script>
