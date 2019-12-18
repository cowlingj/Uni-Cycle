import { configure, addDecorator, addParameters } from '@storybook/vue'
import '../src/assets/css/tailwind.css'
import '../src/assets/css/colors.css'
import '../src/assets/css/fonts.css'
import { withA11y } from '@storybook/addon-a11y'
import { withKnobs } from '@storybook/addon-knobs'
import { action } from '@storybook/addon-actions'
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)
Vue.component('nuxt-link', {
  props:   ['to'],
  methods: {
    log() {
      action('link target')(this.to)
    },
  },
  template: '<a href="#" @click.prevent="log()"><slot>NuxtLink</slot></a>',
})

addDecorator(withA11y)
addDecorator(withKnobs)
addParameters({
  backgrounds: [
    { name: 'black', value: 'black' },
    { name: 'white', value: 'white' },
    { name: 'blue', value: '#3b5998' },
  ],
  viewport: {
    viewports: {
      m: {
        name: 'Mobile',
        styles: {
          height: '480px',
          width: '320px',
        },
        type: 'mobile',
      },
      t: {
        name: 'Tablet',
        styles: {
          height: '568px',
          width: '768px',
        },
        type: 'tablet',
      },
      d: {
        name: 'Desktop',
        styles: {
          height: '768px',
          width: '1024px',
        },
        type: 'desktop',
      }
    },
    defaultViewport: 'responsive'
  }
})

// FIXME: use updated webpack config https://github.com/storybookjs/storybook/issues/7360
// https://medium.com/js-dojo/a-guide-on-using-storybook-with-nuxt-js-1e0018ec51c9
// https://dev.to/jerriclynsjohn/svelte-tailwind-storybook-starter-template-2nih
function loadStories() {
  const req = require.context('../src', true, /\.\/components\/.*\.stories\.js$/)
  req.keys().forEach(filename => req(filename))
}
configure(loadStories, module)
