import { shallowMount } from '@vue/test-utils'
import Vue from 'vue'
import Header from '@/components/header.vue'

describe('header', () => {
  it('Must render', () => {
    expect(shallowMount(Header, { stubs: ['nuxt-link'] }).isVueInstance()).toBe(
      true
    )
  })

  it('Must Add "hidden" on #nav if not already there', async (done) => {
    const wrapper = shallowMount(Header, {
      stubs: ['nuxt-link'],
      attachToDocument: true
    })
    wrapper.find('#nav').element.classList.remove('hidden')
    wrapper.find('#menu').trigger('click')
    await Vue.nextTick()
    expect(wrapper.find('nav').classes('hidden')).toBe(true)
    wrapper.destroy()
    done()
  })

  it('Must Remove "hidden" from #nav classes if already there', async (done) => {
    const wrapper = shallowMount(Header, {
      stubs: ['nuxt-link'],
      attachToDocument: true
    })
    wrapper.find('#nav').element.classList.add('hidden')
    wrapper.find('#menu').trigger('click')
    await Vue.nextTick()
    expect(wrapper.find('nav').classes('hidden')).toBe(true)
    wrapper.destroy()
    done()
  })
})
