/**
 * @jest-environment node
 */

import path from 'path'
import { ApolloServer } from 'apollo-server'
import { Nuxt, Builder } from 'nuxt'
import { JSDOM } from 'jsdom'
import axios from 'axios'
import config from '../../nuxt.config.js'

import rootSchema from '../lib/products-api/schema.gql'
import productSchema from '../lib/products-api/product.gql'

process.env.PRODUCTS_INTERNAL_URI = 'http://localhost:8081'
process.env.PRODUCTS_EXTERNAL_URI = 'http://localhost:8081'

describe('Products route', () => {
  let nuxt
  let server

  const products = [
    {
      id: 'id-1',
      name: 'name-1'
    }
  ]

  beforeAll(async () => {
    const apolloServer = new ApolloServer({
      typeDefs: [rootSchema, productSchema],
      resolvers: {
        Query: { allProducts: () => products }
      }
    })

    server = (
      await apolloServer.listen({
        host: 'localhost',
        port: 8081
      })
    ).server

    nuxt = new Nuxt(
      Object.assign({}, config, {
        srcDir: path.join(__dirname, '..'),
        dev: false,
        server: {
          host: 'localhost',
          port: 8080
        }
      })
    )

    await new Builder(nuxt).build()
    await nuxt.listen(8080)
  }, 60000)

  afterAll(async () => {
    nuxt.close()
    await new Promise((res) => server.close(res))
  })

  it('displays products from service', async () => {
    const { data, status } = await axios.get(
      'http://localhost:8080/store/products'
    )

    expect(status).toBe(200)

    const { window } = new JSDOM(data)

    expect(window.document.querySelector('#products-error')).toBeNull()
    expect(window.document.querySelector('#no-products')).toBeNull()
    expect(window.document.querySelector('#product-list')).toBeTruthy()

    const productsHTML = window.document.querySelector('#product-list')
      .innerHTML

    products.forEach((product) => {
      Object.keys(product).forEach((key) => {
        expect(productsHTML).toContain(product[key])
      })
    })

    window.close()
  })
})
