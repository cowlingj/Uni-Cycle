export default (context) => {
  if (process.server) {
    context.beforeNuxtRender(({ nuxtState }) => {
      nuxtState.env.PRODUCTS_EXTERNAL_ENDPOINT = context.app.$env
        .PRODUCTS_EXTERNAL_ENDPOINT
        ? context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT
        : `${context.req.protocol || 'http'}://${context.req.headers.host}`
    })
  }
}
