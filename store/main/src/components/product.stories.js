import { storiesOf } from '@storybook/vue'
import { text } from '@storybook/addon-knobs'
import Product from './product'

storiesOf('Product', module).add('Default', () => ({
  components: { Product },
  props: {
    id: { default: text('Id', 'product-id') },
    name: { default: text('Name', 'product-name') }
  },
  template: `<Product
    :id="id"
    :name="name"
  />`
}))
