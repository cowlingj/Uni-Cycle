import template from './more-info-template'
describe('more info template', () => {
  it('renders the email template when given email and product', () => {
    const expected =
      'mailto:test@example.com?subject=information%20for%20product%20id&body=Hi%2C%0A%0ACould%20you%20tell%20me%20more%20about%20your%20product%20%22name%22.%0A%0AThanks%0A'

    expect(
      template({
        email: { address: 'test@example.com' },
        product: {
          id: 'id',
          name: 'name'
        }
      })
    ).toBe(expected)
  })
})
