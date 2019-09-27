<template>
  <div>
    <h1>Communication with CMS:</h1> 
    <h1 v-if="err" id="error-message">Error: {{ err }}</h1>
    <ul v-else id="string-resource-list">
      <li v-for="string in data.strings" :key="string.name">
        {{ string.name }} = {{ string.value }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData(context) {
    try {
      const res = await axios.get(`${context.env.CMS_URL}`, {
        params: { query: '{ strings { name, value } }' }
      })

      return {
        err: false,
        data: {
          strings: res.data.data.strings
        }
      }
    } catch (err) {
      return { err }
    }
  }
}
</script>
