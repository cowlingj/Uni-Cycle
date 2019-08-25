<template>
  <div>
    <p>cms</p>
    <ul>
      <li v-for="product in products" v-bind:key="product.id">
        {{ JSON.stringify(product) }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios'
import config from '~/config'

export default {
  async asyncData(context) {
    const res = await axios.get(`http://${config.cmsURL}/products`)
    const products = res.data

    return {
      data: 'this is where the data would go',
      products
    }
  }
}
</script>
