export default function(context) {
  return {
    httpEndpoint: context.app.$env.PRODUCTS_INTERNAL_URI,
    browserHttpEndpoint: context.app.$env.PRODUCTS_EXTERNAL_URI
  }
}
