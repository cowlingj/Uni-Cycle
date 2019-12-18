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
      accent: 'var(--color-accent)',
      fg: 'var(--color-fg)',
      bg_bot: 'var(--color-bg_bot)',
      bg_mid: 'var(--color-bg_mid)',
      bg_top: 'var(--color-bg_top)',
      bg_highlight: 'var(--color-bg_highlight)'
    },
    extend: {
      inset: {
        '1/3': '33%'
      },
      fontFamily: {
        brand: [
          'Caviar Dreams',
          'Open Sans',
          'Helvetica',
          'Arial',
          'sans-serif'
        ]
      },
      screens: {
        dark: {
          raw: 'screen and (prefers-color-scheme: dark)'
        }
      }
    }
  },
  variants: {},
  plugins: []
}
