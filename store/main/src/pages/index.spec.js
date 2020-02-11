import { shallowMount } from '@vue/test-utils'
import Index from '@/pages/index.vue'

describe('homepage', () => {
  it('renders without a next Event', () => {
    const wrapper = shallowMount(Index)
    expect(wrapper.isVueInstance()).toBe(true)
  })

  it('renders with a next Event', () => {
    const wrapper = shallowMount(Index, {
      data: () => ({
        nextEvent: 'event'
      })
    })
    expect(wrapper.isVueInstance()).toBe(true)
    // TODO: update when I know what an event should looks like
  })

  describe('apollo', () => {
    it('handles no events', () => {
      const mock = {
        allEvents: []
      }

      expect(Index.apollo.nextEvent.update(mock)).toBeNull()
    })

    it('handles one event', () => {
      const mock = {
        allEvents: [
          {
            title: 'title',
            description: 'description',
            location: 'location',
            ical: '',
            start: new Date(2000).toISOString(),
            end: new Date(3000).toISOString()
          }
        ]
      }

      expect(Index.apollo.nextEvent.update(mock)).toEqual(mock.allEvents[0])
    })

    it('handles errors correctly', () => {
      const vm = {}
      const error = new Error()
      Index.apollo.nextEvent.error(error, vm)
      expect(vm.err).toBeTruthy()
    })
  })
})
