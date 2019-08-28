import request from "request-promise-native"

test('cms install succeds', async () => {
  try {
    const res = await request({
      methid: 'GET',
      uri: 'http://cms/install',
      resolveWithFullResponse: true,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    console.log(JSON.stringify(res))
    expect(res.statusCode).toBe(200)
  } catch (err) {
    fail()
  }
});


