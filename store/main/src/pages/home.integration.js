/**
 * @jest-environment node
 */

import { Nuxt, Builder } from 'nuxt'
import { promisify } from 'util'
import { ApolloServer } from 'apollo-server'
import { URLResolver, URLTypeDefinition } from 'graphql-scalars'
import gql from 'graphql-tag'
import config from '@/../nuxt.config.js'
import cmsSchema from '@cowlingj/cms-api'
import {buildClientSchema} from 'graphql'
import {addMockFunctionsToSchema} from 'graphql-tools'

const events = [{
    title: 'title',
    description: 'desc',
    start: '2020-01-01 00:00',
    end: '2020-01-02 00:00',
    location: 'location',
    ical: 'ical'
}]

process.env.CMS_INTERNAL_URI = 'http://localhost:8081/'
process.env.CMS_EXTERNAL_URI = 'http://localhost:8081/'

describe('Home route', () => {
  let nuxt, server

  const schema = buildClientSchema(cmsSchema)
  addMockFunctionsToSchema({
    schema: buildClientSchema(cmsSchema),
    mocks: {},
    preserveResolvers: false,
  })

  beforeAll(async () => {
    const apolloServer = new ApolloServer({
      typeDefs: [URLTypeDefinition],
      schema,
      resolvers: {
        Query: { allEvents: () => events },
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

  it('displays homepage', async () => {
    const window = await nuxt.renderAndGetWindow('http://localhost:8080/store/')

    expect(window.document.documentElement).toBeTruthy()
  })
})
