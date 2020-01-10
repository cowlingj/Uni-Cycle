import { shallowMount } from '@vue/test-utils'
import Product from '@/components/product.vue'

describe('header', () => {
  it('Must render', () => {
    expect(
      shallowMount(Product, {
        props: {
          id: 'id',
          name: 'name'
        },
        stubs: ['nuxt-link']
      }).html()
    ).not.toBeUndefined()
  })
})
