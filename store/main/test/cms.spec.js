import { shallowMount } from '@vue/test-utils'
import Cms from '@/pages/cms.vue'
import axios from 'axios'

describe('Cms', () => {

  let axiosGetSpy 

  beforeAll(() => {
    axiosGetSpy = jest.spyOn(axios, 'get')
  })

  beforeEach(() => {
    axiosGetSpy.mockRestore()
  })

  it('renders an empty list of strings', () => {
    const wrapper = shallowMount(Cms, {
      mocks: { err: false, data: { strings: [] } }
    })
    expect(wrapper.element.querySelector('#error-message')).toBeNull()
    expect(wrapper.element.querySelector('#string-resource-list').children.length).toBe(0)
  })

  it('renders a non empty list of strings', () => {

    const mocks = {
      err: false,
      data: {
        strings: [
          { name: "n1", value: "v1" },
          { name: "n2", value: "v2" }
        ]
      }
    }
    const wrapper = shallowMount(Cms, { mocks })

    expect(wrapper.element.querySelector('#error-message')).toBeNull()
    expect(wrapper.element.querySelector('#string-resource-list').children.length)
      .toBe(mocks.data.strings.length)

    Array.from(wrapper.element.querySelector('#string-resource-list').children)
    .forEach((item, index) => {
      expect(item.innerHTML).toContain(mocks.data.strings[index].name)
      expect(item.innerHTML).toContain(mocks.data.strings[index].value)
    })
  })

  it('renders error message', () => {

    const mocks = { err: "err messsage" }
    const wrapper = shallowMount(Cms, { mocks })

    expect(wrapper.element.querySelector('#string-resource-list')).toBeNull()
    expect(wrapper.element.querySelector('#error-message').innerHTML).toContain(mocks.err)
  })

  it('asyncData handles error', async(done) => {

    const err = new Error()
    axios.get = jest.fn(() => { throw err })
    
    const res = await Cms.asyncData({ env: { CMS_URL: ''}})

    expect(res.err).toBe(err)

    done()
  })

  it('asyncData returns a list of strings', async(done) => {

    const mock = { err: false, data: { data: { strings: [] } } }
    const context = { env: { CMS_URL: ''}}

    axios.get = jest.fn(() => mock)
    
    const res = await Cms.asyncData(context)

    expect(res.err).toBe(false)
    expect(res.data.strings).toBe(mock.data.data.strings)
    expect(axios.get.mock.calls.length).toBe(1)
    expect(axios.get.mock.calls[0][0]).toBe(context.env.CMS_URL)
 
    done()
  })
})
