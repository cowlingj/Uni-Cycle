import { shallowMount } from '@vue/test-utils'
import Index from '@/pages/index.vue'
import moment from 'moment'

jest.mock('moment', () => jest.fn(() => jest.requireActual('moment')))

describe('homepage', () => {

  beforeEach(() => {
    moment.mockReset()
  })

  it('renders without a next Event', () => {
    const wrapper = shallowMount(Index)
    expect(wrapper.isVueInstance()).toBe(true)
  })

  describe('with next event', () => {
    let mockDateNow

    beforeAll(() => {
      mockDateNow = jest.spyOn(global.Date, 'now')
    })

    beforeEach(() => {
      mockDateNow.mockReset()
      moment.mockReset()
    })

    afterAll(() => {
      mockDateNow.mockRestore()
    })

    it('renders with a future next event', () => {
      const now = new Date(1000)

      const nextEvent = {
        title: 'title',
        description: 'desc',
        location: 'loc',
        ical: 'ical',
        start: new Date(2000).toISOString(),
        end: new Date(3000).toISOString()
      }

      const expected = {
        title: 'title',
        description: 'desc',
        location: 'loc',
        ical: 'ical',
        relativeTime: 'soon'
      }

      mockDateNow.mockReturnValue(now)
      const mockFromNow = jest.fn(() => expected.relativeTime)
      moment.mockReturnValue({ fromNow: mockFromNow })

      const wrapper = shallowMount(Index, {
        data: () => ({
          nextEvent
        })
      })

      const html = wrapper.html()
      expect(html).toContain(expected.title)
      expect(html).toContain(expected.description)
      expect(html).toContain(expected.location)
      expect(wrapper.find(`a[href=${expected.ical}]`).exists()).toBe(true)
      expect(wrapper.find('.relativeTime').html()).toContain(expected.relativeTime)
    })

    it('renders with a current next event', () => {
      const now = new Date(1000)

      const nextEvent = {
        title: 'title',
        description: 'desc',
        location: 'loc',
        ical: 'ical',
        start: new Date(0).toISOString(),
        end: new Date(2000).toISOString()
      }

      const expected = {
        title: 'title',
        description: 'desc',
        location: 'loc',
        ical: 'ical',
        relativeTime: 'now'
      }

      mockDateNow.mockReturnValue(now)

      const wrapper = shallowMount(Index, {
        data: () => ({
          nextEvent
        })
      })

      expect(wrapper.isVueInstance()).toBe(true)
      const html = wrapper.html()
      expect(html).toContain(expected.title)
      expect(html).toContain(expected.description)
      expect(html).toContain(expected.location)
      expect(wrapper.find(`a[href=${expected.ical}]`).exists()).toBe(true)
      expect(wrapper.find('.relativeTime').html()).toContain(expected.relativeTime)
    })
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
