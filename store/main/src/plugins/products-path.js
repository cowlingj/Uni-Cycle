export default (context, _inject) => {
  context.app.$getProductsUrl = () => {
    return process.server
      ? context.app.$env.PRODUCTS_INTERNAL_URI
      : context.nuxtState.env.PRODUCTS_EXTERNAL_URI
  }
}
