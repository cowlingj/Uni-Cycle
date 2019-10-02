/**
 * @jest-environment node
 */

import path from 'path'
import { ApolloServer, gql } from 'apollo-server'
import { Nuxt, Builder } from 'nuxt'
import config from '@/nuxt.config.js'
import { JSDOM } from 'jsdom'

describe('Cms route', () => {
  let nuxt
  let server

  const mockStrings = () => [ { name: 'name-1', value: 'value-1'  }]

  beforeAll(async (done) => {
    server = (
      await new ApolloServer({
        typeDefs: gql`
          type StringRes {
            name: String!
            value: String!
          }
          type Query {
            strings: [StringRes]
          }
        `,
        resolvers: {
          Query: { strings: mockStrings }
        }
      }).listen({
        host: 'localhost', port: 8080
      })
    ).server

    nuxt = new Nuxt(
      Object.assign({}, config, {
        rootDir: path.join(__dirname, '..'),
        dev: false,
      })
    )

    process.env.CMS_URL = "http://localhost:8000"
    
    await new Builder(nuxt).build()
    done()
  }, 25000)

  afterAll((done) => {
    nuxt.close()
    server.close()
  })

  it('displays strings from service', async (done) => {
    const { html, error, redirected } = await nuxt.renderRoute('/cms')

    expect(error).toBeNull()
    expect(redirected).toBe(false)

    const dom = new JSDOM(html)

    expect(dom.window.document.querySelector('#error-message')).toBeNull()

    Array.from(dom.window.document.querySelector('#string-resource-list').children)
      .forEach((item, index) => {
        expect(item.innerHTML).toContain(mockStrings()[index].name)
        expect(item.innerHTML).toContain(mockStrings()[index].value)
      })
    done()
  })
})
