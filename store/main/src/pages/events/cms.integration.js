/**
 * @jest-environment node
 */

import { promisify } from 'util'
import { ApolloServer } from 'apollo-server'
import { Nuxt, Builder } from 'nuxt'
import { JSDOM } from 'jsdom'
import axios from 'axios'
import config from '@/../nuxt.config.js'
import rootSchema from '@/lib/cms-api/schema.gql'
import eventSchema from '@/lib/cms-api/event.gql'

process.env.CMS_INTERNAL_URI = 'http://localhost:8081'
process.env.CMS_EXTERNAL_URI = 'http://localhost:8081'

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

  beforeAll(async () => {
    const apolloServer = new ApolloServer({
      typeDefs: [rootSchema, eventSchema],
      resolvers: {
        Query: {
          allEvents: () => {
            return events
          }
        }
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

  it('displays events from cms', async () => {
    const { data, status } = await axios.get(
      'http://localhost:8080/store/events'
    )

    expect(status).toBe(200)

    const { window } = new JSDOM(data)

    expect(window.document.querySelector('#error-message')).toBeNull()
    expect(window.document.querySelector('#no-events')).toBeNull()
    expect(window.document.querySelector('#events-list')).toBeTruthy()

    const eventsHTML = window.document.querySelector('#events-list').innerHTML

    expected.forEach((item) => {
      Object.keys(item).forEach((key) => {
        expect(eventsHTML).toContain(item[key])
      })
    })

    window.close()
  }, 10000)
})
