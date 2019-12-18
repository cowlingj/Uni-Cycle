import autoLocale from './auto-locale'

it('calls context.app.$setLocale', () => {
  const updateLocale = jest.fn()
  autoLocale({
    app: {
      $updateLocale: updateLocale
    }
  })

  expect(updateLocale.mock.calls.length).toBe(1)
})
