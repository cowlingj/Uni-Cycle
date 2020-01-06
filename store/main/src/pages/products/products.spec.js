import { shallowMount } from '@vue/test-utils'
import Products from './products.vue'

describe('products page', () => {
  it('must render a list of products', () => {
    const data = {
      err: null,
      data: {
        products: [
          {
            id: 'id-0',
            name: 'name-0'
          },
          {
            id: 'id-1',
            name: 'name-1'
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
    })

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
    const mock = { err: null, data: { data: { allProducts: [] } } }
    const axios = jest.fn()
    axios.get = jest.fn(() => mock)

    const context = {
      app: {
        $getProductsUrl: () => 'URL',
        $env: { NODE_ENV: 'production' }
      },
      $axios: axios
    }

    const res = await Products.asyncData(context)

    expect(res.err).toBeNull()
    expect(res.data.products).toBe(mock.data.data.allProducts)
    expect(axios.get.mock.calls.length).toBe(1)
    expect(axios.get.mock.calls[0][0]).toBe(context.app.$getProductsUrl())
  })

  it('must handle fetch product errors', async () => {
    const axios = jest.fn()
    axios.get = jest.fn(() => {
      throw new Error('test error')
    })

    const context = {
      app: {
        $getProductsUrl: () => 'URL',
        $env: { NODE_ENV: 'production' }
      },
      $axios: axios
    }

    const res = await Products.asyncData(context)

    expect(res.err).not.toBeNull()
    expect(axios.get.mock.calls.length).toBe(1)
    expect(axios.get.mock.calls[0][0]).toBe(context.app.$getProductsUrl())
  })
})
