/**
 * @jest-environment node
 */

import path from 'path'
import { ApolloServer, gql } from 'apollo-server'
import { Nuxt, Builder } from 'nuxt'
import { JSDOM } from 'jsdom'
import axios from 'axios'
import config from '@/nuxt.config.js'

process.env.CMS_INTERNAL_ENDPOINT = 'http://localhost:8081'
process.env.CMS_BASE_PATH = '/'

describe('Cms route', () => {
  let nuxt
  let server

  const events = [
    {
      title: 'title',
      description: 'desc',
      start: '2020-01-01 00:00',
      end: '2020-01-02 00:00',
      location: 'location',
      ical: 'ical'
    }
  ]

  const expected = [
    {
      title: 'title',
      description: 'desc',
      start: '1/1/2020',
      end: '2/1/2020',
      location: 'location',
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
      port: 8081
    })).server

    nuxt = new Nuxt(
      Object.assign({}, config, {
        rootDir: path.join(__dirname, '..'),
        dev: false,
        server: {
          host: 'localhost',
          port: 8080
        }
      })
    )

    await new Builder(nuxt).build()
    await nuxt.listen(8080)

    done()
  }, 25000)

  afterAll((done) => {
    nuxt.close()
    server.close()
  })

  it('displays strings from service', async (done) => {
    const { data, status } = await axios.get(
      'http://localhost:8080/store/events'
    )

    expect(status).toBe(200)

    const dom = new JSDOM(data)

    expect(dom.window.document.querySelector('#error-message')).toBeNull()

    Array.from(
      dom.window.document.querySelector('#events-list').children
    ).forEach((item, index) => {
      Object.keys(expected[index]).forEach((key) => {
        expect(item.innerHTML).toContain(expected[index][key])
      })
    })
    done()
  })
})
