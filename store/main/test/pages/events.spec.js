import { shallowMount } from '@vue/test-utils'
import axios from 'axios'
import Event from '@/pages/events.vue'

describe('Event', () => {
  it('renders an empty list of events', () => {
    const wrapper = shallowMount(Event, {
      data: () => ({ err: null, data: { events: [] } })
    })
    expect(wrapper.element.querySelector('#error-message')).toBeNull()
    expect(wrapper.element.querySelectorAll('.event').length).toBe(0)
  })

  it('renders a non empty list of events', () => {
    const data = {
      err: null,
      data: {
        events: [
          { title: 'title-1', description: 'body-1' },
          { title: 'title-2', description: 'body-2' }
        ]
      }
    }

    const wrapper = shallowMount(Event, { data: () => data })
    expect(wrapper.element.querySelector('#error-message')).toBeNull()
    expect(wrapper.element.querySelectorAll('.event').length).toBe(
      data.data.events.length
    )

    Array.from(wrapper.element.children).forEach((child, index) => {
      expect(child.innerHTML).toContain(data.data.events[index].title)
      expect(child.innerHTML).toContain(data.data.events[index].description)
    })
  })

  it('renders error message', () => {
    const err = { err: 'err messsage' }
    const wrapper = shallowMount(Event, { data: () => err })

    expect(wrapper.element.querySelectorAll('.event').length).toBe(0)
    expect(wrapper.element.querySelector('#error-message')).not.toBeNull()
  })

  it('asyncData handles error', async (done) => {
    const context = { app: { $getCmsUrl: () => 'URL' } }

    axios.get = jest.fn(() => {
      throw new Error('test error')
    })

    const res = await Event.asyncData(context)

    expect(res.err).not.toBeNull()

    done()
  })

  it('asyncData returns a list of events', async (done) => {
    const context = { app: { $getCmsUrl: () => 'URL' } }
    const mock = { err: null, data: { data: { events: [] } } }

    axios.get = jest.fn(() => mock)

    const res = await Event.asyncData(context)

    expect(res.err).toBeNull()
    expect(res.data.events).toBe(mock.data.data.events)
    expect(axios.get.mock.calls.length).toBe(1)
    expect(axios.get.mock.calls[0][0]).toBe(
      `${context.app.$getCmsUrl()}/graphql`
    )

    done()
  })
})
