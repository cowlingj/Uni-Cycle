<template>
  <div>
    <p>cms</p>
    <ul>
      <li v-for="string in strings" v-bind:key="string.name">
        {{ JSON.stringify(string) }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData(context) {

    console.log("cms asyncData")
    console.log(env.CMS_URL)
    
    const res = await axios.post(
      `http://${process.env.CMS_URL}/`,
      "query { strings { name, value } }"
      ) // TODO: use something like gql

    const strings = res.data.data

    console.log(res.data)

    return {
      strings,
    }
  }
}
</script>
