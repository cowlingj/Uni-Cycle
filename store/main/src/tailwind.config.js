module.exports = {
  theme: {
    colors: {
      primary: 'var(--color-primary)',
      accent: 'var(--color-accent)',
      fg: 'var(--color-fg)',
      bg_bot: 'var(--color-bg_bot)',
      bg_mid: 'var(--color-bg_mid)',
      bg_top: 'var(--color-bg_top)',
      bg_highlight: 'var(--color-bg_highlight)',
      action_secondary: 'var(--color-action_secondary)',
      none: 'transparent'
    },
    extend: {
      zIndex: {
        '-10': '-10'
      },
      spacing: {
        '1/3': '33%',
        '1/2': '50%'
      },
      maxWidth: {
        '1/2': '50%',
        '4/5': '80%'
      },
      maxHeight: {
        'screen/2': '50vh'
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
  plugins: [
    require('tailwindcss-grid')({
      grids: [2, 3, 5, 6, 8, 10, 12],
      gaps: {
        0: '0',
        4: '1rem',
        8: '2rem',
        '4-x': '1rem',
        '4-y': '1rem'
      },
      autoMinWidths: {
        '16': '4rem',
        '24': '6rem',
        '300px': '300px'
      },
      variants: ['responsive']
    }),
    function({ addVariant, e }) {
      addVariant('after', ({ modifySelectors, separator }) => {
        modifySelectors(({ className }) => {
          return `.${e(`after${separator}${className}`)}::after`
        })
      })
    },
    function({ addUtilities }) {
      const newUtilities = {
        '.empty': {
          content: "'\\200B'"
        }
      }

      addUtilities(newUtilities, {
        variants: ['after']
      })
    }
  ]
}
