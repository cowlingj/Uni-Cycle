export default (context, _inject) => {
  context.app.$getCmsUrl = () => {
    return process.server
      ? `${context.app.$env.CMS_INTERNAL_ENDPOINT}${context.app.$env.CMS_BASE_PATH}`
      : `${context.app.$env.CMS_EXTERNAL_ENDPOINT}${context.app.$env.CMS_BASE_PATH}`
  }
}
