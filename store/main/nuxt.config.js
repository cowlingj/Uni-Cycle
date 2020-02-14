import { config } from 'dotenv'
config()

const base = '/store/'
export default {
  srcDir: './src',
  mode: 'universal',
  /*
   ** Headers of the page
   */
  head: {
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || ''
      }
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: `${base}/favicon.ico` }]
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },
  /*
   ** Global CSS
   */
  css: [
    '~assets/css/browser-settings.css',
    '~assets/css/colors.css',
    '~assets/css/fonts.css',
    '~assets/css/utilities.css',
    '~assets/css/defaults.css'
  ],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    { src: './plugins/price-string.js' },
    { src: './plugins/cms-path.js' },
    { src: './plugins/products-path.js' },
    { src: './plugins/update-locale.js' }
  ],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    // Doc: https://github.com/nuxt-community/nuxt-tailwindcss
    '@nuxtjs/tailwindcss'
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/apollo',
    '@nuxtjs/pwa',
    '@nuxtjs/svg',
    '~/modules/dotenv',
    [
      'nuxt-env',
      {
        keys: [
          { key: 'CMS_INTERNAL_URI' },
          { key: 'CMS_EXTERNAL_URI' },
          { key: 'PRODUCTS_INTERNAL_URI' },
          { key: 'PRODUCTS_EXTERNAL_URI' },
          { key: 'CONTACT_EMAIL' },
          { key: 'DEFAULT_LOCALE', default: 'en-gb' }
        ]
      }
    ]
  ],
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */
  axios: {},
  apollo: {
    includeNodeModules: true,
    clientConfigs: {
      products: '@/config/apollo/products-client.js',
      cms: '@/config/apollo/cms-client.js'
    }
  },
  /*
   ** Build configuration
   */
  build: {
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {}
  },
  ignore: ['**/*.spec.js', '**/*.integration.js', 'pages/events/**/*'],
  server: {
    port: process.env.PORT || 80,
    host: process.env.HOST || 'localhost'
  },
  router: {
    base,
    middleware: ['cms-path', 'products-path', 'auto-locale']
  }
}
