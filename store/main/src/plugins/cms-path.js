export default (context, _inject) => {
  context.app.$getCmsUrl = () => {
    return process.server
      ? context.app.$env.CMS_INTERNAL_URI
      : context.nuxtState.env.CMS_EXTERNAL_URI
  }
}
