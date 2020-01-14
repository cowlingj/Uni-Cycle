/**
 * @jest-environment node
 */

import path from 'path'
import { Nuxt, Builder } from 'nuxt'
import config from '../../nuxt.config.js'

process.env.CMS_INTERNAL_URI = 'http://localhost:8081/'
process.env.CMS_EXTERNAL_URI = 'http://localhost:8081/'

describe('Home route', () => {
  let nuxt

  beforeAll(async () => {
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

  afterAll(() => {
    nuxt.close()
  })

  it('displays homepage', async () => {
    const window = await nuxt.renderAndGetWindow('http://localhost:8080/store/')

    expect(window.document.documentElement).toBeTruthy()
  })
})
