import Vue from 'vue'
import './price-string'

describe('price string', () => {
  const vue = new Vue()
  it('can display £1.00 correctly', () => {
    expect(
      vue.$priceString({
        value: 100,
        currency: 'gbp'
      })
    ).toBe('£1.00')
  })

  it('can display £0.99 correctly', () => {
    expect(
      vue.$priceString({
        value: 99,
        currency: 'gbp'
      })
    ).toBe('£0.99')
  })

  it('can display £1,000.00 correctly', () => {
    expect(
      vue.$priceString({
        value: 100000,
        currency: 'gbp'
      })
    ).toBe('£1,000.00')
  })

  it('displays a price without currency as "unknown"', () => {
    expect(
      vue.$priceString({
        value: 100
      })
    ).toBe('unknown')
  })

  it('displays a price without value as "unknown"', () => {
    expect(
      vue.$priceString({
        currency: 'gbp'
      })
    ).toBe('unknown')
  })
})
