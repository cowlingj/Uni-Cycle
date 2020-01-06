export default (context, _inject) => {
  context.app.$getProductsUrl = () => {
    return process.server
      ? `${context.app.$env.PRODUCTS_INTERNAL_ENDPOINT}${context.app.$env.PRODUCTS_BASE_PATH}`
      : `${context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT}${context.app.$env.PRODUCTS_BASE_PATH}`
  }
}
