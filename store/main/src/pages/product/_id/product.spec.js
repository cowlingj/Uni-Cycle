import { shallowMount } from '@vue/test-utils'
import Product from './index.vue'
import productQuery from './product.gql'
import defaultImageUrl from '@/assets/img/img_no-product.svg'

describe('product page', () => {
  it('must render a product', () => {
    const data = {
      err: null,
      data: {
        product: {
          id: '00000000-0000-4000-a000-000000000000',
          name: 'name',
          price: {
            value: 100,
            currency: 'gbp'
          }
        }
      }
    }

    const price = 'price'
    const priceString = jest.fn().mockReturnValueOnce(price)

    const email = 'dave@example.com'

    const wrapper = shallowMount(Product, {
      data: () => data,
      mocks: {
        $priceString: priceString,
        $env: {
          CONTACT_EMAIL: email
        }
      }
    })

    const html = wrapper.html()

    expect(html).toContain(data.data.product.name)
    expect(html).toContain(price)
    expect(priceString.mock.calls).toEqual([[data.data.product.price]])

    expect(
      wrapper.find('a#product-page__reserve-product').attributes().href
    ).toContain(email)
    expect(
      wrapper.find('a#product-page__reserve-product').attributes().href
    ).toContain(data.data.product.id)
    expect(
      wrapper.find('a#product-page__more-info').attributes().href
    ).toContain(email)
    expect(
      wrapper.find('a#product-page__more-info').attributes().href
    ).toContain(data.data.product.id)

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
      },
      mocks: {}
    })

    expect(wrapper.find('#product').exists()).toBe(false)

    expect(wrapper.find('#product-error').exists()).toBe(true)
  })

  it('must fetch a product', async () => {
    const mock = {
      name: 'name',
      imageUrl: 'url'
    }

    const expectedId = '00000000-0000-4000-a000-000000000000'

    const mockQuery = jest.fn(() => ({ data: { product: mock } }))
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

  it('must fetch a product without image', async () => {
    const mock = { name: 'name', imageUrl: null }

    const expectedId = '00000000-0000-4000-a000-000000000000'

    const mockQuery = jest.fn(() => ({ data: { product: mock } }))
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
    expect(res.data.product).toEqual({
      name: mock.name,
      imageUrl: defaultImageUrl
    })
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
