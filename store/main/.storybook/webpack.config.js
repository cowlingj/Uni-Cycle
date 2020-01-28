const path = require('path')

module.exports = ({ config, mode: _mode }) => {

  const childConfig = {
    module: {
      rules: [
        {
          test: /\.svg$/,
          loaders: [
            'url-loader'
          ]
        },
        {
          test: /\.svg$/,
          resourceQuery: /inline/,
          loaders: [
            'babel-loader',
            'vue-svg-loader'
          ]
        },
        {
          test: /\.s?css$/,
          loaders: [
            'style-loader',
            'css-loader',
            {
              loader: 'postcss-loader',
              options: {
                sourceMap: true,
                config: {
                  path: './.storybook/',
                }
              }
            },
            // 'sass-loader'
          ],
          include: path.resolve(__dirname, '../')
        },
        {
          test: /\.ttf$/,
          loaders: [
            {
              loader: 'url-loader',
              query: {
                limit: 1000,
              }
            }
          ],
        }
      ]
    },
    resolve: {
      extensions: [ '.svg', 'png.', '.jpg', '.ttf' ],
      alias: {
        '@': path.resolve(__dirname, '..', 'src'),
        'assets': path.resolve(__dirname, '..', 'src', 'assets') // hack for url('~assets/...')
      }
    }
  }

  config.module.rules =
    config.module.rules
      .filter((rule) => !rule.test.test('file.svg'))
      .filter((rule) => !rule.test.test('file.css'))
      .filter((rule) => !rule.test.test('file.scss'))
      .concat(childConfig.module.rules)

  Object.assign(config.resolve.alias, childConfig.resolve.alias)
  config.resolve.extensions =
    config.resolve.extensions.concat(childConfig.resolve.extensions)

  return config
}
