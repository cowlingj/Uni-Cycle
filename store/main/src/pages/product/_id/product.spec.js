import { shallowMount } from '@vue/test-utils'
import Product from './index.vue'
import productQuery from './product.gql'

describe('product page', () => {
  it('must render a product', () => {
    const data = {
      err: null,
      data: {
        product: {
          name: 'name'
        }
      }
    }

    const wrapper = shallowMount(Product, {
      data: () => data
    })

    expect(wrapper.html()).toContain(data.data.product.name)

    expect(wrapper.find('#product-error').exists()).toBe(false)
  })

  it('must render error message', () => {
    const data = {
      err: 'error message',
      data: {
        product: null
      }
    }

    const wrapper = shallowMount(Product, {
      data: () => data,
      stubs: {
        Product: true
      }
    })

    expect(wrapper.find('#product').exists()).toBe(false)

    expect(wrapper.find('#product-error').exists()).toBe(true)
  })

  it('must fetch a product', async () => {
    const mock = { name: 'name-1' }

    const expectedId = '00000000-0000-4000-a000-000000000000'

    const mockQuery = jest.fn(() => ({ data: { productById: mock } }))
    const res = await Product.asyncData({
      params: {
        id: expectedId
      },
      app: {
        apolloProvider: {
          clients: {
            products: {
              query: mockQuery
            }
          }
        }
      }
    })

    expect(res.err).toBeUndefined()
    expect(res.data.product).toEqual(mock)
    expect(mockQuery.mock.calls).toEqual([
      [
        {
          query: productQuery,
          variables: {
            id: expectedId
          }
        }
      ]
    ])
  })

  it('must handle fetch product errors', async () => {
    const mockQuery = jest.fn(() => ({ errors: [new Error()] }))
    const res = await Product.asyncData({
      params: {
        id: '00000000-0000-4000-a000-000000000000'
      },
      app: {
        apolloProvider: {
          clients: {
            products: {
              query: mockQuery
            }
          }
        }
      }
    })

    expect(res.err).toBeTruthy()
    expect(res.products).toBeUndefined()
  })
})
