import { shallowMount } from '@vue/test-utils'
import Products from './index.vue'
import productQuery from './product-list.gql'

describe('products page', () => {
  it('must render a list of products', () => {
    const data = {
      err: null,
      data: {
        products: [
          {
            id: 'id-0',
            name: 'name-0',
            imageUrl: 'url-0',
            price: {
              value: 0,
              currency: 'gbp'
            }
          },
          {
            id: 'id-1',
            name: 'name-1',
            price: {
              value: 0,
              currency: 'gbp'
            }
          }
        ]
      }
    }

    const wrapper = shallowMount(Products, {
      data: () => data,
      stubs: {
        Product: true
      }
    })

    const productList = wrapper.find('#product-list')
    expect(productList.isEmpty()).toBe(false)
    expect(productList.exists()).toBe(true)

    const products = wrapper.findAll('product-stub')
    expect(products.length).toBe(2)
    products.wrappers.forEach((productView, i) => {
      expect(productView.attributes().id).toBe(data.data.products[i].id)
      expect(productView.attributes().name).toBe(data.data.products[i].name)
      expect(productView.attributes().price).toBeDefined()
    })

    expect(products.wrappers[0].attributes().imageurl).toBe(
      data.data.products[0].imageUrl
    )
    expect(products.wrappers[1].attributes().imageurl).toBe('')

    expect(wrapper.find('#no-products').exists()).toBe(false)

    expect(wrapper.find('#products-error').exists()).toBe(false)
  })

  it('must render no products', () => {
    const data = {
      err: null,
      data: {
        products: []
      }
    }

    const wrapper = shallowMount(Products, {
      data: () => data,
      stubs: {
        Product: true
      }
    })

    const productList = wrapper.find('#product-list')
    expect(productList.exists()).toBe(false)

    expect(wrapper.find('#no-products').exists()).toBe(true)

    expect(wrapper.find('#products-error').exists()).toBe(false)
  })

  it('must render error message', () => {
    const data = {
      err: 'error message',
      data: {
        products: []
      }
    }

    const wrapper = shallowMount(Products, {
      data: () => data,
      stubs: {
        Product: true
      }
    })

    const productList = wrapper.find('#product-list')
    expect(productList.exists()).toBe(false)

    expect(wrapper.find('#no-products').exists()).toBe(false)

    expect(wrapper.find('#products-error').exists()).toBe(true)
  })

  it('must fetch products', async () => {
    const mock = [
      {
        id: 'id-1',
        name: 'name-1',
        price: {
          value: 1,
          currency: 'currency-1'
        }
      },
      {
        id: 'id-2',
        name: 'name-2',
        price: {
          value: 2,
          currency: 'currency-2'
        }
      }
    ]

    const mockQuery = jest.fn(() => ({ data: { allProducts: mock } }))
    const res = await Products.asyncData({
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
    expect(res.data.products).toEqual(mock)
    expect(mockQuery.mock.calls).toEqual([
      [
        {
          query: productQuery
        }
      ]
    ])
  })

  it('must handle fetch products errors', async () => {
    const mockQuery = jest.fn(() => ({ errors: [new Error()] }))
    const res = await Products.asyncData({
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
