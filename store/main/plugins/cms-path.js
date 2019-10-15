export default (context, _inject) => {
  context.app.$getCmsUrl = () => {
    return process.server
      ? context.app.$env.CMS_CLUSTER_URL
      : context.app.$env.CMS_EXTERNAL_URL
  }
}
