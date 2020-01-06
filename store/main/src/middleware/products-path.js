export default (context) => {
  console.log(`server: ${process.server}`)
  console.log(`external: ${JSON.stringify(context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT)}`)

  if (
    process.server &&
    context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT === undefined
  ) {
    context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT = `${context.req.protocol ||
      'http'}://${context.req.headers.host}`
    console.log(`set external: ${context.app.$env.PRODUCTS_EXTERNAL_ENDPOINT}`)
  }
}
