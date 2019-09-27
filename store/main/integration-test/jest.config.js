module.exports = {
  rootDir: "..",
  testMatch: [ "<rootDir>/integration-test/**/*.spec.js", "<rootDir>/**/*.integration.js" ],
  testPathIgnorePatterns: [ "<rootDir>/node_modules" ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
    '^~/(.*)$': '<rootDir>/$1',
    '^vue$': 'vue/dist/vue.common.js'
  },
  moduleFileExtensions: ['js', 'vue', 'json'],
  transform: {
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': 'vue-jest'
  },
  collectCoverage: false,
}
