import { shallowMount } from '@vue/test-utils'
import Event from '@/pages/events.vue'

describe('Event', () => {
  it('renders an empty list of events', () => {
    const wrapper = shallowMount(Event, {
      data: () => ({ err: false, data: { events: [] } })
    })
    expect(wrapper.element.children.length).toBe(0)
  })

  it('renders a non empty list of events', () => {
    const data = {
      err: false,
      data: {
        events: [
          { title: 'title-1', description: 'body-1' },
          { title: 'title-2', description: 'body-2' }
        ]
      }
    }

    const wrapper = shallowMount(Event, { data: () => data })
    expect(wrapper.element.children.length).toBe(data.data.events.length)

    Array.from(wrapper.element.children).forEach((child, index) => {
      expect(child.innerHTML).toContain(data.data.events[index].title)
      expect(child.innerHTML).toContain(data.data.events[index].description)
    })
  })
})
