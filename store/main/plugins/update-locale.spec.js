import moment from 'moment'
import setLocale from './update-locale'

describe('Event', () => {
  beforeAll(() => {
    moment.locale = jest.fn()
  })

  afterEach(() => {
    moment.locale.mockReset()
  })

  it('sets the locale to the requested locale server side', () => {
    process.server = true
    const expected = 'browser-locale'
    const context = {
      app: {
        $env: {
          DEFAULT_LOCALE: 'default-locale'
        }
      },
      req: {
        headers: {
          'Accept-Language': expected
        }
      }
    }
    const inject = jest.fn()
    setLocale(context, inject)

    expect(inject.mock.calls.length).toBe(1)
    expect(inject.mock.calls[0][0]).toBe('updateLocale')

    inject.mock.calls[0][1]()

    expect(moment.locale.mock.calls.length).toBe(2)
    expect(moment.locale.mock.calls[0].length).toBe(0)
    expect(moment.locale.mock.calls[1][0]).toBe(expected)
  })

  it('sets the locale to the default locale server side if none locale is requested', () => {
    process.server = true
    const expected = 'default-locale'
    const context = {
      app: {
        $env: {
          DEFAULT_LOCALE: expected
        }
      },
      req: {
        headers: {}
      }
    }
    const inject = jest.fn()
    setLocale(context, inject)

    expect(inject.mock.calls.length).toBe(1)
    expect(inject.mock.calls[0][0]).toBe('updateLocale')

    inject.mock.calls[0][1]()

    expect(moment.locale.mock.calls.length).toBe(2)
    expect(moment.locale.mock.calls[0].length).toBe(0)
    expect(moment.locale.mock.calls[1][0]).toBe(expected)
  })

  it('sets the locale to the navigators language client side', () => {
    process.server = false
    const expected = 'default-locale'

    const languageSpy = jest.spyOn(window.navigator, 'language', 'get')
    languageSpy.mockReturnValue(expected)

    const context = {
      app: {
        $env: {
          DEFAULT_LOCALE: 'default-locale'
        }
      }
    }
    const inject = jest.fn()
    setLocale(context, inject)

    expect(inject.mock.calls.length).toBe(1)
    expect(inject.mock.calls[0][0]).toBe('updateLocale')

    inject.mock.calls[0][1]()

    expect(moment.locale.mock.calls.length).toBe(2)
    expect(moment.locale.mock.calls[0].length).toBe(0)
    expect(moment.locale.mock.calls[1][0]).toBe(expected)

    languageSpy.mockRestore()
  })
})
