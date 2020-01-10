import { shallowMount } from '@vue/test-utils'
import { graphql } from 'graphql'
import { GraphQLURL, GraphQLDateTime } from 'graphql-custom-types'
import { makeExecutableSchema, addMockFunctionsToSchema } from 'graphql-tools'
import Event from './index.vue'
import rootSchema from '@/lib/cms-api/schema.gql'
import eventSchema from '@/lib/cms-api/event.gql'

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

  it('must fetch products', async () => {
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

    const schema = makeExecutableSchema({
      typeDefs: [rootSchema, eventSchema],
      resolvers: {
        Url: GraphQLURL,
        DateTime: GraphQLDateTime,
        Query: {
          allEvents: () => mock
        }
      }
    })

    addMockFunctionsToSchema({
      schema,
      preserveResolvers: true
    })

    const res = await graphql(
      schema,
      Event.apollo.events.query.loc.source.body,
      null,
      null,
      {},
      null
    )

    expect(res.errors).toBeUndefined()
    expect(res.data.allEvents).toEqual(mock)
  })

  it('must update products data from allProducts query', () => {
    const res = {}
    expect(Event.apollo.events.update({ allEvents: res })).toBe(res)
  })

  it('must handle fetch products errors', () => {
    const vm = {}
    Event.apollo.events.error(new Error('test'), vm)

    expect(vm).toEqual({
      err: true,
      events: []
    })
  })
})
