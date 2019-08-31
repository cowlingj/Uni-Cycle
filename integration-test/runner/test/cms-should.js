import request from "request-promise-native"

test('cms install succeds', async () => {
  const res = await request({
    methid: 'GET',
    uri: 'http://cms/install',
    resolveWithFullResponse: true,
  })
  expect(res.statusCode).toBe(200)
  expect(res.body).not.toMatch(/error/i)
})

test('cms get strings succeds', async () => {
  const res = await request({
    methid: 'GET',
    uri: 'http://cms/api/collections/get/strings/',
    resolveWithFullResponse: true,
  })
  expect(res.statusCode).toBe(200)
  expect(res.body).toMatch('whatever the json should be')
})

