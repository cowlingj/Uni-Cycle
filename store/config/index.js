export default {
  ...require('~/config/' + (process.env.NODE_ENV || 'production')).default
}
