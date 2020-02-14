import { shallowMount } from '@vue/test-utils'
import Event from './index.vue'
import eventQuery from './events-list.gql'

describe.skip('Event', () => {
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

  it('must fetch events', async () => {
    const mock = [
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

    const mockQuery = jest.fn(() => ({ data: { allEvents: mock } }))
    const res = await Event.asyncData({
      app: {
        apolloProvider: {
          clients: {
            cms: {
              query: mockQuery
            }
          }
        }
      }
    })

    expect(res.err).toBeUndefined()
    expect(res.data.events).toEqual(mock)
    expect(mockQuery.mock.calls).toEqual([
      [
        {
          query: eventQuery
        }
      ]
    ])
  })

  it('must handle fetch products errors', async () => {
    const mockQuery = jest.fn(() => ({ errors: [new Error()] }))
    const res = await Event.asyncData({
      app: {
        apolloProvider: {
          clients: {
            cms: {
              query: mockQuery
            }
          }
        }
      }
    })

    expect(res.err).toBeTruthy()
    expect(res.events).toBeUndefined()
  })
})
