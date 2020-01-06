export default (context) => {
  if (process.server && context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT === undefined) {
    context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT = `${context.req.protocol ||
      'http'}://${context.req.headers.host}`
  }
}
