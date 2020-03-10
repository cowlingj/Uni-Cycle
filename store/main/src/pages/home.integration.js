/**
 * @jest-environment node
 */

import { promisify } from 'util'
import { Nuxt, Builder } from 'nuxt'
import { ApolloServer, gql } from 'apollo-server'
import { URLResolver, URLTypeDefinition } from 'graphql-scalars'
import { schema as eventsIntrospection } from '@cowlingj/events-api'
import { buildClientSchema } from 'graphql'
import { addMockFunctionsToSchema } from 'graphql-tools'
import config from '@/../nuxt.config.js'

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

process.env.EVENTS_INTERNAL_URI = 'http://localhost:8081/'
process.env.EVENTS_EXTERNAL_URI = 'http://localhost:8081/'

process.env.RESOURCES_INTERNAL_URI = 'http://localhost:8082/'
process.env.RESOURCES_EXTERNAL_URI = 'http://localhost:8082/'

describe('Home route', () => {
  let nuxt, eventsServer, resourcesServer

  const eventsSchema = buildClientSchema(eventsIntrospection)
  addMockFunctionsToSchema({
    schema: eventsSchema,
    mocks: {},
    preserveResolvers: false
  })

  beforeAll(async () => {
    const apolloEvents = new ApolloServer({
      typeDefs: [URLTypeDefinition],
      schema: eventsSchema,
      resolvers: {
        Query: { events: () => events },
        URL: URLResolver
      }
    })

    eventsServer = (
      await apolloEvents.listen({
        host: 'localhost',
        port: 8081
      })
    ).server

    const apolloResources = new ApolloServer({
      typeDefs: [
        gql`
          type StringValues {
            key: ID!
            value: String
          }
          input Where {
            key: String
          }
          type Query {
            allStringValues(where: Where): [StringValues!]!
          }
        `
      ],
      resolvers: {
        Query: { allStringValues: () => [{ value: "value" }] },
      }
    })

    resourcesServer = (
      await apolloResources.listen({
        host: 'localhost',
        port: 8082
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
    await promisify(eventsServer.close.bind(eventsServer))()
    await promisify(eventsServer.close.bind(resourcesServer))()
  })

  it('displays homepage', async () => {
    const window = await nuxt.renderAndGetWindow('http://localhost:8080/store/')

    expect(window.document.documentElement).toBeTruthy()
  })
})
