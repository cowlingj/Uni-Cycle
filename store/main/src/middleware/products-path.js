export default (context) => {
  if (process.server) {
    context.beforeNuxtRender(({ nuxtState }) => {
      nuxtState.env.PRODUCTS_EXTERNAL_URI = context.app.$env
        .PRODUCTS_EXTERNAL_URI
    })
  }
}
