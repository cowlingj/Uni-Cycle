import { shallowMount } from '@vue/test-utils'
import { makeExecutableSchema, addMockFunctionsToSchema } from 'graphql-tools'
import { graphql } from 'graphql'
import Products from './index.vue'
import rootSchema from '@/lib/products-api/schema.gql'
import productSchema from '@/lib/products-api/product.gql'

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
    const mock = [
      {
        id: 'id-1',
        name: 'name-1'
      },
      {
        id: 'id-2',
        name: 'name-2'
      }
    ]

    const schema = makeExecutableSchema({
      typeDefs: [rootSchema, productSchema],
      resolvers: {
        Query: {
          allProducts: () => mock
        }
      }
    })

    addMockFunctionsToSchema({
      schema,
      preserveResolvers: true
    })

    const res = await graphql(
      schema,
      Products.apollo.products.query.loc.source.body,
      null,
      null,
      {},
      null
    )

    expect(res.errors).toBeUndefined()
    expect(res.data.allProducts).toEqual(mock)
  })

  it('must update products data from allProducts query', () => {
    const res = {}
    expect(Products.apollo.products.update({ allProducts: res })).toBe(res)
  })

  it('must handle fetch products errors', () => {
    const vm = {}
    Products.apollo.products.error(new Error('test'), vm)

    expect(vm).toEqual({
      err: true,
      products: []
    })
  })
})
