<template>
  <div>
    <h1>Communication with CMS:</h1>
    <h1 v-if="err" id="error-message">Error: {{ err }}</h1>
    <div v-else id="string-resource-list">
      <section
        v-for="string in data.strings"
        :key="string.name"
        class="shadow-lg overflow-hidden w-4/5 p-4"
      >
        <h1 class="text-xl leading-loose">{{ string.name }}</h1>
        <p class="text-base">{{ string.value }}</p>
      </section>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData(context) {
    try {
      const res = await axios.get(`${context.app.$env.CMS_URL}/graphql`, {
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
