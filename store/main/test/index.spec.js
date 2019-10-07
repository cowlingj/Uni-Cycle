import { shallowMount } from '@vue/test-utils'
import Index from '@/pages/index.vue'

describe('page: /', () => {
  test('is a Vue instance', () => {
    const wrapper = shallowMount(Index)
    expect(wrapper.isVueInstance()).toBe(true)
  })
})
