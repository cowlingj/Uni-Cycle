export default (context) => {
  if (process.server) {
    context.beforeNuxtRender(({ nuxtState }) => {
      nuxtState.env.CMS_EXTERNAL_URI = context.app.$env
        .CMS_EXTERNAL_URI
    })
  }
}
