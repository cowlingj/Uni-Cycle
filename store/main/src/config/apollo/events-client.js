export default function(context) {
  return {
    httpEndpoint: context.app.$env.EVENTS_INTERNAL_URI,
    browserHttpEndpoint: context.app.$env.EVENTS_EXTERNAL_URI
  }
}
