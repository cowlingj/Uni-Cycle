export default (context) => {
  if (process.server) {
    context.beforeNuxtRender(({ nuxtState }) => {
      nuxtState.env.CMS_EXTERNAL_ENDPOINT = `${context.req.protocol ||
        'http'}://${context.req.headers.host}`
    })
  }
}
