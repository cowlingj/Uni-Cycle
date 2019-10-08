import { shallowMount } from '@vue/test-utils'
import Header from '@/components/header.vue'

describe('header', () => {
  it('Must render', () => {
    expect(shallowMount(Header, { stubs: ['nuxt-link'] }).isVueInstance()).toBe(
      true
    )
  })
})
