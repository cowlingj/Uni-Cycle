import { shallowMount } from '@vue/test-utils'
import Product from '@/components/product.vue'

describe('header', () => {
  it('Must render', () => {
    expect(
      shallowMount(Product, { stubs: ['nuxt-link'] }).html()
    ).not.toBeUndefined()
  })
})
