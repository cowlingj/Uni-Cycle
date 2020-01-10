export default function (context) {
  return {
    httpEndpoint: context.app.$env.CMS_INTERNAL_URI,
    browserHttpEndpoint: context.app.$env.CMS_EXTERNAL_URI
  }
}
