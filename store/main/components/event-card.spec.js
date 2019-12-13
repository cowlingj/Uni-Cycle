import { shallowMount } from '@vue/test-utils'
import Event from './event-card.vue'
import Vue from 'vue'
import moment from 'moment'

jest.mock('moment')

// TODO: moment return values and mocking

describe('Event Card', () => {

  afterEach(() => {
    moment.mockClear()
  })

  it('Must contain the event data', () => {
    const title = 'title'
    const location = 'Somewhere'
    const locationLink = 'Somewhere'
    const start = 'some date or string'
    const startText = 'start text'
    const relativeStartText = 'tomorrow'
    const end = 'tomorrow'
    const endText = 'start text'
    const description = 'desc\nmore desc'
    const ical = 'url'

    const relativeStart = jest.fn(() => relativeStartText)

    const format = jest.fn()
    format
      .mockReturnValueOnce(startText)
      .mockReturnValueOnce(endText)


    moment
      .mockReturnValue({ fromNow: relativeStart, format })

    const wrapper = shallowMount(Event, {
      propsData: {
        title, location, locationLink, start, end, description, ical
      }
    })

    expect(wrapper.find(".title").html()).toContain(title)
    expect(wrapper.find(".start-string").html()).toContain(relativeStartText)
    expect(wrapper.find(".location").html()).toContain(location)
    expect(wrapper.find(".start").html()).toContain(startText)
    expect(wrapper.find(".end").html()).toContain(endText)
    expect(wrapper.find(".description").html()).toContain(description)
    expect(wrapper.find(".ical").attributes('href')).toContain(ical)

    expect(moment.mock.calls.length).toBe(3)
    expect(moment.mock.calls[0][0]).toBe(start)
  })

  it('Must expand on click if not expanded', async(done) => {
    const title = 'title'
    const location = 'Somewhere'
    const locationLink = 'Somewhere'
    const start = 'some date or string'
    const startText = 'start text'
    const relativeStartText = 'tomorrow'
    const end = 'tomorrow'
    const endText = 'start text'
    const description = 'desc\nmore desc'
    const ical = 'url'

    const relativeStart = jest.fn(() => relativeStartText)

    const format = jest.fn()
    format
      .mockReturnValueOnce(startText)
      .mockReturnValueOnce(endText)


    moment
      .mockReturnValue({ fromNow: relativeStart, format })

    const wrapper = shallowMount(Event, {
      propsData: {
        title, location, locationLink, start, end, description, ical
      }
    })

    wrapper.find('.more').element.classList.add('hidden')
    wrapper.find('.event-heading').trigger('click')

    await Vue.nextTick()

    expect(wrapper.find('.more').classes('hidden')).toBe(false)
    done()
  })

  it('Must contract on click if expanded', async(done) => {
    const title = 'title'
    const location = 'Somewhere'
    const locationLink = 'Somewhere'
    const start = 'some date or string'
    const startText = 'start text'
    const relativeStartText = 'tomorrow'
    const end = 'tomorrow'
    const endText = 'start text'
    const description = 'desc\nmore desc'
    const ical = 'url'

    const relativeStart = jest.fn(() => relativeStartText)

    const format = jest.fn()
    format
      .mockReturnValueOnce(startText)
      .mockReturnValueOnce(endText)


    moment
      .mockReturnValue({ fromNow: relativeStart, format })

    const wrapper = shallowMount(Event, {
      propsData: {
        title, location, locationLink, start, end, description, ical
      }
    })

    wrapper.find('.more').element.classList.remove('hidden')
    wrapper.find('.event-heading').trigger('click')

    await Vue.nextTick()

    expect(wrapper.find('.more').classes('hidden')).toBe(true)
    done()
  })
})
