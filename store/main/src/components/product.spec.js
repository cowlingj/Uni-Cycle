import { shallowMount } from '@vue/test-utils'
import Product from '@/components/product.vue'

describe('Product Card', () => {
  it('Must render', () => {
    expect(
      shallowMount(Product, {
        propsData: {
          id: 'id',
          name: 'name',
          imageUrl: 'url',
          price: {
            value: 10.5,
            currency: 'gbp'
          }
        },
        stubs: ['nuxt-link']
      }).html()
    ).not.toBeUndefined()
  })
})
