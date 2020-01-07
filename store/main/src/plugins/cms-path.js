export default (context, _inject) => {
  context.app.$getCmsUrl = () => {
    return process.server
      ? `${context.app.$env.CMS_INTERNAL_ENDPOINT}${context.app.$env.CMS_INTERNAL_PATH}`
      : `${context.nuxtState.env.CMS_EXTERNAL_ENDPOINT}${context.app.$env.CMS_EXTERNAL_PATH}`
  }
}
