import moment from 'moment'

export default (context, inject) => {
  inject('updateLocale', () => {
    let desiredLocale

    if (process.server) {
      desiredLocale =
        context.req.headers['Accept-Language'] ||
        context.app.$env.DEFAULT_LOCALE
    } else {
      desiredLocale = navigator.language.toLowerCase()
    }

    if (moment.locale() !== desiredLocale) {
      moment.locale(desiredLocale)
    }
  })
}
