import moment from 'moment'
import Vue from 'vue'

Vue.prototype.$priceString = (price) => {
  let convertedPrice

  if (!price || !price.currency || !price.value) {
    return 'unknown'
  }

  switch (price.currency.toLowerCase()) {
    case 'gbp':
      convertedPrice = price.value / 100
      break
    default:
      convertedPrice = price.value
      break
  }

  return new Intl.NumberFormat(moment.locale(), {
    style: 'currency',
    currency: price.currency
  }).format(convertedPrice)
}
