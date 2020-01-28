/**
 * @jest-environment node
 */

import { promisify } from 'util'
import { ApolloServer } from 'apollo-server'
import { Nuxt, Builder } from 'nuxt'
import { JSDOM } from 'jsdom'
import axios from 'axios'
import { URLTypeDefinition, URLResolver } from 'graphql-scalars'

import rootSchema from '@cowlingj/products-api/schema.gql'
import productSchema from '@cowlingj/products-api/product.gql'
import config from '@/../nuxt.config.js'

process.env.PRODUCTS_INTERNAL_URI = 'http://localhost:8081'
process.env.PRODUCTS_EXTERNAL_URI = 'http://localhost:8081'

describe('Products route', () => {
  let nuxt
  let server

  const products = [
    {
      id: 'id-1',
      name: 'name-1',
      price: {
        value: 1050,
        currency: 'GBP'
      }
    }
  ]

  beforeAll(async () => {
    const apolloServer = new ApolloServer({
      typeDefs: [rootSchema, productSchema, URLTypeDefinition],
      resolvers: {
        Query: { allProducts: () => products },
        URL: URLResolver
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
    await promisify(server.close.bind(server))()
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
        switch (key) {
          case 'price':
            expect(productsHTML).toContain('£10.50')
            break
          default:
            expect(productsHTML).toContain(product[key])
            break
        }

      })
    })

    window.close()
  })
})
