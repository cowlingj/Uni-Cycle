/*
 ** TailwindCSS Configuration File
 **
 ** Docs: https://tailwindcss.com/docs/configuration
 ** Default: https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js
 */
module.exports = {
  theme: {
    colors: {
      primary: 'var(--color-primary)',
      secondary: 'var(--color-secondary)',
      accent: 'var(--color-accent)',
      fg: 'var(--color-fg)',
      bg: 'var(--color-bg)'
    },
    inset: {
      '0': 0,
      auto: 'auto',
      '1/2': '50%',
      '1/3': '33%'
    }
  },
  variants: {},
  plugins: []
}
