export default {
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
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }]
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
    '~assets/css/fonts.css'
  ],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    { src: './plugins/cms-path.js' },
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
    '@nuxtjs/pwa',
    '@nuxtjs/svg',
    [
      'nuxt-env',
      {
        keys: [
          { key: 'CMS_INTERNAL_ENDPOINT' },
          { key: 'CMS_BASE_PATH' },
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
  /*
   ** Build configuration
   */
  build: {
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {}
  },
  server: {
    port: process.env.PORT || 80,
    host: process.env.HOST || 'localhost'
  },
  router: {
    base: '/store/',
    middleware: [
      'cms-path',
      'auto-locale'
    ]
  }
}
