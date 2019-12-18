module.exports = {
  rootDir: '../',
  testMatch: ['<rootDir>/test/**/*.spec.js', '<rootDir>/**/*.spec.js'],
  testPathIgnorePatterns: [
    '<rootDir>/node_modules',
    '<rootDir>/integration-test'
  ],
  moduleNameMapper: {
    '.+\\.(css|styl|less|sass|scss|svg|png|jpg|ttf|woff|woff2)(\\?.*)$':
      'jest-transform-stub',
    '^@/(.*)$': '<rootDir>/$1',
    '^~/(.*)$': '<rootDir>/$1',
    '^vue$': 'vue/dist/vue.common.js'
  },
  moduleFileExtensions: ['js', 'vue', 'json'],
  transform: {
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': 'vue-jest'
  },
  collectCoverage: true,
  collectCoverageFrom: [
    '<rootDir>/components/**/*.vue',
    '<rootDir>/pages/**/*.vue'
  ],
  coverageDirectory: '<rootDir>/coverage'
}
