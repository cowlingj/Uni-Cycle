/**
 * @jest-environment node
 */

import path from 'path'
import { ApolloServer, gql } from 'apollo-server'
import { Nuxt, Builder } from 'nuxt'
import { JSDOM } from 'jsdom'
import config from '@/nuxt.config.js'

describe('Cms route', () => {
  let nuxt
  let server

  const events = [
    {
      title: 'title',
      description: 'desc',
      start: 'start',
      end: 'end',
      location: 'location',
      locationUrl: 'locationUrl',
      ical: 'ical'
    }
  ]

  beforeAll(async (done) => {
    server = (await new ApolloServer({
      typeDefs: gql`
        type Event {
          title: String!
          description: String!
          start: String!
          end: String!
          location: String!
          locationUrl: String!
          ical: String!
        }
        type Query {
          allEvents: [Event]
        }
      `,
      resolvers: {
        Query: { allEvents: () => events }
      }
    }).listen({
      host: 'localhost',
      port: 8080
    })).server

    nuxt = new Nuxt(
      Object.assign({}, config, {
        rootDir: path.join(__dirname, '..'),
        dev: false,
        server: {
          host: 'localhost',
          port: 8081
        }
      })
    )

    process.env.CMS_INTERNAL_ENDPOINT = 'http://localhost:8000'
    process.env.CMS_BASE_PATH = '/'

    await new Builder(nuxt).build()

    done()
  }, 25000)

  afterAll(async (done) => {
    nuxt.close()
    server.close()
    done()
  })

  it('displays strings from service', async (done) => {
    const { html, error, redirected } = await nuxt.renderRoute('/events', {
      req: {
        protocol: 'http',
        headers: {
          host: `http://localhost:8000`
        }
      }
    })

    expect(error).toBeNull()
    expect(redirected).toBe(false)

    const dom = new JSDOM(html)

    expect(dom.window.document.querySelector('#error-message')).toBeNull()

    Array.from(
      dom.window.document.querySelector('#string-resource-list').children
    ).forEach((item, index) => {
      Object.keys(events[index]).forEach((key) => {
        expect(item.innerHTML).toContain(events[index][key])
      })
    })
    done()
  })
})
