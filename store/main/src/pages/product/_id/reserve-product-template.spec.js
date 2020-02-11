import template from './reserve-product-template'
describe('reserve product template', () => {
  it('renders the email template when given email and product', () => {
    const expected =
      'mailto:test@example.com?subject=reservation%20of%20product%20id&body=Hi%2C%0A%0AI%20am%20interested%20in%20%22name%22%2C%20and%20would%20like%20to%20reserve%20it%20so%20I%20can%20buy%20it%20in%20store.%0A%0AThanks%0A'

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
