export default function(context) {
  return {
    httpEndpoint: context.app.$env.RESOURCES_INTERNAL_URI,
    browserHttpEndpoint: context.app.$env.RESOURCES_EXTERNAL_URI
  }
}
