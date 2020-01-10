import { shallowMount } from '@vue/test-utils'
import Product from './index.vue'

describe('product page', () => {
  it('Must render', () => {
    expect(shallowMount(Product).html()).not.toBeUndefined()
  })
})
