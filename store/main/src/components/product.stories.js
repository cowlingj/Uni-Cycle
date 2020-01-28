import { storiesOf } from '@storybook/vue'
import { text, number } from '@storybook/addon-knobs'
import Product from './product'

storiesOf('Product', module)
  .add('With Random Image', () => ({
    components: { Product },
    props: {
      id: { default: text('Id', 'product-id') },
      name: { default: text('Name', 'product-name') },
      imageUrl: { default: text('Image', 'https://picsum.photos/200') },
      price: {
        default: {
          value: number('Price', 10.5),
          currency: 'gbp'
        }
      }
    },
    template: `<Product
    class="w-1/2"
    :id="id"
    :name="name"
    :imageUrl="imageUrl"
    :price="price"
  />`
  }))
  .add('With Default Image', () => ({
    components: { Product },
    props: {
      id: { default: text('Id', 'product-id') },
      name: { default: text('Name', 'product-name') },
      price: {
        default: {
          value: number('Price', 10.5),
          currency: 'gbp'
        }
      }
    },
    template: `<Product
    class="w-1/2"
    :id="id"
    :name="name"
    :price="price"
  />`
  }))
