import { shallowMount } from '@vue/test-utils'
import Event from '@/pages/events.vue'

describe('Event', () => {
  it('renders an empty list of events', () => {
    const wrapper = shallowMount(Event, {
      data: () => ({ err: null, data: { events: [] } }),
      stubs: { Event: true }
    })
    expect(wrapper.find('#error-message').exists()).toBe(false)
    expect(wrapper.findAll('.event').length).toBe(0)
  })

  it('renders a non empty list of events', () => {
    const data = {
      err: null,
      data: {
        events: [
          {
            title: 'title-1',
            description: 'body-1',
            start: 'start-1',
            end: 'end-1',
            location: 'location-1',
            ical: 'ical-1'
          },
          {
            title: 'title-2',
            description: 'body-2',
            start: 'start-2',
            end: 'end-2',
            location: 'location-2',
            ical: 'ical-2'
          }
        ]
      }
    }

    const wrapper = shallowMount(Event, {
      data: () => data,
      stubs: { Event: true }
    })

    expect(wrapper.find('#error-message').exists()).toBe(false)
    expect(wrapper.findAll('#events-list>*').length).toBe(
      data.data.events.length
    )
    Array.from(wrapper.findAll('#events-list>*').wrappers).forEach(
      (item, index) => {
        expect(item.attributes().title).toBe(data.data.events[index].title)
        expect(item.attributes().description).toBe(
          data.data.events[index].description
        )
      }
    )
  })

  it('renders error message', () => {
    const err = { err: 'err messsage' }
    const wrapper = shallowMount(Event, {
      data: () => err,
      stubs: { Event: true }
    })

    expect(wrapper.find('#events-list').exists()).toBe(false)
    expect(wrapper.find('#error-message').exists()).toBe(true)
  })

  it('asyncData handles error', async (done) => {
    const axios = jest.fn()
    axios.get = jest.fn(() => {
      throw new Error('test error')
    })

    const context = {
      app: {
        $getCmsUrl: () => 'URL',
        $env: { NODE_ENV: 'production' }
      },
      $axios: axios
    }

    const res = await Event.asyncData(context)

    expect(res.err).not.toBeNull()
    expect(axios.get.mock.calls.length).toBe(1)
    expect(axios.get.mock.calls[0][0]).toBe(context.app.$getCmsUrl())
    done()
  })

  it('asyncData returns a list of events', async (done) => {
    const mock = { err: null, data: { data: { allEvents: [] } } }
    const axios = jest.fn()
    axios.get = jest.fn(() => mock)

    const context = {
      app: {
        $getCmsUrl: () => 'URL',
        $env: { NODE_ENV: 'production' }
      },
      $axios: axios
    }

    const res = await Event.asyncData(context)

    expect(res.err).toBeNull()
    expect(res.data.events).toBe(mock.data.data.allEvents)
    expect(axios.get.mock.calls.length).toBe(1)
    expect(axios.get.mock.calls[0][0]).toBe(context.app.$getCmsUrl())

    done()
  })
})
